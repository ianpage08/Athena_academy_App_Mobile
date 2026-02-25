import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class ClasseDeAula {
  final String id;
  final String serie;
  final String turno;
  final int qtdAlunos;
  final String professorTitular;

  ClasseDeAula({
    required this.id,
    required this.serie,
    required this.turno,
    required this.qtdAlunos,
    required this.professorTitular,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'serie': serie,
    'turno': turno,
    'qtdAlunos': qtdAlunos,
    'professorTitular': professorTitular,
  };

  factory ClasseDeAula.fromJson(Map<String, dynamic> json) => ClasseDeAula(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    serie: JsonParsingHelper.requiredString(json, 'serie'),
    turno: JsonParsingHelper.requiredString(json, 'turno'),
    qtdAlunos: JsonParsingHelper.requiredInt(json, 'qtdAlunos'),
    professorTitular: JsonParsingHelper.requiredString(json, 'professorTitular')
  );

  ClasseDeAula copyWith({
    String? id,
    String? serie,
    String? turno,
    int? qtdAlunos,
    String? professorTitular,
  }) {
    return ClasseDeAula(
      id: id ?? this.id,
      serie: serie ?? this.serie,
      turno: turno ?? this.turno,
      qtdAlunos: qtdAlunos ?? this.qtdAlunos,
      professorTitular: professorTitular ?? this.professorTitular,
    );
  }
}
