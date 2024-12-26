import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawerMenu extends StatelessWidget {
  final Icon icon;
  final String title;
  final String route;

  const AppDrawerMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        textColor: Colors.blueGrey.shade600,
        iconColor: Colors.blueGrey.shade600,
        splashColor: Colors.teal.shade100,
        selectedTileColor: Colors.teal.shade50,
        selectedColor: Colors.teal,
        selected: GoRouterState.of(context).name == route,
        title: Text(title),
        onTap: () {
          context.pop();
          context.pushNamed(route);
        },
        leading: icon,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
