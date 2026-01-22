import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/auth/data/datasources/cadastro_service.dart';


class AddUsuarioController {
  /// FORM
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// SERVICES
  final CadastroService _cadastroService = CadastroService();

  /// CONTROLLERS
  final Map<String, TextEditingController> controllers = {
    'nome': TextEditingController(),
    'senha': TextEditingController(),
    'confirmarSenha': TextEditingController(),
    'cpf': TextEditingController(),
  };

  List<TextEditingController> get allControllers => controllers.values.toList();

  List<TextEditingController> get obrigatorios => [
    controllers['senha']!,
    controllers['confirmarSenha']!,
  ];

  /// STATE
  String? tipoSelecionado;
  bool isPasswordVisible = false;

  String? turmaId;
  String? alunoId;
  String? nomeAluno;
  String? cpfSelecionado;

  final ValueNotifier<String?> alunoSelecionado = ValueNotifier(null);
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier(null);

  /// GETTERS
  bool get isAluno => tipoSelecionado == 'Aluno';
  bool get isProfessor => tipoSelecionado == 'Professor';
  bool get isAdmin => tipoSelecionado == 'Administrador';

  /// FIRESTORE STREAMS
  Stream<QuerySnapshot<Map<String, dynamic>>> streamTurmas() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  Stream<QuerySnapshot> streamAlunos(String classId) {
    return FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: classId)
        .snapshots();
  }

  /// MAP TYPE
  UserType mapTipo() {
    switch (tipoSelecionado) {
      case 'Professor':
        return UserType.teacher;
      case 'Administrador':
        return UserType.admin;
      case 'Responsável':
        return UserType.parent;
      default:
        return UserType.student;
    }
  }

  /// LIMPAR FORM
  void limpar() {
    tipoSelecionado = null;
    turmaId = null;
    alunoId = null;
    nomeAluno = null;
    cpfSelecionado = null;

    alunoSelecionado.value = null;
    turmaSelecionada.value = null;

    for (final c in allControllers) {
      c.clear();
    }
  }

  /// SUBMIT
  Future<bool> salvar() async {
  if (!FormHelper.isFormValid(
    formKey: formKey,
    listControllers: obrigatorios,
  )) {
    return false;
  }

  final nome = controllers['nome']!.text.trim();
  final senha = controllers['senha']!.text.trim();
  final confirmarSenha = controllers['confirmarSenha']!.text.trim();
  final cpf = controllers['cpf']!.text.replaceAll(RegExp(r'[^0-9]'), '');

  if (senha != confirmarSenha) {
    return false;
  }

  if (isAluno && alunoId == null) {
    return false;
  }

  final cpfExiste = await FirebaseFirestore.instance
      .collection('usuarios')
      .where('cpf', isEqualTo: cpfSelecionado ?? cpf)
      .get();

  if (cpfExiste.docs.isNotEmpty) {
    return false;
  }

  final usuario = Usuario(
    id: '',
    turmaId: turmaId ?? '',
    alunoId: alunoId ?? '',
    name: nomeAluno ?? nome,
    cpf: cpfSelecionado ?? cpf,
    password: senha,
    type: mapTipo(),
  );

  try {
    await _cadastroService.cadastroUsuario(usuario);
    limpar();
    return true; // ✅ SUCESSO
  } catch (_) {
    return false; // ❌ ERRO
  }
}



  /// DISPOSE
  void dispose() {
    for (final c in allControllers) {
      c.dispose();
    }
  }
}
