import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/stream_vizualizacao_de_comunicados.dart';

class PageComunicados extends StatefulWidget {
  const PageComunicados({super.key});

  @override
  State<PageComunicados> createState() => _PageComunicadosState();
}

class _PageComunicadosState extends State<PageComunicados> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream =
      FirebaseFirestore.instance
          .collection('comunicados')
          .where('destinatario', whereIn: ['professores', 'todos'])
          .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comunicados')),
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(12),
          child: StreamVisualizacaoDeComunicados(
            // Passa o stream de comunicados para o widget de visualização
            comunicadosStream: comunicadosStream,
          ),
        ),
      ),
    );
  }
}
