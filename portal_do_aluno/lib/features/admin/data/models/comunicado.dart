import 'package:cloud_firestore/cloud_firestore.dart';

enum Destinatario { todos, alunos, professores, responsaveis }

enum PrioridadeComunicado { baixa, media, alta }

class Comunicado {
  final String id;
  final String titulo;
  final String mensagem;
  final DateTime dataPublicacao;
  final Destinatario destinatario;
  final String? prioridade;

  Comunicado({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.dataPublicacao,
    required this.destinatario,
    this.prioridade,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'mensagem': mensagem,
    'dataPublicacao': Timestamp.fromDate(dataPublicacao),
    'destinatario': destinatario.toString().split('.').last,
    'prioridade': prioridade,
  };

  factory Comunicado.fromJson(Map<String, dynamic> json) => Comunicado(
    id: json['id'] as String? ?? '',
    titulo: json['titulo'] as String? ?? '',
    mensagem: json['mensagem'] as String? ?? '',
    dataPublicacao: DateTime.parse(json['dataPublicacao'] as String? ?? ''),
    destinatario: json['destinatario'] != null
        ? Destinatario.values.byName(json['destinatario'] as String)
        : Destinatario.todos,
    prioridade: json['prioridade'] as String? ?? '',
  );

  Comunicado copyWith({
    String? id,
    String? titulo,
    String? mensagem,
    DateTime? dataPublicacao,
    Destinatario? destinatario,
    String? prioridade,
  }) => Comunicado(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    mensagem: mensagem ?? this.mensagem,
    dataPublicacao: dataPublicacao ?? this.dataPublicacao,
    destinatario: destinatario ?? this.destinatario,
    prioridade: prioridade ?? this.prioridade,
  );
}
