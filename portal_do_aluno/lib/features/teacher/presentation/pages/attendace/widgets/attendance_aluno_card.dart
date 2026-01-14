import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_status_chip.dart';


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

  Color get corStatus {
    switch (status) {
      case Presenca.presente:
        return const Color(0xFF2ECC71);
      case Presenca.falta:
        return const Color(0xFFE53935);
      case Presenca.justificativa:
        return const Color(0xFF3498DB);
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 95,
            decoration: BoxDecoration(
              color: corStatus,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AttendanceStatusChip(
                        text: 'Presente',
                        selected: status == Presenca.presente,
                        color: const Color(0xFF2ECC71),
                        icon: Icons.check_circle,
                        onTap: () => onSelect(Presenca.presente),
                      ),
                      AttendanceStatusChip(
                        text: 'Falta',
                        selected: status == Presenca.falta,
                        color: const Color(0xFFE53935),
                        icon: Icons.close,
                        onTap: () => onSelect(Presenca.falta),
                      ),
                      AttendanceStatusChip(
                        text: 'Justificar',
                        selected: status == Presenca.justificativa,
                        color: const Color(0xFF3498DB),
                        icon: Icons.note_alt_outlined,
                        onTap: () => onSelect(Presenca.justificativa),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
