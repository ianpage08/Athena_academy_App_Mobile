import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_poup.dart';
import 'package:portal_do_aluno/navigation/navigation_service.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/app_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/services/secure_auth_storage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backGround;
  final String? userId;
  final String? nameRoute;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backGround,
    this.userId,
    this.nameRoute,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      // Limpa storage
      await SecureAuthStorage().deleteToken();
      await SecureAuthStorage().deleteUser();
      // Navega limpando stack
      await NavigatorService.navigateAndRemoveUntil(RouteNames.login);
    }

    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: true,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      actions: [
        NotificationPoup(
          userId: userId,
          route: nameRoute ?? RouteNames.comunicadosProfessor,
        ),
        IconButton(
          onPressed: () async {
            final sair = await showAppConfirmationDialog(
              context: context,
              title: 'Deseja Sair?',
              content: 'voce realmente deseja sair?',
              confirmText: 'Sair',
            );
            if (sair == true) {
              await SecureAuthStorage().deleteToken();
              debugPrint('Token deletado');
              await SecureAuthStorage().deleteUser();
              debugPrint('Usuario deletado');
              logout();
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
