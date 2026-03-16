import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/presentation/pages/attendace/widgets/attendance_aluno_card.dart';
import 'package:portal_do_aluno/features/teacher/presentation/providers/attendance_provider.dart';
import 'package:provider/provider.dart';

/// Widget responsável por renderizar a lista de alunos da chamada.
///
/// Ele escuta um [Stream] vindo do Firestore e monta dinamicamente
/// os cards dos alunos com base nos documentos recebidos.
///
/// Também consome o [AttendanceProvider] para recuperar o status
/// atual de presença de cada aluno e atualizar a seleção em tempo real.
class AttendanceStudentList extends StatelessWidget {
  /// Stream com os alunos da turma vindos do Firestore
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  const AttendanceStudentList({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    /// Obtém a instância do provider sem escutar mudanças.
    ///
    /// Esse acesso é útil para disparar ações, como marcar presença,
    /// sem reconstruir o widget inteiro.
    final providerRead = context.read<AttendanceProvider>();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        /// Enquanto o stream ainda está carregando,
        /// exibe um indicador de progresso.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Lista de documentos retornados pelo Firestore.
        ///
        /// Caso o snapshot não tenha dados ainda, utiliza uma lista vazia
        /// para evitar erro no build.
        final docs = snapshot.data?.docs ?? [];

        return Consumer<AttendanceProvider>(
          builder: (_, provider, __) {
            /// Lista de alunos exibida na tela.
            ///
            /// - [shrinkWrap: true] faz a ListView ocupar apenas o espaço necessário
            /// - [NeverScrollableScrollPhysics] desabilita o scroll interno
            ///
            /// Esse padrão costuma ser usado quando a ListView está dentro
            /// de outro widget rolável, como SingleChildScrollView.
            return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                /// Documento do aluno atual
                final aluno = docs[index];

                /// ID do documento, usado como chave para mapear a presença
                final id = aluno.id;

                /// Nome do aluno dentro da estrutura do Firestore
                final nome = aluno['dadosAluno']['nome'];

                /// Card individual do aluno
                return AttendanceAlunoCard(
                  nome: nome,

                  /// Busca o status atual da presença no provider
                  status: provider.presencas[id],

                  /// Atualiza a presença quando um chip é selecionado
                  onSelect: (p) => providerRead.marcarPresenca(id, p),
                );
              },
            );
          },
        );
      },
    );
  }
}
