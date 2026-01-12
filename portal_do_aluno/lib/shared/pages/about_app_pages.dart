import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sobre o App'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(context, 'Portal do Aluno'),

            const SizedBox(height: 8),
            Text(
              'O Portal do Aluno é uma plataforma educacional criada para centralizar informações acadêmicas, melhorar a comunicação escolar e oferecer mais transparência no acompanhamento do desempenho dos alunos.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            _infoTile(
              context,
              icon: Icons.flag_rounded,
              title: 'Missão',
              description:
                  'Facilitar a gestão educacional por meio da tecnologia, promovendo organização, clareza e acesso rápido às informações escolares.',
            ),

            _infoTile(
              context,
              icon: Icons.group_rounded,
              title: 'Público-alvo',
              description:
                  'Alunos, professores, responsáveis e administradores escolares que buscam um ambiente digital moderno e funcional.',
            ),

            _infoTile(
              context,
              icon: Icons.school_rounded,
              title: 'Principais Funcionalidades',
              description:
                  '• Acompanhamento de notas e boletim\n'
                  '• Registro e consulta de frequência\n'
                  '• Comunicados escolares\n'
                  '• Conteúdos ministrados em aula\n'
                  '• Exercícios e atividades',
            ),

            const SizedBox(height: 16),

            _infoTile(
              context,
              icon: Icons.security_rounded,
              title: 'Segurança e Privacidade',
              description:
                  'Os dados são armazenados de forma segura e acessados apenas por usuários autorizados, respeitando boas práticas de segurança e privacidade.',
            ),

            _infoTile(
              context,
              icon: Icons.build_circle_rounded,
              title: 'Evolução contínua',
              description:
                  'O aplicativo está em constante evolução, recebendo melhorias de desempenho, usabilidade e novas funcionalidades.',
            ),

            _infoTile(
              context,
              icon: Icons.update_rounded,
              title: 'Versão do Aplicativo',
              description: 'v1.0.0',
            ),

            const SizedBox(height: 24),
            const Divider(),

            const SizedBox(height: 16),
            Center(
              child: Text(
                '© ${DateTime.now().year} Portal do Aluno\nTodos os direitos reservados.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
