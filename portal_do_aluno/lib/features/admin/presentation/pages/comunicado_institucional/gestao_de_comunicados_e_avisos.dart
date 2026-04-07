import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/core/submit_state/submit_states.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/controller/comunicacao_institucional_controller.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/comunicado_form.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/comunicados_estatisticas.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/widgets/history_annoucement.dart';
import 'package:portal_do_aluno/features/student/presentation/widgets/animated_overlay.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';

import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ComunicacaoInstitucionalPage extends StatefulWidget {
  const ComunicacaoInstitucionalPage({super.key});

  @override
  State<ComunicacaoInstitucionalPage> createState() =>
      _ComunicacaoInstitucionalPageState();
}

class _ComunicacaoInstitucionalPageState
    extends State<ComunicacaoInstitucionalPage> {
  final controller = ComunicacaoInstitucionalController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComunicacaoInstitucionalController>().addListener(
        _onStateChange,
      );
    });
  }

  @override
  void dispose() {
    _onStateChange;
    super.dispose();
  }

  void _onStateChange() {
    if (!mounted) return;

    final state = context
        .read<ComunicacaoInstitucionalController>()
        .submitState;
    if (state is SubmitSuccess) {
      showAppSnackBar(
        context: context,
        mensagem: state.message,
        cor: Colors.green,
      );
    } else if (state is SubmitError) {
      showAppSnackBar(
        context: context,
        mensagem: state.message.message,
        cor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = context.select<ComunicacaoInstitucionalController, bool>(
      (c) => c.isLoading,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(title: 'Portal de Avisos'),

          body: SafeArea(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                setState(() {});
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // 1. DASHBOARD DE MÉTRICAS (Estatísticas no topo para visão rápida)
                        const ComunicadoEstatisticas(),

                        const SizedBox(height: 32),

                        // 2. ÁREA DE CRIAÇÃO (Card principal de ação)
                        _buildSectionLabel(
                          theme,
                          'CRIAÇÃO',
                          CupertinoIcons.plus_square_fill,
                        ),
                        const SizedBox(height: 16),
                        const ComunicadoForm(),

                        const SizedBox(height: 40),

                        // 3. LINHA DO TEMPO (Histórico de envios)
                        _buildSectionLabel(
                          theme,
                          'HISTÓRICO',
                          CupertinoIcons.list_bullet_indent,
                        ),
                        const SizedBox(height: 16),
                        const HistoryAnnoucement(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isLoading) const AnimatedOverlay(),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 2.0,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
