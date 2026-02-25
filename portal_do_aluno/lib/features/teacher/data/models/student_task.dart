import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class StudentTask {
  final String id;
  final String titulo;
  final String professorId;
  final String nomeDoProfessor;
  final String turmaId;
  final String conteudoDoExercicio;
  final Timestamp dataDeEnvio;
  final Timestamp dataDeEntrega;
  final Timestamp dataDeExpiracao;

  StudentTask({
    required this.id,
    required this.titulo,
    required this.professorId,
    required this.nomeDoProfessor,
    required this.turmaId,
    required this.conteudoDoExercicio,
    required this.dataDeEnvio,
    required this.dataDeEntrega,
    required this.dataDeExpiracao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'professorId': professorId,
    'nomeDoProfessor': nomeDoProfessor,
    'turmaId': turmaId,
    'conteudoDoExercicio': conteudoDoExercicio,
    'dataDeEnvio': dataDeEnvio,
    'dataDeEntrega': dataDeEntrega,
    'dataDeExpiracao': dataDeExpiracao,
  };

  factory StudentTask.fromJson(Map<String, dynamic> json) => StudentTask(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    titulo: JsonParsingHelper.requiredString(json, 'titulo'),
    professorId: JsonParsingHelper.requiredString(json, 'professorId'),
    nomeDoProfessor: JsonParsingHelper.requiredString(json, 'nomeDoProfessor'),
    turmaId: JsonParsingHelper.requiredString(json, 'turmaId'),
    conteudoDoExercicio: JsonParsingHelper.requiredString(
      json,
      'conteudoDoExercicio',
    ),
    dataDeEnvio:
        JsonParsingHelper.requiredDate(json['dataDeEnvio']) as Timestamp,
    dataDeEntrega:
        JsonParsingHelper.requiredDate(json['dataDeEntrega']) as Timestamp,
    dataDeExpiracao:
        JsonParsingHelper.requiredDate(json['dataDeExpiracao']) as Timestamp,
  );

  StudentTask copyWith({
    String? id,
    String? titulo,
    String? professorId,
    String? nomeDoProfessor,
    String? turmaId,
    String? conteudoDoExercicio,
    Timestamp? dataDeEnvio,
    Timestamp? dataDeEntrega,
    Timestamp? dataDeExpiracao,
  }) {
    return StudentTask(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      professorId: professorId ?? this.professorId,
      nomeDoProfessor: nomeDoProfessor ?? this.nomeDoProfessor,
      turmaId: turmaId ?? this.turmaId,
      conteudoDoExercicio: conteudoDoExercicio ?? this.conteudoDoExercicio,
      dataDeEnvio: dataDeEnvio ?? this.dataDeEnvio,
      dataDeEntrega: dataDeEntrega ?? this.dataDeEntrega,
      dataDeExpiracao: dataDeExpiracao ?? this.dataDeExpiracao,
    );
  }
}
