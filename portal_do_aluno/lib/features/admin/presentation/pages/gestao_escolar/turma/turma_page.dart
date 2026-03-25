import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // 👉 Importado para ícones mais finos e modernos
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/widgets/turma_stream_list.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});

  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {
  
  final CadastroTurmaService _serviceTurma = CadastroTurmaService();
  final Stream<QuerySnapshot> _streamTurma = FirebaseFirestore.instance
      .collection('turmas')
      .snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTurmaById(String classId) {
    return FirebaseFirestore.instance
        .collection('turmas')
        .doc(classId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigatorService.navigateTo(RouteNames.adminCadastroTurmas);
        },
        backgroundColor: AppColors.lightButtonPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(CupertinoIcons.add),
        label: const Text(
          'Nova Turma',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildHeader(theme),

            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TurmaStreamList(
                  stream: _streamTurma,
                  onDelete: (id) {
                    _serviceTurma.excluirTurma(id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES DA UI ---

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícone com fundo Glassmorphism para identidade visual
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  CupertinoIcons.rectangle_grid_2x2_fill,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Gestão de Turmas',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900, // Tipografia bold futurista
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Acompanhe, organize e gerencie as classes do ecossistema acadêmico.',
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
