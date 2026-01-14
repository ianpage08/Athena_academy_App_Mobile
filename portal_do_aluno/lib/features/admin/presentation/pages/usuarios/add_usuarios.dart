import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/admin_cadastro.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/widgets/professor_cadastro.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/shared/widgets/custom_text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/select_student_button.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';

/// Página para adicionar um novo usuário no sistema.
/// Pode ser professor, aluno ou administrador.
class AddUsuarioPage extends StatefulWidget {
  const AddUsuarioPage({super.key});

  @override
  State<AddUsuarioPage> createState() => _AddUsuarioPageState();
}

class _AddUsuarioPageState extends State<AddUsuarioPage> {
  // Controllers para os campos de texto do formulário.
  final Map<String, TextEditingController> _mapController = {
    'nome': TextEditingController(),
    'senha': TextEditingController(),
    'confirmarSenha': TextEditingController(),
    'cpf': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  // Controladores obrigatórios para validação
  List<TextEditingController> get controllersObrigatorios => [
    _mapController['senha']!,
    _mapController['confirmarSenha']!,
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Estado que guarda o tipo de usuário selecionado.
  String? isSelectedTipo;

  // Stream para obter turmas do Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>> getstreamTurma() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  // Stream para obter alunos da turma selecionada.
  Stream<QuerySnapshot> getAluno(String classId) {
    return FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: classId)
        .snapshots();
  }

  // Map que mantém ValueNotifiers para seleção dinâmica.
  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'alunoSelecionado': ValueNotifier<String?>(null),
    'turmaSelecionada': ValueNotifier<String?>(null),
  };

  // Variáveis que armazenam dados selecionados.
  String? turmaId;
  String? cpfSelecionado;
  String? alunoId;
  String? nomeAluno;

  // Controle para visibilidade da senha no formulário.
  bool isPasswordVisible = false;

  // Conversão de tipo de usuário string para enum UserType.
  UserType _mapTipo(String? tipo) {
    switch (tipo) {
      case 'Professor':
        return UserType.teacher;
      case 'Aluno':
        return UserType.student;
      case 'Responsável':
        return UserType.parent;
      case 'Administrador':
        return UserType.admin;
      default:
        return UserType.student;
    }
  }

