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
  final _keywordInputController = TextEditingController();
  final _keywordFocusNode = FocusNode();
  final _keywords = <String>[];
  final _pickedImages = <File>[];

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
    // Garde le focus pour enchaîner facilement plusieurs mots-clés.
    _keywordFocusNode.requestFocus();
  }

  void _removeKeyword(String label) {
    setState(() => _keywords.remove(label));
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
    // Si l'utilisateur a tapé un mot sans valider, on le récupère quand même.
    _addKeyword(_keywordInputController.text);

    await ref
        .read(carEntryDetailControllerProvider.notifier)
        .saveCar(
          collectionId: widget.collectionId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          keywordLabels: _keywords,
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
          Text('Mots-clés', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (_keywords.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final keyword in _keywords)
                  InputChip(
                    label: Text(keyword),
                    onDeleted: () => _removeKeyword(keyword),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: _keywordInputController,
            focusNode: _keywordFocusNode,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Ajouter un mot-clé',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addKeyword(_keywordInputController.text),
              ),
            ),
            onSubmitted: _addKeyword,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 5,
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
