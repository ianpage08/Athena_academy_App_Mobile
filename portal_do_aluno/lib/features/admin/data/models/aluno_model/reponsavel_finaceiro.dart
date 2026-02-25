import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

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
      nome: JsonParsingHelper.requiredString(json, 'nome'),
      cpf: JsonParsingHelper.requiredString(json, 'cpf'),
      telefone: JsonParsingHelper.requiredString(json, 'telefone'),
    );
  }
}
