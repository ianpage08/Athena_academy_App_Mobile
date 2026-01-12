import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/comunicados_stream_list.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class TeacherCommunicationsPage extends StatefulWidget {
  const TeacherCommunicationsPage({super.key});

  @override
  State<TeacherCommunicationsPage> createState() => _TeacherCommunicationsPageState();
}

class _TeacherCommunicationsPageState extends State<TeacherCommunicationsPage> {
  /* Stream que busca a  coleção de comunicados do Firestore
  
   Filtra os documentos da coleção 'comunicados' onde o campo 'destinatario'
   é igual a 'professor' ou 'todos', garantindo que apenas comunicados relevantes
   sejam exibidos para os professor.*/
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream =
      FirebaseFirestore.instance
          .collection('comunicados')
          .where('destinatario', whereIn: ['professores', 'todos'])
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ComunicadosStreamList(
          // Passa o stream de comunicados para o widget de visualização
          comunicadosStream: comunicadosStream,
        ),
      ),
    );
  }
}
