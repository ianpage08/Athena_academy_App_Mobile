import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA 1: Importado para ícones premium
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/controller/add_usuario_controller.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/admin/admin_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/form_validators.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/password_tips_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/professor/professor_cadastro_section.dart';

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
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor, // Fundo dinâmico
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        final tipos = ['Professor', 'Aluno', 'Administrador'];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                'Perfil de Acesso',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...tipos.map((tipo) {
                final selected = controller.tipoSelecionado == tipo;

                return ListTile(
                  leading: Icon(
                    _iconByTipo(tipo),
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color,
                  ),
                  title: Text(
                    tipo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  trailing: selected
                      ? Icon(
                          CupertinoIcons.checkmark_alt,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() => controller.tipoSelecionado = tipo);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  IconData _iconByTipo(String tipo) {
    switch (tipo) {
      case 'Professor':
        return CupertinoIcons.book_solid;
      case 'Aluno':
        return CupertinoIcons.person_solid;
      case 'Administrador':
        return CupertinoIcons.shield_fill;
      default:
        return CupertinoIcons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER TIPOGRÁFICO
                Text(
                  'Cadastro no Portal',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selecione o perfil e preencha as informações para registrar um novo acesso.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'TIPO DE USUÁRIO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _abrirTipoUsuarioModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ), // Mesmo padding do BuildInput
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: controller.tipoSelecionado != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withValues(alpha: 0.1),
                        width: controller.tipoSelecionado != null ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.tipoSelecionado != null
                              ? _iconByTipo(controller.tipoSelecionado!)
                              : CupertinoIcons.person_badge_plus,
                          color: controller.tipoSelecionado != null
                              ? theme.colorScheme.primary
                              : theme.hintColor.withValues(alpha: 0.5),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.tipoSelecionado ??
                                'Selecione o perfil...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: controller.tipoSelecionado != null
                                  ? theme.textTheme.bodyLarge?.color
                                  : theme.hintColor.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_up_chevron_down,
                          size: 16,
                          color: theme.hintColor.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                if (controller.isAluno) ...[
                  // O SelectStudentButton e SelectClassButton já estão otimizados!
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
                    nomeController: controller.controllers['nome']!,
                    cpfController: controller.controllers['cpf']!,
                    enabled: true,
                  ),
                ],

                if (controller.isAdmin) ...[
                  AdminCadastro(
                    nomeController: controller.controllers['nome']!,
                    cpfController: controller.controllers['cpf']!,
                    enabled: true,
                  ),
                ],

                if (controller.tipoSelecionado != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'CREDENCIAIS DE ACESSO',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color ?? theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.05,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: controller.controllers['senha']!,
                          label: 'Senha',
                          hintText: 'Digite uma senha segura',
                          obscureText: !controller.isPasswordVisible,
                          prefixIcon: CupertinoIcons.lock_fill,
                          validator: FormValidators.senha,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible
                                  ? CupertinoIcons.eye_slash_fill
                                  : CupertinoIcons.eye_fill,
                              color: theme.hintColor.withValues(alpha: 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                controller.isPasswordVisible =
                                    !controller.isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: controller.controllers['confirmarSenha']!,
                          label: 'Confirmar Senha',
                          hintText: 'Repita a senha digitada',
                          validator: (value) => FormValidators.confirmarSenha(
                            value,
                            controller.controllers['senha']!.text,
                          ),
                          obscureText: !controller.isPasswordVisible,
                          prefixIcon: CupertinoIcons.lock,
                        ),
                        const SizedBox(height: 24),
                        const PasswordTipsSection(), // Já refatorado!
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                /// ACTIONS
                Row(
                  children: [
                    Expanded(
                      flex: 2, // Peso maior para a ação primária
                      child: SizedBox(
                        height: 56,
                        child: SaveButton(
                          onSave: () async {
                            final sucesso = await controller.salvar();
                            if (!mounted) return;

                            showAppSnackBar(
                              context: context,
                              mensagem: sucesso
                                  ? 'Usuário registrado com sucesso!'
                                  : 'Não foi possível registrar o usuário.',
                              cor: sucesso
                                  ? Colors.green
                                  : Colors
                                        .red, // Pode evoluir para pegar do tema depois
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1, // Peso menor para ação secundária
                      child: SizedBox(
                        height: 56,
                        child: ClearButton(
                          onClear: () async {
                            controller.limpar();
                            setState(
                              () {},
                            ); // Atualiza a tela para limpar o dropdown
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Respiro final para o scroll
              ],
            ),
          ),
        ),
      ),
    );
  }
}
