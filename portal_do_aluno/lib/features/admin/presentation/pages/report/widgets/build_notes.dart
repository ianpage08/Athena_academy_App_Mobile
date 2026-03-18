import 'package:flutter/material.dart';

class BuildNotes extends StatelessWidget {
  final String notes;
  final ThemeData theme;
  const BuildNotes({super.key, required this.notes, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        notes.isEmpty ? 'Sem observações.' : notes,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade800,
          height: 1.4,
        ),
      ),
    );
  }
}