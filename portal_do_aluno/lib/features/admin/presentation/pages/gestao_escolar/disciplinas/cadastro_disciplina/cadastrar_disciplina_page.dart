import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Importado para consistência de ícones
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👉 MUDANÇA: Necessário para os InputFormatters
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/cadastro_disciplina/controller/cadastro_disciplina_controller.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/clear_button.dart';

class CadastrarDisciplina extends StatefulWidget {
  const CadastrarDisciplina({super.key});

  @override
  State<CadastrarDisciplina> createState() => _CadastrarDisciplinaState();
}

class _CadastrarDisciplinaState extends State<CadastrarDisciplina> {
  final CadastroDisciplinaController controller =
      CadastroDisciplinaController();
  late final VoidCallback _submitListener;

  @override
  void initState() {
    super.initState();
    _submitListener = SubmitStateListener.attach(
      context: context,
      state: controller.submitState,
    );
  }

  @override
  void dispose() {
    _submitListener();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Nova Disciplina',
        ), // Título mais direto

        body: Center(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(
                32,
              ), // Respiro interno mais elegante
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(
                  24,
                ), 
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.03,
                    ), // Sombra hiper suave
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    _buildHeader(theme),

                    const SizedBox(height: 32),

                    
                    CustomTextFormField(
                      controller: controller.nomeDisciplinaController,
                      prefixIcon: CupertinoIcons.book_fill,
                      label: 'Nome da Disciplina',
                      hintText: 'Ex: Matemática Aplicada',
                      textCapitalization:
                          TextCapitalization.words, // Força maiúsculas
                    ),

                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: controller.aulasPrevistasController,
                            prefixIcon: CupertinoIcons.calendar,
                            label: 'Aulas previstas',
                            hintText: 'Ex: 40',
                            keyboardType: TextInputType.number,
                            
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            controller: controller.cargaHorariaController,
                            prefixIcon: CupertinoIcons.clock_fill,
                            label: 'Carga horária',
                            hintText: 'Ex: 80h',
                            keyboardType: TextInputType.number,
                            
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ),
                      ],
                    ),

                    CustomTextFormField(
                      controller: controller.nomeProfessorController,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      label: 'Professor(a) Responsável',
                      hintText: 'Ex: Paulo José',
                      textCapitalization:
                          TextCapitalization.words, // Força maiúsculas
                    ),

                    const SizedBox(height: 32),

                    
                    ValueListenableBuilder<SubmitState>(
                      valueListenable: controller.submitState,
                      builder: (_, state, __) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: SaveButton(
                                onSave: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  controller.submit();
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClearButton(
                              onClear: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.clear();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR ---

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            CupertinoIcons.bookmark_solid,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados da Matéria',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Defina as diretrizes acadêmicas da disciplina.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
