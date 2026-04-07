import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/change_password.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/comunicado_institucional/gestao_de_comunicados_e_avisos.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/detalhes_alunos/detalhes_do_aluno_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/disciplinas/cadastro_disciplina/cadastrar_disciplina_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/turma/cadastro_turmas/cadastro_turma_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/matricula/matricula_cadastro/matricula_cadastro.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/gesta_academica.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/gestao_de_usuarios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/navigation_bottom/relatorios_e_documentos.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/relatorios_e_documentos/relatorios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/report_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/seguranca_e_permissoes.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/sucess_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/usuarios/lista_de_usuarios/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/features/presentation/pages/login/login_page.dart';
import 'package:portal_do_aluno/features/presentation/pages/splash_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/academic_calendar_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/aluno_comunicados_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/boletim_page_aluno.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/exercicios/exercicios_aluno_page.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/student_dashboard.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/attendance_registration_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/grade/grade_entry_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/lesson/lesson_content.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/report/report_teacher.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/send_exercise/exercise_assignment_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/teacher_communications_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/teacher_dashboard.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/view_exercises/pages/exercise_submission_page.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/view_exercises/pages/submission_detail.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/pages/about_app_pages.dart';
import 'package:portal_do_aluno/shared/pages/help_page.dart';
import 'package:portal_do_aluno/shared/pages/settings_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteNames.slashScreen,
  routes: [
    GoRoute(
      path: RouteNames.slashScreen,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.notification,
      builder: (context, state) => const NotificationPage(),
    ),

    // Admin
    GoRoute(
      path: RouteNames.adminDashboard,
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: RouteNames.adminMatriculaCadastro,
      builder: (context, state) => const MatriculaCadastro(),
    ),
    GoRoute(
      path: RouteNames.changePassword,
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: RouteNames.sucessResetPassword,
      builder: (context, state) => const PasswordChangedSuccessPage(),
    ),
    GoRoute(
      path: RouteNames.adminGestao,
      builder: (context, state) => const GestaoDeUsuarios(),
    ),
    GoRoute(
      path: RouteNames.adminGestaoEscolar,
      builder: (context, state) => const GestaAcademica(),
    ),
    GoRoute(
      path: RouteNames.adminGeracaoDocumentos,
      builder: (context, state) => const RelatoriosDocumentosPage(),
    ),
    GoRoute(
      path: RouteNames.adminListaDeUsuarios,
      builder: (context, state) => const ListaDeUsuariosPage(),
    ),
    GoRoute(
      path: RouteNames.adminFrequencia,
      builder: (context, state) => const AttendanceRegistrationPage(),
    ),
    GoRoute(
      path: RouteNames.adminComunicacaoInstiticional,
      builder: (context, state) => const ComunicacaoInstitucionalPage(),
    ),
    GoRoute(
      path: '${RouteNames.adminDetalhesAlunos}/:alunoId',
      builder: (context, state) {
        final alunoId = state.pathParameters['alunoId']!;
        return DetalhesAluno(alunoId: alunoId);
      },
    ),
    GoRoute(
      path: RouteNames.adminRelatoriosGerenciais,
      builder: (context, state) => const RelatoriosGerenciais(),
    ),
    GoRoute(
      path: RouteNames.adminCadastroTurmas,
      builder: (context, state) => const CadastroTurma(),
    ),
    GoRoute(
      path: RouteNames.adminCadastrarDisciplina,
      builder: (context, state) => const CadastrarDisciplina(),
    ),
    GoRoute(
      path: RouteNames.adminSegurancaEPermissoes,
      builder: (context, state) => const SegurancaEPermissoes(),
    ),
    GoRoute(
      path: RouteNames.adminReport,
      builder: (context, state) => const ReportPage(),
    ),

    // Shared
    GoRoute(
      path: RouteNames.helpAppPage,
      builder: (context, state) => const HelpPage(),
    ),
    GoRoute(
      path: RouteNames.aboutAppPage,
      builder: (context, state) => const AboutAppPage(),
    ),
    GoRoute(
      path: RouteNames.boletim,
      builder: (context, state) => const GradeEntryPage(),
    ),
    GoRoute(
      path: RouteNames.addOqueFoiDado,
      builder: (context, state) => const LessonContent(),
    ),

    // Aluno
    GoRoute(
      path: RouteNames.studentDashboard,
      builder: (context, state) => const StudentDashboard(),
    ),
    GoRoute(
      path: RouteNames.studentHelp,
      builder: (context, state) => const NoticesPage(),
    ),
    GoRoute(
      path: RouteNames.studentSettings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: RouteNames.studentCalendar,
      builder: (context, state) => const AcademicCalendarPage(),
    ),
    GoRoute(
      path: RouteNames.studentComunicados,
      builder: (context, state) => const NoticesPage(),
    ),
    GoRoute(
      path: RouteNames.studentBoletim,
      builder: (context, state) => const BoletimPage(),
    ),
    GoRoute(
      path: RouteNames.studentExercicios,
      builder: (context, state) => const ExerciciosAlunoPage(),
    ),

    // Professor
    GoRoute(
      path: RouteNames.teacherDashboard,
      builder: (context, state) => const TeacherDashboard(),
    ),
    GoRoute(
      path: RouteNames.teacherCalendar,
      builder: (context, state) => const AcademicCalendarPage(),
    ),
    GoRoute(
      path: RouteNames.teacherReport,
      builder: (context, state) => const ReportTeacher(),
    ),
    GoRoute(
      path: RouteNames.comunicadosProfessor,
      builder: (context, state) => const TeacherCommunicationsPage(),
    ),
    GoRoute(
      path: RouteNames.teacherExercicios,
      builder: (context, state) => const ExerciseAssignmentPage(),
    ),
    GoRoute(
      path: RouteNames.teacherSubmission,
      builder: (context, state) => const ExerciseSubmissionPage(),
    ),
    GoRoute(
      path: '${RouteNames.teacherSubimissionDetail}/:exerciseId',
      builder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId']!;
        return SubmissionDetail(exerciseId: exerciseId);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Página não encontrada: ${state.uri}')),
  ),
);
