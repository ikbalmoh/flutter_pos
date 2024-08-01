# Selleri POS

## Requirement

- Flutter 3.22.2
- Shorebird
- Makefile
- Firebase Tools

### Generate Provider or Model

- run `dart run build_runner build -d` or `dart run build_runner watch -d` once provider or model are changed

### Build APK Staging

```
make op=release platform=ios flavor=dev release_notes="describe about new feature or fixing issue in which part feature"
```

### Release Patch

```
make op=patch flavor=dev
```

## Available Flavor

- dev
- staging
- release
