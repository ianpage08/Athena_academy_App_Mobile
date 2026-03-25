import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';

import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';

void showCreateCalendarEventModal({
  // 🧠 LÓGICA INTACTA
  required BuildContext context,
  required CalendarEventType tipo,
  required Map<String, TextEditingController> controllers,
  required GlobalKey<FormState> formKey,
  required Function(DateTime?) onDateSelected,
  required Future<void> Function(CalendarEventType tipo) salvarconteudo,
  required ValueNotifier<SubmitState> submitState,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    context: context,
    builder: (_) {
      final theme = Theme.of(context);

      bool podeFechar = false;
      bool timerIniciado = false;

      return StatefulBuilder(
        builder: (context, setState) {
          if (!timerIniciado) {
            timerIniciado = true;
            Future.delayed(const Duration(seconds: 3), () {
              // Verifica se o modal ainda está aberto antes de atualizar a variável
              if (context.mounted) {
                setState(() {
                  podeFechar = true;
                });
              }
            });
          }

          return PopScope(
            canPop:
                podeFechar, // Se for falso, bloqueia o botão de voltar, o arrastar e o clique no fundo
            // Opcional (UX Premium): Dá um feedback sutil se o usuário tentar fechar antes da hora
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Aguarde um instante...'),
                    duration: const Duration(milliseconds: 800),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }
            },
            child: ValueListenableBuilder<SubmitState>(
              valueListenable: submitState,
              builder: (context, state, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Drag Handle
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      color: theme.dividerColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),

                                // Header
                                Column(
                                  children: [
                                    Text(
                                      'Agendar ${tipo.name}',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Insira as informações para o calendário escolar',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.hintColor.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 32),

                                // FORMULÁRIO
                                Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        controller: controllers['titulo']!,
                                        label: 'Título do Evento',
                                        hintText:
                                            'Ex: Prova Bimestral de Matemática',
                                        prefixIcon: CupertinoIcons
                                            .pencil_ellipsis_rectangle,
                                      ),
                                      const SizedBox(height: 20),
                                      CustomTextFormField(
                                        controller: controllers['descricao']!,
                                        label: 'Descrição Detalhada',
                                        hintText:
                                            'Informe pautas, salas ou observações...',
                                        prefixIcon:
                                            CupertinoIcons.text_alignleft,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // SELEÇÃO DE DATA
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.03,
                                    ),
                                  ),
                                  child: CustomDatePickerField(
                                    onDate: (data) => onDateSelected(data),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // AÇÃO
                                SizedBox(
                                  height: 56,
                                  child: SaveButton(
                                    onSave: () => salvarconteudo(tipo),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
