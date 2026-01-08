import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/teacher/presentation/widgets/card_statement.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';

/// Widget responsável por exibir comunicados em tempo real via Stream
class StreamVisualizacaoDeComunicados extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream;

  const StreamVisualizacaoDeComunicados({
    super.key,
    required this.comunicadosStream,
  });

  @override
  State<StreamVisualizacaoDeComunicados> createState() =>
      _StreamVisualizacaoDeComunicadosState();
}

class _StreamVisualizacaoDeComunicadosState
    extends State<StreamVisualizacaoDeComunicados> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.comunicadosStream,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os comunicados'));
        }

        final docs = snapshot.data?.docs ?? [];

        // Empty state
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum comunicado disponível',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            
            final String titulo = data['titulo'] ?? 'Sem título';
            final String descricao = data['mensagem'] ?? 'Sem descrição';

            // Data formatada (com zero à esquerda)
            final DateTime dataPublicacao =
                (data['dataPublicacao'] as Timestamp).toDate();
            final String dataFormatada = DateFormat(
              'dd/MM/yyyy',
            ).format(dataPublicacao);

            // Prioridade (String -> Enum)
            final PrioridadeComunicado prioridade = _mapPrioridade(
              data['prioridade'],
            );

            return CardStatement(
              title: titulo,
              subtitle: descricao,
              data: dataFormatada,
              prioridade: prioridade,
            );
          },
        );
      },
    );
  }

  /// Converte a prioridade salva no Firestore (String) para enum
  PrioridadeComunicado _mapPrioridade(String? prioridade) {
    switch (prioridade) {
      case 'alta':
        return PrioridadeComunicado.alta;
      case 'media':
        return PrioridadeComunicado.media;
      case 'baixa':
        return PrioridadeComunicado.baixa;
      default:
        return PrioridadeComunicado.baixa;
    }
  }
}
