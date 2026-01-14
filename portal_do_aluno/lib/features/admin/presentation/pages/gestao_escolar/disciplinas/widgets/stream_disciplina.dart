import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/widgets/disciplina_card.dart';

class StreamDisciplina extends StatelessWidget {
  final Stream<QuerySnapshot> minhaStream;
  final DisciplinaService disciplinaService;

  const StreamDisciplina({super.key, required this.minhaStream, required this.disciplinaService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar disciplinas'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma disciplina cadastrada'));
        }

        final disciplinas = snapshot.data!.docs;

        return ListView.separated(
          itemCount: disciplinas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = disciplinas[index].data() as Map<String, dynamic>;

            return DisciplinaCard(
              data: data,
              disciplinaService: disciplinaService,
            );
          },
        );
      },
    );
    
  }
}
