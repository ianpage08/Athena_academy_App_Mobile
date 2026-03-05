import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/calendario_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/calendario.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';

class CalendarRepository {
  CalendarRepository({CalendarioService? service})
    : _service = service ?? CalendarioService();

  final CalendarioService _service;

  int typeForInt(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.avaliacao:
        return 1;
      case CalendarEventType.reuniao:
        return 2;
      case CalendarEventType.eventoEscolar:
        return 3;
      case CalendarEventType.outro:
        return 4;
    }
  }

  Future<void> createEvent(
    {required String titulo,
    required CalendarEventType tipo,
    required DateTime dataSelecionada,
    required String? descricao,}
  ) async {
    final newEvent = Calendario(
      id: '',
      titulo: titulo,
      data: dataSelecionada,
      descricao: descricao,
      tipo: typeForInt(tipo),
      dataDeExpiracao: Timestamp.fromDate(
        dataSelecionada.add(const Duration(days: 30)),
      ),
    );

    await _service.cadastrarCalendario(newEvent);
  }
}
