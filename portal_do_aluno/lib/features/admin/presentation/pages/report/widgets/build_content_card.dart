import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/build_header_report.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/build_meta_tags_report.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/build_notes.dart';

class BuildContentCard extends StatelessWidget {
  final String title;
  final String notes;
  final bool hasAttachments;
  final List<String> attachments;
  final ThemeData theme;
  const BuildContentCard({super.key, required this.title, required this.notes, required this.hasAttachments, required this.attachments, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildHeaderReport(title: title, theme: theme),
          const SizedBox(height: 18),
          BuildNotes(notes: notes, theme: theme),
          const SizedBox(height: 14),
          BuildMetaTagsReport(hasAttachments: hasAttachments, attachments: attachments),
        ],
      ),
    );
  }
}