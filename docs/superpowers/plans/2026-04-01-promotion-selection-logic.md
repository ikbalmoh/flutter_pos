# Promotion Selection Logic Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move promotion conflict resolution logic from the widget into the promotions provider, and fix per-item same-type exclusivity rules.

**Architecture:** Add a pure `resolveSelection` method to `Promotions` notifier that handles all conflict resolution. Update `applyPromotions` in cart provider to track claimed items per type. Slim down the widget to delegate to the provider.

**Tech Stack:** Flutter, Riverpod, Freezed, ObjectBox

**Spec:** `docs/superpowers/specs/2026-04-01-promotion-selection-logic-design.md`

---

### Task 1: Add `resolveSelection` method to `Promotions` provider

**Files:**
- Modify: `lib/features/promotion/provider/promotions_provider.dart:237` (append before closing brace)

- [ ] **Step 1: Add the `resolveSelection` method**

Add this method to the `Promotions` class, after the existing `eligibleItems` method (after line 236, before the closing `}`):

```dart
  /// Pure conflict resolver — takes current selection + toggled promo,
  /// returns the new resolved selection list.
  /// Selection state is NOT stored in the provider.
  List<Promotion> resolveSelection(
    List<Promotion> currentSelection,
    Promotion promo,
  ) {
    // Toggle off if already selected
    final int idx = currentSelection.indexWhere((p) => p.id == promo.id);
    if (idx >= 0) {
      return List.from(currentSelection)..removeAt(idx);
    }

    List<Promotion> result = List.from(currentSelection);

    if (promo.type == 2 || promo.type == 4) {
      // Transaction promos: only one per type
      result.removeWhere((p) => p.type == promo.type);
    } else if (promo.type == 1 || promo.type == 3) {
      // Product promos: one promo per type per item
      // Only conflict with same-type promos
      result.removeWhere((p) {
        if (p.type != promo.type) return false;

        // Find overlapping items between p and the new promo
        final bool hasOverlap = p.eligibleItems.any((item) =>
            promo.eligibleItems.any((newItem) =>
                newItem.idItem == item.idItem &&
                newItem.idVariant == item.idVariant));

        if (!hasOverlap) return false;

        // Compute remaining eligible items for p (non-overlapping)
        final remainingItems = p.eligibleItems.where((item) =>
            !promo.eligibleItems.any((newItem) =>
                newItem.idItem == item.idItem &&
                newItem.idVariant == item.idVariant)).toList();

        final double remainingQty =
            remainingItems.fold(0, (sum, item) => sum + item.quantity);
        final double requiredQty =
            (p.requirementQuantity ?? 1).toDouble();

        // Remove if remaining items can't satisfy requirement
        return remainingQty < requiredQty;
      });
    }

    result.add(promo);
    return result;
  }
```

- [ ] **Step 2: Verify no syntax errors**

Run:
```bash
cd /Users/ikbalmoh/Project/DGTI/selleri && fvm flutter analyze lib/features/promotion/provider/promotions_provider.dart
```

Expected: No errors in the provider file.

- [ ] **Step 3: Commit**

```bash
git add lib/features/promotion/provider/promotions_provider.dart
git commit -m "feat: add resolveSelection method to Promotions provider"
```

---

### Task 2: Update widget to use `resolveSelection`

**Files:**
- Modify: `lib/features/cart/widget/components/promotions/cart_promotions_list.dart:52-112`

- [ ] **Step 1: Replace `onSelect` method**

Replace the entire `onSelect` method (lines 52-99) with:

```dart
  void onSelect(Promotion promo) {
    setState(() {
      selected = ref
          .read(promotionsProvider.notifier)
          .resolveSelection(selected, promo);
    });
  }
```

- [ ] **Step 2: Replace `onSelectPromoByCode` method**

Replace the entire `onSelectPromoByCode` method (lines 101-112) with:

```dart
  void onSelectPromoByCode(Promotion promo) {
    setState(() {
      selected = ref
          .read(promotionsProvider.notifier)
          .resolveSelection(selected, promo);
    });
  }
```

- [ ] **Step 3: Verify no syntax errors**

