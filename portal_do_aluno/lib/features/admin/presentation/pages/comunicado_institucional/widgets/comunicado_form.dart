import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/comunicado_destinatario_selector.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/comunicado_prioridade_seletor_.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/comunicado_submit_button.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/form_header_comunicado.dart';
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormHeaderComunicado(),

            const SizedBox(height: 24),

            // 👉 Campo Assunto
            CustomTextFormField(
              controller: tituloController,
              prefixIcon: CupertinoIcons.pencil_ellipsis_rectangle,
              label: 'Assunto do Comunicado',
            ),

            const SizedBox(height: 20),

            // 👉 MUDANÇA: Seletores agora empilhados verticalmente para maior simetria
            // Removido o Row e os Expandeds para permitir largura total
            ComunicadoPrioridadeSelector(
              prioridade: prioridade,
              onSelected: onSelectPrioridade,
            ),

            const SizedBox(
              height: 20,
            ), // 👉 Espaçamento simétrico entre os seletores

            ComunicadoDestinatarioSelector(
              destinatario: destinatario,
              onSelected: onSelectDestinatario,
            ),

            const SizedBox(height: 20),

            // 👉 Área da Mensagem
            _buildMessageArea(theme),

            const SizedBox(height: 32),

            ComunicadoSubmitButton(
              // 👉 CORREÇÃO TÉCNICA: onSubmit agora invoca a função corretamente
              onSubmit: onSubmit,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageArea(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Conteúdo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
        ),
        CustomTextFormField(
          controller: mensagemController,
          prefixIcon: CupertinoIcons.chat_bubble_text,
          maxLines: 6,
          label: 'Escreva sua mensagem aqui...',
        ),
      ],
    );
  }
}
