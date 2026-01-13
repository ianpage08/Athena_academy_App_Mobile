import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisabledButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  const DisabledButton({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200], // fundo desabilitado
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Icon(
              CupertinoIcons.chevron_down,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
