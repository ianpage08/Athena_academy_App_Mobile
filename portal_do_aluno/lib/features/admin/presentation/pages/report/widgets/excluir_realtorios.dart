import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';

class ExcluirRelatorios extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ExcluirRelatorios({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        // Exibe confirmação antes de excluir
        final confirmed = await showAppConfirmationDialog(
          context: context,
          title: 'Excluir Relatório',
          confirmText: 'Excluir',
          cancelText: 'Cancelar',
          content: 'Essa ação não pode ser desfeita.',
        );

        if (confirmed == true) {
          // Chama o service para excluir no Firestore
          await ConteudoPresencaService().excluirConteudoPresenca(
            reportData['id'],
          );

          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },

      icon: const Icon(Icons.delete_outline_rounded),
      label: const Text('Excluir Relatório'),

      // Estilo visual do botão
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
