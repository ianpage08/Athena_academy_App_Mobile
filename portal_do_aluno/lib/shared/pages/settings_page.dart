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
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Configurações'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Conta'),

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
                const Divider(height: 1),
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

          const SizedBox(height: 24),
          _sectionTitle('Aparência'),

          _settingsCard(
            context,
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              secondary: const Icon(CupertinoIcons.moon_stars),
              title: const Text(
                'Modo escuro',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Ativar tema escuro'),
              value: themeProvider.isDarkmode,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(30, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
