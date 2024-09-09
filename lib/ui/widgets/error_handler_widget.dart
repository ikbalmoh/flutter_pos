import 'package:flutter/material.dart';

class ErrorhandlerWidget extends StatelessWidget {
  const ErrorhandlerWidget({
    required this.error,
    super.key,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
