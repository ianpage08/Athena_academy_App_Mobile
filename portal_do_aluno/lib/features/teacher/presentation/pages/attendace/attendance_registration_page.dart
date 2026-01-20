import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/controller/attedance_controller.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_aluno_list.dart';
import 'package:portal_do_aluno/shared/services/snackbar/controller_snack.dart';
import 'package:portal_do_aluno/shared/widgets/select_class_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_date_picker_field.dart';
import 'package:portal_do_aluno/shared/widgets/save_button.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class AttendanceRegistrationPage extends StatefulWidget {
  const AttendanceRegistrationPage({super.key});

  @override
  State<AttendanceRegistrationPage> createState() =>
      _AttendanceRegistrationPageState();
}

class _AttendanceRegistrationPageState
    extends State<AttendanceRegistrationPage> {
  final controller = AttendanceRegistrationController();
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier(null);
  late final VoidCallback _submitCurrente;

  @override
  void dispose() {
    _submitCurrente();

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _submitCurrente = SubmitStateListener.attach(
        context: context,
        state: controller.state,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Registro de Presença'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SaveButton(
          salvarconteudo: () async {
            controller.salvar(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Turma'),
            SelectClassButton(
              turmaSelecionada: turmaSelecionada,
              onTurmaSelecionada: (id, nome) {
                controller.turmaId = id;
                turmaSelecionada.value = nome;
                debugPrint(controller.turmaId);
              },
            ),
            const SizedBox(height: 16),
            const Text('Data'),
            CustomDatePickerField(
              onDate: (data) => controller.dataSelecionada = data,
            ),
            const SizedBox(height: 20),
            if (controller.turmaId != null)
              AttendanceStudentList(
                stream: controller.alunosPorTurma(controller.turmaId!),
              )
            else
              const Text('Selecione uma turma acima'),
          ],
        ),
      ),
    );
  }
}
