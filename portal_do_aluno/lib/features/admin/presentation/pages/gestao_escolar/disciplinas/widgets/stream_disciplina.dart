import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Importado para ícones de feedback modernos
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/widgets/disciplina_card.dart';

class StreamDisciplina extends StatelessWidget {
  final Stream<QuerySnapshot> minhaStream;
  final DisciplinaService disciplinaService;

  const StreamDisciplina({
    super.key,
    required this.minhaStream,
    required this.disciplinaService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: minhaStream,
      builder: (context, snapshot) {
        // 1. ESTADO DE CARREGAMENTO (Loading Premium)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          );
        }

        // 2. ESTADO DE ERRO (Tratamento Visual)
        if (snapshot.hasError) {
          return _buildStateFeedback(
            theme: theme,
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            title: 'Erro de Sincronização',
            subtitle:
                'Não foi possível carregar a grade curricular no momento.',
            iconColor: theme.colorScheme.error,
          );
        }

        // 3. ESTADO VAZIO (Empty State Engajador)
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildStateFeedback(
            theme: theme,
            icon: CupertinoIcons.book_fill, // Ícone semântico da entidade
            title: 'Nenhuma Disciplina Encontrada',
            subtitle:
                'A grade está vazia. Cadastre a primeira matéria para estruturar o ensino.',
          );
        }

        // 4. ESTADO DE SUCESSO (Lista Renderizada)
        final disciplinas = snapshot.data!.docs;

        return ListView.separated(
          // 👉 MUDANÇA 1: Scroll vivo (Física elástica estilo iOS)
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          // 👉 MUDANÇA 2: Padding inteligente para proteger o fim da lista de botões FAB
          padding: const EdgeInsets.only(bottom: 100, top: 8),

          itemCount: disciplinas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = disciplinas[index];

            // 👉 MUDANÇA 3: PREVENÇÃO DE BUG CRÍTICO (Injeção do Document ID)
            final data = doc.data() as Map<String, dynamic>;
            data['id'] =
                doc.id; // Sem isso, o excluirDisciplina do Card não funciona!

            return DisciplinaCard(
              data: data,
              disciplinaService: disciplinaService,
            );
          },
        );
      },
    );
  }

  // --- WIDGET AUXILIAR: UX DE FEEDBACK ---

  // 👉 MUDANÇA 4: Criação de um layout de feedback sofisticado (Glassmorphism)
  Widget _buildStateFeedback({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
  }) {
    final color = iconColor ?? theme.hintColor.withValues(alpha: 0.3);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
