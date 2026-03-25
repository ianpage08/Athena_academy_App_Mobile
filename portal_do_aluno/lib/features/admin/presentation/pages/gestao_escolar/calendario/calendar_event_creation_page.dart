import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/calendario/controller/calendar_event_controller.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_card.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/show_create_calendar_event_modal.dart';

import 'package:portal_do_aluno/navigation/navigation_service.dart';
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

  void _abrirModal(BuildContext context, CalendarEventType tipo) {
    
    controller.tituloController.clear();
    controller.descricaoController.clear();
    // Se você tiver um estado inicial definido no seu core, descomente a linha abaixo:
    // controller.submitState.value = const InitialSubmitState();

    showCreateCalendarEventModal(
      submitState: controller.submitState,
      context: context,
      tipo: tipo,
      controllers: {
        'titulo': controller.tituloController,
        'descricao': controller.descricaoController,
      },
      formKey: controller.formKey,
      onDateSelected: (data) => controller.dataSelecionada = data,
      salvarconteudo: (tipo) async {
        FocusScope.of(context).unfocus();
        await controller.salvar(tipo);
      },
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
    final theme = Theme.of(context);

    return ValueListenableBuilder<SubmitState>(
      valueListenable: controller.submitState,
      builder: (context, state, _) {
        
        final isLoading =
            state.toString().contains('Loading') || state is SubmitLoading;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,

          
          body: Stack(
            children: [
              
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Text(
                        'Gestão de Calendário',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Selecione o tipo de evento que deseja registrar no cronograma oficial da academia.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),

                      

                      // BLOCO 1: ACADÊMICO
                      _buildSectionHeader(context, 'ACADÊMICO'),
                      CalendarEventCard(
                        onTap: isLoading
                            ? null
                            : () => _abrirModal(
                                context,
                                CalendarEventType.avaliacao,
                              ),
                        title: 'Avaliação',
                        subtitle: 'Provas, testes e trabalhos avaliativos',
                        backgroundColor: Colors.redAccent,
                        icon: CupertinoIcons.doc_text_fill,
                      ),
                      CalendarEventCard(
                        onTap: isLoading
                            ? null
                            : () => _abrirModal(
                                context,
                                CalendarEventType.reuniao,
                              ),
                        title: 'Reunião',
                        subtitle: 'Encontros pedagógicos e com responsáveis',
                        backgroundColor: Colors.orangeAccent,
                        icon: CupertinoIcons.person_2_fill,
                      ),

                      const SizedBox(height: 24),

                      // BLOCO 2: INSTITUCIONAL
                      _buildSectionHeader(context, 'EVENTOS E OUTROS'),
                      CalendarEventCard(
                        onTap: isLoading
                            ? null
                            : () => _abrirModal(
                                context,
                                CalendarEventType.eventoEscolar,
                              ),
                        title: 'Evento Escolar',
                        subtitle: 'Festas, passeios e eventos institucionais',
                        backgroundColor: Colors.purpleAccent,
                        icon: CupertinoIcons.calendar_badge_plus,
                      ),
                      CalendarEventCard(
                        onTap: isLoading
                            ? null
                            : () =>
                                  _abrirModal(context, CalendarEventType.outro),
                        title: 'Outro compromisso',
                        subtitle: 'Cadastrar um evento personalizado',
                        backgroundColor: Colors.blueAccent,
                        icon: CupertinoIcons.square_list_fill,
                      ),

                      const SizedBox(height: 24),

                      // BLOCO 3: CONSULTA
                      _buildSectionHeader(context, 'CONSULTA'),
                      CalendarEventCard(
                        onTap: () => NavigatorService.navigateTo(
                          RouteNames.studentCalendar,
                        ),
                        title: 'Cronograma Completo',
                        subtitle: 'Visualizar lista de eventos já criados',
                        backgroundColor: const Color(
                          0xFF2ECC71,
                        ), // Verde sinalizando "Tudo Certo/Prosseguir"
                        icon: CupertinoIcons.list_bullet,
                       
                        trailing: Icon(
                          CupertinoIcons.arrow_right_circle_fill,
                          color: Colors.green.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                    child: const Center(
                      child: CupertinoActivityIndicator(radius: 16),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

 
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
