import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ConfiguracaoPage1 extends StatelessWidget {
  const ConfiguracaoPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: const CustomAppBar(title: 'Configurações'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurações de Conta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            cardItem(
              'Ajuda',
              'Central de ajuda e suporte',
              CupertinoIcons.question_circle,
              context,
            ),
            const SizedBox(height: 16),
            cardItem(
              'Sobre o App',
              'Informações sobre o aplicativo',
              CupertinoIcons.info_circle,
              context,
            ),
            const SizedBox(height: 32),
            const Text(
              'Ativar Modo Escuro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(47, 158, 158, 158),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SwitchListTile(
                title: const Row(
                  children: [
                    Icon(CupertinoIcons.moon_stars, size: 32),
                    SizedBox(width: 12),
                    Text('Tema escuro', style: TextStyle(fontSize: 20)),
                  ],
                ),

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
      ),
    );
  }

  Widget cardItem(
    String title,
    String subtitle,
    IconData icon,
    BuildContext context,
  ) {
    return GestureDetector(
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(47, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        icon,
                        size: 40,
                        color: const Color.fromARGB(255, 156, 190, 241),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 169, 175, 184),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(CupertinoIcons.chevron_forward),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
