import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/athena_selection_modal.dart';

// Importe o seu card premium aqui (ajuste o caminho conforme seu projeto)
// import 'package:portal_do_aluno/shared/widgets/athena_modal_card.dart';

/// Dropdown customizado para listas locais (sem Firestore).
///
/// Arquitetura Visual:
/// - Segue o padrão de modais (BottomSheet) do Athena Academy.
/// - Implementa o estado de 'Disabled' (bloqueado) de forma responsiva ao tema.
/// - Trata quebra de layout (TextOverflow) em nomes longos.
class CustomDropdownField extends StatefulWidget {
  final List<String> itens;
  final String? selecionado;
  final String titulo;
  final IconData icon;
  final void Function(String valor) onSelected;

  /// Controla se o botão é clicável. Se false, assume visual de inativo (cadeado).
  final bool habilitado;

  const CustomDropdownField({
    super.key,
    required this.itens,
    required this.selecionado,
    required this.titulo,
    required this.icon,
    required this.onSelected,
    this.habilitado = true,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  // Controle de estado para a animação da setinha do botão
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  void dispose() {
    _aberto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Se o botão não estiver habilitado, retorna a versão "fantasma" imediatamente.
    if (!widget.habilitado) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? theme.cardColor.withValues(alpha: 0.3)
              : theme.disabledColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? theme.dividerColor.withValues(alpha: 0.1)
                : theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: theme.hintColor.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.selecionado ?? widget.titulo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.hintColor.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.lock_fill, // Feedback visual de bloqueio
              color: theme.hintColor.withValues(alpha: 0.5),
              size: 18,
            ),
          ],
        ),
      );
    }

    // --- Estado Ativo (Botão Interativo) ---
    return GestureDetector(
      onTap: () => _abrirModal(context),
      child: ValueListenableBuilder<bool>(
        valueListenable: _aberto,
        builder: (context, isAberto, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // Borda acende quando o modal abre
                color: theme.colorScheme.primary.withValues(
                  alpha: isAberto ? 0.8 : 0.3,
                ),
                width: isAberto ? 1.5 : 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // Proteção contra TextOverflow
                  child: Row(
                    children: [
                      Icon(widget.icon, size: 22, color: theme.iconTheme.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.selecionado ?? widget.titulo,
                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: widget.selecionado != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: widget.selecionado != null
                                ? theme.textTheme.bodyLarge?.color
                                : theme.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isAberto ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: const Icon(CupertinoIcons.chevron_down, size: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Constrói e exibe o modal de opções (Design System Athena)
  Future<void> _abrirModal(BuildContext context) async {
    _aberto.value = true; // Setinha pra cima

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ajustar altura baseada no conteúdo
      backgroundColor: Colors.transparent, // Fundo transparente para o shape
      builder: (modalContext) {
        final theme = Theme.of(modalContext);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(modalContext).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço dos itens
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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

              // --- Cabeçalho do Modal ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Selecionar ${widget.titulo}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Lista de Itens ---
              Flexible(
                // Permite scroll se a lista for longa
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  shrinkWrap:
                      true, // Fundamental para o MainAxisSize.min funcionar
                  itemCount: widget.itens.length,

                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = widget.itens[index];
                    final isSelected = item == widget.selecionado;

                    return AthenaModalCard(
                      label: item,
                      icon: widget.icon,
                      isSelected: isSelected,
                      onTap: () {
                        widget.onSelected(item);
                        Navigator.pop(context); // Fecha o modal após selecionar
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    _aberto.value = false; // Setinha volta ao normal
  }
}
