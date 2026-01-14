import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/detalhes%20alunos/widgets/stream_detalhes.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class DetalhesAluno extends StatefulWidget {
  final String alunoId;

  const DetalhesAluno({super.key, required this.alunoId});

  @override
  State<DetalhesAluno> createState() => _DetalhesAlunoState();
}

class _DetalhesAlunoState extends State<DetalhesAluno> {
  final minhaStream = FirebaseFirestore.instance.collection('matriculas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detalhes do Aluno'),
      body: StreamDetalhes(alunoId: widget.alunoId),
    );
  }
}
