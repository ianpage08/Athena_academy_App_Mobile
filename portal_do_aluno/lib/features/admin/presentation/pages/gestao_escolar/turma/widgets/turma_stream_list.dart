import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Ícones modernos
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/widgets/turma_card.dart';

class TurmaStreamList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Function(String id) onDelete;

  const TurmaStreamList({
    super.key,
    required this.stream,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        // 1. ESTADO DE CARREGAMENTO (Loading)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3, 
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          );
        }

        // 2. ESTADO DE ERRO
        if (snapshot.hasError) {
          return _buildStateFeedback(
            theme: theme,
            icon: CupertinoIcons.exclamationmark_triangle_fill,
            title: 'Ops! Falha na conexão.',
            subtitle: 'Não foi possível sincronizar as turmas no momento.',
            iconColor: theme.colorScheme.error,
          );
        }

        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildStateFeedback(
            theme: theme,
            icon: CupertinoIcons.tray_fill, // Ícone de bandeja vazia
            title: 'Nenhuma turma encontrada',
            subtitle:
                'O ecossistema está vazio. Cadastre a primeira turma para iniciar a gestão acadêmica.',
          );
        }

        
        final turmas = snapshot.data!.docs;

        return ListView.separated(
          
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),

          
          padding: const EdgeInsets.only(bottom: 100, top: 8),

          itemCount: turmas.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: 12), // Espaço que combinamos no card
          itemBuilder: (context, index) {
            final doc = turmas[index];

            
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc
                .id; // Garante que o TurmaCard ache o ID para a exclusão e contagem!

            return TurmaCard(data: data, onDelete: () => onDelete(doc.id));
          },
        );
      },
    );
  }

  // --- WIDGET AUXILIAR: UX DE FEEDBACK ---

  
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
