import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

/// Botão responsável por abrir um modal de comentário/revisão.
/// Esse feedback será enviado pela coordenação para o professor.
class ReviewCoordenador extends StatelessWidget {
  /// Dados do relatório/conteúdo atual
  final Map<String, dynamic> reportData;

  const ReviewCoordenador({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    // Controller usado para capturar o texto digitado no campo de comentário
    final TextEditingController reviewController = TextEditingController();

    // Service responsável por atualizar os dados no Firestore
    final ConteudoPresencaService conteudoPresencaService =
        ConteudoPresencaService();

    return FilledButton.icon(
      // Ação do botão principal: abrir o modal bottom sheet
      onPressed: () {
        showModalBottomSheet(
          context: context,

          // Permite que o modal suba junto com o teclado
          isScrollControlled: true,

          // Deixa o fundo transparente para o container interno ter estilo próprio
          backgroundColor: Colors.transparent,

          builder: (modalContext) {
            return Padding(
              // Adiciona espaçamento e evita que o teclado cubra o conteúdo
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 16,
              ),

              child: Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  // Cor baseada no tema atual
                  color: Theme.of(modalContext).cardColor,

                  // Bordas arredondadas para visual mais moderno
                  borderRadius: BorderRadius.circular(24),

                  // Sombra para destacar o modal
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  // Faz o modal ocupar apenas o espaço necessário
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Barra visual superior, comum em bottom sheets
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// Título principal do modal
                    Text(
                      'Enviar comentário',
                      style: Theme.of(modalContext).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),

                    const SizedBox(height: 6),

                    /// Texto auxiliar explicando o objetivo do campo
                    Text(
                      'Escreva um feedback para o professor sobre o planejamento enviado.',
                      style: Theme.of(modalContext).textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey.shade700, height: 1.4),
                    ),

                    const SizedBox(height: 18),

                    /// Campo de texto onde a coordenação digita o comentário
                    CustomTextFormField(
                      controller: reviewController,
                      label: 'Digite o comentário',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 18),

                    /// Botões de ação do modal
                    Row(
                      children: [
                        /// Botão para cancelar e fechar o modal
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(modalContext);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Botão para enviar o comentário
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              // Remove espaços extras do início e fim do texto
                              final review = reviewController.text.trim();

                              // Valida se o campo está vazio
                              if (review.isEmpty) {
                                showAppSnackBar(
                                  context: modalContext,
                                  mensagem:
                                      'Digite uma mensagem antes de enviar.',
                                  cor: Colors.redAccent,
                                );
                                return;
                              }

                              try {
                                // Envia o feedback para o Firestore
                                await conteudoPresencaService.reviewCoodenador(
                                  conteudoPresencaId: reportData['id'],
                                  feedback: review,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                // Caso aconteça algum erro no envio
                                if (context.mounted) {
                                  showAppSnackBar(
                                    context: context,
                                    mensagem: 'Erro ao enviar feedback.',
                                    cor: Colors.redAccent,
                                  );
                                }
                              } finally {
                                // Exibe feedback visual e fecha o modal
                                if (context.mounted) {
                                  showAppSnackBar(
                                    context: context,
                                    mensagem: 'Feedback enviado com sucesso.',
                                    cor: Colors.green,
                                  );
                                }
                              }
                            },

                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Enviar'),

                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(
                                modalContext,
                              ).primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },

      // Ícone do botão principal
      icon: const Icon(Icons.comment_outlined),

      // Texto do botão principal
      label: const Text('Comentar'),

      // Estilo visual do botão principal
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
