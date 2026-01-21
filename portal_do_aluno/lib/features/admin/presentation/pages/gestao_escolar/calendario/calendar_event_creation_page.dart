import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/calendario/controller/calendar_event_controller.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/calendario/widgets/create_calendar_event_modal.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';

class CalendarEventCreationPage extends StatefulWidget {
  const CalendarEventCreationPage({super.key});

  @override
  State<CalendarEventCreationPage> createState() =>
      _CalendarEventCreationPageState();
}

class _CalendarEventCreationPageState extends State<CalendarEventCreationPage> {
  final controller = CalendarEventController();
  late final VoidCallback _submitListener;

  @override
  void initState() {
    super.initState();
    _submitListener = SubmitStateListener.attach(
      context: context,
      state: controller.submitState,
    );
  }

  @override
  void dispose() {
    _submitListener();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário Escolar'),
        centerTitle: true,
      ),
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
              onTap: () =>
                  NavigatorService.navigateTo(RouteNames.studentCalendar),
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

  void _abrirModal(BuildContext context, CalendarEventType tipo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ValueListenableBuilder<SubmitState>(
          valueListenable: controller.submitState,
          builder: (_, state, __) {
            return CreateCalendarEventModal(
              formKey: controller.formKey,
              tituloController: controller.tituloController,
              descricaoController: controller.descricaoController,
              tipo: tipo,
              isLoading: state is SubmitLoading,
              onDateSelected: (data) => controller.dataSelecionada = data,
              onSubmit: () {
                controller.salvar(tipo);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
