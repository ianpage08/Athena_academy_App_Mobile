import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/athena_selection_modal.dart';

// Importe o seu card premium aqui (ajuste o caminho conforme seu projeto)
// import 'package:portal_do_aluno/shared/widgets/athena_modal_card.dart';

/// Seletor de alunos otimizado com Lazy Loading e Design System do Athena.
class SelectStudentButton extends StatefulWidget {
  final ValueNotifier<String?> alunoSelecionado;
  final String? turmaId;
  final void Function(String id, String nomeCompleto, String cpf)
  onAlunoSelecionado;

  const SelectStudentButton({
    super.key,
    required this.alunoSelecionado,
    required this.onAlunoSelecionado,
    this.turmaId,
  });

  @override
  State<SelectStudentButton> createState() => _SelectStudentButtonState();
}

class _SelectStudentButtonState extends State<SelectStudentButton> {
  // Controle da animação da setinha
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  void dispose() {
    _aberto.dispose();
    super.dispose();
  }

  /// Helper para deixar os nomes padronizados e bonitos na UI
  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto
        .trim()
        .split(' ')
        .map((p) {
          if (p.isEmpty) return p;
          // Trata preposições para não ficarem maiúsculas
          if (['de', 'da', 'do', 'das', 'dos'].contains(p.toLowerCase())) {
            return p.toLowerCase();
          }
          return p[0].toUpperCase() + p.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.alunoSelecionado,
      builder: (context, alunoAtual, _) {
        return GestureDetector(
          onTap: () => _abrirModalDeAlunos(context, alunoAtual),
          child: ValueListenableBuilder<bool>(
            valueListenable: _aberto,
            builder: (context, isAberto, _) {
              // --- UI do Botão Base ---
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(
                      alpha: isAberto ? 0.8 : 0.3,
                    ),
                    width: isAberto ? 1.5 : 1.0,
                  ),
                  boxShadow: const [
                    // Sombra super sutil e elegante
                    BoxShadow(
                      color: Color.fromARGB(15, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // O uso do Expanded aqui evita o famoso erro de fita amarela e preta
                    // caso o nome do aluno seja muito comprido para a tela.
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.person_2_fill,
                            size: 22,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              alunoAtual ?? "Selecione um aluno",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: alunoAtual != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: alunoAtual != null
                                    ? Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color
                                    : Theme.of(context).hintColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // Corta com "..." se ficar gigante
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isAberto ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: const Icon(CupertinoIcons.chevron_down, size: 20),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Modal Dinâmico de Seleção de Alunos (Lazy Loading)
  Future<void> _abrirModalDeAlunos(
    BuildContext context,
    String? alunoAtual,
  ) async {
    // Trava de segurança: Não abre a busca se não houver turma selecionada
    if (widget.turmaId == null || widget.turmaId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor, selecione uma turma primeiro."),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _aberto.value = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final theme = Theme.of(modalContext);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(modalContext).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Handle (Pílula de arrasto) ---
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(
                      alpha: isDark ? 0.2 : 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Selecionar Aluno",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Lista de Alunos (StreamBuilder) ---
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('matriculas')
                      .where(
                        'dadosAcademicos.classId',
                        isEqualTo: widget.turmaId,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Nenhum aluno encontrado para esta turma.",
                          ),
                        ),
                      );
                    }

                    final alunos = snapshot.data!.docs;

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      shrinkWrap: true,
                      itemCount: alunos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final aluno = alunos[i];

                        // Extração segura de dados (previne crashes se o doc vier incompleto)
                        final dadosAluno =
                            aluno.data() as Map<String, dynamic>? ?? {};
                        final dados =
                            dadosAluno['dadosAluno'] as Map<String, dynamic>? ??
                            {};

                        final nomeOriginal = dados['nome'] ?? 'Aluno sem nome';
                        final cpf = dados['cpf'] ?? '';
                        final alunoId =
                            dados['id'] ??
                            aluno.id; // Fallback para o ID do documento

                        final nomeFormatado = _capitalizar(nomeOriginal);
                        final isSelected = nomeFormatado == alunoAtual;

                        return AthenaModalCard(
                          label: nomeFormatado,
                          icon: CupertinoIcons.person_fill,
                          isSelected: isSelected,
                          onTap: () {
                            widget.alunoSelecionado.value = nomeFormatado;
                            widget.onAlunoSelecionado(
                              alunoId,
                              nomeFormatado,
                              cpf,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    _aberto.value = false;
  }
}
