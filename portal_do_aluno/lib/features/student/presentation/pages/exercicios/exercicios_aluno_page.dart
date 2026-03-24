import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/exercicios/widgets/card_exercicio.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/exercicios/exercicios_detalhes/exercicios_detalhes_page.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart'; 
import 'package:provider/provider.dart';

class ExerciciosAlunoPage extends StatefulWidget {
  const ExerciciosAlunoPage({super.key});

  @override
  State<ExerciciosAlunoPage> createState() => _ExerciciosAlunoPageState();
}

class _ExerciciosAlunoPageState extends State<ExerciciosAlunoPage> {
  String? _turmaId;
  bool _loadingInitialData = true;

  @override
  void initState() {
    super.initState();
    //  Busca de dados movida para o initState para evitar rebuilds infinitos
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      if (mounted) {
        setState(() {
          _turmaId = snapshot.data()?['turmaId'];
          _loadingInitialData = false;
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar turma: $e');
      if (mounted) setState(() => _loadingInitialData = false);
    }
  }

  Stream<QuerySnapshot> _getExerciciosStream(String turmaId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .where('turmaId', isEqualTo: turmaId)
        .snapshots();
  }

  //  Função simplificada e injetada no card
  Future<bool> _getStatusEntregue(String userId, String exerciciosId) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .collection('exercicios_status')
        .doc(exerciciosId)
        .get();

    return doc.data()?['status'] == true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (_loadingInitialData) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Exercícios',
        nameRoute: RouteNames.studentComunicados,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Suas Atividades',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fique em dia com seus exercícios e prazos.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getExerciciosStream(_turmaId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    //  Usando o widget global de Empty State
                    return const EmptyStateWidget(
                      icon: Icons.assignment_turned_in_outlined,
                      title: 'Tudo em dia!',
                      description:
                          'Não encontramos nenhum exercício pendente para sua turma no momento.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final exercicio = docs[index];
                      final data = exercicio.data() as Map<String, dynamic>;

                      
                      // Removido o Container roxo externo que causava os erros de borda e overflow.
                      return Hero(
                        tag: exercicio.id,
                        child: Material(
                          color: Colors
                              .transparent, 
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  
                                  builder: (_) => ExerciciosDetalhesPage(
                                    exercicios: exercicio,
                                  ),
                                ),
                              ).then((_) => setState(() {}));
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: CardExercicio(
                              titulo: data['titulo'] ?? 'Sem título',
                              conteudo: data['conteudoDoExercicio'] ?? '',
                              nomeProfessor:
                                  data['nomeDoProfessor'] ?? 'Instituição',
                              userId: userProvider.userId!,
                              exerciciosId: exercicio.id,
                              getStatusEntregue: _getStatusEntregue,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
