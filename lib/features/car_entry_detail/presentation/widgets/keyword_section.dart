import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_spacing.dart';

class KeywordSection extends StatelessWidget {
  const KeywordSection({
    required this.keywords,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onRemove,
    super.key,
  });

  final List<String> keywords;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mots-clés', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        if (keywords.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final keyword in keywords)
                InputChip(
                  label: Text(keyword),
                  onDeleted: () => onRemove(keyword),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Ajouter un mot-clé',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onSubmitted(controller.text),
            ),
          ),
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
