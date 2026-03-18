import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_meta_tag.dart';

class BuildMetaTagsReport extends StatelessWidget {
  final bool hasAttachments;
  final List<String> attachments;

  const BuildMetaTagsReport({super.key, required this.hasAttachments, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReportMetaTag(
          icon: Icons.attach_file,
          label: hasAttachments
              ? '${attachments.length} anexo(s)'
              : 'Sem anexos',
        ),
        const SizedBox(width: 8),
        const ReportMetaTag(
          icon: Icons.check_circle_outline_rounded,
          label: 'Registrado',
        ),
      ],
    );
  }
}