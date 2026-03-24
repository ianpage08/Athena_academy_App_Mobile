import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/settings_tile.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //  Usando select para observar apenas a propriedade isDarkmode.
    // Isso evita que esta página sofra rebuild se outras propriedades do ThemeProvider mudarem.
    final isDark = context.select((ThemeProvider p) => p.isDarkmode);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Configurações'),
      body: ListView(
        // Scroll com física de mola (iOS style)
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildHeader(theme),
          const SizedBox(height: 32),

          _sectionTitle('Conta'),
          const SizedBox(height: 12),
          _settingsCard(
            context,
            child: Column(
              children: [
                SettingsTile(
                  icon: CupertinoIcons.question_circle,
                  title: 'Ajuda',
                  subtitle: 'Central de ajuda e suporte',
                  onTap: () =>
                      NavigatorService.navigateTo(RouteNames.helpAppPage),
                ),
                _buildDivider(theme),
                SettingsTile(
                  icon: CupertinoIcons.info_circle,
                  title: 'Sobre o App',
                  subtitle: 'Informações do aplicativo',
                  onTap: () =>
                      NavigatorService.navigateTo(RouteNames.aboutAppPage),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          _sectionTitle('Aparência'),
          const SizedBox(height: 12),
          _settingsCard(
            context,
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDark
                      ? CupertinoIcons.moon_fill
                      : CupertinoIcons.sun_max_fill,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Modo Escuro',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                isDark ? 'Ativado' : 'Desativado',
                style: theme.textTheme.bodySmall,
              ),
              activeThumbColor: theme.colorScheme.primary,
              value: isDark,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),

          const SizedBox(height: 48),
          _buildFooter(theme),
        ],
      ),
    );
  }

  // --- COMPONENTES AUXILIARES ---

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            CupertinoIcons.settings,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ajustes do Sistema',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Personalize sua experiência no portal',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          20,
        ), // 👉 Bordas mais arredondadas (moderno)
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 56, // 👉 Alinhamento inteligente com o texto, ignorando o ícone
      endIndent: 16,
      color: theme.dividerColor.withValues(alpha: 0.1),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Athena Academy v1.0.0',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        const Text(
          'Feito  por',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
