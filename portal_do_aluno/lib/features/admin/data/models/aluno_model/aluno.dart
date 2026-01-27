import 'package:cloud_firestore/cloud_firestore.dart';

class DadosAluno {
  final String? id;
  final String nome;
  final String cpf;
  final String sexo;
  final DateTime dataNascimento;
  final String naturalidade;
  final String? nomeMae;
  final String? nomePai;

  DadosAluno({
    this.id,
    required this.nome,
    required this.cpf,
    required this.sexo,
    required this.naturalidade,
    required this.dataNascimento,
    this.nomeMae,
    this.nomePai,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'cpf': cpf,
    'sexo': sexo,
    'naturalidade': naturalidade,
    'dataNascimento': Timestamp.fromDate(dataNascimento),
    'nomeMae': nomeMae,
    'nomePai': nomePai,
  };

  factory DadosAluno.fromJson(Map<String, dynamic> json) {
    return DadosAluno(
      id: json['id'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      sexo: json['sexo'] as String? ?? '',
      naturalidade: json['naturalidade'] as String? ?? '',
      dataNascimento: json['dataNascimento'] is Timestamp
          ? (json['dataNascimento'] as Timestamp).toDate()
          : DateTime.now(),
      nomeMae: json['nomeMae'] as String? ?? '',
      nomePai: json['nomePai'] as String? ?? '',
    );
  }

  DadosAluno copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? sexo,
    String? naturalidade,
    DateTime? dataNascimento,
  }) {
    return DadosAluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      sexo: sexo ?? this.sexo,
      naturalidade: naturalidade ?? this.naturalidade,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  int calcularIdade() {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  String get formatarDataNascimento {
    return '${dataNascimento.day.toString().padLeft(2, '0')}/'
        '${dataNascimento.month.toString().padLeft(2, '0')}/'
        '${dataNascimento.year}';
  }
}

