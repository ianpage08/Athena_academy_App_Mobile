// CPF formatado
  String formatarCpf(String cpf) {
    return cpf.replaceAllMapped(
      RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
      (m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}",
    );
  }