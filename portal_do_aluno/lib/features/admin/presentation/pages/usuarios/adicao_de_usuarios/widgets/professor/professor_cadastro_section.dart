import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/form_validators.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class ProfessorCadastro extends StatelessWidget {
  
  
  final TextEditingController nomeController; 
  final TextEditingController cpfController; 
  final bool enabled;

  const ProfessorCadastro({
    super.key,
    required this.nomeController, 
    required this.cpfController,  
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Retorno invisível caso o formulário esteja desativado
    if (!enabled) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      mainAxisSize: MainAxisSize.min,
      children: [
        
        
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Dados do Professor',
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
            borderRadius: BorderRadius.circular(20), // Curvatura Premium
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02), // Sombra super leve
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              
              // CAMPO: NOME
              CustomTextFormField(
                
                label: 'Nome Completo', 
                hintText: 'Ex: João da Silva',
                controller: nomeController,
                
                prefixIcon: CupertinoIcons.person_crop_circle_fill,
                validator: FormValidators.nome,
              ),
              
              const SizedBox(height: 20), // Espaçamento orgânico
              
              // CAMPO: CPF
              CustomTextFormField(
                label: 'CPF', 
                hintText: '000.000.000-00',
                controller: cpfController,
                
                keyboardType: TextInputType.number, 
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11), 
                  CpfInputFormatter(), 
                ],
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