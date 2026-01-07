import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/shared/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/shared/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';

void showCreateCalendarEventModal({
  required BuildContext context,
  required CalendarEventType tipo,
  required Map<String, TextEditingController> controllers,
  required Function(DateTime?) onDateSelected,
  required Future<void> Function(CalendarEventType tipo) salvarconteudo,
  required GlobalKey<FormState> formKey,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Marcar novo evento no calendário',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormFieldPersonalizado(
                    controller: controllers['titulo']!,
                    label: 'Título do Evento',
                    hintText: 'Digite o título do evento',
                    prefixIcon: Icons.title,
                  ),

                  const SizedBox(height: 16),

                  TextFormFieldPersonalizado(
                    controller: controllers['descricao']!,
                    label: 'Descrição do Evento',
                    hintText: 'Digite a descrição do evento (opcional)',
                    prefixIcon: Icons.description,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            DataPickerCalendario(onDate: onDateSelected),

            const SizedBox(height: 24),

            BotaoSalvar(
              salvarconteudo: () async {
                await salvarconteudo(tipo);
              },
            ),
          ],
        ),
      );
    },
  );
}
