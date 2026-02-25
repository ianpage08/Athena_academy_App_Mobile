import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class EnderecoAluno {
  final String cep;
  final String rua;
  final String cidade;
  final String estado;
  final String bairro;
  final String numero;

  EnderecoAluno({
    required this.cep,
    required this.rua,
    required this.cidade,
    required this.estado,
    required this.bairro,
    required this.numero,
  });

  Map<String, dynamic> toJson() => {
    'cep': cep,
    'rua': rua,
    'cidade': cidade,
    'estado': estado,
    'bairro': bairro,
    'numero': numero,
  };

  factory EnderecoAluno.fromJson(Map<String, dynamic> json) => EnderecoAluno(
    cep: JsonParsingHelper.optionalString(json['cep']) ?? '',
    rua: JsonParsingHelper.optionalString(json['rua']) ?? '',
    cidade: JsonParsingHelper.optionalString(json['cidade']) ?? '',
    estado: JsonParsingHelper.optionalString(json['estado']) ?? '',
    bairro: JsonParsingHelper.optionalString(json['bairro']) ?? '',
    numero: JsonParsingHelper.optionalString(json['numero']) ?? '',
  );

  EnderecoAluno copyWith({
    String? cep,
    String? rua,
    String? cidade,
    String? estado,
    String? bairro,
    String? numero,
  }) {
    return EnderecoAluno(
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      bairro: bairro ?? this.bairro,
      numero: numero ?? this.numero,
    );
  }
}
