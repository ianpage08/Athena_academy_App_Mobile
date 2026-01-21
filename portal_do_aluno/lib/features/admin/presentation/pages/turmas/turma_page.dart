import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/turmas/widgets/turma_stream_list.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
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
    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminCadastroTurmas);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TurmaStreamList(
          stream: _streamTurma,

          onDelete: (id) {
            _serviceTurma.excluirTurma(id);
          },
        ),
      ),
    );
  }
}
