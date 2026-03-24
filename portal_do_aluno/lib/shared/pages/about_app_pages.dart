import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sobre o App'),
      body: SingleChildScrollView(
        // 👉 MUDANÇA 1: Physics de mola para sensação premium
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👉 MUDANÇA 2: Seção de Branding (Identidade Visual)
            _buildBrandHeader(theme),

            const SizedBox(height: 40),

            _sectionTitle(context, 'Nossa Missão'),
            const SizedBox(height: 12),
            _buildGlassCard(
              theme,
              child: Text(
                'O Athena Academy é uma plataforma educacional de elite, criada para centralizar a vida acadêmica e elevar a transparência entre escola e família através da tecnologia.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 32),
            _sectionTitle(context, 'Ecossistema Athena'),
            const SizedBox(height: 16),

            // 👉 MUDANÇA 3: Grid de informações para melhor escaneabilidade
            _infoTile(
              context,
              icon: CupertinoIcons.flag_fill,
              title: 'Objetivo',
              description:
                  'Facilitar a gestão educacional promovendo acesso rápido e clareza.',
            ),
            _infoTile(
              context,
              icon: CupertinoIcons.group_solid,
              title: 'Comunidade',
              description:
                  'Alunos, professores e gestores em um ambiente digital moderno.',
            ),
            _infoTile(
              context,
              icon: CupertinoIcons.shield_lefthalf_fill,
              title: 'Privacidade',
              description:
                  'Dados protegidos por criptografia e protocolos de segurança.',
            ),
            _infoTile(
              context,
              icon: CupertinoIcons.rocket_fill,
              title: 'Evolução',
              description:
                  'Melhorias contínuas em performance e novas funcionalidades.',
            ),

            const SizedBox(height: 40),
            _buildVersionBadge(theme),
            const SizedBox(height: 24),

            // 👉 MUDANÇA 4: Rodapé minimalista e centralizado
            Opacity(
              opacity: 0.5,
              child: Text(
                '© ${DateTime.now().year} Athena Academy\nDesign & Code by Kraher',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES AUXILIARES ---

  Widget _buildBrandHeader(ThemeData theme) {
    return Column(
      children: [
        // Representação do Logo (Futuramente um Image.asset)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.infinite,
            size: 60,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ATHENA ACADEMY',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: theme.colorScheme.primary,
          ),
        ),
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(ThemeData theme, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👉 MUDANÇA 5: Container de ícone padronizado com o projeto
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Versão 1.0.0',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
