import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String data;
  final PrioridadeComunicado prioridade;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.prioridade,
    this.data = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _abrirModal(context);
            },
            child: Stack(
              children: [
                // Card base
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28), // espaço do badge

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.campaign, size: 28),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  limitarCampo(subtitle, 80),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                            color: Colors.black45,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Publicado em: $data',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badge de prioridade
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeColor().withOpacity(0.15),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(_badgeIcon(), size: 14, color: _badgeColor()),
                        const SizedBox(width: 6),
                        Text(
                          _badgeLabel(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _badgeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _abrirModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueGrey,
                padding: EdgeInsets.symmetric(horizontal: 24),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: AppColors.lightButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  Color _badgeColor() {
    switch (prioridade) {
      case PrioridadeComunicado.baixa:
        return Colors.green;
      case PrioridadeComunicado.media:
        return Colors.orange;
      case PrioridadeComunicado.alta:
        return Colors.red;
    }
  }

  IconData _badgeIcon() {
    switch (prioridade) {
      case PrioridadeComunicado.baixa:
        return Icons.arrow_downward;
      case PrioridadeComunicado.media:
        return Icons.remove;
      case PrioridadeComunicado.alta:
        return Icons.arrow_upward;
    }
  }

  String _badgeLabel() {
    switch (prioridade) {
      case PrioridadeComunicado.baixa:
        return 'Baixa';
      case PrioridadeComunicado.media:
        return 'Média';
      case PrioridadeComunicado.alta:
        return 'Alta';
    }
  }
}
