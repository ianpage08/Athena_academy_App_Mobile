
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

enum Presenca { presente, falta, justificativa }

class ClassAttendance {
  final String id;
  final String alunoId;
  final String classId;
  final DateTime data;
  final Presenca presenca;

  ClassAttendance({
    required this.id,
    required this.alunoId,
    required this.classId,
    required this.data,
    required this.presenca,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'classId': classId,
    'data': data,
    'presenca': presenca.name,
  };
  factory ClassAttendance.fromJson(Map<String, dynamic> json) => ClassAttendance(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    alunoId: JsonParsingHelper.requiredString(json, 'alunoId'),
    classId: JsonParsingHelper.requiredString(json, 'classId'),
    data: JsonParsingHelper.requiredDate(json['data']),

    presenca: json['presenca'] != null
        ? Presenca.values.byName(json['presenca'] as String)
        : Presenca.falta,
  );

  ClassAttendance copyWith(
    {String? id,
    String? alunoId,
    String? classId,
    DateTime? data,
    Presenca? presenca,}
  ) {
    return ClassAttendance(
      id: id ?? this.id,
      alunoId: alunoId ?? this.alunoId,
      classId: classId ?? this.classId,
      data: data ?? this.data,
      presenca: presenca ?? this.presenca,
    );
  }
}
