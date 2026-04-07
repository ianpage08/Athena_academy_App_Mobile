import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA 1: CupertinoIcons para estética Apple
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
// 👉 MUDANÇA 2: Importando o componente de dicas que refatoramos na etapa anterior (Ajuste o caminho se necessário)
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/adicao_de_usuarios/widgets/password_tips_section.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/features/auth/data/datasources/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formaKey = GlobalKey<FormState>();
  final CadastroService _cadastroService = CadastroService();
  bool isObscure = true;

  final Map<String, TextEditingController> _mapTextEditing = {
    'novaSenha': TextEditingController(),
    'repetirSenha': TextEditingController(),
  };

  List<TextEditingController> get listControllers =>
      _mapTextEditing.values.toList();

  @override
  void dispose() {
    for (var controller in listControllers) {
      controller.dispose(); // 👉 MUDANÇA 3: Prevenção de Memory Leak
    }
    super.dispose();
  }

  // 👉 MUDANÇA 4: Correção Lógica Crítica.
  // Agora a função retorna um 'bool' para avisar ao botão se a operação deu certo.
  Future<bool> _salvarSenha(String usuarioId) async {
    final novaSenha = _mapTextEditing['novaSenha']!.text;
    final repetirSenha = _mapTextEditing['repetirSenha']!.text;

    if (!FormHelper.isFormValid(
      formKey: _formaKey,
      listControllers: listControllers,
    )) {
      return false; // Falha na validação do formulário
    }

    if (novaSenha != repetirSenha) {
      showAppSnackBar(
        context: context,
        mensagem: 'As senhas digitadas não conferem.',
        cor: Theme.of(context).colorScheme.error,
      );
      return false; // Falha de senhas diferentes
    }

    try {
      await _cadastroService.atualizarSenha(usuarioId, novaSenha);
      return true; // Sucesso na API!
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Erro de conexão. Não foi possível atualizar a senha.',
          cor: Theme.of(context).colorScheme.error,
        );
      }
      return false; // Falha na API
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usuarioId =
        GoRouterState.of(context).uri.queryParameters['usuarioId'];

    if (usuarioId == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: ''),
        body: Center(
          child: Text(
            'Link ou usuário inválido.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(title: ''),
      // 👉 MUDANÇA 5: SafeArea e Scroll fluido para o teclado não quebrar a tela
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ), // Mantém a proporção elegante em tablets
              child: Form(
                key: _formaKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 👉 MUDANÇA 6: Header Tipográfico Premium
                    Text(
                      'Redefinir Senha',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crie uma nova credencial de acesso segura.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // 👉 MUDANÇA 7: Envelopamento do Formulário (Glassmorphism)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color:
                            theme.cardTheme.color ?? theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.05,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CAMPO: NOVA SENHA
                          Text(
                            'NOVA SENHA',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            obscureText: isObscure,
                            hintText: 'Digite a nova senha',
                            controller: _mapTextEditing['novaSenha']!,
                            prefixIcon: CupertinoIcons.lock_fill,
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => isObscure = !isObscure),
                              icon: Icon(
                                isObscure
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: theme.hintColor.withValues(alpha: 0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira a senha';
                              }
                              if (value.length < 8) {
                                return 'Mínimo de 8 caracteres';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Inclua ao menos 1 letra maiúscula';
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return 'Inclua ao menos 1 letra minúscula';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Inclua ao menos 1 número';
                              }
                              if (!value.contains(
                                RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                              )) {
                                return 'Inclua ao menos 1 símbolo especial';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // CAMPO: REPETIR SENHA
                          Text(
                            'CONFIRMAR SENHA',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            obscureText: isObscure,
                            controller: _mapTextEditing['repetirSenha']!,
                            hintText: 'Repita a nova senha',
                            prefixIcon: CupertinoIcons.lock,
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => isObscure = !isObscure),
                              icon: Icon(
                                isObscure
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: theme.hintColor.withValues(alpha: 0.5),
                              ),
                            ),
                            // 👉 MUDANÇA 8: Validação em tempo real adicionada ao segundo campo
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirme a nova senha';
                              }
                              if (value != _mapTextEditing['novaSenha']!.text) {
                                return 'As senhas não conferem';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 👉 MUDANÇA 9: Reutilização do Componente de Dicas (Clean Code!)
                    const PasswordTipsSection(),

                    const SizedBox(height: 32),

                    // 👉 MUDANÇA 10: Botão com controle assíncrono real
                    SizedBox(
                      height: 56,
                      child: SaveButton(
                        onSave: () async {
                          // Aguarda a resposta da API antes de decidir o que fazer
                          final sucesso = await _salvarSenha(usuarioId);

                          // Só navega para a tela de sucesso SE a API retornar OK
                          if (sucesso && mounted) {
                            NavigatorService.navigateReplaceWith(
                              RouteNames.sucessResetPassword,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
