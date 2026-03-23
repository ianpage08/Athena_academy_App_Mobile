import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

class SubmissionDetail extends StatefulWidget {
  final String exerciseId;
  const SubmissionDetail({super.key, required this.exerciseId});

  @override
  State<SubmissionDetail> createState() => _SubmissionDetailState();
}

class _SubmissionDetailState extends State<SubmissionDetail> {
  Stream<QuerySnapshot> getSubmission(String exerciseId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .doc(exerciseId)
        .collection('entregas')
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getListSubmissionList(String teacherId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .where('professorId', isEqualTo: teacherId)
        .snapshots()
        .asyncMap((exerciseSnapshot) async {
          List<Map<String, dynamic>> listaCompleta = [];

          for (var docExercise in exerciseSnapshot.docs) {
            final exerciseData = docExercise.data();
            exerciseData['id'] = docExercise.id;

            final entregasSnapshot = await docExercise.reference
                .collection('entregas')
                .get();

            final entregas = entregasSnapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList();

            exerciseData['entregas'] = entregas;

            listaCompleta.add(exerciseData);
          }

          return listaCompleta;
        });
  }

  @override
  Widget build(BuildContext context) {
    final teacherId = Provider.of<UserProvider>(context).userId;
    if (teacherId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Submissão')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [Expanded(child: _buildStreamList(teacherId))]),
      ),
    );
  }

  Widget _buildStreamList(String teacherId) {
    return StreamBuilder<QuerySnapshot>(
      stream: getSubmission(widget.exerciseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const EmptyStateWidget(
            icon: Icons.list,
            title: 'nenhuma Atividade entregue',
            description:
                'Quando alguma atividade for entregue ela ira aparecer aqui',
          );
        }
        final data = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];
            

            final status = doc['status'];
            final anexos = doc['anexos'];

            return Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      
                      Text(anexos.toString()),
                      Text(status.toString()),
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
