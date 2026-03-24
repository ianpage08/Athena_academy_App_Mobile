import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/helper/boletim_helper.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/disabled_button.dart';
import 'package:portal_do_aluno/shared/widgets/clear_button.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_dropdown_field.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/firestore_dropdown_field.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class GradeEntryPage extends StatefulWidget {
  const GradeEntryPage({super.key});

  @override
  State<GradeEntryPage> createState() => _GradeEntryPageState();
}

class _GradeEntryPageState extends State<GradeEntryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _notaController = TextEditingController();

  final BoletimHelper _boletimHelper = BoletimHelper();

  // VALUE NOTIFIERS
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  final ValueNotifier<String?> alunoSelecionado = ValueNotifier<String?>(null);

  // MAP de valores selecionados
  final Map<String, String?> selected = {
    'turmaId': null,
    'alunoId': null,
    'disciplinaId': null,
    'disciplinaNome': null,
    'unidade': null,
    'tipoAvaliacao': null,
  };

  final List<String> unidades = [
    'Unidade 1',
    'Unidade 2',
    'Unidade 3',
    'Unidade 4',
  ];
  final List<String> avaliacao = ['Teste', 'Prova', 'Trabalho', 'Nota Extra'];

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  void limparCampos() {
    setState(() {
      selected['alunoId'] = null;
      alunoSelecionado.value = null;
      selected['disciplinaId'] = null;
      selected['disciplinaNome'] = null;
      selected['unidade'] = null;
      selected['tipoAvaliacao'] = null;
      _notaController.clear();
    });
  }

  Future<void> salvarNota() async {
    // 1. Fecha o teclado para dar foco visual ao carregamento (UX)
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    
    final stringNota = _notaController.text.replaceAll(',', '.');
    final notaParsed = double.tryParse(stringNota);

    if (notaParsed == null) {
      showAppSnackBar(
        context: context,
        mensagem: 'Formato de nota inválido.',
        cor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    try {
      await _boletimHelper.salvarNota(
        alunoId: selected['alunoId']!,
        turmaId: selected['turmaId']!,
        disciplinaNome: selected['disciplinaNome']!,
        disciplinaId: selected['disciplinaId']!,
        unidade: selected['unidade']!,
        tipoDeNota: selected['tipoAvaliacao']!,
        nota: notaParsed, // Usa o valor validado
      );
      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Nota salva com sucesso!',

          cor: const Color(0xFF34D399),
        );
      }

      limparCampos();
    } catch (e) {
      // ignore: use_build_context_synchronously
      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Erro ao salvar nota!',
          cor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  // 👉 MUDANÇA: Helper para padronizar as labels dos campos (Clean Code)
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Theme.of(
            context,
          ).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.05 : 0.1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Lançamento de Notas'),

      // O usuário não precisa mais "rolar até o final" para salvar ou limpar.
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SaveButton(onSave: salvarNota),
            const SizedBox(height: 12),
            ClearButton(
              label: 'Limpar Formulário',
              isDestructive: true, // Usa a lógica destrutiva que criamos
              onClear: () async {
                setState(() {
                  turmaSelecionada.value = null;
                  selected['turmaId'] = null;
                  limparCampos();
                });
              },
            ),
          ],
        ),
      ),

      body: Form(
        key: _formKey,
        child: GestureDetector(
          // Fecha o teclado ao clicar fora
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            // Adicionado padding inferior extra para não colar nos botões fixos
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Column(
              children: [
                // --- SESSÃO 1: IDENTIFICAÇÃO DO ALUNO ---
                // Chunking visual para reduzir a carga cognitiva
                _buildSectionCard(
                  title: '1. Identificação',
                  children: [
                    _buildLabel('Turma'),
                    SelectClassButton(
                      turmaSelecionada: turmaSelecionada,
                      onTurmaSelecionada: (id, turmaNome) {
                        setState(() {
                          selected['turmaId'] = id;
                          limparCampos();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Aluno'),
                    selected['turmaId'] != null
                        ? SelectStudentButton(
                            alunoSelecionado: alunoSelecionado,
                            turmaId: selected['turmaId'],
                            onAlunoSelecionado: (id, nome, cpf) {
                              setState(() => selected['alunoId'] = id);
                            },
                          )
                        : const DisabledButton(
                            label: 'Selecione a turma primeiro',
                            icon: CupertinoIcons.person_fill,
                          ),
                  ],
                ),

                // --- SESSÃO 2: CONTEXTO DA AVALIAÇÃO ---
                _buildSectionCard(
                  title: '2. Detalhes da Avaliação',
                  children: [
                    _buildLabel('Disciplina'),
                    FirestoreDropdownField(
                      tipo: 'disciplina',
                      titulo: 'Selecione a Disciplina',
                      stream: getDisciplinas(),
                      selecionado: selected['disciplinaNome'],
                      icon: CupertinoIcons.book_fill, // Ícone mais Apple-like
                      habilitado: selected['alunoId'] != null,
                      onSelected: (id, nome) {
                        setState(() {
                          selected['disciplinaId'] = id;
                          selected['disciplinaNome'] = nome;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Colocando Unidade e Tipo lado a lado para economizar espaço
                    // já que são dropdowns de seleção curta
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Unidade'),
                              CustomDropdownField(
                                itens: unidades,
                                selecionado: selected['unidade'],
                                titulo: 'Unidade',
                                icon: CupertinoIcons.calendar,
                                habilitado: selected['disciplinaId'] != null,
                                onSelected: (valor) {
                                  setState(() => selected['unidade'] = valor);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tipo'),
                              CustomDropdownField(
                                itens: avaliacao,
                                selecionado: selected['tipoAvaliacao'],
                                titulo: 'Tipo',
                                icon: CupertinoIcons.doc_text,
                                habilitado: selected['unidade'] != null,
                                onSelected: (valor) {
                                  setState(
                                    () => selected['tipoAvaliacao'] = valor,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // --- SESSÃO 3: RESULTADO ---
                _buildSectionCard(
                  title: '3. Resultado Final',
                  children: [
                    _buildLabel('Nota Alcançada'),
                    CustomTextFormField(
                      controller: _notaController,
                      hintText: 'Ex: 8.5',
                      prefixIcon: CupertinoIcons
                          .star_fill, // Trocado pencil por star (nota)
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      enable: selected['tipoAvaliacao'] != null,

                      // cor de desabilitado. Removemos o 'fillColor' forçado.
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Digite a nota';
                        }

                        // Validação extra no front-end
                        final val = double.tryParse(value.replaceAll(',', '.'));
                        if (val == null) return 'Apenas números';
                        if (val < 0 || val > 10) {
                          return 'Nota deve ser de 0 a 10';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
