import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/discipline_tile.dart';
import 'package:portal_do_aluno/features/teacher/data/models/grade_record.dart';

class StreamBoletim extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  const StreamBoletim({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('❌ Erro no stream: ${snapshot.error}');
          return Center(
            child: Text('Erro ao carregar boletim: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Nenhum boletim disponível',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'As notas ainda não foram lançadas para este aluno.\n'
                    'Assim que o professor registrar as avaliações, o boletim aparecerá aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!.data();

        if (data == null || !data.containsKey('disciplinas')) {
          return const Center(
            child: Text('Nenhuma nota  foi adicionado no boletim.'),
          );
        }

        final disciplinasRaw = data['disciplinas'];

        if (disciplinasRaw is! List || disciplinasRaw.isEmpty) {
          return const Center(
            child: Text('Nenhuma disciplina encontrada no boletim.'),
          );
        }

        final disciplinas = List<Map<String, dynamic>>.from(disciplinasRaw);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(44, 0, 0, 0),
                offset: Offset(0, 5),
                blurRadius: 5,
              ),
            ],
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.15),
              width: 1.2,
            ),
          ),
          child: Column(
            children: disciplinas.map((materia) {
              final disciplina = GradeRecord.fromJson(materia);
              return DisciplineTile(disciplina: disciplina);
            }).toList(),
          ),
        );
      },
    );
  }
}
