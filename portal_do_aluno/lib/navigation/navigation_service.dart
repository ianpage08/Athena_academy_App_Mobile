import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigatorService {
  // Usuário logado (opcional)
  static Usuario? _currentUser;

  static BuildContext? get context => navigatorKey.currentContext;

  static void setCurrentUser(Usuario user) {
    _currentUser = user;
  }

  static Usuario? get currentUser => _currentUser;

  static void clearUser() {
    _currentUser = null;
  }

  // ---------- Acesso ao router ----------

  // Importado via app_router.dart para evitar dependência circular
  static GoRouter? _router;

  static void setRouter(GoRouter router) {
    _router = router;
  }

  static GoRouter get _go {
    assert(_router != null, 'NavigatorService: chame setRouter() antes de navegar.');
    return _router!;
  }

  // ---------- Util helpers ----------

  static bool get isNavigatorReady => navigatorKey.currentState != null;

  /// Tenta esperar o navigator por até [timeout] antes de prosseguir.
  static Future<bool> ensureInitializedBeforeNavigation({
    Duration timeout = const Duration(seconds: 3),
    Duration pollInterval = const Duration(milliseconds: 50),
  }) async {
    final completer = Completer<bool>();
    final stopwatch = Stopwatch()..start();

    Timer.periodic(pollInterval, (t) {
      if (isNavigatorReady) {
        t.cancel();
        completer.complete(true);
      } else if (stopwatch.elapsed > timeout) {
        t.cancel();
        completer.complete(false);
      }
    });

    return completer.future;
  }

  // ---------- Navegação ----------

  /// Push de uma nova rota (empilha sobre a atual).
  static void navigateTo(String routePath) {
    _go.push(routePath);
  }

  /// Substitui a rota atual (sem empilhar).
  static void navigateReplaceWith(String routePath) {
    _go.pushReplacement(routePath);
  }

  /// Navega e limpa toda a pilha (equivalente a pushNamedAndRemoveUntil).
  static void navigateAndRemoveUntil(String routePath) {
    _go.go(routePath);
  }

  /// Volta para a tela anterior.
  static void goBack<T extends Object?>([T? result]) {
    if (_go.canPop()) {
      _go.pop(result);
    } else {
      debugPrint('goBack: não era possível dar pop, canPop == false');
    }
  }

  static bool canGoBack() => _go.canPop();

  // ---------- Snackbar ----------

  static void showSnackBar(String message) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('showSnackBar: context nulo -> $message');
      return;
    }
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ---------- Rotas específicas ----------

  static void navigateToDashboard([Usuario? user]) {
    final userToUse = user ?? _currentUser;

    if (userToUse == null) {
      navigateAndRemoveUntil(RouteNames.login);
      return;
    }

    final String route;
    switch (userToUse.type) {
      case UserType.student:
        route = RouteNames.studentDashboard;
        break;
      case UserType.teacher:
        route = RouteNames.teacherDashboard;
        break;
      case UserType.parent:
        route = RouteNames.parentDashboard;
        break;
      case UserType.admin:
        route = RouteNames.adminDashboard;
        break;
    }

    navigateAndRemoveUntil(route);
  }

  static void logout() {
    clearUser();
    navigateAndRemoveUntil(RouteNames.login);
  }

  // Rotas de erro
  static void navigateToNotFound() => navigateTo(RouteNames.notFound);

  static void navigateToInternalServerError() =>
      navigateTo(RouteNames.internalServerError);

  static void navigateToError(String errorMessage) =>
      navigateTo(RouteNames.error);
}