  @override
  void dispose() {
    // Liberar recursos dos controllers para evitar vazamento de memória
    for (var controller in _mapController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Exibe modal para seleção do tipo de usuário
  void showtipoPerfilModal() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Selecione o tipo de usuário',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: 3,

                itemBuilder: (context, index) {
                  final tipos = ['Professor', 'Aluno', 'Administrador'];
                  final tipo = tipos[index];
                  final isSelected = isSelectedTipo == tipo;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedTipo = tipo;
                      });
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF6366F1).withOpacity(0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _iconByTipo(tipo),
                                size: 20,
                                color: isSelected
                                    ? const Color.fromARGB(255, 139, 141, 253)
                                    : Theme.of(context).iconTheme.color,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tipo,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color.fromARGB(255, 166, 167, 248)
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Color(0xFF6366F1),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _iconByTipo(String tipo) {
    switch (tipo) {
      case 'Professor':
        return Icons.school_rounded;
      case 'Aluno':
        return Icons.person_rounded;
      case 'Administrador':
        return Icons.admin_panel_settings_rounded;
      default:
        return Icons.person_outline;
    }
  }

  // Limpa os campos e variáveis selecionadas no formulário
  void _limparCampos() {
    setState(() {
      isSelectedTipo = null;
      turmaId = null;
      cpfSelecionado = null;
      alunoId = null;
      nomeAluno = null;

      // Resetar valores nos ValueNotifiers para atualizar UI
      _mapValueNotifier['alunoSelecionado']!.value = null;
      _mapValueNotifier['turmaSelecionada']!.value = null;

      // Limpar campos de texto
      for (var controller in _allControllers) {
        controller.clear();
      }
    });
  }

  // Método para adicionar um usuário ao banco de dados
  // Faz validações e interage com o serviço de cadastro
  void _adicionarUsuario() async {
    if (FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: controllersObrigatorios,
    )) {
      final nome = _mapController['nome']!.text.trim();
      final senha = _mapController['senha']!.text.trim();
      final confirmarSenha = _mapController['confirmarSenha']!.text.trim();
      final cpf = _mapController['cpf']!.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Validações específicas para tipo Aluno
      if (isSelectedTipo == 'Aluno' && (alunoId == null || nomeAluno == null)) {
        showAppSnackBar(
          context: context,
          mensagem: 'Selecione um aluno antes de cadastrar.',
          cor: Colors.orange,
        );
        return;
      }

      // Validação para professor
      if (isSelectedTipo == 'Professor' &&
          (_mapController['nome']!.text.isEmpty ||
              _mapController['cpf']!.text.isEmpty)) {
        showAppSnackBar(
          context: context,
          mensagem: 'Preencha todos os campos antes de cadastrar.',
          cor: Colors.orange,
        );
        return;
      }

      // Continuação se todos os campos de senha, cpf e nome estiverem preenchidos
      if (senha.isNotEmpty &&
          confirmarSenha.isNotEmpty &&
          (cpf.isNotEmpty || cpfSelecionado != null) &&
          (nome.isNotEmpty || nomeAluno != null)) {
        // Verificação para CPF duplicado no Firestore
        final verificarCpf = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpf)
            .get();

        if (verificarCpf.docs.isNotEmpty) {
          if (mounted) {
            showAppSnackBar(
              context: context,
              mensagem: 'CPF já cadastrado no sistema.',
              cor: Colors.red,
            );
          }
          return;
        }

        // Criar novo objeto Usuario para salvar
        final novoUsuario = Usuario(
          id: '',
          turmaId: turmaId ?? '',
          alunoId: alunoId ?? '',
          name: nomeAluno ?? nome,
          cpf: cpfSelecionado ?? cpf,
          password: senha,
          type: _mapTipo(isSelectedTipo),
        );

        try {
          await CadastroService().cadastroUsuario(novoUsuario);

          // Feedback visual para usuário
          if (mounted) {
            showAppSnackBar(
              context: context,
              mensagem: 'Usuário cadastrado com sucesso! 🎉',
              cor: Colors.green,
            );
          }

          _limparCampos();
        } catch (e) {
          if (e is Exception) {
            debugPrint(e.toString());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Cadastrar Usuário',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      // Formulário que agrupa os campos de entrada e validação
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),

                            // Botão para selecionar o tipo de usuário
                            SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: showtipoPerfilModal,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            color: Theme.of(
                                              context,
                                            ).iconTheme.color,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            isSelectedTipo ??
                                                'Selecione o tipo de usuário',
                                            style: const TextStyle(
                                              fontSize: 18,

                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Coluna que exibe widgets de seleção dinâmicos conforme o tipo
                            Column(
                              children: [
                                // Se for aluno: seleção de turma e aluno (widgets podem ser extraídos)
                                if (isSelectedTipo == 'Aluno') ...[
                                  SelectClassButton(
                                    turmaSelecionada:
                                        _mapValueNotifier['turmaSelecionada']!,
                                    onTurmaSelecionada: (id, nomeCompleto) {
                                      setState(() {
                                        turmaId = id;
                                      });
                                      debugPrint(
                                        'Turma ID selecionada: $turmaId',
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  if (turmaId != null)
                                    SelectStudentButton(
                                      alunoSelecionado:
                                          _mapValueNotifier['alunoSelecionado']!,
                                      turmaId: turmaId,
                                      onAlunoSelecionado: (id, nomeCompleto, cpf) {
                                        alunoId = id;
                                        cpfSelecionado = cpf;
                                        nomeAluno = nomeCompleto;
                                        debugPrint(
                                          'Nome do Aluno selecionado: $nomeAluno',
                                        );
                                        debugPrint(
                                          'Aluno ID selecionado: $alunoId',
                                        );
                                        debugPrint(
                                          'Aluno CPF selecionado: $cpfSelecionado',
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 12),
                                ],

                                // Se for professor, exibe campos específicos (função já isolada)
                                if (isSelectedTipo == 'Professor') ...[
                                  ProfessorCadastro(
                                    mapController1: _mapController['nome']!,
                                    mapController2: _mapController['cpf']!,
                                    enabled: isSelectedTipo == 'Professor',
                                  ),
                                ],

                                // Se for administrador, exibe campos específicos (função já isolada)
                                if (isSelectedTipo == 'Administrador') ...[
                                  AdminCadastro(
                                    mapController1: _mapController['nome']!,
                                    mapController2: _mapController['cpf']!,
                                    enabled: isSelectedTipo == 'Administrador',
                                  ),
                                ],
                              ],
                            ),

                            // Campos para senha e confirmação de senha
                            CustomTextFormField(
                              controller: _mapController['senha']!,
                              obscureText: !isPasswordVisible,

                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: isPasswordVisible
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              label: 'Senha',

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira a senha';
                                }
                                if (value.length < 8) {
                                  return 'Senha deve ter no minimo 8 caracteres';
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return 'Senha deve conter ao menos uma letra maiúscula';
                                }
                                if (!value.contains(RegExp(r'[a-z]'))) {
                                  return 'Senha deve conter ao menos uma letra minúscula';
                                }
                                if (!value.contains(RegExp(r'[0-9]'))) {
                                  return 'Senha deve conter ao menos um número';
                                }
                                if (!value.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                                )) {
                                  return 'Senha deve conter ao menos um símbolo especial';
                                }
                                return null;
                              },
                            ),

                            CustomTextFormField(
                              controller: _mapController['confirmarSenha']!,
                              obscureText: !isPasswordVisible,

                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: isPasswordVisible
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              label: 'Confirmar Senha',

                              validator: (value) {
                                if (value != _mapController['senha']!.text) {
                                  return 'Senhas não coincidem';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Card com dicas para criar senha segura
                            SizedBox(
                              child: Card(
                                elevation: 0,
                                color: Theme.of(context).cardColor,
                                child: const Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.info,
                                          color: Colors.blue,
                                        ),
                                        title: Text('Dica de Senha Segura'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Mínimo de 8 caracteres'),
                                            Text(
                                              'Incluir letras maiúsculas e minúsculas',
                                            ),
                                            Text(
                                              'Incluir números e símbolos especiais',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Linha com botões para adicionar usuário ou limpar dados
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                ),
                                onPressed: _adicionarUsuario,
                                child: const Text(
                                  'Adicionar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 3,
                                ),
                                onPressed: _limparCampos,
                                child: const Text(
                                  'Limpar Dados',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
