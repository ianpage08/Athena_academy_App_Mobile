import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/calendar_event_type.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';

class CreateCalendarEventModal extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController tituloController;
  final TextEditingController descricaoController;
  final CalendarEventType tipo;
  final bool isLoading;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onSubmit;

  const CreateCalendarEventModal({
    super.key,
    required this.formKey,
    required this.tituloController,
    required this.descricaoController,
    required this.tipo,
    required this.onDateSelected,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Novo ${tipo.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obrigatório' : null,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );
                if (date != null) {
                  onDateSelected(date);
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Selecionar data'),
            ),

            const SizedBox(height: 24),

            SaveButton(
              salvarconteudo: () async {
                onSubmit;
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
