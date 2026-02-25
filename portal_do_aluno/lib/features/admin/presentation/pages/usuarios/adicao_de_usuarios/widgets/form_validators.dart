class FormValidators {
  /// -------------------------
  /// VALIDADOR DE SENHA
  /// -------------------------
  static String? senha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }
    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Inclua ao menos 1 letra maiúscula';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Inclua ao menos 1 letra minúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Inclua ao menos 1 número';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Inclua ao menos 1 símbolo especial';
    }
    return null;
  }

  /// -------------------------
  /// CONFIRMAR SENHA
  /// -------------------------
  static String? confirmarSenha(String? value, String senhaOriginal) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    }
    if (value != senhaOriginal) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  /// -------------------------
  /// CPF OBRIGATÓRIO
  /// -------------------------
  static String? cpfObrigatorio(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
      return 'CPF inválido';
    }
    return null;
  }

  /// -------------------------
  /// NOME OBRIGATÓRIO
  /// -------------------------
  static String? nome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Nome muito curto';
    }
    return null;
  }
}
