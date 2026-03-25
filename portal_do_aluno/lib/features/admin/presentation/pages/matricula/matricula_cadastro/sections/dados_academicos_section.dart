import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/card_section.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';

class DadosAcademicosSection extends StatelessWidget {
  
  final Map<String, TextEditingController> mapController;
  final ValueNotifier<String?> turmaName;
  final ValueNotifier<String?> turmaId;

  const DadosAcademicosSection({
    super.key,
    required this.mapController,
    required this.turmaName,
    required this.turmaId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CardSection(
      title: 'Dados Acadêmicos',
      icon:
          CupertinoIcons.book_solid, 
      children: [
         
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'Alocação de Turma'.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),

        
        // Colocar o botão dentro de um container com leve destaque foca a atenção
        // do usuário e tira a sensação de "botão flutuando no vazio".
        Container(
          padding: const EdgeInsets.all(4), // Leve respiro interno
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: SelectClassButton(
            turmaSelecionada: turmaName,
            onTurmaSelecionada: (id, turmaNome) {
              turmaName.value = turmaNome;
              turmaId.value = id;

              // Lógica original mantida intacta!
              
              debugPrint('🎓 Turma selecionada: $turmaNome (ID: $id)');
            },
          ),
        ),

        
        // Informa ao usuário a consequência da ação acima.
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.info_circle_fill,
                size: 16,
                color: theme.hintColor.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'O aluno será vinculado a esta turma e terá acesso imediato aos comunicados e exercícios correspondentes após a matrícula.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
