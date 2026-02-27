import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notification.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_comunicado_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/features/admin/helper/limitar_tamanho_texto.dart';

class StatementRepository {
  StatementRepository({
    ComunicadoService? comunicadoService,
    FirebaseFirestore? firestore,
  }) : _comunicadoService = comunicadoService ?? ComunicadoService(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  final ComunicadoService _comunicadoService;
  final FirebaseFirestore _firestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunosPorTurma(
    String classId,
  ) {
    final turmaRef = _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: classId);

    return turmaRef.snapshots();
  }

  Future<void> newStatement({
    required String titulo,
    required String mensagem,

    required String destinatario,
    required String prioridade,
  }) async {
    final newStatement = Comunicado(
      id: '',
      titulo: titulo,
      mensagem: mensagem,
      prioridade: prioridade,
      dataPublicacao: DateTime.now(),
      destinatario: Destinatario.values.byName(destinatario.toLowerCase()),
      dataDeExpiracao: Timestamp.fromDate(
        DateTime.now().add(const Duration(days: 7)),
      ),
    );
    await _comunicadoService.enviarComunidado(newStatement);
  }

  Future<void> statementNotification({
    required String destinatario,
    required String message,
  }) async {
    final tokens = await _comunicadoService.getTokensDestinatario(
      Destinatario.values.byName(destinatario.toLowerCase()).name,
    );
    final resumo = limitarCampo(message, 40);

    for (final token in tokens) {
      enviarNotification(token, 'Novo comunicado disponível', resumo);
    }
  }
}
