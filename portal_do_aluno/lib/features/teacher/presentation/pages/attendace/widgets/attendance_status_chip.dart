import 'package:flutter/material.dart';

/// Chip interativo usado para selecionar o status de presença do aluno.
///
/// Esse widget funciona como um botão visual com três estados possíveis
/// no contexto da chamada escolar:
/// - Presente
/// - Falta
/// - Justificado
///
/// Ele muda dinamicamente:
/// - cor de fundo
/// - cor do ícone
/// - cor do texto
/// - borda
///
/// Tudo isso baseado na propriedade `selected`.
class AttendanceStatusChip extends StatelessWidget {
  /// Texto exibido dentro do chip
  final String text;

  /// Indica se o chip está selecionado
  /// Quando true, aplica destaque visual
  final bool selected;

  /// Cor principal do chip
  /// Usada para:
  /// - borda
  /// - ícone
  /// - texto
  /// - fundo quando selecionado
  final Color color;

  /// Ícone exibido ao lado do texto
  final IconData icon;

  /// Callback executado quando o chip é pressionado
  final VoidCallback onTap;

  const AttendanceStatusChip({
    super.key,
    required this.text,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /// Arredondamento do efeito ripple ao clicar
      borderRadius: BorderRadius.circular(12),

      /// Função executada ao tocar no chip
      onTap: onTap,

      child: AnimatedContainer(
        /// Duração da animação para transições visuais
        duration: const Duration(milliseconds: 200),

        /// Espaçamento interno do chip
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

        /// Estilo visual do chip
        decoration: BoxDecoration(
          /// Cor de fundo muda quando selecionado
          color: selected ? color.withValues(alpha: 0.3) : Colors.grey.shade200,

          /// Bordas arredondadas
          borderRadius: BorderRadius.circular(12),

          /// Borda muda de cor dependendo do estado
          border: Border.all(color: selected ? color : Colors.grey),
        ),

        /// Estrutura horizontal do chip (ícone + texto)
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ocupa espaço mínimo
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            /// Ícone representando o status
            Icon(icon, size: 18, color: selected ? color : Colors.black54),

            /// Espaçamento entre ícone e texto
            const SizedBox(width: 6),

            /// Texto do chip
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,

                /// Cor muda dependendo do estado selecionado
                color: selected ? color : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
