import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Ícones com linhas mais finas e elegantes

class FormHeaderComunicado extends StatelessWidget {
  const FormHeaderComunicado({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // 👉 DESIGN: Padding interno para dar respiro ao conteúdo do header
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 👉 INTERFACE: Ícone com um background sutil para destaque visual (Glassmorphism feel)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CupertinoIcons
                  .speaker_2_fill, // 👉 MUDANÇA: Ícone mais moderno que o 'campaign'
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 14,
          ), // 👉 ESPAÇAMENTO: Aumentado para melhor respiro
          // 👉 HIERARQUIA: Títulos com separação clara de peso e cor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novo Comunicado',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5, // Toque de design moderno
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                // 👉 UX: Adição de uma sub-legenda para contextualizar a ação
                Text(
                  'Preencha os dados abaixo para disparar o aviso.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // 👉 DESIGN: Badge decorativo opcional para indicar "Modo de Edição"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'RASCUNHO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
