import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/widgets/matricula_form.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class MatriculaCadastro extends StatelessWidget {
  const MatriculaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Formulário de Matrícula'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: MatriculaForm(),
      ),
    );
  }
}
