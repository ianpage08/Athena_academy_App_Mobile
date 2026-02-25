import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class Visualizacao {
  final String id;
  final String alunoId;
  final bool visualiado;

  Visualizacao({
    required this.id,
    required this.alunoId,
    required this.visualiado,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'visualiado': visualiado,
  };

  factory Visualizacao.fromJson(Map<String, dynamic> json) =>
      Visualizacao(
        id: JsonParsingHelper.optionalString(json['id']) ?? '', 
        alunoId: JsonParsingHelper.requiredString(json, 'alunoId'),
        visualiado: json  ['visualiado'] as bool,
      ) ;

  
}
