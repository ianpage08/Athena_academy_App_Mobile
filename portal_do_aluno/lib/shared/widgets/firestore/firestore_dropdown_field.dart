import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/athena_selection_modal.dart';

// Importe o seu card premium aqui (ajuste o caminho conforme seu projeto)
// import 'package:portal_do_aluno/shared/widgets/athena_modal_card.dart';

/// Dropdown Universal Premium conectado ao Firestore.
///
/// Arquitetura:
/// - Lazy Loading: A consulta ao banco só ocorre quando o modal é aberto.
/// - Design System: Herda os visuais padronizados do Athena (Cards, Sombras, Disabled State).
/// - Genérico: Consegue formatar dados de 'turma', 'aluno' ou 'disciplina' dinamicamente.
class FirestoreDropdownField extends StatefulWidget {
  final String tipo;
  final String titulo;
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final String? selecionado;
  final void Function(String id, String nome) onSelected;
  final IconData? icon;
  final Map<String, String>? camposNome;

  /// Controla se o botão pode ser clicado. Se false, assume visual de bloqueado.
  final bool habilitado;

  const FirestoreDropdownField({
    super.key,
    required this.tipo,
    required this.titulo,
    required this.stream,
    required this.selecionado,
    required this.onSelected,
    this.icon,
    this.camposNome,
    this.habilitado = true,
  });

  @override
  State<FirestoreDropdownField> createState() => _FirestoreDropdownFieldState();
}

class _FirestoreDropdownFieldState extends State<FirestoreDropdownField> {
  // Controle de estado para a animação da setinha do botão
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  // Mantém o estado local do que foi selecionado para refletir na UI instantaneamente
  String? selecionadoInterno;

  @override
  void initState() {
    super.initState();
    selecionadoInterno = widget.selecionado;
  }

  /// Sincroniza o estado interno caso a tela pai mude o valor selecionado
  @override
  void didUpdateWidget(covariant FirestoreDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selecionado != oldWidget.selecionado) {
      selecionadoInterno = widget.selecionado;
    }
  }

  @override
  void dispose() {
    _aberto.dispose();
    super.dispose();
  }

  /// Helper inteligente para capitalizar nomes ignorando preposições
  String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto
        .trim()
        .split(' ')
        .map((p) {
          if (p.isEmpty) return p;
          if (['de', 'da', 'do', 'das', 'dos'].contains(p.toLowerCase())) {
            return p.toLowerCase();
          }
          return p[0].toUpperCase() + p.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Tratamento do Estado Desabilitado ---
    // Se não estiver habilitado, mostramos a UI fantasma igual ao DisabledButton
    if (!widget.habilitado) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? theme.cardColor.withValues(alpha: 0.3)
              : theme.disabledColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? theme.dividerColor.withValues(alpha: 0.1)
                : theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    widget.icon ?? CupertinoIcons.square_list,
                    color: theme.hintColor.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selecionadoInterno ?? widget.titulo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.hintColor.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Ícone de cadeado para UX clara de bloqueio
            Icon(
              CupertinoIcons.lock_fill,
              color: theme.hintColor.withValues(alpha: 0.5),
              size: 18,
            ),
          ],
        ),
      );
    }

    // --- Estado Ativo (Botão Padrão) ---
    // Repare que o StreamBuilder sumiu daqui! O botão agora é super leve.
    return GestureDetector(
      onTap: () => _abrirModalUniversal(context),
      child: ValueListenableBuilder<bool>(
        valueListenable: _aberto,
        builder: (context, isAberto, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(
                  alpha: isAberto ? 0.8 : 0.3,
                ),
                width: isAberto ? 1.5 : 1.0,
              ),
              boxShadow: const [
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
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        widget.icon ?? CupertinoIcons.square_list,
                        size: 22,
                        color: theme.iconTheme.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selecionadoInterno ?? widget.titulo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selecionadoInterno != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selecionadoInterno != null
                                ? theme.textTheme.bodyLarge?.color
                                : theme.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
  }

  /// Método que carrega os dados do Firebase (Lazy Loading) e exibe o modal
  Future<void> _abrirModalUniversal(BuildContext context) async {
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

              // --- Título Dinâmico ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Selecionar ${_capitalizar(widget.tipo)}",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- Stream do Firebase: Rodando apenas quando o modal está aberto! ---
              Flexible(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: widget.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CupertinoActivityIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            "Nenhum(a) ${widget.tipo} encontrado(a).",
                          ),
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final doc = docs[i];
                        final data = doc.data();
                        String nomeFormatado = "Sem nome";
                        final id = doc.id;

                        // Parser dinâmico baseado no tipo
                        switch (widget.tipo.toLowerCase()) {
                          case 'turma':
                            final serie = data['serie'] ?? '';
                            final turno = data['turno'] ?? '';
                            nomeFormatado = "$serie - $turno";
                            break;

                          case 'aluno':
                            if (widget.camposNome != null &&
                                widget.camposNome!.isNotEmpty) {
                              final rootKey = widget.camposNome!.keys.first;
                              final childKey = widget.camposNome!.values.first;
                              final rawName =
                                  data[rootKey]?[childKey] ?? "Aluno sem nome";
                              nomeFormatado = _capitalizar(rawName);
                            } else {
                              nomeFormatado = _capitalizar(
                                data['nome'] ?? 'Aluno sem nome',
                              );
                            }
                            break;

                          case 'disciplina':
                            nomeFormatado = _capitalizar(
                              data['nome'] ??
                                  data['titulo'] ??
                                  "Disciplina sem nome",
                            );
                            break;

                          default:
                            nomeFormatado = _capitalizar(
                              data['nome'] ?? "Item sem nome",
                            );
                        }

                        final isSelected = nomeFormatado == selecionadoInterno;

                        // 👉 Integrado com nosso componente de Design System
                        return AthenaModalCard(
                          label: nomeFormatado,
                          icon: widget.icon ?? CupertinoIcons.list_bullet,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => selecionadoInterno = nomeFormatado);
                            widget.onSelected(id, nomeFormatado);
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
