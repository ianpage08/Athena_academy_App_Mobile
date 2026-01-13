import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/features/student/presentation/ui/calendar_event_type_style.dart';

class AcademicCalendarPage extends StatefulWidget {
  const AcademicCalendarPage({super.key});

  @override
  State<AcademicCalendarPage> createState() => _AcademicCalendarPageState();
}

class _AcademicCalendarPageState extends State<AcademicCalendarPage> {
  int? eventoSelecionado;

  Stream<QuerySnapshot> get minhaListaPorFiltro {
    final lista = FirebaseFirestore.instance.collection('calendario');
    if (eventoSelecionado == null) return lista.snapshots();

    return lista.where('tipo', isEqualTo: eventoSelecionado).snapshots();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário Escolar')),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(12),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _chipFiltro(title: 'Todos', valor: null),
                    const SizedBox(width: 8),
                    _chipFiltro(title: 'Avaliações', valor: 1),
                    const SizedBox(width: 8),
                    _chipFiltro(title: 'Reuniões', valor: 2),
                    const SizedBox(width: 8),
                    _chipFiltro(title: 'Eventos', valor: 3),
                    const SizedBox(width: 8),
                    _chipFiltro(title: 'Outros', valor: 4),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Lista de Eventos', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: minhaListaPorFiltro,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Nenhum usuário encontrado"),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.separated(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final String titulo = data['titulo'] ?? 'Sem título';
                      final tipo = data['tipo'] ?? 0;
                      final Timestamp tempo = data['data'] ?? 'Sem data';
                      final DateTime dataFormatada = tempo.toDate();

                      final descricao = data['descricao'] ?? 'Sem descrição';
                      final tipoEnum = _calendarEventTypeFromInt(tipo as int);
                      final style = calendarStylesEvent[tipoEnum];
                      final icon = style?.icon;
                      final backgroundColor = style?.backgroundColor;
                      final formatter = DateFormat('dd/MM/yyyy');
                      final formattedDate = formatter.format(dataFormatada);

                      return CalendarEventCard(
                        title: titulo,
                        subtitle: descricao,
                        date: formattedDate,
                        backgroundColor: backgroundColor!,
                        icon: icon!,
                        trailing: const SizedBox(),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipFiltro({required String title, required int? valor}) {
    final bool ativo = eventoSelecionado == valor;

    return ChoiceChip(
      label: Text(title),
      selected: ativo,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ativo ? Colors.white : Colors.black87,
      ),
      selectedColor: const Color(0xFF4A6CF7),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: ativo ? 2 : 0,
      onSelected: (_) {
        setState(() {
          eventoSelecionado = valor;
        });
      },
    );
  }
}
