import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prioridade',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: Theme.of(context).elevatedButtonTheme.style,
            onPressed: () => _openBottomSheet(context),
            icon: Icon(
              _icon(prioridade),
              color: prioridade != null ? _color(prioridade!) : Colors.white,
            ),
            label: Text(
              prioridade != null
                  ? _label(prioridade!)
                  : 'Selecionar prioridade',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: PrioridadeComunicado.values.map((nivel) {
            final bool isSelected = prioridade == nivel;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? _color(nivel).withOpacity(0.1)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _color(nivel)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: Icon(_icon(nivel), color: _color(nivel)),
                  title: Text(
                    _label(nivel),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    onSelected(nivel);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _label(PrioridadeComunicado p) {
    switch (p) {
      case PrioridadeComunicado.baixa:
        return 'Baixa';
      case PrioridadeComunicado.media:
        return 'Média';
      case PrioridadeComunicado.alta:
        return 'Alta';
    }
  }

  IconData _icon(PrioridadeComunicado? p) {
    switch (p) {
      case PrioridadeComunicado.alta:
        return Icons.arrow_upward;
      case PrioridadeComunicado.media:
        return Icons.remove;
      case PrioridadeComunicado.baixa:
        return Icons.arrow_downward;
      default:
        return Icons.flag_outlined;
    }
  }

  Color _color(PrioridadeComunicado p) {
    switch (p) {
      case PrioridadeComunicado.alta:
        return Colors.red;
      case PrioridadeComunicado.media:
        return Colors.orange;
      case PrioridadeComunicado.baixa:
        return Colors.green;
    }
  }
}
