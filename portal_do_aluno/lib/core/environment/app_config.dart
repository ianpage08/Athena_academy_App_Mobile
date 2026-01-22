import 'package:portal_do_aluno/core/environment/app_evironment_type.dart';

/// configurar ainda no projeto

class AppConfig {
  final AppEnvironmentType environment;
  final String appName;
  final bool enableTestUsers;
  final bool enableLogs;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.enableTestUsers,
    required this.enableLogs,
  });

  bool get isDev => environment == AppEnvironmentType.development;
  bool get isProd => environment == AppEnvironmentType.production;
}
