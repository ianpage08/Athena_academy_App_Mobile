import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/view_exercises/pages/submission_detail.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

class ExerciseSubmissionPage extends StatefulWidget {
  const ExerciseSubmissionPage({super.key});

  @override
  State<ExerciseSubmissionPage> createState() => _ExerciseSubmissionPageState();
}

class _ExerciseSubmissionPageState extends State<ExerciseSubmissionPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>> getListExercise(
    String teacherID,
  ) {
    final docRef = FirebaseFirestore.instance
        .collection('exercicios')
        .where('professorId', isEqualTo: teacherID);

    return docRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final teacherId = Provider.of<UserProvider>(context).userId;
    if (teacherId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: const CustomAppBar(title: 'detalhes da submissão de atividade'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.dock,
            title: 'Nenhuma atividade publicada',
            description: 'Voç~e não publicou nenhuma atividade até agora ',
          );
        }
        final data = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];
            final title = doc['titulo'];
            final description = doc['conteudoDoExercicio'];
            final deliveryDate = doc['dataDeEntrega'];
            final normalDate = deliveryDate.toDate();
            final exerciceId = doc.id;
            final formattedDate = DateFormat('dd/MM/yyyy').format(normalDate);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  NavigatorService.navigateTo(
                    RouteNames.teacherSubimissionDetail,
                    arguments: exerciceId,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(title),
                      Text(description),
                      Text(formattedDate),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
