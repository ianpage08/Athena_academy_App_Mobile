import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o_de_usuarios/controller/add_usuario_controller.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o_de_usuarios/widgets/admin/admin_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o_de_usuarios/widgets/form_validators.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o_de_usuarios/widgets/password_tips_section.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adi%C3%A7%C3%A3o_de_usuarios/widgets/professor/professor_cadastro_section.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/clear_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';

class AddUsuarioPage extends StatefulWidget {
  const AddUsuarioPage({super.key});

  @override
  State<AddUsuarioPage> createState() => _AddUsuarioPageState();
}

class _AddUsuarioPageState extends State<AddUsuarioPage> {
  final controller = AddUsuarioController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _abrirTipoUsuarioModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      builder: (_) {
        final tipos = ['Professor', 'Aluno', 'Administrador'];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Selecione o tipo de usuário',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...tipos.map((tipo) {
              final selected = controller.tipoSelecionado == tipo;

              return ListTile(
                leading: Icon(
                  _iconByTipo(tipo),
                  color: selected ? Colors.indigo : null,
                ),
                title: Text(tipo),
                trailing: selected
                    ? const Icon(Icons.check, color: Colors.indigo)
                    : null,
                onTap: () {
                  setState(() => controller.tipoSelecionado = tipo);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  IconData _iconByTipo(String tipo) {
    switch (tipo) {
      case 'Professor':
        return Icons.school;
      case 'Aluno':
        return Icons.person;
      case 'Administrador':
        return Icons.admin_panel_settings;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Cadastrar Usuário',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                /// SELECT TIPO
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _abrirTipoUsuarioModal,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.indigo.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.tipoSelecionado ??
                                'Selecione o tipo de usuário',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// CONTEÚDO DINÂMICO
                if (controller.isAluno) ...[
                  SelectClassButton(
                    turmaSelecionada: controller.turmaSelecionada,
                    onTurmaSelecionada: (id, _) {
                      setState(() => controller.turmaId = id);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (controller.turmaId != null)
                    SelectStudentButton(
                      turmaId: controller.turmaId,
                      alunoSelecionado: controller.alunoSelecionado,
                      onAlunoSelecionado: (id, nome, cpf) {
                        controller.alunoId = id;
                        controller.nomeAluno = nome;
                        controller.cpfSelecionado = cpf;
                      },
                    ),
                ],

                if (controller.isProfessor) ...[
                  ProfessorCadastro(
                    mapController1: controller.controllers['nome']!,
                    mapController2: controller.controllers['cpf']!,
                    enabled: true,
                  ),
                ],

                if (controller.isAdmin) ...[
                  AdminCadastro(
                    mapController1: controller.controllers['nome']!,
                    mapController2: controller.controllers['cpf']!,
                    enabled: true,
                  ),
                ],

                const SizedBox(height: 16),

                /// SENHA
                CustomTextFormField(
                  controller: controller.controllers['senha']!,
                  label: 'Senha',
                  obscureText: !controller.isPasswordVisible,
                  prefixIcon: Icons.lock,
                  validator: FormValidators.senha,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        controller.isPasswordVisible =
                            !controller.isPasswordVisible;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                CustomTextFormField(
                  controller: controller.controllers['confirmarSenha']!,
                  label: 'Confirmar Senha',
                  validator: (value) => FormValidators.confirmarSenha(
                    value,
                    controller.controllers['senha']!.text,
                  ),
                  obscureText: !controller.isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                ),
                const PasswordTipsSection(),
                const SizedBox(height: 24),

                /// ACTIONS
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: SaveButton(
                          salvarconteudo: () async {
                            final sucesso = await controller.salvar();
                            if (!mounted) {
                              return;
                            }

                            showAppSnackBar(
                              context: context,
                              mensagem: sucesso
                                  ? 'Usuário cadastrado com sucesso'
                                  : 'Erro ao cadastrar usuário',
                              cor: sucesso ? Colors.green : Colors.red,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ClearButton(
                          limparconteudo: () async {
                            controller.limpar();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
