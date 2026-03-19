import 'package:flutter/material.dart';

/// Widget reutilizável para exibir estados vazios (empty states) no app.
///
/// Usado quando não há dados para mostrar na tela, como:
/// - nenhum boletim
/// - nenhuma tarefa
/// - nenhum comunicado
///
/// Objetivo:
/// Melhorar a experiência do usuário, evitando telas vazias ou confusas,
/// fornecendo feedback claro e visualmente agradável.
class EmptyStateWidget extends StatelessWidget {
  /// Ícone exibido no topo do componente
  /// Representa visualmente o tipo de conteúdo (ex: calendário, boletim, tarefas)
  final IconData icon;

  /// Título principal do empty state
  /// Deve ser curto e direto (ex: "Nenhum comunicado disponível")
  final String title;

  /// Texto descritivo complementar
  /// Explica o motivo do estado vazio e orienta o usuário
  final String description;

  /// Construtor do widget
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centraliza todo o conteúdo na tela
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        // Espaçamento lateral para evitar texto colado nas bordas
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Centraliza verticalmente os elementos
          children: [
            /// Ícone principal do empty state
            /// Usado para dar contexto visual rápido ao usuário
            Icon(
              icon,
              size: 64,
              color: Colors.grey.shade400, // cor neutra e suave
            ),

            const SizedBox(height: 16),

            /// Título principal
            /// Destaque visual com fonte maior e negrito
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// Texto descritivo
            /// Explica o estado vazio e reduz dúvidas do usuário
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600, // menor destaque visual
                height: 1.4, // melhora legibilidade
              ),
            ),
          ],
        ),
      ),
    );
  }
}