import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/comunicado_form.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/comunicados_estatisticas.dart';
import 'package:portal_do_aluno/features/admin/presentation/comunicado%20institucional/widgets/history_annoucement.dart';
import 'package:portal_do_aluno/features/student/presentation/widgets/animated_overlay.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class ComunicacaoInstitucionalPage extends StatefulWidget {
  const ComunicacaoInstitucionalPage({super.key});

  @override
  State<ComunicacaoInstitucionalPage> createState() =>
      _ComunicacaoInstitucionalPageState();
}

class _ComunicacaoInstitucionalPageState
    extends State<ComunicacaoInstitucionalPage> {
  final ComunicadoService _service = ComunicadoService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final mensagemController = TextEditingController();

  PrioridadeComunicado? prioridade;
  String? destinatario;
  bool isLoading = false;
  Future<void> _enviarComunicado() async {
    if (!formKey.currentState!.validate()) return;

    if (prioridade == null || destinatario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione prioridade e destinatário')),
      );
      return;
    }

    final comunicado = Comunicado(
      id: '',
      titulo: tituloController.text.trim(),
      mensagem: mensagemController.text.trim(),
      prioridade: prioridade!.name,
      destinatario: Destinatario.values.byName(destinatario!.toLowerCase()),
      dataPublicacao: DateTime.now(),
      dataDeExpiracao: Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 7)),
      ),
    );

    try {
      setState(() => isLoading = true);

      await _service.enviarComunidado(comunicado);

      if (!mounted) return;

      // Reset
      tituloController.clear();
      mensagemController.clear();
      setState(() {
        prioridade = null;
        destinatario = null;
      });

      showAppSnackBar(
        context: context,
        mensagem: 'Comunicado enviado com sucesso!',
        cor: Colors.green,
      );
    } catch (e) {
      showAppSnackBar(
        context: context,
        mensagem: 'Erro ao enviar comunicado',
        cor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: 'Comunicação Institucional'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ComunicadoForm(
                  formKey: formKey,
                  tituloController: tituloController,
                  mensagemController: mensagemController,
                  prioridade: prioridade,
                  destinatario: destinatario,
                  onSelectPrioridade: (p) => setState(() => prioridade = p),
                  onSelectDestinatario: (d) => setState(() => destinatario = d),
                  onSubmit: _enviarComunicado,
                  isLoading: isLoading,
                ),

                const SizedBox(height: 16),

                ComunicadoEstatisticas(service: _service),

                const SizedBox(height: 16),

                const HistoryAnnoucement(),
              ],
            ),
          ),
        ),
        if (isLoading) const AnimatedOverlay(),
      ],
    );
  }
}
