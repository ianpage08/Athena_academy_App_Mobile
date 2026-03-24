import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart'; // Importando suas cores
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_status_chip.dart';

/// Card premium responsável por exibir um aluno na lista de chamada.
///
/// Apresenta uma experiência visual rica com avatar, nome destacado
/// e seleção rápida de status com feedback tátil e visual.
class AttendanceAlunoCard extends StatelessWidget {
  final String nome;
  final Presenca? status;
  final ValueChanged<Presenca> onSelect;

  const AttendanceAlunoCard({
    super.key,
    required this.nome,
    required this.status,
    required this.onSelect,
  });

  // --- Helpers Visuais ---

  /// Retorna a cor semântica do status, ajustada para a paleta elegante do app.
  Color _getCorStatus(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case Presenca.presente:
        // Usando o AppColors.darkSuccess que você definiu, ou uma variação suave
        return isDark ? const Color(0xFF4ADE80) : AppColors.lightSuccess;
      case Presenca.falta:
        return isDark ? AppColors.darkError : AppColors.lightError;
      case Presenca.justificativa:
        // Um azul info que combine com o roxo
        return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2196F3);
      default:
        // Cinza sutil para não definido
        return isDark ? AppColors.darkBorder : Colors.grey.shade300;
    }
  }

  /// Gera as iniciais do nome para o avatar (Ex: "Kraher Silva" -> "KS")
  String _getIniciais(String nomeCompleto) {
    if (nomeCompleto.isEmpty) return "?";
    final nomes = nomeCompleto.trim().split(' ');
    if (nomes.length <= 1) return nomes.first[0].toUpperCase();
    return (nomes.first[0] + nomes.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final corStatusAtiva = _getCorStatus(context);
    final temStatus = status != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      // Pequeno feedback visual no card inteiro se selecionado
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (temStatus && theme.brightness == Brightness.light)
            BoxShadow(
              color: corStatusAtiva.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Card(
        // Usando o cardColor do seu tema (AppColors.darkCard)
        color: theme.cardColor,
        elevation: temStatus ? 2 : 0, // Destaca levemente se já foi chamado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // Borda sutil para dar definição no modo escuro
          side: BorderSide(
            color: temStatus
                ? corStatusAtiva.withValues(alpha: 0.5)
                : theme.dividerColor.withValues(alpha: 0.1),
            width: temStatus ? 1.5 : 1,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // --- Barra Lateral de Status (Versão Moderna "Pill") ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 6, // Mais fina e elegante
                  margin: const EdgeInsets.only(
                    left: 12,
                  ), // Não colada na borda
                  decoration: BoxDecoration(
                    color: corStatusAtiva,
                    // Totalmente arredondada estilo pílula
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              // --- Conteúdo Principal ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Avatar + Nome
                      Row(
                        children: [
                          // Avatar com Iniciais (Melhoria de UX/Estética)
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: temStatus
                                ? corStatusAtiva.withValues(alpha: 0.15)
                                : theme.brightness == Brightness.dark
                                ? AppColors.darkInputFill
                                : AppColors.lightInputFill,
                            child: Text(
                              _getIniciais(nome),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: temStatus
                                    ? corStatusAtiva
                                    : theme.textTheme.titleMedium?.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Nome do Aluno Destacado
                          Expanded(
                            child: Text(
                              nome,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                // Cor principal do seu tema
                                color: AppColors.darkBackground,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Divider(
                        height: 1,
                        color: theme.dividerColor.withValues(alpha: 0.05),
                      ),
                      const SizedBox(height: 16),

                      // --- Área de Ações (Chips) ---
                      // Usando Wrap para garantir que não quebre em telas menores
                      Wrap(
                        spacing: 8, // Espaço horizontal entre chips
                        runSpacing: 8, // Espaço vertical se quebrar linha
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          // Nota: Para o 'Expanded' funcionar dentro do Wrap,
                          // seu AttendanceStatusChip precisa lidar bem com largura.
                          // Se ele for fixo, remova o FractionallySizedBox.
                          _buildChipAction(
                            context,
                            text: 'Presente',
                            presenca: Presenca.presente,
                            icon: Icons.check_circle_rounded,
                          ),
                          _buildChipAction(
                            context,
                            text: 'Falta',
                            presenca: Presenca.falta,
                            icon:
                                Icons.unpublished_rounded, // Ícone mais moderno
                          ),
                          _buildChipAction(
                            context,
                            text: 'Justificar',
                            presenca: Presenca.justificativa,
                            icon: Icons.edit_note_rounded,
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
      ),
    );
  }

  /// Helper para construir os chips de ação de forma padronizada.
  Widget _buildChipAction(
    BuildContext context, {
    required String text,
    required Presenca presenca,
    required IconData icon,
  }) {
    final isSelected = status == presenca;
    // Pega a cor semântica baseada apenas no tipo de presença deste chip
    final Color colorBase = _getCorInfo(context, presenca);

    return AttendanceStatusChip(
      text: text,
      selected: isSelected,
      // Passa a cor semântica (Verde, Vermelho, Azul)
      color: colorBase,
      icon: icon,
      onTap: () => onSelect(presenca),
    );
  }

  // Helper interno para pegar a cor do chip independente do status atual do card
  Color _getCorInfo(BuildContext context, Presenca p) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (p) {
      case Presenca.presente:
        return isDark ? const Color(0xFF4ADE80) : AppColors.lightSuccess;
      case Presenca.falta:
        return isDark ? AppColors.darkError : AppColors.lightError;
      case Presenca.justificativa:
        return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2196F3);
    }
  }
}
