import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Disciplinas'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados da Disciplina',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Informe os dados para cadastrar uma nova disciplina.',
                  ),
                  const SizedBox(height: 24),

                  CustomTextFormField(
                    controller: controller.nomeDisciplinaController,
                    prefixIcon: Icons.book,
                    label: 'Nome da Disciplina',
                    hintText: 'Ex: Matemática',
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.aulasPrevistasController,
                    prefixIcon: Icons.calendar_month_outlined,
                    label: 'Aulas previstas',
                    hintText: 'Ex: 20',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.cargaHorariaController,
                    prefixIcon: Icons.lock_clock_outlined,
                    label: 'Carga horária',
                    hintText: 'Ex: 180',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.nomeProfessorController,
                    prefixIcon: Icons.person,
                    label: 'Professor',
                    hintText: 'Ex: Paulo José',
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
                              salvarconteudo: () async {
                                controller.submit();
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClearButton(
                            limparconteudo: () async {
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
    );
  }
}
