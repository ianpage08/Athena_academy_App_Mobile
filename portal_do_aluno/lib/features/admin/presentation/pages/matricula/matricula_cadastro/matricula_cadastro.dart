import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/widgets/matricula_form.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class MatriculaCadastro extends StatelessWidget {
  const MatriculaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(
        
        appBar: CustomAppBar(title: 'Nova Matrícula'),

        body: SingleChildScrollView(
          
          physics: BouncingScrollPhysics(),

          
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),

          
          child: SafeArea(bottom: true, child: MatriculaForm()),
        ),
      ),
    );
  }
}
