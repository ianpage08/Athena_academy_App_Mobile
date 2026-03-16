import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_status_chip.dart';

/// Card responsável por exibir um aluno na lista de chamada.
///
/// O componente mostra:
/// - Nome do aluno
/// - Status atual de presença
/// - Chips interativos para selecionar o status (Presente, Falta, Justificado)
///
/// Também possui uma barra lateral colorida que muda dinamicamente
/// conforme o status selecionado, facilitando a visualização rápida
/// do professor durante a chamada.
class AttendanceAlunoCard extends StatelessWidget {
  /// Nome do aluno exibido no card
  final String nome;

  /// Status atual de presença do aluno
  /// Pode ser:
  /// - presente
  /// - falta
  /// - justificativa
  /// - null (ainda não marcado)
  final Presenca? status;

  /// Callback executado quando o professor seleciona um novo status
  final ValueChanged<Presenca> onSelect;

  const AttendanceAlunoCard({
    super.key,
    required this.nome,
    required this.status,
    required this.onSelect,
  });

  /// Retorna a cor que será exibida na barra lateral do card
  /// de acordo com o status atual da presença.
  ///
  /// Isso cria um feedback visual rápido para o professor.
  Color get corStatus {
    switch (status) {
      case Presenca.presente:
        return const Color(0xFF2ECC71); // verde
      case Presenca.falta:
        return const Color(0xFFE53935); // vermelho
      case Presenca.justificativa:
        return const Color(0xFF3498DB); // azul
      default:
        return Colors.grey.shade300; // status ainda não definido
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      /// Anima suavemente mudanças visuais (principalmente a cor lateral)
      duration: const Duration(milliseconds: 200),

      /// Espaçamento entre os cards da lista
      margin: const EdgeInsets.only(bottom: 14),

      /// Estilização visual do card
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),

      /// Estrutura horizontal principal do card
      child: IntrinsicHeight(
        child: Row(
          children: [
            /// Barra lateral que indica o status da presença
            Container(
              width: 10,

              decoration: BoxDecoration(
                color: corStatus,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),

            /// Área principal do conteúdo
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),

                /// Estrutura vertical com nome + ações
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Nome do aluno
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// Espaçamento entre nome e os botões
                    const SizedBox(height: 12),

                    /// Linha com os botões de seleção de presença
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,

                      children: [
                        Expanded(
                          child: AttendanceStatusChip(
                            text: 'Presente',
                            selected: status == Presenca.presente,
                            color: const Color(0xFF2ECC71),
                            icon: Icons.check_circle,
                            onTap: () => onSelect(Presenca.presente),
                          ),
                        ),
                        const SizedBox(width: 8),

                        /// Chip para marcar falta
                        Expanded(
                          child: AttendanceStatusChip(
                            text: 'Falta',
                            selected: status == Presenca.falta,
                            color: const Color(0xFFE53935),
                            icon: Icons.close,
                            onTap: () => onSelect(Presenca.falta),
                          ),
                        ),
                        const SizedBox(width: 8),

                        /// Chip para justificar falta
                        Expanded(
                          child: AttendanceStatusChip(
                            text: 'Justificar',
                            selected: status == Presenca.justificativa,
                            color: const Color(0xFF3498DB),
                            icon: Icons.note_alt_outlined,
                            onTap: () => onSelect(Presenca.justificativa),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
