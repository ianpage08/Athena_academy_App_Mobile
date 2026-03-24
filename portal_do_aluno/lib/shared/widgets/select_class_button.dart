import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/athena_selection_modal.dart';

/// Seletor de turmas com  integração Lazy com Firestore.
class SelectClassButton extends StatefulWidget {
  final ValueNotifier<String?> turmaSelecionada;
  final void Function(String id, String turmaNome)? onTurmaSelecionada;

  const SelectClassButton({
    super.key,
    required this.turmaSelecionada,
    required this.onTurmaSelecionada,
  });

  @override
  State<SelectClassButton> createState() => _SelectClassButtonState();
}

class _SelectClassButtonState extends State<SelectClassButton> {
  // Controle da animação da setinha
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  void dispose() {
    _aberto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.turmaSelecionada,
      builder: (context, turmaAtual, _) {
        return GestureDetector(
          onTap: () => _abrirModalDeTurmas(context, turmaAtual),
          child: ValueListenableBuilder<bool>(
            valueListenable: _aberto,
            builder: (context, isAberto, _) {
              // --- Botão Base ---
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
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 22,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          turmaAtual ?? "Selecionar turma",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: turmaAtual != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: turmaAtual != null
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
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

  /// Modal Lazy Loading com Design Premium
  Future<void> _abrirModalDeTurmas(
    BuildContext context,
    String? turmaAtual,
  ) async {
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
              // --- Handle de Arrastar ---
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

              // --- Título ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Selecione a Turma",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Lista Conectada ao Firebase ---
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('turmas')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text("Nenhuma turma encontrada.")),
                      );
                    }

                    final turmas = snapshot.data!.docs;

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      shrinkWrap: true,
                      itemCount: turmas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final turma = turmas[i];
                        final nome = turma['serie'] ?? 'S/N';
                        final turno = turma['turno'] ?? '';
                        final nomeCompleto = "$nome - $turno";
                        final isSelected = nomeCompleto == turmaAtual;

                        // 👉 AQUI A MÁGICA ACONTECE: Usando o novo Card Premium!
                        return AthenaModalCard(
                          label: nomeCompleto,
                          icon: Icons.groups_rounded, // Ícone de turma
                          isSelected: isSelected,
                          onTap: () {
                            widget.turmaSelecionada.value = nomeCompleto;
                            widget.onTurmaSelecionada?.call(
                              turma.id,
                              nomeCompleto,
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