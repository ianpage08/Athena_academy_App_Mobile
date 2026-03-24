import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/comunicados_stream_list.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

/// Tela de Mural de Comunicados do Professor.
///
/// Arquitetura e Performance:
/// - [DRY (Don't Repeat Yourself)]: Filtros gerados dinamicamente via mapa de dados.

class TeacherCommunicationsPage extends StatefulWidget {
  const TeacherCommunicationsPage({super.key});

  @override
  State<TeacherCommunicationsPage> createState() =>
      _TeacherCommunicationsPageState();
}

class _TeacherCommunicationsPageState extends State<TeacherCommunicationsPage> {
  String? _filtroSelecionado;

  // Evita que a query seja recriada a cada micro-rebuild da tela
  late Stream<QuerySnapshot<Map<String, dynamic>>> _comunicadosStream;

  // Se amanhã a escola criar o filtro "Urgente", você adiciona só 1 linha aqui!
  final List<Map<String, String?>> _opcoesFiltro = [
    {'title': 'Todos', 'value': null},
    {'title': 'Baixa', 'value': 'baixa'},
    {'title': 'Média', 'value': 'media'},
    {'title': 'Alta', 'value': 'alta'},
  ];

  @override
  void initState() {
    super.initState();
    _atualizarStream(); // Inicializa o stream na montagem da tela
  }

  void _atualizarStream() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('comunicados')
        .where('destinatario', whereIn: ['professores', 'todos']);

    if (_filtroSelecionado != null) {
      query = query.where('prioridade', isEqualTo: _filtroSelecionado);
    }

    _comunicadosStream = query.snapshots();
  }

  void _onFiltroAlterado(String? novoFiltro) {
    // Só atualiza se o filtro realmente mudou
    if (_filtroSelecionado == novoFiltro) return;

    setState(() {
      _filtroSelecionado = novoFiltro;
      _atualizarStream(); // Reconecta o Firebase com a nova query
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Column(
        children: [
          // --- ÁREA DE FILTROS (Header Inteligente) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,

              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Padding nas bordas para o primeiro e último chip não colarem na tela
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _opcoesFiltro.map((filtro) {
                  final title = filtro['title'] as String;

                  final value = filtro['value'];

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),

                    child: ChipFiltro(
                      title: title,
                      value: value,
                      filtroSelected: _filtroSelecionado,
                      onSelected: _onFiltroAlterado,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // --- LISTA DE COMUNICADOS ---
          Expanded(
            child: ComunicadosStreamList(comunicadosStream: _comunicadosStream),
          ),
        ],
      ),
    );
  }
}
