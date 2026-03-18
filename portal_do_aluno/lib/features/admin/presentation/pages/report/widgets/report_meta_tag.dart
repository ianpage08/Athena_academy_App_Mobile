import 'package:flutter/material.dart';

// Widget reutilizável para exibir "tags" de metadados
// Ex: data, turma, status, anexos, etc.
class ReportMetaTag extends StatelessWidget {

  // Ícone que representa o tipo de informação
  final IconData icon;

  // Texto da tag (ex: "3 anexos", "Turma A", "Hoje")
  final String label;

  const ReportMetaTag({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      // Espaçamento interno (define o "tamanho visual" da tag)
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(

        // Borda totalmente arredondada (formato de pill/tag)
        borderRadius: BorderRadius.circular(30),

        // Fundo leve (efeito sutil de destaque)
        color: Colors.grey.withValues(alpha: 0.12),

        // Borda discreta pra dar definição
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.18),
        ),
      ),

      // Conteúdo horizontal (ícone + texto)
      child: Row(
        mainAxisSize: MainAxisSize.min, // ocupa só o necessário
        children: [

          // Ícone da tag
          Icon(
            icon,
            size: 16,
            color: Colors.black54,
          ),

          const SizedBox(width: 6),

          // Texto da tag
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}