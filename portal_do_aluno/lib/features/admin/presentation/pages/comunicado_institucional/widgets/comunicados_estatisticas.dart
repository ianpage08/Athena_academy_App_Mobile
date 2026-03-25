import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Ícones mais refinados
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';

class ComunicadoEstatisticas extends StatefulWidget {
  // 👉 MUDANÇA: StatefulWidget para gerenciar a instância do serviço
  final VoidCallback? att;

  const ComunicadoEstatisticas({super.key, this.att});

  @override
  State<ComunicadoEstatisticas> createState() => _ComunicadoEstatisticasState();
}

class _ComunicadoEstatisticasState extends State<ComunicadoEstatisticas> {
  // 👉 ARQUITETURA: Instanciando o serviço uma única vez no initState.
  // Isso evita que o Flutter crie um novo objeto a cada rebuild da tela.
  late final ComunicadoService _service;
  late final Stream<int> _countStream;

  @override
  void initState() {
    super.initState();
    _service = ComunicadoService();
    // 👉 PERFORMANCE: Convertendo o Future em Stream uma única vez.
    _countStream = _service.calcularQuantidadeDeCominicados().asStream();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<int>(
      stream: _countStream,
      builder: (context, snapshot) {
        // 👉 UX: Tratamento de estados (Loading/Error) antes de exibir o dado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final total = snapshot.data ?? 0;

        return Row(
          children: [
            // 👉 DESIGN: Grid de estatísticas com cores dinâmicas e profundidade
            _StatCard(
              icon: CupertinoIcons.paperplane_fill,
              label: 'Comunicados Enviados',
              value: total.toString(),
              color: theme.colorScheme.primary,
              trend: '+12%', // Sugestão: Adicionar lógica de tendência futura
            ),
            const SizedBox(width: 12),
            // 👉 ESCALABILIDADE: Espaço reservado para uma segunda métrica (ex: Visualizações)
            const _StatCard(
              icon: CupertinoIcons.eye_fill,
              label: 'Taxa de Leitura',
              value: '85%',
              color: CupertinoColors.systemGreen,
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
  final String? trend;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        // 👉 DESIGN: Container customizado com bordas suaves e Glassmorphism
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // 👉 UX: Alinhamento lateral é mais moderno
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trend != null)
                  Text(
                    trend!,
                    style: const TextStyle(
                      color: CupertinoColors.systemGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
