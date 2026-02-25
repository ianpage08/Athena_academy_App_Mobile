import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class EntregaDeAtividade {
  final String alunoId;
  final String exercicioId;
  final String status;
  final Timestamp dataEntrega;
  final List<String> anexos;
  EntregaDeAtividade({
    required this.alunoId,
    required this.exercicioId,
    this.status = 'Entregue',
    required this.dataEntrega,
    required this.anexos,
  });

  Map<String, dynamic> toJson() => {
    'alunoId': alunoId,
    'exercicioId': exercicioId,
    'status': status,
    'dataEntrega': dataEntrega,
    'anexos': anexos,
  };

  factory EntregaDeAtividade.fromJson(Map<String, dynamic> json) =>
      EntregaDeAtividade(
        alunoId: JsonParsingHelper.requiredString(json, 'alunoId'),
        exercicioId: JsonParsingHelper.requiredString(json, 'exercicioId'),
        dataEntrega: JsonParsingHelper.requiredDate(json['dataEntrega']) as Timestamp,
        anexos: JsonParsingHelper.stringListOrEmpty(json['anexos']),
      );

}
