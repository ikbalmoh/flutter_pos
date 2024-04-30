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
              child: LoadingIndicator(),
            ),
          )
        : const LoadingIndicator();
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}
