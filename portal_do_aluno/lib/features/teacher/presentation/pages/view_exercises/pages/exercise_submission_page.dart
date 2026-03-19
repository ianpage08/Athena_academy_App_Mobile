import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class ExerciseSubmissionPage extends StatefulWidget {
  const ExerciseSubmissionPage({super.key});

  @override
  State<ExerciseSubmissionPage> createState() => _ExerciseSubmissionPageState();
}

class _ExerciseSubmissionPageState extends State<ExerciseSubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'detalhes da submissão de atividade'),
    );
  }
}