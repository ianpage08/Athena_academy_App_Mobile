import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/empty_attachments_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/excluir_realtorios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/full_screen.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_meta_tag.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/review_coodernador.dart';

/// Tela de detalhes do conteúdo enviado pelo professor
/// Exibe:
/// - título
/// - observações
/// - anexos
/// - ação de exclusão (quando permitido)
class LessonDetailPage extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final List<String> attachments;

  /// Define se ações administrativas (como excluir) estarão disponíveis
  final bool isActionEnabled;

  const LessonDetailPage({
    super.key,
    required this.reportData,
    required this.attachments,
    this.isActionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tratamento seguro dos dados vindos do Firestore
    final title = (reportData['conteudo'] ?? '').toString().trim();
    final notes = (reportData['observacoes'] ?? '').toString().trim();
    final feedback = (reportData['feedback'] ?? '').toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do conteúdo'),
        centerTitle: true,
        elevation: 0,
      ),

      /// Botão inferior para exclusão (somente se permitido)
      bottomNavigationBar: isActionEnabled
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),

              child: Row(
                children: [
                  Expanded(child: ReviewCoordenador(reportData: reportData)),
                  const SizedBox(width: 12),
                  Expanded(child: ExcluirRelatorios(reportData: reportData)),
                ],
              ),
            )
          : const SizedBox.shrink(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =========================
            /// CARD PRINCIPAL (CONTEÚDO)
            /// =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.6),
                ),

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
                  /// Ícone + título
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: theme.primaryColor.withValues(alpha: 0.10),
                        ),

                        child: Icon(
                          Icons.menu_book_rounded,
                          color: theme.primaryColor,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.isEmpty ? 'Conteúdo sem título' : title,

                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Registro de aula',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// Observações (bloco destacado)
                  Container(
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
                  ),

                  const SizedBox(height: 14),

                  /// Tags de metadados
                  Row(
                    children: [
                      ReportMetaTag(
                        icon: Icons.attach_file,
                        label: attachments.isEmpty
                            ? 'Sem anexos'
                            : '${attachments.length} anexo(s)',
                      ),
                      const SizedBox(width: 8),
                      const ReportMetaTag(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Registrado',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            if (feedback.isNotEmpty) ...[
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.feedback_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Feedback da coordenação',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue.shade800,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      feedback,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const SizedBox(height: 20),

            const SizedBox(height: 20),

            /// =========================
            /// SEÇÃO DE ANEXOS
            /// =========================
            Row(
              children: [
                Text(
                  'Anexos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(width: 8),

                if (attachments.isNotEmpty)
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

            /// Caso não haja anexos
            if (attachments.isEmpty)
              EmptyAttachmentsCard(theme: theme)
            /// Grid de imagens
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: attachments.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),

                itemBuilder: (context, index) {
                  final url = attachments[index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),

                    child: Material(
                      color: Colors.transparent,

                      child: InkWell(
                        onTap: () {
                          // Abre imagem em tela cheia
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImagePage(url: url),
                            ),
                          );
                        },

                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// Imagem carregada da internet
                            Image.network(
                              url,
                              fit: BoxFit.cover,

                              // Loading
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return Container(
                                      color: Colors.grey.withValues(
                                        alpha: 0.10,
                                      ),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  },

                              // Erro
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.withValues(alpha: 0.12),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),

                            /// Overlay com ícone de expandir
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.open_in_full_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
