import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

/// Componente premium para anexar arquivos no Athena Academy.
/// "Dropzone" (área de anexo) interativa. Isso aumenta a affordance visual
/// e convida o professor a interagir com confiança.
class AttachSection extends StatelessWidget {
  final int attachedCount;
  final VoidCallback onAttach;

  const AttachSection({
    super.key,
    required this.attachedCount,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const primaryColor = AppColors.darkSuccess;

    final hasFile = attachedCount > 0;

    // A cor de fundo e da borda mudam dinamicamente se houver um arquivo.
    final bgColor = hasFile
        ? primaryColor.withValues(alpha: 0.05)
        : theme.scaffoldBackgroundColor;

    final borderColor = hasFile
        ? primaryColor.withValues(alpha: 0.5)
        : theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.3);

    // o efeito visual nativo de clique (ripple) em toda a área do componente.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAttach,
        borderRadius: BorderRadius.circular(16),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        splashColor: primaryColor.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          width: double.infinity,

          // Transformamos uma "linha" em um "quadro" para o usuário clicar.
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: hasFile ? 1.5 : 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Ícone Dinâmico ---
              // AnimatedSwitcher garante uma transição suave entre o ícone
              // de "clipes" e o ícone de "documento confirmado".
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey<bool>(
                    hasFile,
                  ), // Chave essencial para o Switcher funcionar
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: hasFile
                        ? primaryColor.withValues(alpha: 0.1)
                        : theme.cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Sombra sutil apenas no estado vazio (Light Theme)
                      if (!hasFile && !isDark)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Icon(
                    hasFile
                        ? CupertinoIcons.doc_checkmark_fill
                        : CupertinoIcons.paperclip,
                    color: hasFile ? primaryColor : theme.iconTheme.color,
                    size: 32, // Ícone maior, focado em clareza
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Texto Principal ---
              Text(
                hasFile
                    ? '$attachedCount arquivo(s) anexado(s)'
                    : 'Anexe um arquivo ou imagem',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: hasFile ? FontWeight.bold : FontWeight.w600,
                  color: hasFile
                      ? primaryColor
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),

              // Um pequeno guia visual que aparece apenas quando não há arquivos.
              if (!hasFile) ...[
                const SizedBox(height: 6),
                Text(
                  'Toque para procurar no dispositivo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
