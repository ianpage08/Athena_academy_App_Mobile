import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Ajuda & Suporte'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _helpCard(
            context,
            icon: Icons.person_add_rounded,
            title: 'Cadastro de usuários',
            description:
                'Administradores podem cadastrar alunos, professores e responsáveis através do menu de usuários.',
          ),
          _helpCard(
            context,
            icon: Icons.assignment_rounded,
            title: 'Notas e boletim',
            description:
                'As notas são lançadas pelos professores e ficam disponíveis automaticamente no boletim do aluno.',
          ),
          _helpCard(
            context,
            icon: Icons.campaign_rounded,
            title: 'Comunicados',
            description:
                'Os comunicados são exibidos conforme o perfil do usuário e nível de prioridade.',
          ),
          _helpCard(
            context,
            icon: Icons.lock_rounded,
            title: 'Problemas com acesso',
            description:
                'Verifique sua senha ou entre em contato com a administração da escola.',
          ),
          _helpCard(
            context,
            icon: Icons.support_agent_rounded,
            title: 'Suporte',
            description:
                'Em caso de dúvidas ou problemas técnicos, procure a coordenação ou o suporte do sistema.',
          ),
        ],
      ),
    );
  }

  Widget _helpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(description),
        ),
      ),
    );
  }
}
