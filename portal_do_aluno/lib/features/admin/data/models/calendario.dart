import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/shared/helpers/json_parsing_helper.dart';

class Calendario {
  final String id;
  final String titulo;
  final String? descricao;
  final DateTime data;
  final int? tipo;
  final Timestamp dataDeExpiracao;

  Calendario({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.data,
    required this.tipo,
    required this.dataDeExpiracao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'data': data,
    'tipo': tipo,
    'dataDeExpiracao': dataDeExpiracao,
  };

  factory Calendario.fromJson(Map<String, dynamic> json) => Calendario(
    id: JsonParsingHelper.optionalString(json['id']) ?? '',
    titulo: JsonParsingHelper.requiredString(json, 'titulo'),
    descricao: JsonParsingHelper.optionalString(json['descricao']),
    data: JsonParsingHelper.requiredDate(json['data']),
    tipo: JsonParsingHelper.optionalInt(json['tipo']),
    dataDeExpiracao: JsonParsingHelper.requiredDate(json['dataDeExpiracao']) as Timestamp,
  );

  Calendario copyWith({
    String? id,
    String? titulo,
    String? descricao,
    DateTime? data,
    int? tipo,
    Timestamp? dataDeExpiracao,
  }) {
    return Calendario(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      dataDeExpiracao: dataDeExpiracao ?? this.dataDeExpiracao,
    );
  }
}
