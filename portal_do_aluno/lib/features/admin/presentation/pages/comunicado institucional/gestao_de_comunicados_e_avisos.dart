import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/submit%20state/submit_states.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado%20institucional/controller/comunicacao_institucional_controller.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado%20institucional/widgets/comunicado_form.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado%20institucional/widgets/comunicados_estatisticas.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado%20institucional/widgets/history_annoucement.dart';
import 'package:portal_do_aluno/features/student/presentation/widgets/animated_overlay.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class ComunicacaoInstitucionalPage extends StatefulWidget {
  const ComunicacaoInstitucionalPage({super.key});

  @override
  State<ComunicacaoInstitucionalPage> createState() =>
      _ComunicacaoInstitucionalPageState();
}

class _ComunicacaoInstitucionalPageState
    extends State<ComunicacaoInstitucionalPage> {
  final controller = ComunicacaoInstitucionalController();
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
    return ValueListenableBuilder<SubmitState>(
      valueListenable: controller.submitState,
      builder: (context, state, _) {
        final isLoading = state is SubmitLoading;

        return Stack(
          children: [
            Scaffold(
              appBar: const CustomAppBar(title: 'Comunicação Institucional'),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ComunicadoForm(
                      formKey: controller.formKey,
                      tituloController: controller.tituloController,
                      mensagemController: controller.mensagemController,
                      prioridade: controller.prioridade,
                      destinatario: controller.destinatario,
                      onSelectPrioridade: (p) =>
                          setState(() => controller.prioridade = p),
                      onSelectDestinatario: (d) =>
                          setState(() => controller.destinatario = d),
                      onSubmit: controller.enviar,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 16),

                    ComunicadoEstatisticas(service: controller.service),

                    const SizedBox(height: 16),

                    const HistoryAnnoucement(),
                  ],
                ),
              ),
            ),

            // Overlay agora FUNCIONA
            if (isLoading) const AnimatedOverlay(),
          ],
        );
      },
    );
  }
}
