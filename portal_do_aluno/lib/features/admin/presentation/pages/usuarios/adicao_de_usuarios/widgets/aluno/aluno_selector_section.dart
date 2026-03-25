import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';

class AlunoSelectorSection extends StatelessWidget {
  final ValueNotifier<String?> turmaSelecionada;
  final ValueNotifier<String?> alunoSelecionado;
  final Function(String turmaId) onTurma;
  final Function(String id, String nome, String cpf) onAluno;

  const AlunoSelectorSection({
    super.key,
    required this.turmaSelecionada,
    required this.alunoSelecionado,
    required this.onTurma,
    required this.onAluno,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, 
      mainAxisSize: MainAxisSize.min,
      children: [
        
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Vínculo Acadêmico',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.8,
              ), // Estética Athena
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          
          // Agora a tela "escuta" a turmaSelecionada e reage automaticamente!
          child: ValueListenableBuilder<String?>(
            valueListenable: turmaSelecionada,
            builder: (context, turmaId, child) {
              return Column(
                children: [
                  // BOTÃO 1: TURMA
                  SelectClassButton(
                    turmaSelecionada: turmaSelecionada,
                    onTurmaSelecionada: (id, nome) => onTurma(id),
                  ),

                  
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.topCenter,
                    child: turmaId != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ), // Respiro entre os botões
                            child: SelectStudentButton(
                              alunoSelecionado: alunoSelecionado,
                              turmaId: turmaId,
                              onAlunoSelecionado: onAluno,
                            ),
                          )
                        : const SizedBox.shrink(), // Mantém invisível e sem ocupar espaço até a turma ser selecionada
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
