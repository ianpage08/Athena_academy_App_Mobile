import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 

class FormHeaderComunicado extends StatelessWidget {
  const FormHeaderComunicado({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CupertinoIcons
                  .speaker_2_fill, 
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 14,
          ), 
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
                
                Text(
                  'Preencha os dados abaixo para disparar o aviso.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          
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
