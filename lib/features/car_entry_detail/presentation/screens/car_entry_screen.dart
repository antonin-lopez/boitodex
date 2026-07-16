import 'dart:io';

import 'package:boitodex/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/core/widgets/error_snackbar.dart';
import 'package:boitodex/core/theme/app_spacing.dart';
import 'package:boitodex/core/utils/image_compressor.dart';
import 'package:boitodex/core/widgets/async_result_handler.dart';
import 'package:boitodex/core/widgets/primary_loading_button.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car_entry_detail/presentation/controllers/car_entry_detail_controller.dart';
import 'package:boitodex/features/car_entry_detail/presentation/widgets/image_picker_row.dart';
import 'package:boitodex/features/car_entry_detail/presentation/widgets/keyword_section.dart';

class CarEntryScreen extends ConsumerStatefulWidget {
  const CarEntryScreen({
    required this.collectionId,
    this.existingCar,
    super.key,
  });

  final String collectionId;
  final Car? existingCar;

  bool get isEditing => existingCar != null;

  @override
  ConsumerState<CarEntryScreen> createState() => _CarEntryScreenState();
}

class _CarEntryScreenState extends ConsumerState<CarEntryScreen> {
  late final _notesController = TextEditingController(
    text: widget.existingCar?.notes ?? '',
  );
  final _keywordInputController = TextEditingController();
  final _keywordFocusNode = FocusNode();
  late final _keywords = <String>[
    ...?widget.existingCar?.keywords.map((k) => k.label),
  ];
  late final _pickedImages = <File>[
    for (final image in widget.existingCar?.images ?? const [])
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
    final xFiles = await ImagePicker().pickMultiImage();
    if (xFiles.isEmpty) return;

    final compressedFiles = <File>[];
    try {
      for (final xFile in xFiles) {
        final compressed = await ImageCompressor.compressImage(
          File(xFile.path),
        );
        if (compressed != null) compressedFiles.add(compressed);
      }
    } catch (error) {
      if (!mounted) return;
      showErrorSnackBar(context, error);
      return;
    }

    setState(() => _pickedImages.addAll(compressedFiles));
  }

  Future<void> _save() async {
    _addKeyword(_keywordInputController.text);

    await ref
        .read(carEntryDetailControllerProvider.notifier)
        .saveCar(
          id: widget.existingCar?.id,
          collectionId: widget.collectionId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          keywordLabels: _keywords,
          imagePaths: _pickedImages.map((file) => file.path).toList(),
        );
    if (!mounted) return;

    handleAsyncActionResult(
      context,
      ref.read(carEntryDetailControllerProvider),
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
    final isLoading = ref.watch(carEntryDetailControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Modifier la voiture' : 'Ajouter une voiture',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + context.bottomSystemInset,
        ),
        children: [
          Text('Photos', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          ImagePickerRow(
            images: _pickedImages,
            onAddPressed: _pickImages,
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
            maxLines: AppSizes.notesFieldMaxLines,
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
