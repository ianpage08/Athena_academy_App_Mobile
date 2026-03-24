import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Função global para chamar o Modal Padrão do Athena de forma fácil.
///
/// Como usar:
/// final turmaEscolhida = await showAthenaSelectionModal(...);
Future<T?> showAthenaSelectionModal<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) itemLabel, // Como extrair o nome do item
  IconData icon = CupertinoIcons.person_2_fill, // Ícone padrão
  T? selectedItem,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Necessário para o shape customizado
    builder: (modalContext) {
      final theme = Theme.of(modalContext);
      final isDark = theme.brightness == Brightness.dark;

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(modalContext).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          // Fundo adaptável (off-white quente no claro, azul/roxo escuro no dark)
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: -5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Drag Handle (Pílula de arrastar) ---
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withValues(
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // --- Header do Modal ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.5, // Toque de tipografia moderna
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Lista de Opções ---
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                shrinkWrap: true, // Se tiver poucos itens, o modal fica menor
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final label = itemLabel(item);
                  final isSelected = item == selectedItem;

                  return AthenaModalCard(
                    label: label,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () => Navigator.pop(modalContext, item),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Widget privado que desenha os cards bonitões inspirados na sua imagem
class AthenaModalCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AthenaModalCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Pegando a cor principal do seu tema para os destaques
    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        // Efeito de clique suave
        highlightColor: primaryColor.withValues(alpha: 0.05),
        splashColor: primaryColor.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            // Cor do card (branco no modo claro, cardColor no escuro)
            color: isSelected
                ? primaryColor.withValues(alpha: 0.05)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.5)
                  : theme.dividerColor.withValues(alpha: isDark ? 0.1 : 0.05),
              width: isSelected ? 1.5 : 1,
            ),
            // Sombra super sutil para destacar do fundo, como na sua imagem
            boxShadow: [
              if (!isDark && !isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              // Ícone estilizado com fundo suave
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 16),

              // Texto principal
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? primaryColor
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),

              // Se tiver selecionado, mostra um checkzinho elegante
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: primaryColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
