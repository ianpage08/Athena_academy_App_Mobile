import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class Professor {
  final String id;
  final String nome;
  final String classId; //colocar a turma que vaii ser um professor titular
  final String usuarioId;
  final String turno;
  Professor({
    required this.id,
    required this.nome,
    required this.classId,
    required this.usuarioId,
    required this.turno,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'classId': classId,
    'usuarioId': usuarioId,
    'turno': turno,
  };

  factory Professor.fromJson(Map<String, dynamic> json) => Professor(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    nome: JsonParsingHelper.requiredString(json, 'nome'),
    classId: JsonParsingHelper.requiredString(json, 'classId'),
    usuarioId: JsonParsingHelper.requiredString(json, 'usuarioId'),
    turno: JsonParsingHelper.requiredString(json, 'turno'),
  );

  Professor copyWith({
    String? id,
    String? nome,
    String? classId,
    String? usuarioId,
    String? turno
  }){
    return Professor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      classId: classId ?? this.classId,
      usuarioId: usuarioId ?? this.usuarioId,
      turno: turno ?? this.turno,
    );
  }
}
