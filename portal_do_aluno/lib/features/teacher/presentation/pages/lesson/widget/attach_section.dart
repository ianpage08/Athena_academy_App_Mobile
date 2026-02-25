import 'package:flutter/material.dart';

class AttachSection extends StatelessWidget {
  final int attachedCount;
  final VoidCallback onAttach;

  const AttachSection({super.key,required this.attachedCount, required this.onAttach});

  @override
  Widget build(BuildContext context) {
    final hasFile = attachedCount > 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasFile
                    ? '$attachedCount arquivo(s) anexado(s)'
                    : 'Anexe um arquivo ou imagem',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAttach,
              icon: const Icon(Icons.attach_file),
              tooltip: 'Anexar arquivo',
            ),
          ],
        ),
      ),
    );
  }
}