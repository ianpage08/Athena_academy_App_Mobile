import 'package:portal_do_aluno/core/environment/app_evironment_type.dart';

import 'app_config.dart';

class AppConfigs {
  static const dev = AppConfig(
    environment: AppEnvironmentType.development,
    appName: 'Portal do Aluno (DEV)',
    enableTestUsers: true,
    enableLogs: true,
  );

  static const prod = AppConfig(
    environment: AppEnvironmentType.production,
    appName: 'Portal do Aluno',
    enableTestUsers: false,
    enableLogs: false,
  );
}
