import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 👉 MUDANÇA: Para ícones e feedbacks premium
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/attachement_section_report.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/empty_state_widget.dart';
import 'package:provider/provider.dart';

class SubmissionDetail extends StatefulWidget {
  final String exerciseId;
  const SubmissionDetail({super.key, required this.exerciseId});

  @override
  State<SubmissionDetail> createState() => _SubmissionDetailState();
}

class _SubmissionDetailState extends State<SubmissionDetail> {
  // 👉 ARQUITETURA: Stream memorizada para evitar múltiplas conexões ao Firestore no build
  Stream<QuerySnapshot>? _submissionStream;

  @override
  void initState() {
    super.initState();
    // 👉 PERFORMANCE: Inicialização única da stream
    _submissionStream = FirebaseFirestore.instance
        .collection('exercicios')
        .doc(widget.exerciseId)
        .collection('entregas')
        .orderBy(
          'dataEntrega',
          descending: true,
        ) // 👉 UX: Entregas recentes primeiro
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teacherId = Provider.of<UserProvider>(context).userId;

    if (teacherId == null) {
      return const Scaffold(body: Center(child: CupertinoActivityIndicator()));
    }

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // 👉 DESIGN: Fundo liso e clean
      appBar: AppBar(
        title: Text(
          'Entregas dos Alunos', // 👉 UX: Título mais direto ao ponto
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            Colors.transparent, // 👉 DESIGN: Appbar integrada ao fundo
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 👉 DESIGN: Indicador de contexto sutil
          _buildInfoCounter(theme),
          Expanded(child: _buildStreamList()),
        ],
      ),
    );
  }

  // 👉 NOVO COMPONENTE: Badge de resumo no topo
  Widget _buildInfoCounter(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: theme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "ID da Atividade: ${widget.exerciseId.substring(0, 8).toUpperCase()}",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor.withValues(alpha: 0.6),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildStreamList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _submissionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const EmptyStateWidget(
            icon: CupertinoIcons.square_stack_3d_up_slash,
            title: 'Nenhuma entrega',
            description: 'Aguardando o envio de atividades pelos alunos.',
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _SubmissionCard(doc: docs[index]);
          },
        );
      },
    );
  }
}

// 👉 REFATORAÇÃO: Widget extraído para melhorar a performance e legibilidade
class _SubmissionCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const _SubmissionCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = doc.data() as Map<String, dynamic>;

    final status = data['status'] ?? 'Pendente';
    final anexos = List<String>.from(data['anexos'] ?? []);
    final studentName = data['studentName'] ?? 'Aluno sem nome';
    final delivery = data['dataEntrega'] as Timestamp?;

    final formatDate = delivery != null
        ? DateFormat('dd MMM yyyy', 'pt_BR').format(delivery.toDate())
        : '--/--/----';

    final isDelivered = status.toString().toLowerCase() == 'entregue';

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        // 👉 DESIGN: Remove as linhas divisórias do ExpansionTile padrão
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDelivered ? Colors.green : Colors.orange).withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDelivered
                  ? CupertinoIcons.check_mark_circled
                  : CupertinoIcons.clock,
              color: isDelivered ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          title: Text(
            studentName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  formatDate,
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(status, isDelivered),
              ],
            ),
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.02),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.paperclip,
                        size: 14,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "ANEXOS ENVIADOS",
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: theme.primaryColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AttachementSectionReport(
                    hasAttachments: anexos.isNotEmpty,
                    attachments: anexos,
                    theme: theme,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDelivered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isDelivered ? Colors.green : Colors.orange).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isDelivered ? Colors.green : Colors.orange,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
