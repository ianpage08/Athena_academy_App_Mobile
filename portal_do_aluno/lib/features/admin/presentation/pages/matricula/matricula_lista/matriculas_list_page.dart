import 'package:flutter/cupertino.dart'; 
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_lista/widgets/stream_list_matriculas.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';


// Como a tela apenas exibe o StreamList (que gerencia o próprio estado), não precisamos do custo de um StatefulWidget aqui.
class MatriculasPage extends StatelessWidget {
  const MatriculasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    
    // LÓGICA INTACTA: O serviço continua sendo passado para a lista.
    final matriculaService = MatriculaService();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Mantido conforme sua regra
        toolbarHeight: 80, // Mais espaço para respirar
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alunos Matriculados',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gestão do corpo discente da academia',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),

      
      // É uma prática superior de UX para a "Ação Primária" da tela.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            NavigatorService.navigateTo(RouteNames.adminMatriculaCadastro),
        backgroundColor: AppColors.lightButtonPrimary,
        elevation: 4,
        icon: const Icon(CupertinoIcons.add, color: Colors.white, size: 20),
        label: const Text(
          'Nova Matrícula',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      
      // Removidos o Padding, Column e Expanded desnecessários.
      body: SafeArea(
        child: StreamListMatriculas(matriculaService: matriculaService),
      ),
    );
  }
}
