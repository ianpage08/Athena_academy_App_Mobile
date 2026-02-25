
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class LessonRecord {
  final String id;
  final String classId;
  final String conteudo;
  final DateTime data;
  final Presenca presenca;
  final String? observacoes;
  final List<String> anexo;
  

  LessonRecord({
    required this.id,
    required this.classId,
    required this.conteudo,
    required this.data,
    this.observacoes,
    this.presenca = Presenca.presente,
    this.anexo = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'conteudo': conteudo,
    'data': data,
    'observacoes': observacoes,
    'presenca': presenca.name,
    'anexo': anexo,
  };
  factory LessonRecord.fromJson(Map<String, dynamic> json) =>
      LessonRecord(
        id: JsonParsingHelper.optionalString(json['id']) ?? '',
        classId: JsonParsingHelper.requiredString(json, 'classId'),
        conteudo: JsonParsingHelper.requiredString(json, 'conteudo'),
        data: JsonParsingHelper.requiredDate(json['data']),
        observacoes: JsonParsingHelper.optionalString(json['observacoes']),
        presenca: json['presenca'],
        anexo: JsonParsingHelper.stringListOrEmpty(json['anexo']),
      );

  LessonRecord copyWith({
    String? id,
    String? classId,
    String? conteudo,
    DateTime? data,
    String? observacoes,
    Presenca? presenca,
    List<String>? anexo,
  }) {
    return LessonRecord(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      conteudo: this.conteudo,
      data: data ?? this.data,
      observacoes: observacoes ?? this.observacoes,
      presenca: presenca ?? this.presenca,
      anexo: anexo ?? this.anexo,
    );
  }
}
