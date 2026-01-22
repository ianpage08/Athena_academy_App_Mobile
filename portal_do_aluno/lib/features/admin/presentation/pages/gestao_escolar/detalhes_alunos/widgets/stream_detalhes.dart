import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/contrato_pdf_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/detalhes_alunos/widgets/card_section_detalhes.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/detalhes_alunos/widgets/info_row_detalhes.dart';
import 'package:printing/printing.dart';

class StreamDetalhes extends StatelessWidget {
  final String alunoId;

  const StreamDetalhes({super.key, required this.alunoId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matriculas')
          .doc(alunoId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Aluno Não Encontrado'));
        }

        final docMatricula = snapshot.data!.data() as Map<String, dynamic>;
        final dadosAluno = DadosAluno.fromJson(
          docMatricula['dadosAluno'] ?? {},
        );
        final dadosAcademicos = DadosAcademicos.fromJson(
          docMatricula['dadosAcademicos'],
        );
        final dadosPais = ResponsaveisAluno.fromJson(
          docMatricula['responsaveisAluno'] ?? {},
        );
        final dadosEndereco = EnderecoAluno.fromJson(
          docMatricula['enderecoAluno'] ?? {},
        );
        final dadosMedicos = InformacoesMedicasAluno.fromJson(
          docMatricula['informacoesMedicasAluno'] ?? {},
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dadosAluno.nome,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dadosAcademicos.numeroMatricula,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dadosAcademicos.turma}º Ano - ${dadosAcademicos.turno}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CardSectionDetalhes(
                title: 'Dados Pessoais',
                icon: Icons.person,
                children: [
                  InfoRowDetalhes(label: 'Nome', value: dadosAluno.nome),
                  InfoRowDetalhes(label: 'CPF', value: dadosAluno.cpf),
                  InfoRowDetalhes(
                    label: 'Data de Nascimento',
                    value: dadosAluno.formatarDataNascimento,
                  ),
                  InfoRowDetalhes(label: 'Sexo', value: dadosAluno.sexo),
                  InfoRowDetalhes(
                    label: 'Naturalidade',
                    value: dadosAluno.naturalidade,
                  ),
                ],
              ),
              CardSectionDetalhes(
                title: 'Acadêmico',
                icon: Icons.school,
                children: [
                  InfoRowDetalhes(
                    label: 'Matrícula',
                    value: dadosAcademicos.numeroMatricula,
                  ),
                  InfoRowDetalhes(label: 'Série', value: dadosAcademicos.turma),
                  InfoRowDetalhes(label: 'Turno', value: dadosAcademicos.turno),
                  InfoRowDetalhes(
                    label: 'Situação',
                    value: dadosAcademicos.situacao,
                  ),
                ],
              ),
              CardSectionDetalhes(
                title: 'Pais/Responsáveis',
                icon: Icons.family_restroom,
                children: [
                  InfoRowDetalhes(
                    label: 'Mãe',
                    value: dadosPais.nomeMae ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Cpf',
                    value: dadosPais.cpfMae ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Telefone',
                    value: dadosPais.telefoneMae ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Pai',
                    value: dadosPais.nomePai ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Cpf',
                    value: dadosPais.cpfPai ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Telefone',
                    value: dadosPais.telefonePai ?? '---',
                  ),
                ],
              ),
              CardSectionDetalhes(
                title: 'Endereço',
                icon: Icons.location_on,
                children: [
                  InfoRowDetalhes(label: 'Cep', value: dadosEndereco.cep),
                  InfoRowDetalhes(label: 'Cidade', value: dadosEndereco.cidade),
                  InfoRowDetalhes(label: 'Estado', value: dadosEndereco.estado),
                  InfoRowDetalhes(label: 'Rua', value: dadosEndereco.rua),
                  InfoRowDetalhes(label: 'Numero', value: dadosEndereco.numero),
                ],
              ),
              CardSectionDetalhes(
                title: 'Informações Médicas',
                icon: Icons.medical_information,
                children: [
                  InfoRowDetalhes(
                    label: 'Tipo(s) Alergia',
                    value: dadosMedicos.alergia ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Medicação',
                    value: dadosMedicos.medicacao ?? '---',
                  ),
                  InfoRowDetalhes(
                    label: 'Obeservações',
                    value: dadosMedicos.observacoes ?? '---',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: () async {
                    final pdfService = ContratoPdfService();
                    final pdfPronto = await pdfService.gerarContratoPdf(
                      dadosPdfAluno: dadosAluno,
                      dadosPdfAcademicos: dadosAcademicos,
                      dadosPdfResponsavel: dadosPais,
                      dadosPdfEndereco: dadosEndereco,
                    );
                    await Printing.layoutPdf(onLayout: (format) => pdfPronto);
                  },
                  label: const Text('Gerar PDF'),
                  icon: const Icon(Icons.picture_as_pdf),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
