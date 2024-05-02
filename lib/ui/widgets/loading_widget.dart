import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.withScaffold, super.key});

  final bool? withScaffold;

  @override
  Widget build(BuildContext context) {
    return withScaffold != null && withScaffold == true
        ? const Scaffold(
            backgroundColor: Colors.teal,
            body: Center(
              child: LoadingIndicator(
                color: Colors.white,
              ),
            ),
          )
        : const LoadingIndicator(
            color: Colors.white,
          );
  }
}

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  const LoadingIndicator({
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Colors.white,
      ),
    );
  }
}
