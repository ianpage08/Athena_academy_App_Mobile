import 'package:cloud_firestore/cloud_firestore.dart';

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
        turma: json['turma'] as String? ?? '',
        dataMatricula: json['dataMatricula'] is Timestamp
            ? (json['dataMatricula'] as Timestamp).toDate()
            : DateTime.now(),
        classId: json['classId'] as String? ?? '',
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