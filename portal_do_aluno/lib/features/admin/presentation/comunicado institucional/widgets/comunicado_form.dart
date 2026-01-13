import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/comunicado_destinatario_selector.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/comunicado_prioridade_seletor_.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/comunicado_submit_button.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/form_header_comunicado.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';

class ComunicadoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController tituloController;
  final TextEditingController mensagemController;
  final PrioridadeComunicado? prioridade;
  final String? destinatario;

  final ValueChanged<PrioridadeComunicado> onSelectPrioridade;
  final ValueChanged<String> onSelectDestinatario;
  final Function()? onSubmit;
  final bool isLoading;



  const ComunicadoForm({
    super.key,
    required this.formKey,
    required this.tituloController,
    required this.mensagemController,
    required this.prioridade,
    required this.destinatario,
    required this.onSelectPrioridade,
    required this.onSelectDestinatario,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormHeaderComunicado(),

              const SizedBox(height: 16),

              CustomTextFormField(
                controller: tituloController,
                prefixIcon: Icons.title,
                label: 'Título',
              ),

              const SizedBox(height: 12),

              ComunicadoPrioridadeSelector(
                prioridade: prioridade,
                onSelected: onSelectPrioridade,
              ),

              const SizedBox(height: 12),

              ComunicadoDestinatarioSelector(
                destinatario: destinatario,
                onSelected: onSelectDestinatario,
              ),

              const SizedBox(height: 12),

              CustomTextFormField(
                controller: mensagemController,
                prefixIcon: Icons.message,
                maxLines: 4,
                label: 'Mensagem',
              ),

              const SizedBox(height: 16),

               ComunicadoSubmitButton(onSubmit: onSubmit!, isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
