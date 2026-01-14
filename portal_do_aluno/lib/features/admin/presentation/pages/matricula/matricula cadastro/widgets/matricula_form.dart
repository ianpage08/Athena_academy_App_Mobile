import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/sections/dados_academicos_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/sections/dados_aluno_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/sections/dados_endereco_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/sections/dados_medicos_section.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/sections/dados_responsaveis_section.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';

class MatriculaForm extends StatefulWidget {
  const MatriculaForm({super.key});

  @override
  State<MatriculaForm> createState() => _MatriculaFormState();
}

class _MatriculaFormState extends State<MatriculaForm> {
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
    'cpfMae': TextEditingController(),
    'telefoneMae': TextEditingController(),
    'nomePai': TextEditingController(),
    'cpfPai': TextEditingController(),
    'telefonePai': TextEditingController(),
    'numeroMatricula': TextEditingController(),
    'anoLetivo': TextEditingController(),
  };
  final Map<String, TextEditingController> _mapControllerMedico = {
    'alergias': TextEditingController(),
    'medicamentos': TextEditingController(),
    'observacoes': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  final ValueNotifier<String?> sexoSelecionado = ValueNotifier<String?>(null);
  final ValueNotifier<DateTime?> dataSelecionada = ValueNotifier<DateTime?>(
    null,
  );
  final ValueNotifier<String?> turnoSelecionado = ValueNotifier<String?>(null);
  final ValueNotifier<String?> turmaNome = ValueNotifier<String?>(null);
  final ValueNotifier<String?> turmaId = ValueNotifier<String?>(null);
  final MatriculaService _matriculaService = MatriculaService();
  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
    );
    final enderecoAluno = EnderecoAluno(
      cep: _mapController['cep']!.text,
      rua: _mapController['rua']!.text,
      numero: _mapController['numero']!.text,
      bairro: _mapController['bairro']!.text,
      cidade: _mapController['cidade']!.text,
      estado: _mapController['estado']!.text,
    );
    final responsaveisAluno = ResponsaveisAluno(
      nomeMae: _mapController['nomeMae']!.text,
      cpfMae: _mapController['cpfMae']!.text,
      telefoneMae: _mapController['telefoneMae']!.text,
      nomePai: _mapController['nomePai']!.text,
      cpfPai: _mapController['cpfPai']!.text,
      telefonePai: _mapController['telefonePai']!.text,
    );
    final dadosAcademicos = DadosAcademicos(
      classId: turmaId.value!,
      numeroMatricula: _mapController['numeroMatricula']!.text,
      turma: turmaNome.value!,
      anoLetivo: _mapController['anoLetivo']!.text,
      turno: turnoSelecionado.value!,
      situacao: 'Matriculado',
      dataMatricula: DateTime.now(),
    );
    final informacoesMedicasAluno = InformacoesMedicasAluno(
      alergia: _mapControllerMedico['alergias']!.text,
      medicacao: _mapControllerMedico['medicamentos']!.text,
      observacoes: _mapControllerMedico['observacoes']!.text,
    );

    try {
      await _matriculaService.cadastrarAlunoCompleto(
        dadosAluno: dadosAluno,
        enderecoAluno: enderecoAluno,
        responsaveisAluno: responsaveisAluno,
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
        turnoSelecionado.value = null;
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DadosAlunoSection(
            mapController: _mapController,
            dataSelecionada: dataSelecionada,
            sexoSelecionado: sexoSelecionado,
          ),
          const SizedBox(height: 16),
          DadosEnderecoSection(mapController: _mapController),
          const SizedBox(height: 16),
          DadosResponsaveisSection(mapController: _mapController),
          const SizedBox(height: 16),
          DadosAcademicosSection(
            mapController: _mapController,
            turnoSelecionado: turnoSelecionado,
            turmaName: turmaNome,
            turmaId: turmaId,
          ),
          const SizedBox(height: 16),
          DadosMedicosSection(mapController: _mapControllerMedico),
          const SizedBox(height: 20),
          SaveButton(
            salvarconteudo: () async {
              await _submit();
            },
          ),
        ],
      ),
    );
  }
}
