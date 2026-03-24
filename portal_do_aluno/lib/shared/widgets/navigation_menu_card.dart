import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

/// Card de navegação premium para o menu principal do Athena Academy.
class NavigationMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Se true, o card ganha destaque visual (borda primária, cor de fundo e ícone dinâmico).
  final bool highlight;

  const NavigationMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle = '',
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const primaryColor = AppColors.lightButtonPrimary;

    // --- Definição Reativa de Cores ---
    final bgColor = highlight
        ? primaryColor.withValues(alpha: 0.05)
        : theme.cardColor;

    final borderColor = highlight
        ? primaryColor.withValues(alpha: 0.5)
        : theme.dividerColor.withValues(alpha: isDark ? 0.05 : 0.1);

    
    // Se o estado 'highlight' mudar dinamicamente, o card se transforma suavemente!
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          20,
        ), // Borda levemente mais arredondada
        border: Border.all(color: borderColor, width: highlight ? 1.5 : 1.0),
        boxShadow: [
          // MUDANÇA 2: Sombra mais orgânica, difusa e que respeita o Dark Mode
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),

     
      // Isso garante que o efeito de "onda" do clique apareça perfeitamente.
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          highlightColor: primaryColor.withValues(alpha: 0.05),
          splashColor: primaryColor.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20), // Respiro interno ampliado
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ÍCONE ---
                
                // Isso cria uma hierarquia visual de Dashboard corporativo altíssimo nível.
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: highlight
                        ? primaryColor.withValues(alpha: 0.15)
                        : theme.scaffoldBackgroundColor,
                    shape: BoxShape.circle, // Formato perfeitamente redondo
                  ),
                  child: Icon(
                    icon,
                    size: highlight ? 28 : 24, // Tamanho equilibrado
                    color: highlight ? primaryColor : theme.iconTheme.color,
                  ),
                ),

                
                // Ideal se esse card for usado dentro de um GridView!
                const Spacer(),

                // --- TÍTULO ---
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: -0.3,
                    color: highlight
                        ? primaryColor
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),

                // --- SUBTÍTULO ---
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines:
                        2, // Permite até duas linhas pro subtítulo respirar
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
