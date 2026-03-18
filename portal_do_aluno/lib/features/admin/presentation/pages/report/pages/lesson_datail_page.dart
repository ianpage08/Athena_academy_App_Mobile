import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/attachement_section_report.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/build_content_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/build_feedback_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/excluir_realtorios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/review_coodernador.dart';

/// Tela de detalhes do conteúdo enviado pelo professor.
/// Exibe:
/// - título
/// - observações
/// - feedback da coordenação
/// - anexos
/// - ações administrativas (quando permitidas)
class LessonDetailPage extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final List<String> attachments;
  final bool isActionEnabled;

  const LessonDetailPage({
    super.key,
    required this.reportData,
    required this.attachments,
    this.isActionEnabled = true,
  });

  String get _title => (reportData['conteudo'] ?? '').toString().trim();
  String get _notes => (reportData['observacoes'] ?? '').toString().trim();
  String get _feedback => (reportData['feedback'] ?? '').toString().trim();

  bool get _hasFeedback => _feedback.isNotEmpty;
  bool get _hasAttachments => attachments.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do conteúdo'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: isActionEnabled
          ? _buildBottomActions()
          : const SizedBox.shrink(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildContentCard(
              title: _title,
              notes: _notes,
              hasAttachments: _hasAttachments,
              attachments: attachments,
              theme: theme,
            ),
            const SizedBox(height: 20),
            if (_hasFeedback) ...[
              BuildFeedbackCard(feedback: _feedback),
              const SizedBox(height: 20),
            ],
            AttachementSectionReport(
              hasAttachments: _hasAttachments,
              attachments: attachments,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  /// Barra inferior com ações administrativas.
  Widget _buildBottomActions() {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(child: ReviewCoordenador(reportData: reportData)),
          const SizedBox(width: 12),
          Expanded(child: ExcluirRelatorios(reportData: reportData)),
        ],
      ),
    );
  }
}
