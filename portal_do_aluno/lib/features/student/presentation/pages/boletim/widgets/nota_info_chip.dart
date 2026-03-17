import 'package:flutter/cupertino.dart';

class NotaInfoChip extends StatelessWidget {
  final String titulo;
  final IconData icone;

  const NotaInfoChip({super.key, required this.titulo, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 16),
        const SizedBox(width: 8),
        Text(titulo),
      ],
    );
  }
  }
