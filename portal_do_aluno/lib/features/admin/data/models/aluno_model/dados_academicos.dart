import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class DadosAcademicos {
  final String turma;
  final DateTime dataMatricula;
  final String? classId;

  DadosAcademicos({
    required this.turma,
    required this.dataMatricula,
    this.classId,
  });

  Map<String, dynamic> toJson() => {
    'turma': turma,
    'dataMatricula': Timestamp.fromDate(dataMatricula),
    'classId': classId,
  };

  factory DadosAcademicos.fromJson(Map<String, dynamic> json) =>
      DadosAcademicos(
        turma: JsonParsingHelper.requiredString(json, 'turma'),
        dataMatricula: JsonParsingHelper.requiredDate(json['dataMatricula']),
        classId: JsonParsingHelper.optionalString(json['classId']),
      );

  DadosAcademicos copyWith({
    String? numeroMatricula,
    String? turma,
    String? anoLetivo,
    String? turno,
    String? situacao,
    DateTime? dataMatricula,
    String? classId,
  }) {
    return DadosAcademicos(
      turma: turma ?? this.turma,
      dataMatricula: dataMatricula ?? this.dataMatricula,
      classId: classId ?? this.classId,
    );
  }
}