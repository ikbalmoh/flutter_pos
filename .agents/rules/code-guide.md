---
trigger: always_on
---

# code-guide.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Selleri POS — a Flutter-based point-of-sale application supporting offline transactions, multi-outlet management, thermal receipt printing, and barcode scanning. Targets Android and iOS with three build flavors: dev, stage, prod.

## Build & Development Commands

```bash
# Flutter version management (uses FVM)
fvm flutter run --flavor dev          # Run dev flavor
fvm flutter run --flavor stage        # Run stage flavor

# Code generation (required after changing models, providers, or ObjectBox entities)
make runner                           # or: dart run build_runner build -d
dart run build_runner watch -d        # Watch mode for continuous generation

# Apply patched packages
dart run patch_package apply

# Run tests
flutter test                          # All tests
flutter test test/path/to/test.dart   # Single test file

# Static analysis
flutter analyze

# Release & distribution (via Makefile)
make op=release platform=android flavor=stage release_notes="description"
make op=patch flavor=prod
```

## Architecture

**Feature-based clean architecture** with Riverpod state management. Each feature in `lib/features/` follows this structure:

```
feature/
├── api/           # Dio HTTP calls
├── model/         # Freezed immutable data classes
├── repository/    # Business logic, bridges API ↔ ObjectBox local DB
├── provider/      # Riverpod providers (use @Riverpod codegen)
└── widget/        # UI screens and components
```

Not all features need every layer. Some features (e.g., `cart`, `pos`, `table`) are local-only and skip `api/` and `repository/`.

**Data flow**: Widget → Provider → Repository → API/ObjectBox → back up the chain.

### Key Layers

- **State management**: Riverpod 2.x with code generation (`@Riverpod`, `@riverpod` annotations → `.g.dart` files)
- **Networking**: Dio with interceptors for auth tokens, device headers, outlet ID, and 401 session expiration handling (`lib/shared/utils/fetch.dart`)
- **Local database**: ObjectBox for offline-first caching (items, categories, promotions, customers, offline transactions). Schema in `lib/objectbox-model.json`
- **Routing**: GoRouter with redirect logic based on auth/outlet state (`lib/shared/router/`)
- **Models**: Freezed + json_serializable for all data classes
- **Localization**: easy_localization with translations in `assets/translations/` (en_US, id_ID)

### Shared Code

`lib/shared/` contains cross-feature utilities:

- `router/` — GoRouter setup, route constants (`lib/shared/router/routes.dart`), API URL constants (`lib/shared/router/api_url.dart`)
- `utils/fetch.dart` — Dio client factory with auth interceptors
- `objectbox.dart` — ObjectBox singleton, all Box declarations, query helper methods
- `constants/` — Storage keys, app constants
- `model/` — Shared models (e.g., `Pagination<T>`)

## Code Patterns

### API Layer

API classes take a `Dio` instance and are exposed via a manual `Provider`:

```dart
class FeatureApi {
  final Dio api;
  FeatureApi({required this.api});

  Future fetchSomething(String idOutlet) async {
    final res = await api.get(ApiUrl.endpoint, queryParameters: {'id_outlet': idOutlet});
    return res.data;
  }
}

final featureApiProvider = Provider<FeatureApi>((ref) {
  final dio = ref.watch(apiProvider);
  return FeatureApi(api: dio);
});
```

### Repository Layer

Repositories use an abstract protocol class + concrete implementation, wired via `@riverpod`:

```dart
part 'feature_repository.g.dart';

@riverpod
FeatureRepository featureRepository(Ref ref) => FeatureRepository(ref);

abstract class FeatureRepositoryProtocol {
  Future<List<Model>> fetchModels();
}

class FeatureRepository implements FeatureRepositoryProtocol {
  FeatureRepository(this.ref);
  final Ref ref;

  @override
  Future<List<Model>> fetchModels() async {
    final api = ref.watch(featureApiProvider);
    // ...
  }
}
```

### Provider Layer

Two patterns in use:

- **`@Riverpod(keepAlive: true)`** — for long-lived state (auth, outlet, items, settings, shift)
- **`@riverpod`** — for auto-disposed, request-scoped providers (adjustments, vouchers, holded)

Class-based notifiers for mutable state with methods:

```dart
@Riverpod(keepAlive: true)
class Feature extends _$Feature {
  @override
  FutureOr<FeatureState> build() async { /* initial state */ }

  Future<void> doSomething() async { /* mutate state */ }
}
```

### Model Layer

Two entity patterns:

1. **Freezed + ObjectBox entity** (for models that need both JSON serialization and local persistence):

   ```dart
   @Freezed(addImplicitFinal: false)
   class Item with _$Item {
     @Entity(uid: ..., realClass: Item)
     @JsonSerializable(fieldRename: FieldRename.snake)
     factory Item({
       @Default(0) @Id() int id,
       @Index() required String idItem,
       // ...
     }) = _Item;
     const Item._();
     factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
   }
   ```

   ToMany relationships use custom `JsonConverter` classes (e.g., `VariantRelToManyConverter`).

2. **Plain ObjectBox entity** (simple local-only storage):

   ```dart
   @Entity()
   class OfflineTransaction {
     int id;
     String transactionNo;
     OfflineTransaction({this.id = 0, required this.transactionNo});
   }
   ```

3. **Freezed without ObjectBox** (API-only models, state unions):
   ```dart
   @freezed
   class FeatureState with _$FeatureState {
     const factory FeatureState.loading() = Loading;
     const factory FeatureState.loaded(Data data) = Loaded;
   }
   ```

### ObjectBox

Singleton in `lib/shared/objectbox.dart`. When adding a new entity:

1. Add the `Box<NewEntity>` declaration in the `ObjectBox` class
2. Initialize it in the `ObjectBox._create()` constructor
3. Add query helper methods as needed
4. Run `make runner` to regenerate `lib/objectbox.g.dart` and update `lib/objectbox-model.json`

### Routing

Routes are defined as constants in `lib/shared/router/routes.dart` and registered in `lib/shared/router/app_router.dart`. API URLs are constants in `lib/shared/router/api_url.dart`.

## Code Generation

Generated files (`*.g.dart`, `*.freezed.dart`) are checked in. After modifying any of these, run `make runner`:

- **Freezed models** — `@freezed` classes with `fromJson`/`toJson`
- **Riverpod providers** — `@Riverpod`/`@riverpod` annotated classes/functions
- **ObjectBox entities** — `@Entity` annotated classes
- **JSON serialization** — `@JsonSerializable` classes

## Build Flavors & Environment

Three flavors with separate Firebase configs and API endpoints:

- `dev` — development
- `stage` — staging / QA
- `prod` — production

Environment variables are in `.env` files. Shorebird is used for OTA code push updates.

## Flutter Version

Managed via FVM. Current version specified in `.fvmrc` (currently 3.35.3).

## Code Exploration Policy

Always use jCodemunch-MCP tools — never fall back to Read, Grep, Glob, or Bash for code exploration.

- Before reading a file: use `get_file_outline` or `get_file_content`
- Before searching: use `search_symbols` or `search_text`
- Before exploring structure: use `get_file_tree` or `get_repo_outline`
- Call `resolve_repo` with the current directory first; if not indexed, call `index_folder`
