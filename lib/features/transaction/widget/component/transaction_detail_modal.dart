import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/cart/model/transaction_image.dart';
import 'package:selleri/shared/model/custom_field.dart';
import 'package:selleri/shared/utils/formater.dart';

class TransactionDetailModal extends StatelessWidget {
  const TransactionDetailModal({super.key, required this.cart});

  final model.Cart cart;

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _TransactionDetailSheet(cart: cart),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _TransactionDetailSheet extends StatelessWidget {
  const _TransactionDetailSheet({required this.cart});

  final model.Cart cart;

  bool get hasImages => cart.images != null && cart.images!.isNotEmpty;

  bool get hasTransactionImages =>
      cart.transactionImages != null && cart.transactionImages!.isNotEmpty;

  bool get hasCustomFields =>
      cart.customFields != null && cart.customFields!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!hasImages && !hasTransactionImages && !hasCustomFields) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHeader(context: context),
              const SizedBox(height: 40),
              Icon(CupertinoIcons.doc_on_clipboard,
                  size: 48, color: Colors.blueGrey.shade300),
              const SizedBox(height: 12),
              Text(
                'there_is_no'
                    .tr(args: ['transaction_detail'.tr().toLowerCase()]),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.blueGrey.shade400),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(context: context),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasCustomFields) ...[
                      _SectionTitle(
                        title: 'additional_information'.tr(),
                        icon: CupertinoIcons.person,
                      ),
                      const SizedBox(height: 8),
                      _CustomFieldsSection(fields: cart.customFields!),
                      const SizedBox(height: 20),
                    ],
                    if (hasImages) ...[
                      _SectionTitle(
                        title: 'attachments'.tr(),
                        icon: CupertinoIcons.paperclip,
                      ),
                      const SizedBox(height: 8),
                      _ImagesSection(
                        images: cart.images!,
                        imageNotes: cart.imageNotes ?? [],
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (hasTransactionImages) ...[
                      _SectionTitle(
                        title: 'attachments'.tr(),
                        icon: CupertinoIcons.paperclip,
                      ),
                      const SizedBox(height: 8),
                      _TransactionImagesSection(
                        images: cart.transactionImages!,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'transaction_detail'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey.shade600),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}

class _ImagesSection extends StatelessWidget {
  const _ImagesSection({required this.images, required this.imageNotes});

  final List<XFile> images;
  final List<String> imageNotes;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(images.length, (index) {
          final XFile image = images[index];
          final bool isUrl = image.path.startsWith('http');
          final String? note =
              imageNotes.length > index ? imageNotes[index] : null;
          final bool hasNote = note != null && note.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              _ImageThumbnail(source: image.path, isUrl: isUrl),
              if (hasNote)
                SizedBox(
                  width: 130,
                  child: Text(
                    note,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blueGrey.shade600,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 2,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({
    required this.source,
    required this.isUrl,
  });

  final String source;
  final bool isUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullscreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isUrl
            ? Image.network(
                source,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              )
            : Image.file(
                File(source),
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 130,
      height: 130,
      color: Colors.blueGrey.shade100,
      child: Icon(Icons.broken_image_outlined,
          color: Colors.blueGrey.shade400, size: 32),
    );
  }

  void _showFullscreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenImage(source: source, isUrl: isUrl),
      ),
    );
  }
}

class _FullscreenImage extends StatelessWidget {
  const _FullscreenImage({required this.source, required this.isUrl});

  final String source;
  final bool isUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          child: isUrl
              ? Image.network(source, fit: BoxFit.contain)
              : Image.file(File(source), fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _CustomFieldsSection extends StatelessWidget {
  const _CustomFieldsSection({required this.fields});

  final List<CustomField> fields;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
      children: fields.map((field) {
        final value = field.value;
        final displayValue = _formatValue(field);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  field.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blueGrey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  displayValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value != null
                        ? Colors.black87
                        : Colors.blueGrey.shade300,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatValue(CustomField field) {
    final value = field.value;
    if (value == null) return '-';

    if (field.typeData == TypeData.boolean) {
      final strVal = value.toLowerCase();
      if (strVal == 'true' || strVal == '1') return 'yes'.tr();
      if (strVal == 'false' || strVal == '0') return 'no'.tr();
    }
    if (field.inputType == FieldType.date) {
      return DateTimeFormater.dateFromString(
        field.value as String,
      );
    }

    final strVal = value.toString().trim();
    return strVal.isEmpty ? '-' : strVal;
  }
}

class _TransactionImagesSection extends StatelessWidget {
  const _TransactionImagesSection({required this.images});

  final List<TransactionImage> images;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: images.map((img) {
          final hasNote = img.imageNotes != null && img.imageNotes!.isNotEmpty;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              _ImageThumbnail(source: img.imagePath, isUrl: true),
              if (hasNote)
                SizedBox(
                  width: 130,
                  child: Text(
                    img.imageNotes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blueGrey.shade600,
                          overflow: TextOverflow.ellipsis,
                        ),
                    maxLines: 2,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
