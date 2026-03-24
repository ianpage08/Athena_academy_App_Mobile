import 'package:flutter/material.dart';

/// Botão de ação secundária/limpeza premium para o Athena Academy.
///
/// Arquitetura e UX:
/// - Lógica de ciclo de vida (`mounted`) já perfeitamente implementada!
/// - Adicionamos a flag `isDestructive` para mudar a semântica visual
///   (ex: fica vermelho se for uma ação de apagar dados).
/// - Altura padronizada (54px) para alinhar lado a lado com o SaveButton.
/// - Hierarquia visual rebaixada (cores neutras) para não brigar com o botão principal.
class ClearButton extends StatefulWidget {
  // 👉 MUDANÇA: Renomeado para o padrão Dart (onClear)
  final Future<void> Function() onClear;

  final String label;
  final String loadingLabel;
  final IconData icon;

  /// Define se o botão deve alertar perigo (ex: limpar um formulário inteiro)
  final bool isDestructive;

  const ClearButton({
    super.key,
    required this.onClear,
    this.label = 'Limpar',
    this.loadingLabel = 'Limpando...',
    this.icon = Icons.delete_sweep_rounded, // Ícone mais moderno e semântico
    this.isDestructive = false,
  });

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool _isLoading = false;

  /// Método isolado para manter o build clean (Igual fizemos no SaveButton)
  Future<void> _handlePress() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onClear();
    } finally {
      // Perfeito! Você já garantiu que não vai dar crash se a tela fechar.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Semântica de Cores (O Pulo do Gato) ---
    // Se for destrutivo, usa a cor de erro (vermelho/laranja do tema).
    // Se não for, usa uma cor neutra (hintColor) para ficar sutil na tela.
    final baseColor = widget.isDestructive
        ? theme.colorScheme.error
        : theme.hintColor.withValues(alpha: isDark ? 0.7 : 0.6);

    final hoverColor = baseColor.withValues(alpha: 0.1);

    return SizedBox(
      width: double.infinity,
      height: 54, // 👉 MUDANÇA: Exatamente a mesma altura do SaveButton
      child: OutlinedButton.icon(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: baseColor,
              // Borda com transparência para não ficar "pesada" visualmente
              side: BorderSide(
                color: baseColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ), // Mesmo shape do SaveButton
              ),
            ).copyWith(
              // Garante que o efeito de clique respeite a cor semântica do botão
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) return hoverColor;
                if (states.contains(WidgetState.hovered)) return hoverColor;
                return null;
              }),
            ),
        onPressed: _isLoading ? null : _handlePress,
        icon: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: baseColor.withValues(alpha: 0.7),
                ),
              )
            : Icon(widget.icon, size: 22),
        label: Text(
          _isLoading ? widget.loadingLabel : widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
