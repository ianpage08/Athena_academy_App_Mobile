import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA 1: Estética refinada
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class PasswordChangedSuccessPage extends StatefulWidget {
  const PasswordChangedSuccessPage({super.key});

  @override
  State<PasswordChangedSuccessPage> createState() =>
      _PasswordChangedSuccessPageState();
}

class _PasswordChangedSuccessPageState extends State<PasswordChangedSuccessPage>
    with SingleTickerProviderStateMixin {
  // 👉 MUDANÇA 2: Adicionado controlador para a barra de progresso visual
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    // Inicializa a animação para durar os mesmos 3 segundos do redirecionamento
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    // Redirecionamento automático
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      // 👉 DECISÃO TÉCNICA: Limpamos a pilha para evitar que o usuário volte para a tela de troca de senha
      NavigatorService.navigateAndRemoveUntil(RouteNames.adminListaDeUsuarios);
    });
  }

  @override
  void dispose() {
    _progressController.dispose(); // Limpeza de memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 👉 MUDANÇA 3: Feedback Visual Futurista (Animação de escala implícita)
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    // Gradiente sutil em vez de cor sólida
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withValues(alpha: 0.2),
                        Colors.green.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 👉 MUDANÇA 4: Hierarquia Tipográfica
              Text(
                'Tudo pronto!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sua senha foi atualizada com segurança. Estamos te levando de volta ao painel.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.hintColor.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              // 👉 MUDANÇA 5: Timer Visual (Substituindo o CircularProgressIndicator)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 140,
                      height: 6,
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Redirecionando...',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
