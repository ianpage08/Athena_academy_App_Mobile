import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_do_aluno/features/student/data/datasources/entrega_exercicio_service.dart';
import 'package:portal_do_aluno/features/student/data/models/entrega_de_atividade.dart';
import 'package:portal_do_aluno/features/admin/helper/anexo_helper.dart';

class ExerciseDeliveryController {
  final EntregaExercicioService _service = EntregaExercicioService();

  final isUploading = ValueNotifier<bool>(false);
  final imagensSelecionadas = ValueNotifier<List<XFile>>([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getAlunoId(String userId) async {
    final snap =
        await _firestore.collection('usuarios').doc(userId).get();
    return snap.data()!['alunoId'];
  }

  Future<void> selecionarImagens() async {
    final imagens = await getImage();
    if (imagens.isNotEmpty) {
      imagensSelecionadas.value = imagens;
    }
  }

  Future<void> enviar({
    required String userId,
    required String exercicioId,
  }) async {
    if (imagensSelecionadas.value.isEmpty) {
      throw Exception('Nenhuma imagem selecionada');
    }

    isUploading.value = true;

    try {
      final alunoId = await getAlunoId(userId);

      final urls = await uploadImagensExercicio(
        imagensSelecionadas.value,
        exercicioId,
        alunoId,
      );

      final entrega = EntregaDeAtividade(
        alunoId: alunoId,
        exercicioId: exercicioId,
        dataEntrega: Timestamp.now(),
        anexos: urls,
      );

      await _service.entregarExercicio(
        exerciciosId: exercicioId,
        alunoId: alunoId,
        entrega: entrega,
      );

      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('exercicios_status')
          .doc(exercicioId)
          .update({
        'status': true,
        'dataDeEntrega': FieldValue.serverTimestamp(),
      });

      imagensSelecionadas.value = [];
    } finally {
      isUploading.value = false;
    }
  }

  void dispose() {
    isUploading.dispose();
    imagensSelecionadas.dispose();
  }
}
