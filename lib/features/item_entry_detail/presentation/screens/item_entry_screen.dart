import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/utils/image_compressor.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/core/widgets/error_snackbar.dart';
import 'package:boitodex/core/widgets/primary_loading_button.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item_entry_detail/presentation/controllers/item_entry_detail_controller.dart';
import 'package:boitodex/features/item_entry_detail/presentation/widgets/image_picker_row.dart';
import 'package:boitodex/features/item_entry_detail/presentation/widgets/keyword_section.dart';

class ItemEntryScreen extends ConsumerStatefulWidget {
  const ItemEntryScreen({
    required this.collectionId,
    this.existingItem,
    super.key,
  });

  final String collectionId;
  final Item? existingItem;

  bool get isEditing => existingItem != null;

  @override
  ConsumerState<ItemEntryScreen> createState() => _ItemEntryScreenState();
}

class _ItemEntryScreenState extends ConsumerState<ItemEntryScreen> {
  // --- Colocated UI Constants ---
  static const int _maxImages = 10;
  static const int _notesMaxLines = 4;

  late final _notesController = TextEditingController(
    text: widget.existingItem?.notes ?? '',
  );
  final _keywordInputController = TextEditingController();
  final _keywordFocusNode = FocusNode();
  late final _keywords = <String>[
    ...?widget.existingItem?.keywords.map((k) => k.label),
  ];
  late final _pickedImages = <File>[
    for (final image in widget.existingItem?.images ?? const [])
      if (image.localPath != null) File(image.localPath!),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _keywordInputController.dispose();
    _keywordFocusNode.dispose();
    super.dispose();
  }

  void _addKeyword(String raw) {
    final label = raw.trim();
    _keywordInputController.clear();
    if (label.isEmpty) return;

    final alreadyExists = _keywords.any(
      (existing) => existing.toLowerCase() == label.toLowerCase(),
    );
    if (alreadyExists) return;

    setState(() => _keywords.add(label));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_keywordFocusNode.canRequestFocus) {
        _keywordFocusNode.requestFocus();
      }
    });
  }

  void _removeKeyword(String label) {
    setState(() => _keywords.remove(label));
  }

  Future<void> _pickImages() async {
    final remainingSlots = _maxImages - _pickedImages.length;
    if (remainingSlots <= 0) return;

    final xFiles = await ImagePicker().pickMultiImage(limit: remainingSlots);
    if (xFiles.isEmpty) return;

    final compressedFiles = <File>[];
    try {
      for (final xFile in xFiles) {
        final compressed = await ImageCompressor.compress(xFile);
        if (compressed != null) {
          compressedFiles.add(File(compressed.path));
        }
      }
    } catch (error) {
      if (!mounted) return;
      showErrorSnackBar(context, error);
      return;
    }

    setState(() => _pickedImages.addAll(compressedFiles.take(remainingSlots)));
  }

  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      final moved = _pickedImages.removeAt(oldIndex);
      _pickedImages.insert(newIndex, moved);
    });
  }

  Future<void> _save() async {
    _addKeyword(_keywordInputController.text);

    await ref
        .read(itemEntryDetailControllerProvider.notifier)
        .saveItem(
          id: widget.existingItem?.id,
          collectionId: widget.collectionId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          keywordLabels: _keywords,
          imagePaths: _pickedImages.map((file) => file.path).toList(),
        );
    if (!mounted) return;

    ref
        .read(itemEntryDetailControllerProvider)
        .handleResult(
          context,
          onSuccess: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isEditing ? 'Voiture mise à jour' : 'Voiture ajoutée',
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(itemEntryDetailControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Modifier la voiture' : 'Ajouter une voiture',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ).copyWith(bottom: AppSpacing.md + context.bottomSystemPadding),
        children: [
          Text('Photos', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          ImagePickerRow(
            images: _pickedImages,
            onAddPressed: _pickImages,
            onReorder: _reorderImages,
            onRemove: (index) => setState(() => _pickedImages.removeAt(index)),
          ),
          const SizedBox(height: AppSpacing.md),
          KeywordSection(
            keywords: _keywords,
            controller: _keywordInputController,
            focusNode: _keywordFocusNode,
            onSubmitted: _addKeyword,
            onRemove: _removeKeyword,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _notesController,
            maxLines: _notesMaxLines,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryLoadingButton(
            label: 'Enregistrer',
            isLoading: isLoading,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
