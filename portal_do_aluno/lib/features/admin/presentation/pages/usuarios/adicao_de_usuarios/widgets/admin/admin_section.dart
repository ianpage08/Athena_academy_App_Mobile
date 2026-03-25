import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/form_validators.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class AdminCadastro extends StatelessWidget {
  // Nomenclatura explícita define exatamente o que o controller guarda.
  final TextEditingController nomeController;
  final TextEditingController cpfController;
  final bool enabled;

  const AdminCadastro({
    super.key,
    required this.nomeController, // Antes: mapController1
    required this.cpfController, // Antes: mapController2
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // a árvore de widgets usa o AnimatedSize/AnimatedOpacity do pai ou desaparece de forma limpa.
    if (!enabled) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Dados do Administrador',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              20,
            ), // Arredondamento Apple-like
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.02,
                ), // Sombra hiper leve
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // CAMPO: NOME
              CustomTextFormField(
                label: 'Nome Completo', // Simplificado e mais direto
                controller: nomeController,
                hintText: 'Digite o nome do administrador',

                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                validator: FormValidators.nome,
              ),

              const SizedBox(
                height: 20,
              ), // Respiro matemático maior (Múltiplo de 4)
              // CAMPO: CPF
              CustomTextFormField(
                label:
                    'CPF', // Mantido simples (O header já diz que é do admin)
                controller: cpfController,
                hintText: '000.000.000-00', // Padrão visual zerado para CPF
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  CpfInputFormatter(),
                ],
                // Ícone ajustado para remeter a "Documento de Identidade"
                prefixIcon: CupertinoIcons.doc_text_viewfinder,
                validator: FormValidators.cpfObrigatorio,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
