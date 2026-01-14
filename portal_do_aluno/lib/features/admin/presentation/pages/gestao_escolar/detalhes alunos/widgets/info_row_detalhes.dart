import 'package:flutter/material.dart';

class InfoRowDetalhes extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRowDetalhes({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}