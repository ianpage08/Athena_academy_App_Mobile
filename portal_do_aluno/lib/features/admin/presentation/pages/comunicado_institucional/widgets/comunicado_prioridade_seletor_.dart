import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Iconografia mais premium
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';

class ComunicadoPrioridadeSelector extends StatelessWidget {
  final PrioridadeComunicado? prioridade;
  final ValueChanged<PrioridadeComunicado> onSelected;

  const ComunicadoPrioridadeSelector({
    super.key,
    required this.prioridade,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = prioridade != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 👉 HIERARQUIA: Label seguindo o padrão do seletor de destinatários
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Nível de Urgência',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // 👉 INTERFACE: InkWell para manter o ripple effect com bordas arredondadas
        InkWell(
          onTap: () => _openPrioritySheet(context),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              // 👉 DESIGN: Background sutil baseado na cor da prioridade escolhida
              color: hasSelection
                  ? _color(prioridade!).withValues(alpha: 0.08)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasSelection
                    ? _color(prioridade!)
                    : theme.dividerColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _icon(prioridade),
                  color: hasSelection ? _color(prioridade!) : Colors.grey,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasSelection ? _label(prioridade!) : 'Definir prioridade',
                    style: TextStyle(
                      fontSize: 15,
                      color: hasSelection
                          ? theme.textTheme.bodyLarge?.color
                          : Colors.grey,
                      fontWeight: hasSelection
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  size: 16,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openPrioritySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 👉 DESIGN: Floating Sheet
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // 👉 DESIGN: Handle de arraste para feedback visual de interatividade
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Prioridade do Comunicado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // 👉 PERFORMANCE: Uso do map para gerar a lista dinamicamente
            ...PrioridadeComunicado.values.map((nivel) {
              final isSelected = prioridade == nivel;
              return _buildPriorityTile(context, nivel, isSelected);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityTile(
    BuildContext context,
    PrioridadeComunicado nivel,
    bool isSelected,
  ) {
    
    final color = _color(nivel);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: isSelected
            ? color.withValues(alpha: 0.1)
            : Colors.transparent,
        leading: Icon(_icon(nivel), color: color),
        title: Text(
          _label(nivel),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? color : null,
          ),
        ),
        trailing: isSelected
            ? Icon(CupertinoIcons.check_mark_circled_solid, color: color)
            : null,
        onTap: () {
          onSelected(nivel);
          Navigator.pop(context);
        },
      ),
    );
  }

  // 👉 LÓGICA: Centralização das definições visuais dos enums
  String _label(PrioridadeComunicado p) {
    switch (p) {
      case PrioridadeComunicado.baixa:
        return 'Baixa Prioridade';
      case PrioridadeComunicado.media:
        return 'Prioridade Média';
      case PrioridadeComunicado.alta:
        return 'Alta Prioridade / Urgente';
    }
  }

  IconData _icon(PrioridadeComunicado? p) {
    switch (p) {
      case PrioridadeComunicado.alta:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case PrioridadeComunicado.media:
        return CupertinoIcons.minus_circle_fill;
      case PrioridadeComunicado.baixa:
        return CupertinoIcons.arrow_down_circle_fill;
      default:
        return CupertinoIcons.flag;
    }
  }

  Color _color(PrioridadeComunicado p) {
    switch (p) {
      case PrioridadeComunicado.alta:
        return CupertinoColors.systemRed;
      case PrioridadeComunicado.media:
        return CupertinoColors.systemOrange;
      case PrioridadeComunicado.baixa:
        return CupertinoColors.systemGreen;
    }
  }
}
