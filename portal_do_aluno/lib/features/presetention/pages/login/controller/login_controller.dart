import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/auth_service_datasource.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/shared/helpers/single_execution_flag.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final obscurePassword = ValueNotifier<bool>(true);

  final SingleExecutionFlag _navigationFlag = SingleExecutionFlag();

  Future<void> login({
    required VoidCallback onInvalid,
    required VoidCallback onError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    _navigationFlag.execute(() async {
      try {
        final cpf = cpfController.text.trim();
        final senha = passwordController.text.trim();

        final usuario = await AuthServico().loginCpfsenha(cpf, senha);

        NavigatorService.setCurrentUser(usuario);
        await NavigatorService.navigateToDashboard();
      } catch (_) {
        onError();
        _navigationFlag.reset();
      } finally {
        isLoading.value = false;
      }
    });
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void fillTestUser(String cpf, String senha) {
    cpfController.text = cpf;
    passwordController.text = senha;
  }

  void dispose() {
    cpfController.dispose();
    passwordController.dispose();
    isLoading.dispose();
    obscurePassword.dispose();
  }
}
