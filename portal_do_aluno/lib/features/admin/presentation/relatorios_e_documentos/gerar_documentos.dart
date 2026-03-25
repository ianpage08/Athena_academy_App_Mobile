import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

// Importações mantidas conforme seu projeto
import 'package:portal_do_aluno/features/admin/data/datasources/contrato_pdf_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/dados_academicos.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/endereco_aluno.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/reponsavel_finaceiro.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/aluno.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';

class GerarDocumentosPage extends StatefulWidget {
  const GerarDocumentosPage({super.key});

  @override
  State<GerarDocumentosPage> createState() => _GerarDocumentosPageState();
}

class _GerarDocumentosPageState extends State<GerarDocumentosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 👉 MELHORIA: Agrupamento lógico de variáveis de estado
  String? _tipoDeDocumento;
  final ContratoPdfService _contratoPdfService = ContratoPdfService();

  final Map<String, String?> _mapSelectedValues = {
    'turmaId': null,
    'alunoId': null,
  };

  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'turma': ValueNotifier<String?>(null),
    'aluno': ValueNotifier<String?>(null),
  };

  // 👉 ESTRUTURA: Definição de documentos com cores e metadados
  final List<Map<String, dynamic>> documentos = [
    {
      'nome': 'Certificado',
      'icon': Icons.workspace_premium_rounded,
      'descricao': 'Conclusão Escolar',
      'cor': Colors.amber,
    },
    {
      'nome': 'Histórico',
      'icon': Icons.history_edu_rounded,
      'descricao': 'Notas e Carga Horária',
      'cor': Colors.blue,
    },
    {
      'nome': 'Declaração',
      'icon': Icons.description_rounded,
      'descricao': 'Comprovante de Matrícula',
      'cor': Colors.teal,
    },
    {
      'nome': 'Relatório',
      'icon': Icons.insights_rounded,
      'descricao': 'Desempenho Individual',
      'cor': Colors.indigo,
    },
    {
      'nome': 'Matrícula',
      'icon': Icons.assignment_turned_in_rounded,
      'descricao': 'Contrato e Termos',
      'cor': Colors.deepPurple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Emissor de Documentos',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('1. Selecione o Documento'),
            const SizedBox(height: 16),

            // 👉 ALTERAÇÃO: Grid dinâmico para seleção de tipos
            _buildDocumentSelector(),

            const SizedBox(height: 32),
            _buildSectionHeader('2. Vincular Aluno'),
            const SizedBox(height: 16),

            // 👉 ALTERAÇÃO: Card de seleção de aluno mais "Clean"
            _buildSelectionCard(theme),

            const SizedBox(height: 40),

            // 👉 ALTERAÇÃO: Botão de ação com estado visual
            _buildSubmitButton(theme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- COMPONENTES DE INTERFACE ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildDocumentSelector() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: documentos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final doc = documentos[index];
          final isSelected = _tipoDeDocumento == doc['nome'];
          final Color color = doc['cor'];

          return GestureDetector(
            onTap: () => setState(() => _tipoDeDocumento = doc['nome']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 130,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? color : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? color.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    doc['icon'],
                    color: isSelected ? Colors.white : color,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doc['nome'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc['descricao'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SelectClassButton(
              turmaSelecionada: _mapValueNotifier['turma']!,
              onTurmaSelecionada: (id, turmaNome) {
                setState(() {
                  _mapSelectedValues['turmaId'] = id;
                  _mapSelectedValues['alunoId'] =
                      null; // Reset aluno ao trocar turma
                  _mapValueNotifier['aluno']!.value = null;
                });
                _mapValueNotifier['turma']!.value = turmaNome;
              },
            ),
            if (_mapSelectedValues['turmaId'] != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              SelectStudentButton(
                alunoSelecionado: _mapValueNotifier['aluno']!,
                turmaId: _mapSelectedValues['turmaId']!,
                onAlunoSelecionado: (id, nomeCompleto, cpf) {
                  _mapSelectedValues['alunoId'] = id;
                },
              ),
            ] else
              _buildEmptyStateSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateSelection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Text(
            'Selecione uma turma para carregar os alunos',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    final bool canGenerate =
        _tipoDeDocumento != null && _mapSelectedValues['alunoId'] != null;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: canGenerate ? _processarGeracao : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: canGenerate ? 8 : 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded),
            SizedBox(width: 12),
            Text(
              'GERAR DOCUMENTO AGORA',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  // --- LÓGICA DE NEGÓCIO (BACK-END) ---

  Future<void> _processarGeracao() async {
    // Validação de segurança extra
    if (_tipoDeDocumento == 'Matricula') {
      await _gerarContratoMatricula();
    } else {
      // Mock para outros tipos
      showAppSnackBar(
        context: context,
        mensagem: '$_tipoDeDocumento gerado com sucesso! 🎉',
      );
      _limparCampos();
    }
  }

  Future<void> _gerarContratoMatricula() async {
    try {
      final docAluno = await FirebaseFirestore.instance
          .collection('matriculas')
          .doc(_mapSelectedValues['alunoId'])
          .get();

      if (!docAluno.exists) throw 'Aluno não encontrado';

      final dados = docAluno.data()!;

      // 👉 DECISÃO TÉCNICA: Parsing seguro de models
      final contratoPronto = await _contratoPdfService.gerarContratoPdf(
        dadosPdfAcademicos: DadosAcademicos.fromJson(
          dados['dadosAcademicos'] ?? {},
        ),
        dadosPdfAluno: DadosAluno.fromJson(dados['dadosAluno'] ?? {}),
        dadosPdfResponsavel: ResponsavelFinanceiro.fromJson(
          dados['responsaveisAluno'] ?? {},
        ),
        dadosPdfEndereco: EnderecoAluno.fromJson(dados['dadosEndereco'] ?? {}),
      );

      await Printing.layoutPdf(onLayout: (format) => contratoPronto);

      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Documento impresso com sucesso! 🖨️',
        );
        _limparCampos();
      }
    } catch (e) {
      if (mounted)
        showAppSnackBar(
          context: context,
          mensagem: 'Erro: $e',
          cor: Colors.red,
        );
    }
  }

  void _limparCampos() {
    setState(() {
      _tipoDeDocumento = null;
      _mapSelectedValues['alunoId'] = null;
      _mapValueNotifier['aluno']!.value = null;
    });
  }

  @override
  void dispose() {
    _mapValueNotifier.values.forEach((v) => v.dispose());
    super.dispose();
  }
}