Run:
```bash
cd /Users/ikbalmoh/Project/DGTI/selleri && fvm flutter analyze lib/features/cart/widget/components/promotions/cart_promotions_list.dart
```

Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/cart/widget/components/promotions/cart_promotions_list.dart
git commit -m "refactor: delegate promotion selection logic to provider"
```

---

### Task 3: Update `applyPromotions` to track claimed items per type

**Files:**
- Modify: `lib/features/cart/provider/cart_provider.dart:703-727` (Type 3 application block)
- Modify: `lib/features/cart/provider/cart_provider.dart:750-800` (Type 1 application block)

- [ ] **Step 1: Add claimed items tracking and update Type 3 application**

In the `applyPromotions` method, add a `Set` to track claimed items before the Type 3 loop. Replace lines 701-727 (from `List<CartPromotion> cartPromotions` through the end of the Type 3 for-loop) with:

```dart
    List<CartPromotion> cartPromotions = [];

    // Track items claimed per promo type to enforce one-promo-per-type-per-item
    Set<String> claimedByType3 = {};
    Set<String> claimedByType1 = {};

    // PROMO BY PRODUCT
    for (var i = 0; i < promotionByProducts.length; i++) {
      Promotion promo = promotionByProducts[i];

      CartPromotion cartPromo = CartPromotion.fromData(promo);

      List<ItemCart> eligibleItems =
          ref.read(promotionsProvider.notifier).eligibleItems(promo, items);

      // Filter out items already claimed by another Type 3 promo
      eligibleItems = eligibleItems
          .where((item) => !claimedByType3.contains(item.identifier))
          .toList();

      if (eligibleItems.isEmpty) {
        continue;
      }

      for (ItemCart itemCart in eligibleItems) {
        int itemIdx = items.indexWhere(
          (item) => item.identifier == itemCart.identifier,
        );
        itemCart = ItemCart.copyWithPromotion(itemCart, promotion: promo);

        log('ITEM GET PROMO: ${itemCart.promotion?.promotionName} ${itemCart.promotion?.discountValue}');

        cartPromotions.add(cartPromo);
        claimedByType3.add(itemCart.identifier);
        items[itemIdx] = itemCart;
      }
    }
```

- [ ] **Step 2: Update Type 1 (free gift) application to track claimed items**

Replace the Type 1 for-loop (lines 751-800, from `for (var i = 0; i < freeGiftpromotions.length` through its closing brace) with:

```dart
    // FREE GIFT
    for (var i = 0; i < freeGiftpromotions.length; i++) {
      Promotion promo = freeGiftpromotions[i];

      List<ItemCart> eligibleItems =
          ref.read(promotionsProvider.notifier).eligibleItems(promo, items);

      // Filter out items already claimed by another Type 1 promo
      eligibleItems = eligibleItems
          .where((item) => !claimedByType1.contains(item.identifier))
          .toList();

      log('A GET B eligible items: ${eligibleItems.map((e) => e.itemName).toList()}');
      if (promo.type == 1 && eligibleItems.isEmpty) {
        continue;
      }
      // Apply Rewards
      ScanItemResult? reward = objectBox.getPromotionReward(promotion: promo);
      log('A GET B Promotion => ${promo.name}\nREWARD ITEM =>${reward.item?.itemName}\nREWARD Variant=>${reward.variant?.variantName}\n\n');
      if (reward.item != null) {
        for (ItemCart itemCart in eligibleItems) {
          int itemIdx = items.indexWhere(
            (item) => item.identifier == itemCart.identifier,
          );
          if (itemCart.promotion == null || itemCart.promotion!.type != 3) {
            itemCart = ItemCart.copyWithPromotion(itemCart, promotion: promo);
            items[itemIdx] = itemCart;
          }
          claimedByType1.add(itemCart.identifier);

          log('ITEM GET PROMO AB: ${itemCart.itemName}');
        }
        double rewardQty = promo.rewardQty?.toDouble() ?? 1;
        double rewardPrice = reward.item?.itemPrice ?? 0;

        final double itemPromoQty = eligibleItems
            .map((item) => item.quantity)
            .reduce((value, total) => value + total);

        if (promo.kelipatan == true) {
          rewardQty = ((rewardQty * itemPromoQty) ~/ promo.requirementQuantity!)
              .toDouble();
        }

        if (promo.rewardNominal > rewardPrice) {
          promo = promo.copyWith(rewardNominal: rewardPrice);
        }

        ItemCart rewardItem = ItemCart.asReward(
          reward.item!,
          variant: reward.variant,
          promotion: promo,
          quantity: rewardQty,
        );
        items.add(rewardItem);
        cartPromotions.add(CartPromotion.fromData(promo));
      }
    }
```

- [ ] **Step 3: Verify no syntax errors**

Run:
```bash
cd /Users/ikbalmoh/Project/DGTI/selleri && fvm flutter analyze lib/features/cart/provider/cart_provider.dart
```

Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/cart/provider/cart_provider.dart
git commit -m "fix: enforce one-promo-per-type-per-item in applyPromotions"
```

---

### Task 4: Manual verification

- [ ] **Step 1: Run full analysis**

```bash
cd /Users/ikbalmoh/Project/DGTI/selleri && fvm flutter analyze
```

Expected: No new errors introduced.

- [ ] **Step 2: Run the app and test scenarios**

```bash
cd /Users/ikbalmoh/Project/DGTI/selleri && fvm flutter run --flavor dev
```

Test these scenarios:
1. **Type 2 replacement**: Select a Type 2 promo, then select another Type 2 → first should be replaced
2. **Type 4 replacement**: Same as above for Type 4
3. **Type 3 per-item exclusivity**: Add item eligible for two Type 3 promos → selecting second should remove first (if items fully overlap) or keep first for non-overlapping items
4. **Type 1 per-item exclusivity**: Same as above for Type 1
5. **Type 1 + Type 3 coexistence**: An item eligible for both a Type 1 and Type 3 promo → both should be selectable
6. **Toggle off**: Select a promo, tap again → should deselect
7. **Code-based promo**: Enter promo code → should go through same resolution logic
8. **Policy check**: Non-combinable promos should still disable other promos in UI
