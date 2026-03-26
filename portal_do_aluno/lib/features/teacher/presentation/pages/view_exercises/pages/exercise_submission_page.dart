import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';

class ExerciseSubmissionPage extends StatefulWidget {
  const ExerciseSubmissionPage({super.key});

  @override
  State<ExerciseSubmissionPage> createState() => _ExerciseSubmissionPageState();
}

class _ExerciseSubmissionPageState extends State<ExerciseSubmissionPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>> getListExercise(
    String teacherID,
  ) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .where('professorId', isEqualTo: teacherID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teacherId = Provider.of<UserProvider>(context).userId;

    if (teacherId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Portal do Professor'),
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ATIVIDADES",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: theme.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Submissões Pendentes",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildStreamListExercice(teacherID: teacherId)),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamListExercice({required String teacherID}) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getListExercise(teacherID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        final data = snapshot.data?.docs ?? [];

        if (data.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.auto_awesome_motion_rounded,
            title: 'Nenhuma atividade publicada',
            description: 'Sua lista de exercícios está vazia no momento.',
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final doc = data[index];
            final title = doc['titulo'] ?? 'Sem Título';
            final description = doc['conteudoDoExercicio'] ?? '';
            final deliveryDate = (doc['dataDeEntrega'] as Timestamp).toDate();
            final exerciceId = doc.id;
            final formattedDate = DateFormat(
              'dd MMM yyyy',
              'pt_BR',
            ).format(deliveryDate);

            return _buildFuturisticCard(
              context,
              title: title,
              description: description,
              date: formattedDate,
              onTap: () {
                NavigatorService.navigateTo(
                  RouteNames.teacherSubimissionDetail,
                  arguments: exerciceId,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFuturisticCard(
    BuildContext context, {
    required String title,
    required String description,
    required String date,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : theme.primaryColor.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: theme.primaryColor.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Data Limite de Entrega: ${date.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: theme.hintColor.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 16,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Ver alunos",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
