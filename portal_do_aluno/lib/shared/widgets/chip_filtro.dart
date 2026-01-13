import 'package:flutter/material.dart';

class ChipFiltro extends StatelessWidget {
  final String title;
  final String? value;
  final String? filtroSelected;
  final ValueChanged<String?> onSelected;

  const ChipFiltro({super.key, required this.title, required this.value, required this.filtroSelected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final selected = value == filtroSelected;

    return ChoiceChip(
      label: Text(title),
      selected: selected,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : Colors.black87,
      ),
      selectedColor: const Color(0xFF4A6CF7),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: selected ? 2 : 0,
      onSelected: (_) => onSelected(value),
    );
    
  }
}
