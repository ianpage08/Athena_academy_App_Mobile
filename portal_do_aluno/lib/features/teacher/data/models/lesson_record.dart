import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/class_attendance.dart';

class LessonRecord {
  final String id;
  final String classId;
  final String conteudo;
  final DateTime data;
  final Presenca presenca;
  final String? observacoes;
  

  LessonRecord({
    required this.id,
    required this.classId,
    required this.conteudo,
    required this.data,
    this.observacoes,
    this.presenca = Presenca.presente,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'conteudo': conteudo,
    'data': data,
    'observacoes': observacoes,
    'presenca': presenca.name,

  };
  factory LessonRecord.fromJson(Map<String, dynamic> json) =>
      LessonRecord(
        id: json['id'],
        classId: json['classId'],
        conteudo: json['onteudo'],
        data: (json['data'] as Timestamp).toDate(),
        observacoes: json['observacoes'],
        presenca: json['presenca'],
      );

  LessonRecord copyWith({
    String? id,
    String? classId,
    String? conteudo,
    DateTime? data,
    String? observacoes,
    Presenca? presenca,
  }) {
    return LessonRecord(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      conteudo: this.conteudo,
      data: data ?? this.data,
      observacoes: observacoes ?? this.observacoes,
      presenca: presenca ?? this.presenca,
    );
  }
}
