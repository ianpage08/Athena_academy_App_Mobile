import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

/// Chip de filtro premium do Design System Athena.
///
/// Arquitetura e UX:
/// - [MUDANÇA CRÍTICA]: Suporte 100% nativo ao Dark/Light Mode removendo cores hardcoded.
/// - [UX Defensiva]: Implementa comportamento de "Toggle" (Permite desmarcar ao clicar novamente).
/// - [UI Premium]: Adota design "Flat" com transparências (withValues) em vez de cores sólidas agressivas.
class ChipFiltro extends StatelessWidget {
  final String title;
  final String? value;
  final String? filtroSelected;

  // 👉 Melhoria de documentação: Deixamos claro o que essa função espera
  final ValueChanged<String?> onSelected;

  const ChipFiltro({
    super.key,
    required this.title,
    required this.value,
    required this.filtroSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const primaryColor = AppColors.lightButtonPrimary;

    final isSelected = value == filtroSelected;

    // --- MUDANÇA 1: Cores Semânticas e Futuristas ---
    // Fundo Inativo: Fundo levemente destacado do scaffold.
    final backgroundColor = isDark
        ? theme.cardColor
        : theme.dividerColor.withValues(alpha: 0.05);

    // Fundo Ativo: Em vez de pintar de azul sólido (que pesa na tela),
    // usamos uma transparência elegante da cor primária.
    final selectedBackgroundColor = primaryColor.withValues(alpha: 0.15);

    // Texto: Acompanha a lógica do fundo, garantindo contraste.
    final textColor = isSelected
        ? primaryColor
        : theme.hintColor.withValues(alpha: 0.8);

    // Borda dinâmica
    final borderColor = isSelected
        ? primaryColor.withValues(alpha: 0.5)
        : theme.dividerColor.withValues(alpha: isDark ? 0.1 : 0.2);

    return ChoiceChip(
      label: Text(title),
      selected: isSelected,

      // Em filtros de texto único, a mudança de cor/borda já é feedback suficiente e mais limpo.
      showCheckmark: false,

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      // Tipografia alinhada ao tema
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: textColor,
        letterSpacing: 0.3, // Dá um ar de precisão tecnológica
      ),

      // Aplicação das cores dinâmicas
      backgroundColor: backgroundColor,
      selectedColor: selectedBackgroundColor,

      elevation: 0,
      pressElevation: 0,

      // Formato de "Pílula" perfeita (Pill shape)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: BorderSide(color: borderColor, width: 1),
      ),

      onSelected: (_) {
        if (isSelected) {
          // Se clicou no que JÁ ESTAVA selecionado, limpa o filtro (envia null)
          onSelected(null);
        } else {
          // Se clicou num novo, envia o valor normal
          onSelected(value);
        }
      },
    );
  }
}
