import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class Disciplina {
  final String id;
  final String nome;
  final String professor;
  final int cargaHoraria;
  final int aulaPrevistas;

  Disciplina({
    required this.id,
    required this.nome,
    required this.professor,
    required this.cargaHoraria,
    required this.aulaPrevistas,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'professor': professor,
    'cargaHoraria': cargaHoraria,
    'aulaPrevistas': aulaPrevistas,
  };

  factory Disciplina.fromJson(Map<String, dynamic> json) => Disciplina(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    nome: JsonParsingHelper.requiredString(json, 'nome'),
    professor: JsonParsingHelper.requiredString(json, 'professor'),
    cargaHoraria: JsonParsingHelper.requiredInt(json, 'cargaHoraria'),
    aulaPrevistas: JsonParsingHelper.requiredInt(json, 'aulaPrevistas'),
  );

  Disciplina copyWith({
    String? id,
    String? nome,
    String? professor,
    int? cargaHoraria,
    int? aulaPrevistas,
  }) {
    return Disciplina(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      professor: professor ?? this.professor,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      aulaPrevistas: aulaPrevistas ?? this.aulaPrevistas,
    );
  }
}
