import 'package:cloud_firestore/cloud_firestore.dart';

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
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    descricao: json['descricao'] as String,
    data: (json['data'] as Timestamp).toDate(),
    tipo: json['tipo'] as int,
    dataDeExpiracao: json['dataDeExpiracao'] as Timestamp,
    
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
