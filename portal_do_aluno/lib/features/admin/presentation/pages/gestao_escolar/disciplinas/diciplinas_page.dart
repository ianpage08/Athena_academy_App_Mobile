import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Ícones modernos integrados
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/widgets/stream_disciplina.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class DiciplinasPage extends StatefulWidget {
  const DiciplinasPage({super.key});

  @override
  State<DiciplinasPage> createState() => _DiciplinasPageState();
}

class _DiciplinasPageState extends State<DiciplinasPage> {
  // 🧠 LÓGICA INTACTA: Stream, Service e OrderBy preservados
  final DisciplinaService _disciplinaService = DisciplinaService();

  final Stream<QuerySnapshot> minhaStream = FirebaseFirestore.instance
      .collection('disciplinas')
      .orderBy('nome')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      // 👉 MUDANÇA 1: Fim do botão espremido na AppBar. Agora temos um FAB de destaque!
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigatorService.navigateTo(RouteNames.adminCadastrarDisciplina);
        },
        backgroundColor: AppColors.lightButtonPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(CupertinoIcons.add),
        label: const Text(
          'Nova Disciplina',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👉 MUDANÇA 2: Cabeçalho rico (Dashboard Style)
            _buildHeader(theme),

            // 👉 MUDANÇA 3: Expanded para preencher o resto da tela com segurança
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamDisciplina(
                  minhaStream: minhaStream,
                  disciplinaService: _disciplinaService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR DA UI ---

  // 👉 MUDANÇA 4: Componentização do Header para deixar o build() limpo
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar de Contexto (Glassmorphism)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  CupertinoIcons.book_fill, // Ícone que conversa com o módulo
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // UX Writing: Título mais executivo
              Text(
                'Grade Curricular',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Gerencie as disciplinas oferecidas pela instituição e seus respectivos professores responsáveis.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
