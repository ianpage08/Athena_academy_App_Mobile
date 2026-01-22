import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final DisciplinaService _disciplinaService = DisciplinaService();

  final Stream<QuerySnapshot> minhaStream = FirebaseFirestore.instance
      .collection('disciplinas')
      .orderBy('nome')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disciplinas'),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {
                  NavigatorService.navigateTo(
                    RouteNames.adminCadastrarDisciplina,
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamDisciplina(
          minhaStream: minhaStream,
          disciplinaService: _disciplinaService,
        ),
      ),
    );
  }

  
}
