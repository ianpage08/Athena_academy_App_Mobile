import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/comunicados_stream_list.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class TeacherCommunicationsPage extends StatefulWidget {
  const TeacherCommunicationsPage({super.key});

  @override
  State<TeacherCommunicationsPage> createState() =>
      _TeacherCommunicationsPageState();
}

class _TeacherCommunicationsPageState extends State<TeacherCommunicationsPage> {
  /* Stream que busca a  coleção de comunicados do Firestore
  
   Filtra os documentos da coleção 'comunicados' onde o campo 'destinatario'
   é igual a 'professor' ou 'todos', garantindo que apenas comunicados relevantes
   sejam exibidos para os professor.*/

  String? filtroSelecionado;

  Stream<QuerySnapshot<Map<String, dynamic>>> getComunicadosStream() {
    Query<Map<String, dynamic>> comunicadosQuery = FirebaseFirestore.instance
        .collection('comunicados')
        .where('destinatario', whereIn: ['professores', 'todos']);

    if (filtroSelecionado  != null) {
      comunicadosQuery = comunicadosQuery.where(
        'prioridade',
        isEqualTo: filtroSelecionado,
      );
    }
    return comunicadosQuery.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChipFiltro(
                    title: 'Todos',
                    value: null,
                    filtroSelected: filtroSelecionado,
                    onSelected: (value) {
                      setState(() {
                        filtroSelecionado = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChipFiltro(
                    title: 'Baixa',
                    value: 'baixa',
                    filtroSelected: filtroSelecionado,
                    onSelected: (value) {
                      setState(() {
                        filtroSelecionado = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChipFiltro(
                    title: 'Média',
                    value: 'media',
                    filtroSelected: filtroSelecionado,
                    onSelected: (value) {
                      setState(() {
                        filtroSelecionado = value;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChipFiltro(
                    title: 'Alta',
                    value: 'alta',
                    filtroSelected: filtroSelecionado,
                    onSelected: (value) {
                      filtroSelecionado = value;
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
