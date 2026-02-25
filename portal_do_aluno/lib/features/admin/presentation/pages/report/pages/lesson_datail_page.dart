import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/empty_attachments_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/full_screen.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/report_meta_tag.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';

class LessonDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> anexos;

  const LessonDetailPage({super.key, required this.data, required this.anexos});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titulo = (data['conteudo'] ?? '').toString().trim();
    final obs = (data['observacoes'] ?? '').toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do conteúdo'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomSheet: GestureDetector(
        onTap: () async {
          final result = await showAppConfirmationDialog(
            context: context,
            title: 'Excluir Relatório',
            confirmText: 'Excluir',
            cancelText: 'Cancelar',
            content: 'Essa ação não pode ser desfeita.',
          );
          if (result == true) {
            ConteudoPresencaService().excluirConteudoPresenca(data['id']);
            Navigator.pop(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),

          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Excluir Relatório',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cabeçalho / Conteúdo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: theme.primaryColor.withOpacity(0.10),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          titulo.isEmpty ? 'Conteúdo sem título' : titulo,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    obs.isEmpty ? 'Sem observações.' : obs,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      ReportMetaTag(
                        icon: Icons.attach_file,
                        label: anexos.isEmpty
                            ? 'Sem anexos'
                            : '${anexos.length} anexo(s)',
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

            const SizedBox(height: 18),

            /// Seção anexos
            Row(
              children: [
                Text(
                  'Anexos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                if (anexos.isNotEmpty)
                  Text(
                    '(${anexos.length})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            if (anexos.isEmpty)
              EmptyAttachmentsCard(theme: theme)
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: anexos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final url = anexos[index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
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
                            Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey.withOpacity(0.10),
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
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.withOpacity(0.12),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),

                            /// Overlay suave + ícone de zoom
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
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






