import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';

class ComunicadoEstatisticas extends StatelessWidget {
  final ComunicadoService service;

  const ComunicadoEstatisticas({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: service.calcularQuantidadeDeCominicados().asStream(),
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0;

        return Row(
          children: [
            _StatCard(
              icon: Icons.send,
              label: 'Enviados',
              value: total.toString(),
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }
}
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
