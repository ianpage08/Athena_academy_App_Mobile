import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👉 MUDANÇA: Necessário para os Formatters
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/cadastro_turmas/controller/cadastro_turma_controller.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class CadastroTurma extends StatefulWidget {
  const CadastroTurma({super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  final CadastroTurmaController controller = CadastroTurmaController();
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
    final theme = Theme.of(context);

    // 👉 MUDANÇA 1: UX Defensiva com GestureDetector para o teclado
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Nova Turma',
        ), // Título mais focado em ação

        body: Center(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), // 👉 MUDANÇA 2: Scroll premium
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              padding: const EdgeInsets.all(
                32,
              ), // Respiro interno maior para elegância
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(
                  24,
                ), // 👉 MUDANÇA 3: Curvatura orgânica
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.03,
                    ), // Sombra hiper suave
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Ajusta o container ao conteúdo
                  children: [
                    // 👉 MUDANÇA 4: Header do formulário enriquecido
                    _buildHeader(theme),

                    const SizedBox(height: 32),

                    // 👉 MUDANÇA 5: Limpeza de SizedBox e uso de CupertinoIcons
                    CustomTextFormField(
                      controller: controller.professorTitularController,
                      prefixIcon: CupertinoIcons.person_crop_circle_fill,
                      label: 'Professor titular',
                      hintText: 'Ex: Maria Silva',
                      keyboardType: TextInputType.name,
                      textCapitalization:
                          TextCapitalization.words, // Força iniciais maiúsculas
                    ),

                    CustomTextFormField(
                      controller: controller.turnoController,
                      prefixIcon: CupertinoIcons
                          .sun_max_fill, // Ícone mais adequado para turno
                      label: 'Turno',
                      hintText: 'Ex: Matutino',
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                    ),

                    // 👉 MUDANÇA 6: Otimização Espacial (Gridding) para Série e Qtd Alunos
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: CustomTextFormField(
                            controller: controller.serieController,
                            prefixIcon: CupertinoIcons.bookmark_fill,
                            label: 'Série',
                            hintText: 'Ex: 9º Ano',
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: CustomTextFormField(
                            controller: controller.qtdAlunosController,
                            prefixIcon: CupertinoIcons.person_3_fill,
                            label:
                                'Vagas', // Label mais curta que 'Quantidade de alunos'
                            hintText: 'Ex: 25',
                            keyboardType: TextInputType.number,
                            // 👉 MUDANÇA 7: Blindagem de backend - só aceita números
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                3,
                              ), // Evita valores irreais (ex: 9999 alunos)
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // BOTÃO
                    SizedBox(
                      width: double.infinity,
                      child: SaveButton(
                        onSave: () async {
                          // Esconde o teclado antes de processar
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.submit();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper visual para o cabeçalho
  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            CupertinoIcons.group_solid,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dados da Turma',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Parâmetros base da classe acadêmica.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
