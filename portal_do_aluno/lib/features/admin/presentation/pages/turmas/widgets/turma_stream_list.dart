import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/turmas/widgets/turma_card.dart';

class TurmaStreamList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Function(String id) onDelete;


  const TurmaStreamList({super.key, required this.stream, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar turmas'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma turma cadastrada'));
        }

        final turmas = snapshot.data!.docs;

        return ListView.separated(
          itemCount: turmas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = turmas[index].data() as Map<String, dynamic>;

            return TurmaCard(data: data, onDelete: () {
              onDelete(turmas[index].id);
            },);
          },
        );
      },
    );
  }
}