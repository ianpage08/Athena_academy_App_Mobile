class ResponsavelFinanceiro {
  final String nome;
  final String cpf;
  final String telefone;

  ResponsavelFinanceiro({
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'cpf': cpf,
    'telefone': telefone,
  };

  factory ResponsavelFinanceiro.fromJson(Map<String, dynamic> json) {
    return ResponsavelFinanceiro(
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
    );
  }
}