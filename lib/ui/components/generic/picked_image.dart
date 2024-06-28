import 'dart:io';

import 'package:flutter/material.dart';

enum SourceType { path, uri }

class PickedImage extends StatelessWidget {
  const PickedImage({
    super.key,
    required this.source,
    required this.sourceType,
    required this.onDelete,
  });

  final String source;
  final SourceType sourceType;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: sourceType == SourceType.path
                ? Image.file(
                    File(source),
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  )
                : Image.network(
                    source,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              iconSize: 15,
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white.withOpacity(0.4)),
              padding: const EdgeInsets.all(3),
              onPressed: onDelete,
              icon: const Icon(
                Icons.close_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }
}
