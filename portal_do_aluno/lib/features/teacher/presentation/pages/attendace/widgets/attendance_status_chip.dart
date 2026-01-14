import 'package:flutter/material.dart';

class AttendanceStatusChip extends StatelessWidget {
  final String text;
  final bool selected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const AttendanceStatusChip({
    super.key,
    required this.text,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : Colors.grey),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? color : Colors.black54),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
