import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

/// Campo de seleção de data premium para o Athena Academy.
///
/// Arquitetura e UX:
/// - Sincronização de estado (`didUpdateWidget`) para suportar ações de "Limpar".
/// - Formatação inteligente de data (Adiciona '0' à esquerda para dias e meses de um dígito).
/// - Integração 100% fiel ao Design System (Bordas ativas, Sombras e Transparências).
class CustomDatePickerField extends StatefulWidget {
  final DateTime? isSelecionada;
  final Function(DateTime? data) onDate;

  const CustomDatePickerField({
    super.key,
    this.isSelecionada,
    required this.onDate,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  DateTime? dataSelecionada;
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    dataSelecionada = widget.isSelecionada;
  }

  // 👉 MUDANÇA 1: Sincronização de Estado (Bugfix Crítico)
  // Sem isso, se a tela pai passar "isSelecionada: null" (ex: ao Limpar Form),
  // este componente continuaria mostrando a data antiga na tela.
  @override
  void didUpdateWidget(covariant CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelecionada != oldWidget.isSelecionada) {
      dataSelecionada = widget.isSelecionada;
    }
  }

  @override
  void dispose() {
    _aberto.dispose();
    super.dispose();
  }

  // 👉 MUDANÇA 2: Helper de Formatação de Data (UX de Leitura)
  // Garante que dia 5 do mês 3 vire "05/03/2026" em vez de "5/3/2026"
  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = AppColors.lightButtonPrimary;

    return ValueListenableBuilder<bool>(
      valueListenable: _aberto,
      builder: (context, aberto, _) {
        return GestureDetector(
          onTap: () async {
            // Anima a setinha para cima indicando interação
            _aberto.value = true;

            final DateTime? data = await showDatePicker(
              context: context,
              initialDate: dataSelecionada ?? DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(2030),
              // 👉 Melhoria visual: Podemos forçar o tema do DatePicker se necessário no futuro
            );

            if (data != null) {
              // Normalização de Fuso Horário (Excelente prática sua, mantida!)
              final dataNormalizada = DateTime(
                data.year,
                data.month,
                data.day,
                12, // Evita bugs de DayLight Saving Time (Horário de verão)
              );

              setState(() => dataSelecionada = dataNormalizada);
              widget.onDate(dataNormalizada);
            }

            // Anima a setinha de volta
            _aberto.value = false;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            // 👉 MUDANÇA 3: Padding ajustado para o padrão do Design System (16 vertical)
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // 👉 MUDANÇA 4: Borda dinâmica (acende quando o picker é aberto)
                color: primaryColor.withValues(alpha: aberto ? 0.8 : 0.3),
                width: aberto ? 1.5 : 1.0,
              ),
              // 👉 MUDANÇA 5: Sombra sutil premium para separar do fundo
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
                  // 👉 MUDANÇA 6: Proteção contra quebra de tela
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 22,
                        // Ícone acende se houver data selecionada
                        color: dataSelecionada != null
                            ? primaryColor
                            : theme.iconTheme.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          dataSelecionada != null
                              ? _formatarData(dataSelecionada!)
                              : 'Selecionar Data',
                          style: TextStyle(
                            fontSize: 16, // Padronizado com os Dropdowns
                            // 👉 MUDANÇA 7: Negrito sutil e cor semântica baseada na seleção
                            fontWeight: dataSelecionada != null
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: dataSelecionada != null
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

                // Ícone com animação (Setinha de "Dropdown" para consistência visual)
                AnimatedRotation(
                  turns: aberto ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic, // Curva de animação mais suave
                  child: const Icon(CupertinoIcons.chevron_down, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
