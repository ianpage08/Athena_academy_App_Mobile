import 'package:portal_do_aluno/features/teacher/data/models/grade_record.dart';

class AcademicReport {
  final String id;
  final String alunoId;
  final List<GradeRecord> disciplinas;
  final double mediageral;
  final String situacao; // aprovado ou reprovado

  AcademicReport({
    required this.id,
    required this.alunoId,
    required this.disciplinas,
    required this.mediageral,
    required this.situacao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'disciplinas': disciplinas.map((e) => e.toJson()).toList(),
    'mediageral': mediageral,
    'situacao': situacao,
  };

  factory AcademicReport.fromJson(Map<String, dynamic> json) => AcademicReport(
    id: json['id'] as String? ?? '',
    alunoId: json['alunoId'] as String? ?? '',
    disciplinas:
        (json['disciplinas'] as List<dynamic>?)
            ?.map((e) => GradeRecord.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    mediageral: json['mediageral'] as double? ?? 0.0,
    situacao: json['situacao'] as String? ?? '',
  );

  AcademicReport copyWith({
    String? id,
    String? alunoId,
    List<GradeRecord>? disciplinas,
    double? mediageral,
    String? situacao,
  }) => AcademicReport(
    id: id ?? this.id,
    alunoId: alunoId ?? this.alunoId,
    disciplinas: disciplinas ?? this.disciplinas,
    mediageral: mediageral ?? this.mediageral,
    situacao: situacao ?? this.situacao,
  );
}
