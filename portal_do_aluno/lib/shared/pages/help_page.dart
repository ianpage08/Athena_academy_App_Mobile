import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Ajuda & Suporte'),
      body: CustomScrollView(
        // 👉 MUDANÇA 1: Usando CustomScrollView para permitir efeitos de scroll premium
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(theme),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHelpSection(
                  context,
                  icon: CupertinoIcons.person_badge_plus,
                  title: 'Cadastro de usuários',
                  description:
                      'Administradores podem cadastrar alunos, professores e responsáveis através do menu de usuários dedicados na área administrativa.',
                ),
                _buildHelpSection(
                  context,
                  icon: CupertinoIcons.doc_text_viewfinder,
                  title: 'Notas e boletim',
                  description:
                      'As notas são lançadas pelos professores e ficam disponíveis automaticamente no boletim do aluno assim que o período letivo é encerrado.',
                ),
                _buildHelpSection(
                  context,
                  icon: CupertinoIcons.speaker_2,
                  title: 'Comunicados',
                  description:
                      'Os comunicados são exibidos conforme o perfil do usuário e nível de prioridade, garantindo que informações críticas cheguem primeiro.',
                ),
                _buildHelpSection(
                  context,
                  icon: CupertinoIcons.lock_shield,
                  title: 'Problemas com acesso',
                  description:
                      'Verifique sua senha ou entre em contato com a administração da escola para resetar suas credenciais de segurança.',
                ),
                _buildHelpSection(
                  context,
                  icon: CupertinoIcons.headphones,
                  title: 'Suporte Técnico',
                  description:
                      'Em caso de dúvidas ou problemas técnicos, nossa equipe está disponível através do chat da coordenação ou suporte central.',
                ),
              ]),
            ),
          ),
          // 👉 MUDANÇA 2: Rodapé de contato rápido
          _buildQuickContact(theme),
        ],
      ),
    );
  }

  // --- COMPONENTES DA INTERFACE ---

  Widget _buildHeader(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como podemos\najudar hoje?',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Encontre respostas rápidas para as dúvidas mais comuns sobre o portal.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    // 👉 MUDANÇA 3: Substituição do Card simples por um ExpansionTile customizado
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // 👉 MUDANÇA 4: Uso do termo atualizado withValues(alpha: ...)
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // Remove a borda padrão do ExpansionTile ao abrir
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.centerLeft,
          children: [
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickContact(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Gradiente elegante para chamar atenção para o suporte
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Não encontrou o que precisava?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Fale com nosso time técnico agora.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {}, // Ação de contato
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
