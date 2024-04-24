import 'package:flutter/material.dart';
import 'package:selleri/models/outlet.dart';

class OutletItem extends StatelessWidget {
  const OutletItem({
    super.key,
    required this.onSelect,
    required this.outlet,
  });

  final Outlet outlet;
  final void Function(Outlet) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelect(outlet),
      dense: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0, horizontal: 17),
      title: Text(
        outlet.outletName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.teal.shade700,
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(outlet.outletAddress),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade300,
      ),
    );
  }
}
