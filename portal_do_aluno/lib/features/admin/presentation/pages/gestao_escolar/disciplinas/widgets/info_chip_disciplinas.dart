import 'package:flutter/material.dart';

class InfoChipDisciplinas extends StatelessWidget {
  final IconData icon;
  final String title;

  const InfoChipDisciplinas({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}