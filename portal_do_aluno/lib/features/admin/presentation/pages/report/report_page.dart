import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/report/widgets/stream_builder.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Relatório de aula'),
      body: Padding(padding: EdgeInsets.all(16), child: ReportStreamBuilder()),
    );
  }
}
