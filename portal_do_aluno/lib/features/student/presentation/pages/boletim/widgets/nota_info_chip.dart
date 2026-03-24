import 'package:flutter/material.dart';

/// Chip de informação de nota premium do Design System Athena.
///
/// Arquitetura e UX:
/// - [UI Premium]: Transformado de uma simples `Row` para um verdadeiro "Chip"
///   com fundo estilizado, bordas arredondadas e tipografia refinada.
/// - [Responsividade]: Utiliza `mainAxisSize: MainAxisSize.min` para garantir
///   que ocupe apenas o espaço necessário dentro de componentes como o `Wrap`.
/// - [UX Defensiva]: Adição do `Flexible` e `ellipsis` previne quebras caso o valor seja enorme.
class NotaInfoChip extends StatelessWidget {
  final String titulo;
  final IconData icone;

  const NotaInfoChip({super.key, required this.titulo, required this.icone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    
    return Container(
      // Padding interno para o texto respirar dentro da "pílula"
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // Fundo super sutil com a cor primária (O padrão tecnológico que criamos)
        color: isDark ? theme.cardColor : primaryColor.withValues(alpha: 0.05),

        // Formato de Pílula (Pill Shape)
        borderRadius: BorderRadius.circular(100),

        // Borda fina para dar delimitação tátil
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),

      child: Row(
        
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Icon(icone, size: 16, color: primaryColor.withValues(alpha: 0.8)),

          const SizedBox(width: 6),

          // Tipografia tratada e proteção contra textos gigantes
          Flexible(
            child: Text(
              titulo,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600, // Dá presença ao dado
                color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                letterSpacing: 0.2, // Respiro entre as letras (Look moderno)
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
