import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  // BACKEND INTACTO (COMO VOCÊ ENVIOU)
  Stream<QuerySnapshot> getSubmission(String exerciseId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .doc(exerciseId)
        .collection('entregas')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final teacherId = Provider.of<UserProvider>(context).userId;
    if (teacherId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes da Submissão',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [Expanded(child: _buildStreamList(teacherId))]),
      ),
    );
  }

  Widget _buildStreamList(String teacherId) {
    return StreamBuilder<QuerySnapshot>(
      stream: getSubmission(widget.exerciseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.auto_awesome,
            title: 'Nenhuma Atividade entregue',
            description:
                'Quando alguma atividade for entregue ela irá aparecer aqui',
          );
        }

        final data = snapshot.data?.docs ?? [];

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = data[index];

            // CAMPOS ORIGINAIS
            final status = doc['status'] ?? 'Pendente';
            final anexos = List<String>.from(doc['anexos'] ?? []);
            // Usando o complemento que combinamos

            bool hasAttachments = anexos.isNotEmpty;
            final theme = Theme.of(context);
            final studentName = doc['studentName'];
            final delivery = doc['dataEntrega'];
            final formatDate = DateFormat(
              'dd/MM/yyyy',
            ).format(delivery.toDate());

            return Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blueAccent.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data de Entrega: $formatDate'),
                      Text(
                        "Status: $status",
                        style: TextStyle(
                          color: status.toString().toLowerCase() == 'entregue'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.02),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ANEXOS DA ATIVIDADE",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AttachementSectionReport(
                            hasAttachments: hasAttachments,
                            attachments: anexos,
                            theme: theme,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
