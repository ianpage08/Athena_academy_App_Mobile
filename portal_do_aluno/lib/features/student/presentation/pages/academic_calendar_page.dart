import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/features/student/presentation/ui/calendar_event_type_style.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';

// 👉 MUDANÇA 1: Importando nossos componentes Premium globais
import 'package:portal_do_aluno/shared/widgets/chip_filtro.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

/// Tela de Calendário Acadêmico.
///
/// Arquitetura e Performance:
/// - [DRY]: Remoção do `_chipFiltro` local em favor do componente global do Design System.
/// - [Performance]: Cache do `_eventosStream` no estado, evitando chamadas repetitivas ao Firebase.
/// - [Segurança]: Tratamento de nulos ao renderizar os ícones e cores do `CalendarEventCard`.
class AcademicCalendarPage extends StatefulWidget {
  const AcademicCalendarPage({super.key});

  @override
  State<AcademicCalendarPage> createState() => _AcademicCalendarPageState();
}

class _AcademicCalendarPageState extends State<AcademicCalendarPage> {
  int? _eventoSelecionado;

  // 👉 MUDANÇA 2: Stream cacheado na memória
  late Stream<QuerySnapshot> _eventosStream;

  // Lista dinâmica de filtros (Fácil manutenção)
  final List<Map<String, dynamic>> _opcoesFiltro = [
    {'title': 'Todos', 'valor': null},
    {'title': 'Avaliações', 'valor': 1},
    {'title': 'Reuniões', 'valor': 2},
    {'title': 'Eventos', 'valor': 3},
    {'title': 'Outros', 'valor': 4},
  ];

  @override
  void initState() {
    super.initState();
    _atualizarStream();
  }

  // 👉 MUDANÇA 3: Atualização inteligente do Firebase
  void _atualizarStream() {
    final colecao = FirebaseFirestore.instance.collection('calendario');

    // Filtro por data futura? Dica para o futuro: .where('data', isGreaterThanOrEqualTo: DateTime.now())
    if (_eventoSelecionado == null) {
      _eventosStream = colecao.snapshots();
    } else {
      _eventosStream = colecao
          .where('tipo', isEqualTo: _eventoSelecionado)
          .snapshots();
    }
  }

  void _onFiltroAlterado(String? valorString) {
    // O ChipFiltro devolve String?, então convertemos de volta para int?
    final novoValor = valorString != null ? int.tryParse(valorString) : null;

    if (_eventoSelecionado == novoValor) return;

    setState(() {
      _eventoSelecionado = novoValor;
      _atualizarStream();
    });
  }

  CalendarEventType _calendarEventTypeFromInt(int value) {
    switch (value) {
      case 1:
        return CalendarEventType.avaliacao;
      case 2:
        return CalendarEventType.reuniao;
      case 3:
        return CalendarEventType.eventoEscolar;
      default:
        return CalendarEventType.outro;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // 👉 MUDANÇA 4: Usando nosso CustomAppBar
      appBar: const CustomAppBar(title: 'Calendário Escolar'),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ÁREA DE FILTROS (Sticky Header) ---
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _opcoesFiltro.map((filtro) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    // 👉 MUDANÇA 5: Reutilizando a inteligência do nosso ChipFiltro global!
                    child: ChipFiltro(
                      title: filtro['title'],
                      value: filtro['valor']?.toString(), // Passa como String
                      filtroSelected: _eventoSelecionado?.toString(),
                      onSelected: _onFiltroAlterado,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // --- CABEÇALHO CONTEXTUAL ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próximos Eventos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acompanhe as datas importantes da instituição.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // --- LISTA DE EVENTOS ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _eventosStream, // Lendo do Cache!
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(radius: 16),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const EmptyStateWidget(
                    icon: CupertinoIcons.calendar_badge_minus,
                    title: 'Agenda Livre',
                    description:
                        'Não há eventos programados para este filtro no momento.',
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final String titulo = data['titulo'] ?? 'Evento sem título';
                    final String descricao =
                        data['descricao'] ?? 'Sem detalhes adicionais.';
                    final int tipo = data['tipo'] ?? 0;

                    // 👉 MUDANÇA 6: Proteção contra ausência de data
                    final Timestamp? tempo = data['data'];
                    final DateTime dataFormatada =
                        tempo?.toDate() ?? DateTime.now();
                    final formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(dataFormatada);

                    final tipoEnum = _calendarEventTypeFromInt(tipo);
                    final style = calendarStylesEvent[tipoEnum];

                    // 👉 MUDANÇA 7: Fallback de UI. Se o estilo não existir, não quebra a tela com o "!"
                    final icon = style?.icon ?? CupertinoIcons.circle;
                    final backgroundColor =
                        style?.backgroundColor ??
                        theme.colorScheme.surfaceContainerHighest;

                    return CalendarEventCard(
                      title: titulo,
                      subtitle: descricao,
                      date: formattedDate,
                      backgroundColor: backgroundColor,
                      icon: icon,
                      trailing: const SizedBox(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
