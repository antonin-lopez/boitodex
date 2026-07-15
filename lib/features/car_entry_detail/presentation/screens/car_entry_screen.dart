import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boitodex/core/utils/image_compressor.dart';
import 'package:boitodex/features/car_entry_detail/presentation/controllers/car_entry_detail_controller.dart';

class CarEntryScreen extends ConsumerStatefulWidget {
  const CarEntryScreen({required this.collectionId, super.key});

  final String collectionId;

  @override
  ConsumerState<CarEntryScreen> createState() => _CarEntryScreenState();
}

class _CarEntryScreenState extends ConsumerState<CarEntryScreen> {
  final _notesController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _pickedImages = <File>[];

  @override
  void dispose() {
    _notesController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final xFiles = await ImagePicker().pickMultiImage();
    if (xFiles.isEmpty) return;

    for (final xFile in xFiles) {
      final compressed = await ImageCompressor.compressImage(File(xFile.path));
      if (compressed != null) _pickedImages.add(compressed);
    }
    setState(() {});
  }

  Future<void> _save() async {
    final keywordLabels = _keywordsController.text
        .split(',')
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toList();

    await ref
        .read(carEntryDetailControllerProvider.notifier)
        .saveCar(
          collectionId: widget.collectionId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          keywordLabels: keywordLabels,
          imagePaths: _pickedImages.map((file) => file.path).toList(),
        );
    if (!mounted) return;

    ref
        .read(carEntryDetailControllerProvider)
        .when(
          data: (_) => Navigator.of(context).pop(),
          error: (error, _) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$error'))),
          loading: () {},
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(carEntryDetailControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une voiture')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final image in _pickedImages)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        image,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                IconButton.filledTonal(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _keywordsController,
            decoration: const InputDecoration(
              labelText: 'Mots-clés (séparés par des virgules)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isLoading ? null : _save,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
