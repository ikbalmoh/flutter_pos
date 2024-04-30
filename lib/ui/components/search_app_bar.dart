import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() onBack;
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  final Size preferredSize;

  const SearchAppBar({
    super.key,
    required this.onBack,
    required this.onChanged,
    required this.controller,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey.shade500,
      automaticallyImplyLeading: false,
      titleSpacing: 5,
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'search',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: onBack,
          ),
          suffixIcon: controller.text.isNotEmpty ? IconButton(
            color: Colors.grey.shade400,
            onPressed: () {
              controller.text = '';
              onChanged('');
            },
            icon: const Icon(
              Icons.close,
            ),
          ) : const SizedBox(),
        ),
      ),
    );
  }
}
