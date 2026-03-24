import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:portal_do_aluno/features/student/data/datasources/entrega_exercicio_service.dart';
import 'package:portal_do_aluno/features/student/data/models/entrega_de_atividade.dart';
import 'package:portal_do_aluno/features/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/shared/helpers/app_snackbar.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciciosDetalhesPage extends StatefulWidget {
  final QueryDocumentSnapshot exercicios;
  const ExerciciosDetalhesPage({super.key, required this.exercicios});

  @override
  State<ExerciciosDetalhesPage> createState() => _ExerciciosDetalhesPageState();
}

class _ExerciciosDetalhesPageState extends State<ExerciciosDetalhesPage> {
  bool _isUploading = false;
  final List<XFile> _imgSelected = [];
  final EntregaExercicioService _entregaExercicioService =
      EntregaExercicioService();

  // 👉 MUDANÇA 1: Encapsulamento de busca de dados.
  // Em uma arquitetura limpa, isso ficaria no Repository.
  Future<Map<String, String>> _getStudentData(String userId) async {
    final snap = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();
    final data = snap.data() ?? {};
    return {'alunoId': data['alunoId'] ?? '', 'name': data['name'] ?? 'Aluno'};
  }

  Future<void> _handleEnvio() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    if (_imgSelected.isEmpty) {
      showAppSnackBar(
        context: context,
        mensagem: 'Selecione um anexo primeiro',
        cor: Colors.orange,
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 👉 MUDANÇA 2: Paralelismo e Performance. Buscamos os dados do aluno de uma vez.
      final studentData = await _getStudentData(userId);
      final exerciciosId = widget.exercicios.id;

      // Upload e envio em sequência lógica
      final urls = await uploadImagensExercicio(
        _imgSelected,
        exerciciosId,
        studentData['alunoId']!,
      );

      final entrega = EntregaDeAtividade(
        alunoId: studentData['alunoId']!,
        exercicioId: exerciciosId,
        dataEntrega: Timestamp.now(),
        anexos: urls,
        studentName: studentData['name']!,
      );

      await _entregaExercicioService.entregarExercicio(
        exerciciosId: exerciciosId,
        alunoId: studentData['alunoId']!,
        entrega: entrega,
      );

      // 👉 MUDANÇA 3: Atualização de status usando merge para evitar sobrescrever campos
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('exercicios_status')
          .doc(exerciciosId)
          .set({
            'status': true,
            'dataDeEntrega': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        showAppSnackBar(
          context: context,
          mensagem: 'Atividade entregue com sucesso!',
          cor: Colors.green,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted)
        showAppSnackBar(
          context: context,
          mensagem: 'Falha no envio: $e',
          cor: Colors.red,
        );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 👉 MUDANÇA 4: Design Imersivo. Hero agora ocupa a tela toda com elegância.
          CustomScrollView(
            slivers: [
              _buildAppBar(theme),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Hero(
                    tag: widget.exercicios.id,
                    child: Material(
                      type: MaterialType.transparency,
                      child: _buildMainContent(theme),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isUploading) _buildLoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(theme),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Detalhes do Exercício',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.exercicios['titulo'],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            widget.exercicios['conteudoDoExercicio'],
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ),
        const SizedBox(height: 30),
        if (_imgSelected.isNotEmpty) _buildImagePreview(theme),
      ],
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anexos Selecionados', style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _imgSelected.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => Container(
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.hintColor.withValues(alpha: 0.1),
              ),
              child: const Icon(CupertinoIcons.doc_fill, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final imagens = await getImage();
                if (imagens.isNotEmpty) {
                  setState(() {
                    _imgSelected.clear();
                    _imgSelected.addAll(imagens);
                  });
                }
              },
              icon: const Icon(CupertinoIcons.link),
              label: const Text('Anexar'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F5DFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: _isUploading ? null : _handleEnvio,
              icon: const Icon(CupertinoIcons.paperplane_fill),
              label: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/loading_40 _ paperplane.json',
                height: 200,
              ),
              const Text(
                'Enviando sua conquista...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
