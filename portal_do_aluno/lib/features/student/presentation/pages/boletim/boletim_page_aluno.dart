import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/stream_boletim.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({super.key});

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  late Future<String?> _alunoIdFuture;

  @override
  void initState() {
    super.initState();
    _alunoIdFuture = _carregarAlunoId();
  }

  Future<String?> _carregarAlunoId() async {
    final userId = context.read<UserProvider>().userId;

    if (userId == null) {
      debugPrint('❌ Usuário não encontrado no provider');
      return null;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();

    if (!snapshot.exists) {
      debugPrint('❌ Documento do usuário não encontrado');
      return null;
    }

    final alunoId = snapshot.data()?['alunoId'] as String?;
    if (alunoId == null || alunoId.isEmpty) {
      debugPrint('❌ alunoId não encontrado no documento do usuário');
      return null;
    }

    return alunoId;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _getBoletimStream(
    String alunoId,
  ) {
    return FirebaseFirestore.instance
        .collection('boletim')
        .doc(alunoId)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Boletim Escolar',
        backGround: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<String?>(
          future: _alunoIdFuture,
          builder: (context, alunoSnapshot) {
            if (alunoSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (alunoSnapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar aluno: ${alunoSnapshot.error}'),
              );
            }

            final alunoId = alunoSnapshot.data;

            if (alunoId == null) {
              return const Center(
                child: Text('Aluno não encontrado para este usuário.'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Boletim do Aluno',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  StreamBoletim(stream: _getBoletimStream(alunoId)),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  

  

  
}
