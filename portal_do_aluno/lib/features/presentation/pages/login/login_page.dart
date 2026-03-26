import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart'; // 👉 NOVO: Feedback visual premium
import 'package:portal_do_aluno/core/utils/validacao.dart';
import 'package:portal_do_aluno/shared/helpers/single_execution_flag.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
import 'package:portal_do_aluno/features/auth/data/datasources/auth_service_datasource.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import '../../../../core/app_constants/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SingleExecutionFlag _navigationFlag = SingleExecutionFlag();

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 👉 DESIGN: Fundo liso e clean conforme diretriz
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // 👉 DESIGN: Espaçamento mais generoso para telas maiores
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 👉 HEADER: Seção de Marca/Identidade
                _buildHeroSection(theme),

                const SizedBox(height: 48),

                // 👉 MUDANÇA: Troquei o Card clássico por um Container clean com borda sutil
                // Isso remove o aspecto "caixa pesada" e traz o ar futurista.
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 👉 CPF INPUT
                        CustomTextFormField(
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                            CpfInputFormatter(),
                          ],
                          label: 'CPF',
                          prefixIcon: CupertinoIcons.person, // Ícone mais fino
                          hintText: '000.000.000-00',
                          validator: (value) => validarCpf(value),
                          enable: !isLoading,
                        ),

                        const SizedBox(height: 20),

                        // 👉 SENHA INPUT
                        CustomTextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          label: 'Senha',
                          hintText: 'Digite sua senha',
                          prefixIcon: CupertinoIcons.lock_shield,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              size: 20,
                            ),
                          ),
                          validator: (value) => validarSenha(value),
                          enable: !isLoading,
                        ),

                        const SizedBox(height: 12),

                        // 👉 ESQUECI SENHA: Alinhado à direita para melhor hierarquia
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading ? null : _handleForgotPassword,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              // 👉 MUDANÇA: Garante que não haja bordas de nenhuma cor/espessura
                              side: BorderSide.none,
                              // 👉 MUDANÇA: Define o shape como retangular ou arredondado sem bordas visíveis
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              foregroundColor: theme.primaryColor.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            child: const Text('Esqueci minha senha'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 👉 BOTÃO LOGIN: Componente principal
                        _buildLoginButton(theme),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 👉 USUÁRIOS DE TESTE: Refatorado para parecer um painel técnico
                _buildTestPanel(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 👉 NOVO: Widget de Identidade (Hero)
  Widget _buildHeroSection(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.book_fill, // Mudança para ícone mais clean
            color: theme.primaryColor,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppConstants.nameApp,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'GESTÃO EDUCACIONAL INTELIGENTE', // Slogan mais profissional
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: theme.hintColor.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  // 👉 MUDANÇA: Botão com estado de loading elegante
  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : _handleLogin,
        child: isLoading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : const Text(
                'Entrar no Portal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  // 👉 MUDANÇA: Painel de teste mais elegante e compacto
  Widget _buildTestPanel(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                size: 16,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'ACESSO RÁPIDO (MODO TESTE)',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.primaryColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestUser('Aluno', '000.000.000-00', '@Maciel2003', theme),
          _buildTestUser('Professor', '666.666.666-66', '@Maciel2003', theme),
          _buildTestUser(
            'Administrador',
            '853.523.000-00',
            '@Maciel2003',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildTestUser(
    String tipo,
    String cpf,
    String senha,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          _cpfController.text = cpf;
          _passwordController.text = senha;
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '$cpf / $senha',
                      style: TextStyle(fontSize: 11, color: theme.hintColor),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.doc_on_clipboard,
                size: 18,
                color: theme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LOGICA INTACTA ABAIXO
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    _navigationFlag.execute(() async {
      try {
        final cpf = _cpfController.text.trim();
        final senha = _passwordController.text.trim();
        final usuario = await AuthServico().loginCpfsenha(cpf, senha);
        if (!mounted) return;
        NavigatorService.setCurrentUser(usuario);
        await NavigatorService.navigateToDashboard();
      } catch (e) {
        if (mounted) {
          showAppSnackBar(
            context: context,
            mensagem: 'Cpf ou senha inválidos',
            cor: Colors.red,
          );
        }
        _navigationFlag.reset();
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    });
  }

  void _handleForgotPassword() {
    showAppSnackBar(
      context: context,
      mensagem: 'Entre em contato com a secretaria do colégio',
      cor: Colors.orange,
    );
  }
}
