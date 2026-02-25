import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/cadastro_turmas/controller/cadastro_turma_controller.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class CadastroTurma extends StatefulWidget {
  const CadastroTurma({super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  
  final CadastroTurmaController controller = CadastroTurmaController();
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
      appBar: const CustomAppBar(title: 'Cadastro de Turma'),

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
                  // HEADER
                  const Text(
                    'Dados da Turma',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Informe os dados básicos para criar uma nova turma.',
                  ),

                  const SizedBox(height: 24),

                  // CAMPOS
                  CustomTextFormField(
                    controller: controller.professorTitularController,
                    prefixIcon: Icons.person,
                    label: 'Professor titular',
                    hintText: 'Ex: Maria Silva',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.turnoController,
                    prefixIcon: Icons.schedule,
                    label: 'Turno',
                    hintText: 'Matutino / Vespertino',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.serieController,
                    prefixIcon: Icons.class_,
                    label: 'Série',
                    hintText: '9º Ano',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: controller.qtdAlunosController,
                    prefixIcon: Icons.group,
                    label: 'Quantidade de alunos',
                    hintText: 'Ex: 25',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 32),

                  // BOTÃO
                  SizedBox(
                    width: double.infinity,
                    child: SaveButton(
                      salvarconteudo: () async {
                        controller.submit();
                      },
                    ),
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
