import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/calendario_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/calendario.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/show_create_calendar_event_modal.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';

class CalendarPage1 extends StatefulWidget {
  const CalendarPage1({super.key});

  @override
  State<CalendarPage1> createState() => _CalendarPage1State();
}

class _CalendarPage1State extends State<CalendarPage1> {
  int calendarEventTypeToInt(CalendarEventType tipo) {
    switch (tipo) {
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

  void _abrirModal(BuildContext context, CalendarEventType tipo) {
    final controllers = {
      'titulo': TextEditingController(),
      'descricao': TextEditingController(),
    };
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final listControllers = controllers.values.toList();

    DateTime? dataSelecionada;
    final CalendarioService _calendarioService = CalendarioService();

    showCreateCalendarEventModal(
      context: context,
      tipo: tipo,
      controllers: controllers,
      onDateSelected: (data) {
        dataSelecionada = data;
      },
      formKey: formKey,
      salvarconteudo: (tipo) async {
        final titulo = controllers['titulo']!.text;
        final descricao = controllers['descricao']!.text;

        final tipoInt = calendarEventTypeToInt(tipo);
        if (titulo.isEmpty) {
          return snackBarPersonalizado(
            context: context,
            mensagem: 'Por favor, preencha todos os campos corretamente.',
            cor: Colors.red,
          );
        }

        if (dataSelecionada != null) {
          try {
            final novoEvento = Calendario(
              id: '',
              titulo: titulo,
              descricao: descricao,
              data: Timestamp.fromDate(dataSelecionada!).toDate(),
              tipo: tipoInt,
            );
            await _calendarioService.cadastrarCalendario(novoEvento);
            debugPrint('Tipo: $tipoInt');
            debugPrint('Título: ${controllers['titulo']!.text}');
            debugPrint('Descrição: ${controllers['descricao']!.text}');
            debugPrint('Data: $dataSelecionada');
            FormHelper.limparControllers(controllers: listControllers);
            dataSelecionada = null;
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário Escolar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CalendarEventCard(
              onTap: () => _abrirModal(context, CalendarEventType.avaliacao),

              title: 'Avaliação',
              subtitle: 'Provas, testes e trabalhos avaliativos',
              backgroundColor: Colors.redAccent,
              icon: CupertinoIcons.doc_text_fill,
            ),
            const SizedBox(height: 16),
            CalendarEventCard(
              onTap: () => _abrirModal(context, CalendarEventType.reuniao),
              title: 'Reunião',
              subtitle: 'Reuniões pedagógicas ou com responsáveis',
              backgroundColor: Colors.orangeAccent,
              icon: CupertinoIcons.person_2_fill,
            ),
            const SizedBox(height: 16),
            CalendarEventCard(
              onTap: () =>
                  _abrirModal(context, CalendarEventType.eventoEscolar),
              title: 'Evento Escolar',
              subtitle: 'Festas, passeios e eventos institucionais',
              backgroundColor: Colors.purpleAccent,
              icon: CupertinoIcons.calendar_badge_plus,
            ),
            const SizedBox(height: 16),
            CalendarEventCard(
              onTap: () => _abrirModal(context, CalendarEventType.outro),
              title: 'Outro compromisso',
              subtitle: 'Cadastrar um evento personalizado',
              backgroundColor: Colors.blueAccent,
              icon: CupertinoIcons.square_list_fill,
            ),
            const SizedBox(height: 16),
            CalendarEventCard(
              title: 'Lista de Eventos',
              subtitle: 'Eventos já criados',
              backgroundColor: Colors.green[300]!,
              icon: CupertinoIcons.list_bullet,
            ),
          ],
        ),
      ),
    );
  }
}
