import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/attachement_grid.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/empty_attachments_card.dart';

class AttachementSectionReport extends StatelessWidget {
  final bool hasAttachments;
  final List<String> attachments;
  final ThemeData theme;

  const AttachementSectionReport({super.key, required this.hasAttachments, required this.attachments, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Anexos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            if (hasAttachments)
              Text(
                '(${attachments.length})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasAttachments)
          EmptyAttachmentsCard(theme: theme)
        else
          AttachementGrid(attachments: attachments),
      ],
    );
  }
}