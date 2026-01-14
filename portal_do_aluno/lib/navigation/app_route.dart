import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/change_password.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/sucess_page.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_page.dart';
import 'package:portal_do_aluno/features/presetention/pages/splash_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/academic_calendar_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/exercicios_aluno_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/grade_entry_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/cadastrar_disciplina_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/cadastro_turma_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson_content.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/detalhes%20alunos/detalhes_do_aluno_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/exercise_assignment_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendance_registration_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/gesta_academica.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado%20institucional/gestao_de_comunicados_e_avisos.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/gestao_de_usuarios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/lista%20de%20usuarios/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula%20cadastro/matricula_cadastro.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/relatorios_e_documentos.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/relatorios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/seguranca_e_permissoes.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/features/presetention/pages/login_page.dart';

import 'package:portal_do_aluno/features/student/presentation/pages/boletim_page_aluno.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/aluno_comunicados_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/student_dashboard.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/school_class_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/teacher_communications_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/teacher_dashboard.dart';
import 'package:portal_do_aluno/shared/pages/about_app_pages.dart';
import 'package:portal_do_aluno/shared/pages/help_page.dart';
import 'package:portal_do_aluno/shared/pages/settings_page.dart';

Map<String, WidgetBuilder> get routes => {
  RouteNames.slashScreen: (context) => const SplashPage(),
  RouteNames.login: (context) => const LoginPage(),
  RouteNames.notification: (context) => const NotificationPage(),
  RouteNames.adminMatriculaCadastro: (context) => const MatriculaCadastro(),
  RouteNames.adminDashboard: (context) => const AdminDashboard(),
  RouteNames.changePassword: (context) => const ChangePassword(),
  RouteNames.sucessResetPassword: (context) =>
      const PasswordChangedSuccessPage(),

  RouteNames.adminGestao: (context) => const GestaoDeUsuarios(),
  RouteNames.adminGestaoEscolar: (context) => const GestaAcademica(),
  RouteNames.adminGeracaoDocumentos: (context) =>
      const RelatoriosDocumentosPage(),
  RouteNames.adminListaDeUsuarios: (context) => const ListaDeUsuariosPage(),
  RouteNames.adminFrequencia: (context) => const AttendanceRegistrationPage(),
  RouteNames.adminComunicacaoInstiticional: (context) =>
      const ComunicacaoInstitucionalPage(),
  RouteNames.adminDetalhesAlunos: (context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as String;
    return DetalhesAluno(alunoId: argumentos);
  },
  RouteNames.helpAppPage: (context) => const HelpPage(),
  RouteNames.aboutAppPage: (context) => const AboutAppPage(),

  RouteNames.boletim: (context) => const GradeEntryPage(),
  RouteNames.adminRelatoriosGerenciais: (context) =>
      const RelatoriosGerenciais(),
  RouteNames.adminCadastroTurmas: (context) => const CadastroTurma(),
  RouteNames.adminCadastrarDisciplina: (context) => const CadastrarDisciplina(),
  RouteNames.adminSegurancaEPermissoes: (context) =>
      const SegurancaEPermissoes(),

  RouteNames.addOqueFoiDado: (context) => const LessonContent(),

  // rotas do Aluno
  RouteNames.studentDashboard: (context) => const StudentDashboard(),

  RouteNames.studentHelp: (context) => const NoticesPage(),
  RouteNames.studentSettings: (context) => const SettingsPage(),

  RouteNames.studentCalendar: (context) => const AcademicCalendarPage(),

  RouteNames.studentComunicados: (context) => const NoticesPage(),
  RouteNames.studentBoletim: (context) => const BoletimPage(),
  RouteNames.studentExercicios: (context) => const ExerciciosAlunoPage(),
  // rotas de detalhes

  // rotas do Professor
  RouteNames.teacherDashboard: (context) => const TeacherDashboard(),

  RouteNames.teacherCalendar: (context) => const AcademicCalendarPage(),
  RouteNames.teacherClasses: (context) => SchoolClassPage(),
  RouteNames.comunicadosProfessor: (context) =>
      const TeacherCommunicationsPage(),
  RouteNames.teacherExercicios: (context) => const ExerciseAssignmentPage(),
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.gradeDetails:
      return _buidRoute(settings, const LoginPage());
  }
  return _buidRoute(settings, const LoginPage());
}

Route<dynamic> _buidRoute(RouteSettings settings, Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secundaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
