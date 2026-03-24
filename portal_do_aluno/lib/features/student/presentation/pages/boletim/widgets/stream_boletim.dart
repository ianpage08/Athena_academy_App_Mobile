import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/discipline_tile.dart';
import 'package:portal_do_aluno/features/teacher/data/models/grade_record.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';

/// Orquestrador reativo do Boletim do Aluno.
class StreamBoletim extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  const StreamBoletim({super.key, required this.stream});

//Helper global de Empty State para essa tela
  // Garante que todo aviso (seja de erro, falta de dados ou ausência de nota)
  // tenha o mesmo padrão premium Apple/Google.
  Widget _buildEmptyState(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.8),
                height: 1.4, // Melhora a legibilidade do parágrafo
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        // 1. Estado de Erro
        if (snapshot.hasError) {
          debugPrint('❌ Erro no stream: ${snapshot.error}');
          return _buildEmptyState(
            context,
            title: 'Erro de Conexão',
            subtitle:
                'Não foi possível carregar o boletim no momento.\nVerifique sua internet ou tente mais tarde.',
            icon: CupertinoIcons.exclamationmark_triangle,
          );
        }

        // 2. Estado de Carregamento (Loading Suave)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CupertinoActivityIndicator(radius: 16),
            ),
          );
        }

        // 3. Estado Vazio (Documento não existe)
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildEmptyState(
            context,
            title: 'Boletim Indisponível',
            subtitle:
                'As notas ainda não foram lançadas para este aluno.\nAssim que o professor registrar as avaliações, elas aparecerão aqui.',
            icon: CupertinoIcons.doc_text_search,
          );
        }

        final data = snapshot.data!.data();

        // 4. Estado Vazio (Documento existe, mas campo "disciplinas" não existe ou está vazio)
        final disciplinasRaw = data?['disciplinas'];
        if (disciplinasRaw == null ||
            disciplinasRaw is! List ||
            disciplinasRaw.isEmpty) {
          return const EmptyStateWidget(
            title: 'Nenhuma Disciplina Lançada',
            description:
                'O boletim foi gerado, mas os professores ainda não inseriram as médias e notas das unidades.',
            icon: CupertinoIcons.tray,
          );
        }

        // 5. Sucesso! Processamento e Renderização
        final disciplinas = List<Map<String, dynamic>>.from(disciplinasRaw);

       
        // Como o DisciplineTile já tem o design premium com bordas, se você colocasse
        // ele dentro de outro Container com bordas, a interface ficaria extremamente suja.
        // Agora nós apenas retornamos uma Column limpa.
        return Column(
          children: disciplinas.map((materia) {
            final disciplina = GradeRecord.fromJson(materia);
            return DisciplineTile(disciplina: disciplina);
          }).toList(),
        );
      },
    );
  }
}
