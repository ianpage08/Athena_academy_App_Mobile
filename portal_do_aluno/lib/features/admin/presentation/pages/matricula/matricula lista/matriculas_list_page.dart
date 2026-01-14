import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20lista/widgets/stream_list_matriculas.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class MatriculasPage extends StatefulWidget {
  const MatriculasPage({super.key});

  @override
  State<MatriculasPage> createState() => _MatriculasPageState();
}

class _MatriculasPageState extends State<MatriculasPage> {
  final minhaStream = FirebaseFirestore.instance
      .collection('matriculas')
      .snapshots();
  final MatriculaService _matriculaService = MatriculaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos Matrículados'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminMatriculaCadastro);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Lista de matrículas
            Expanded(
              child: StreamListMatriculas(matriculaService: _matriculaService),
            ),
          ],
        ),
      ),
    );
  }

  
}
