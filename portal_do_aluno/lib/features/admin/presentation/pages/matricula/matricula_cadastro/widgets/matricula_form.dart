import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/aluno.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/dados_academicos.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/endereco_aluno.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/informacoes_medicas.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno_model/reponsavel_finaceiro.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/sections/dados_academicos_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/sections/dados_aluno_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/sections/dados_endereco_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/sections/dados_medicos_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/sections/dados_responsaveis_section.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
// ... (imports mantidos idênticos)

class MatriculaForm extends StatefulWidget {
  const MatriculaForm({super.key});

  @override
  State<MatriculaForm> createState() => _MatriculaFormState();
}

class _MatriculaFormState extends State<MatriculaForm> {
  // --- LÓGICA MANTIDA INTEGRALMENTE ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _mapController = {
    'nomeAluno': TextEditingController(),
    'cpfAluno': TextEditingController(),
    'naturalidade': TextEditingController(),
    'cep': TextEditingController(),
    'rua': TextEditingController(),
    'numero': TextEditingController(),
    'bairro': TextEditingController(),
    'cidade': TextEditingController(),
    'estado': TextEditingController(),
    'nomeMae': TextEditingController(),
    'nomePai': TextEditingController(),
    'nomeResponsavel': TextEditingController(),
    'cpfDoResponsavel': TextEditingController(),
    'telefoneResponsavel': TextEditingController(),
  };
  final Map<String, TextEditingController> _mapControllerMedico = {
    'alergias': TextEditingController(),
    'medicamentos': TextEditingController(),
    'observacoes': TextEditingController(),
    'telefoneEmergencia': TextEditingController(),
  };

  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  final ValueNotifier<String?> sexoSelecionado = ValueNotifier<String?>(null);
  final ValueNotifier<DateTime?> dataSelecionada = ValueNotifier<DateTime?>(
    null,
  );
  final ValueNotifier<String?> turmaNome = ValueNotifier<String?>(null);
  final ValueNotifier<String?> turmaId = ValueNotifier<String?>(null);
  final MatriculaService _matriculaService = MatriculaService();

  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller.dispose();
    }
    
    sexoSelecionado.dispose();
    dataSelecionada.dispose();
    turmaNome.dispose();
    turmaId.dispose();
    super.dispose();
  }

  // --- MÉTODO _submit MANTIDO EXATAMENTE COMO VOCÊ ESCREVEU ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showAppSnackBar(
        context: context,
        mensagem: 'Por favor, preencha todos os campos corretamente.',
      );
      return;
    }
    if (dataSelecionada.value == null ||
        turmaId.value == null ||
        turmaNome.value == null ||
        sexoSelecionado.value == null) {
      showAppSnackBar(
        context: context,
        mensagem: 'Por favor, preencha todos os campos corretamente.',
      );
      return;
    }

    final dadosAluno = DadosAluno(
      nome: _mapController['nomeAluno']!.text,
      cpf: _mapController['cpfAluno']!.text,
      sexo: sexoSelecionado.value!,
      naturalidade: _mapController['naturalidade']!.text,
      dataNascimento: dataSelecionada.value!,
      nomeMae: _mapController['nomeMae']!.text,
      nomePai: _mapController['nomePai']!.text,
    );
    final enderecoAluno = EnderecoAluno(
      cep: _mapController['cep']!.text,
      rua: _mapController['rua']!.text,
      numero: _mapController['numero']!.text,
      bairro: _mapController['bairro']!.text,
      cidade: _mapController['cidade']!.text,
      estado: _mapController['estado']!.text,
    );
    final responsaveisAluno = ResponsavelFinanceiro(
      nome: _mapController['nomeResponsavel']!.text,
      cpf: _mapController['cpfDoResponsavel']!.text,
      telefone: _mapController['telefoneResponsavel']!.text,
    );
    final dadosAcademicos = DadosAcademicos(
      classId: turmaId.value!,
      turma: turmaNome.value!,
      dataMatricula: DateTime.now(),
    );
    final informacoesMedicasAluno = InformacoesMedicasAluno(
      alergia: _mapControllerMedico['alergias']!.text,
      medicacao: _mapControllerMedico['medicamentos']!.text,
      observacoes: _mapControllerMedico['observacoes']!.text,
      numeroEmergencia: _mapControllerMedico['telefoneEmergencia']!.text,
    );

    try {
      await _matriculaService.cadastrarAlunoCompleto(
        dadosAluno: dadosAluno,
        enderecoAluno: enderecoAluno,
        responsavelFinanceiro: responsaveisAluno,
        dadosAcademicos: dadosAcademicos,
        informacoesMedicasAluno: informacoesMedicasAluno,
        turmaId: turmaId.value!,
      );
      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Aluno cadastrado com sucesso! 🎉',
          cor: Colors.green,
        );
      }
      FormHelper.limparControllers(controllers: _allControllers);
      FormHelper.limparControllers(
        controllers: _mapControllerMedico.values.toList(),
      );
      setState(() {
        sexoSelecionado.value = null;
        dataSelecionada.value = null;
        turmaNome.value = null;
        turmaId.value = null;
      });
    } catch (e) {
      if (mounted) {
        showAppSnackBar(context: context, mensagem: 'Erro ao cadastrar aluno');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, 
        children: [
          
          _buildFormHeader(theme),

          const SizedBox(height: 24),

          DadosAlunoSection(
            mapController: _mapController,
            dataSelecionada: dataSelecionada,
            sexoSelecionado: sexoSelecionado,
          ),

          _buildStepDivider(), 

          DadosEnderecoSection(mapController: _mapController),

          _buildStepDivider(),

          DadosResponsaveisSection(mapController: _mapController),

          _buildStepDivider(),

          DadosAcademicosSection(
            mapController: _mapController,
            turmaName: turmaNome,
            turmaId: turmaId,
          ),

          _buildStepDivider(),

          DadosMedicosSection(mapController: _mapControllerMedico),

          const SizedBox(height: 32),

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SaveButton(onSave: () async => await _submit()),
          ),

          const SizedBox(
            height: 50,
          ), // Respiro final para não colar na borda da tela
        ],
      ),
    );
  }

  // --- WIDGETS DE ESTILO (SEM LÓGICA) ---

  Widget _buildFormHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nova Matrícula',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Preencha todos os módulos para registrar o novo aluno.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider() {
    return const SizedBox(height: 12); // Ajuste fino no ritmo vertical
  }
}
