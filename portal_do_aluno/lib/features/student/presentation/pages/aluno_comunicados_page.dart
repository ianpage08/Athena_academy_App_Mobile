import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/comunicados_stream_list.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({super.key});

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  /* Stream que busca a  coleção de comunicados do Firestore
  
   Filtra os documentos da coleção 'comunicados' onde o campo 'destinatario'
   é igual a 'alunos' ou 'todos', garantindo que apenas comunicados relevantes
   sejam exibidos para os alunos.*/
  String? filtro;
  Stream<QuerySnapshot<Map<String, dynamic>>> getComunicadosStream() {
    Query<Map<String, dynamic>> comunicadosQuery = FirebaseFirestore.instance
        .collection('comunicados')
        .where('destinatario', whereIn: ['alunos', 'todos']);

    if (filtro != null) {
      comunicadosQuery = comunicadosQuery.where(
        'prioridade',
        isEqualTo: filtro,
      );
    }

    return comunicadosQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  ChipFiltro(
                    title: 'Todos',
                    value: null,
                    filtroSelected: filtro,
                    onSelected: (value) {
                      setState(() {
                        filtro = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChipFiltro(
                    title: 'Baixa',
                    value: 'baixa',
                    filtroSelected: filtro,
                    onSelected: (value) {
                      setState(() {
                        filtro = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChipFiltro(
                    title: 'Média',
                    value: 'media',
                    filtroSelected: filtro,
                    onSelected: (value) {
                      setState(() {
                        filtro = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChipFiltro(
                    title: 'Alta',
                    value: 'alta',
                    filtroSelected: filtro,
                    onSelected: (value) {
                      setState(() {
                        filtro = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ComunicadosStreamList(
                // Passa o stream de comunicados para o widget de visualização
                comunicadosStream: getComunicadosStream(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
