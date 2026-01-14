import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_aluno_card.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/attendance_provider.dart';
import 'package:provider/provider.dart';


class AttendanceStudentList extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  const AttendanceStudentList({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<AttendanceProvider>();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        return Consumer<AttendanceProvider>(
          builder: (_, provider, __) {
            return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final aluno = docs[index];
                final id = aluno.id;
                final nome = aluno['dadosAluno']['nome'];

                return AttendanceAlunoCard(
                  nome: nome,
                  status: provider.presencas[id],
                  onSelect: (p) => providerRead.marcarPresenca(id, p),
                );
              },
            );
          },
        );
      },
    );
  }
}
