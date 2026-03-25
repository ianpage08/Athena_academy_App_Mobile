import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    final theme = Theme.of(context);
    final hasSelection = destinatario != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 👉 HIERARQUIA: Label refinada com tipografia moderna
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Público-Alvo',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // 👉 INTERFACE: Input visualmente rico em vez de um botão simples
        InkWell(
          onTap: () => _openSelectionSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: hasSelection
                  ? theme.colorScheme.primary.withValues(alpha: 0.05)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasSelection
                    ? theme.colorScheme.primary
                    : theme.dividerColor.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasSelection ? _icon(destinatario!) : CupertinoIcons.group,
                  color: hasSelection ? theme.colorScheme.primary : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destinatario ?? 'Quem deve receber este comunicado?',
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

  void _openSelectionSheet(BuildContext context) {
    // 👉 ESTRUTURA: Lista de objetos para facilitar expansão futura
    final options = [
      {'title': 'Todos', 'desc': 'Envio geral para toda a instituição'},
      {'title': 'Alunos', 'desc': 'Estudantes matriculados e ativos'},
      {'title': 'Professores', 'desc': 'Corpo docente e coordenadores'},
      {'title': 'Responsáveis', 'desc': 'Pais e tutores financeiros'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // 👉 DESIGN: Permite o efeito de float
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
            // 👉 DESIGN: Handle de arraste moderno
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Selecione o Destinatário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...options.map((opt) {
              final isSelected = destinatario == opt['title'];
              return _buildOptionTile(context, opt, isSelected);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    Map<String, String> opt,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _icon(opt['title']!),
          color: isSelected ? Colors.white : theme.colorScheme.primary,
        ),
      ),
      title: Text(
        opt['title']!,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(opt['desc']!, style: const TextStyle(fontSize: 12)),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: () {
        onSelected(opt['title']!);
        Navigator.pop(context);
      },
    );
  }

  IconData _icon(String value) {
    switch (value) {
      case 'Alunos':
        return CupertinoIcons.person_solid;
      case 'Professores':
        return CupertinoIcons.person_2_fill;
      case 'Responsáveis':
        return CupertinoIcons.person_crop_circle_fill_badge_checkmark;
      default:
        return CupertinoIcons.rectangle_stack_person_crop_fill;
    }
  }
}
