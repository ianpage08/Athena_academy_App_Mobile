import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/boletim/widgets/stream_boletim.dart';
import 'package:portal_do_aluno/shared/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

/// Tela principal do Boletim Escolar do Aluno.

class BoletimPage extends StatefulWidget {
  const BoletimPage({super.key});

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  late Future<String?> _alunoIdFuture;

  //  Variável de Cache para o Stream
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _boletimStreamCache;

  @override
  void initState() {
    super.initState();
    _alunoIdFuture = _inicializarDados();
  }

  //Função unificada que busca o ID e JÁ PREPARA o Stream
  Future<String?> _inicializarDados() async {
    final userId = context.read<UserProvider>().userId;

    if (userId == null) {
      debugPrint('❌ Usuário não encontrado no provider');
      return null;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();

    if (!snapshot.exists) return null;

    final alunoId = snapshot.data()?['alunoId'] as String?;

    if (alunoId == null || alunoId.isEmpty) {
      debugPrint('❌ alunoId não encontrado no documento do usuário');
      return null;
    }

    
    _boletimStreamCache = FirebaseFirestore.instance
        .collection('boletim')
        .doc(alunoId)
        .snapshots();

    return alunoId;
  }

  
  Widget _buildStateFeedback(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Boletim Escolar',
        
      ),

      // Removido o padding geral para deixar o fundo fluir melhor,
      // aplicamos os paddings apenas onde importa.
      body: FutureBuilder<String?>(
        future: _alunoIdFuture,
        builder: (context, alunoSnapshot) {
          if (alunoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator(radius: 16));
          }

          if (alunoSnapshot.hasError) {
            return _buildStateFeedback(
              context,
              title: 'Erro de Conexão',
              subtitle:
                  'Houve um problema ao verificar seus dados.\nTente novamente mais tarde.',
              icon: CupertinoIcons.wifi_slash,
            );
          }

          final alunoId = alunoSnapshot.data;

          if (alunoId == null) {
            return _buildStateFeedback(
              context,
              title: 'Acesso Restrito',
              subtitle:
                  'Não encontramos o vínculo de aluno para este perfil.\nContate a secretaria da escola.',
              icon: CupertinoIcons.person_crop_circle_badge_xmark,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  'Desempenho Acadêmico',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Acompanhe suas notas e médias lançadas pelos professores ao longo das unidades.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 24),

                
                StreamBoletim(stream: _boletimStreamCache!),
              ],
            ),
          );
        },
      ),
    );
  }
}
