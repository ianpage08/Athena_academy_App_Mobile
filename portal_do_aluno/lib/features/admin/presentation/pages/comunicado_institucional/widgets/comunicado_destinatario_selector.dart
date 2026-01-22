import 'package:flutter/material.dart';

class ComunicadoDestinatarioSelector extends StatelessWidget {
  final String? destinatario;
  final ValueChanged<String> onSelected;

  const ComunicadoDestinatarioSelector({
    super.key,
    required this.destinatario,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Destinatário',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _openBottomSheet(context),
            icon: const Icon(Icons.group, color: Colors.white),
            label: Text(
              destinatario ?? 'Selecionar destinatário',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _openBottomSheet(BuildContext context) {
    final itens = ['Todos', 'Alunos', 'Professores', 'Responsáveis'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: itens.map((item) {
            final selected = destinatario == item;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: Icon(_icon(item)),
                  title: Text(item),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    onSelected(item);
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

  IconData _icon(String value) {
    switch (value) {
      case 'Alunos':
        return Icons.school;
      case 'Professores':
        return Icons.person;
      case 'Responsáveis':
        return Icons.family_restroom;
      default:
        return Icons.groups;
    }
  }
}
