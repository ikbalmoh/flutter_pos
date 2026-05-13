# Promotion Selection Logic Redesign

## Problem

The current promotion selection logic in `cart_promotions_list.dart` has two issues:

1. **Type 1 and Type 3 are treated as interchangeable** — the overlap check groups them together (`p.type != 1 && p.type != 3`), so a Type 1 promo can conflict with a Type 3 promo on the same item. They should be independent.
2. **Conflict resolution is quantity-based, not per-item** — currently allows multiple same-type promos on the same item if combined quantity fits. The rule is stricter: one promo per type per item.

## Rules

### Transaction Promos (Type 2 & 4)
- Only one promo per type can be selected at a time
- Selecting a new Type 2 replaces existing Type 2; same for Type 4
- **Already working correctly** — no changes needed to this logic

### Product Promos (Type 1 & 3)
- Each cart line item can have at most **one Type 1** and **one Type 3** promo
- A Type 1 and Type 3 can coexist on the same item
- Type 1 only conflicts with other Type 1 promos; Type 3 only with other Type 3
- When a new promo is selected and overlaps with an existing same-type promo:
  - The **new promo wins** the overlapping items
  - The old promo **keeps non-overlapping items**
  - If the old promo's remaining items no longer meet its `requirementQuantity` → remove it entirely

## Design

### Move conflict resolution to `promotions_provider.dart`

Add a pure method to the existing `Promotions` notifier:

```dart
List<Promotion> resolveSelection(List<Promotion> currentSelection, Promotion promo)
```

**Selection state remains local in the widget.** The provider only owns the conflict resolution logic. No draft state stored in the provider.

### `resolveSelection` Logic

1. If `promo` is already in `currentSelection` → remove it (toggle off), return
2. If `promo.type == 2 || promo.type == 4`:
   - Remove any existing promo in `currentSelection` with the same `type`
   - Add `promo`, return
3. If `promo.type == 1 || promo.type == 3`:
   - For each promo `p` in `currentSelection` where `p.type == promo.type`:
     - Compute overlapping items: items in both `p.eligibleItems` and `promo.eligibleItems` (matched by `idItem` + `idVariant`)
     - Compute `p`'s remaining items: `p.eligibleItems` minus overlapping items
     - If remaining items' total quantity < `p.requirementQuantity` → remove `p`
   - Add `promo`, return

### Code-based promo selection

`onSelectPromoByCode` also routes through `resolveSelection` instead of having separate toggle logic.

### Widget changes (`cart_promotions_list.dart`)

- Replace `onSelect` body with:
  ```dart
  void onSelect(Promotion promo) {
    setState(() {
      selected = ref.read(promotionsProvider.notifier)
          .resolveSelection(selected, promo);
    });
  }
  ```
- Replace `onSelectPromoByCode` to also use `resolveSelection`
- Keep `isPromoDisabled` and `hasCannotCombinedPromo` in the widget (UI concern)

### Application changes (`cart_provider.dart` — `applyPromotions`)

When applying same-type product promos, track claimed items:
- Apply Type 3 promos in order: once an item is claimed by a Type 3 promo, skip it for subsequent Type 3 promos
- Apply Type 1 promos in order: once an item is claimed by a Type 1 promo, skip it for subsequent Type 1 promos
- An item claimed by Type 3 can still be claimed by Type 1 (they're independent)

### Data Flow

```
User taps promo
  → widget calls resolveSelection(selected, promo)
  → provider returns resolved list (pure function, no state stored)
  → widget updates local state via setState

User confirms
  → widget pops with selected list
  → cart calls applyPromotions(selected)
  → items claimed per-type, no double-application within same type
```

## Out of Scope

- Eligibility logic (`isPromotionEligible`) — no changes
- Transaction promo selection (Type 2 & 4) — already correct, just moved to provider
- `isPromoDisabled` / `hasCannotCombinedPromo` — stays in widget
- Promotion priority ordering — not needed for this change
