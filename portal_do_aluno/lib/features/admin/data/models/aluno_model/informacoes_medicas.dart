import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class InformacoesMedicasAluno {
  final String? alergia;
  final String? medicacao;
  final String? observacoes;
  final String? numeroEmergencia;

  InformacoesMedicasAluno({this.alergia, this.medicacao, this.observacoes, this.numeroEmergencia});

  Map<String, dynamic> toJson() => {
    'alergia': alergia,
    'medicacao': medicacao,
    'observacoes': observacoes,
    'numeroEmergencia': numeroEmergencia,
  };

  factory InformacoesMedicasAluno.fromJson(Map<String, dynamic> json) =>
      InformacoesMedicasAluno(
        alergia: JsonParsingHelper.optionalString(json['alergia']),
        medicacao: JsonParsingHelper.optionalString(json['medicacao']),
        observacoes: JsonParsingHelper.optionalString(json['observacoes']),
        numeroEmergencia: JsonParsingHelper.optionalString(json['numeroEmergencia']),
      );

  InformacoesMedicasAluno copyWith({
    String? alergia,
    String? medicacao,
    String? observacoes,
    String? numeroEmergencia,
  }) {
    return InformacoesMedicasAluno(
      alergia: alergia ?? this.alergia,
      medicacao: medicacao ?? this.medicacao,
      observacoes: observacoes ?? this.observacoes,
      numeroEmergencia: numeroEmergencia ?? this.numeroEmergencia,
    );
  }
}