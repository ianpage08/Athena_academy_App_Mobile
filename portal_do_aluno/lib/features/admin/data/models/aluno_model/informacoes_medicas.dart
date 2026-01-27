class InformacoesMedicasAluno {
  final String? alergia;
  final String? medicacao;
  final String? observacoes;
  final String? numeroEmergencia;

  InformacoesMedicasAluno({this.alergia, this.medicacao, this.observacoes, this.numeroEmergencia});

  Map<String, dynamic> toJson() => {
    'alergia': alergia,
    'medicacao': medicacao,
    'observacoes': observacoes,
    'numeroEmergencia': numeroEmergencia,
  };

  factory InformacoesMedicasAluno.fromJson(Map<String, dynamic> json) =>
      InformacoesMedicasAluno(
        alergia: json['alergia'] as String? ?? '',
        medicacao: json['medicacao'] as String? ?? '',
        observacoes: json['observacoes'] as String? ?? '',
        numeroEmergencia: json['numeroEmergencia'] as String? ?? '',
      );

  InformacoesMedicasAluno copyWith({
    String? alergia,
    String? medicacao,
    String? observacoes,
    String? numeroEmergencia,
  }) {
    return InformacoesMedicasAluno(
      alergia: alergia ?? this.alergia,
      medicacao: medicacao ?? this.medicacao,
      observacoes: observacoes ?? this.observacoes,
      numeroEmergencia: numeroEmergencia ?? this.numeroEmergencia,
    );
  }
}