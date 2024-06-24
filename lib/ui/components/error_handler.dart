import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  const ErrorHandler({super.key, required this.error, this.stackTrace});

  final String error;
  final String? stackTrace;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.dangerous_outlined,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          stackTrace != null
              ? Text(
                  stackTrace.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : Container(),
        ],
      ),
    );
  }
}
