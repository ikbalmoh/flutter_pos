import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/shared/utils/app_alert.dart';

enum SourceType { path, uri }

class PickedImage extends StatelessWidget {
  const PickedImage({
    super.key,
    required this.source,
    required this.sourceType,
    required this.onDelete,
    this.note,
    this.withNote,
    this.size = 90,
    this.onAddNote,
  });

  final String source;
  final SourceType sourceType;
  final Function() onDelete;
  final String? note;
  final double? size;
  final bool? withNote;
  final void Function(String note)? onAddNote;

  @override
  Widget build(BuildContext context) {
    final hasNote = note != null && note!.isNotEmpty;
    return SizedBox(
      width: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 5,
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: sourceType == SourceType.path
                      ? Image.file(
                          File(source),
                          fit: BoxFit.cover,
                          width: size,
                          height: size,
                        )
                      : Image.network(
                          source,
                          fit: BoxFit.cover,
                          width: size,
                          height: size,
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
                        backgroundColor: Colors.white.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.all(3),
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (withNote == true)
            Material(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: InkWell(
                onTap: () => AppAlert.prompt(
                  context,
                  title: 'add'.tr(args: ['note'.tr()]),
                  note: note,
                  onConfirm: (value) {
                    if (onAddNote != null) {
                      onAddNote!(value ?? '');
                    }
                  },
                ),
                borderRadius: BorderRadius.circular(2),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          hasNote ? note! : 'note'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            color: hasNote ? Colors.black87 : Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
