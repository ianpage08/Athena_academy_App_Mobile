import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Um StreamBuilder genérico e reutilizável para escutar
/// um documento específico no Firestore em tempo real.
///
/// Exemplo de uso:
/// ```dart
/// FirestoreDocumentStreamBuilder(
///   collectionPath: 'usuarios',
///   documentId: 'uid_do_usuario',
///   builder: (context, snapshot) {
///     final dados = snapshot.data!.data();
///     return Text('Olá, ${dados?['nome']}');
///   },
/// )
/// ```
class FirestoreDocumentStreamBuilder extends StatefulWidget {
  final String collectionPath;
  final String documentId;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
  )
  builder;

  const FirestoreDocumentStreamBuilder({
    super.key,
    required this.collectionPath,
    required this.documentId,
    required this.builder,
  });

  @override
  State<FirestoreDocumentStreamBuilder> createState() =>
      _FirestoreDocumentStreamBuilderState();
}

class _FirestoreDocumentStreamBuilderState
    extends State<FirestoreDocumentStreamBuilder> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection(widget.collectionPath)
        .doc(widget.documentId)
        .snapshots();

  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        //  Enquanto carrega
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //  Erro ao carregar
        if (snapshot.hasError) {
          debugPrint(
            'Erro no FirestoreDocumentStreamBuilder: ${snapshot.error}',
          );
          return const Center(
            child: Text(
              'Erro ao carregar os dados',
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        }

        //  Documento inexistente
        if (!snapshot.hasData || !(snapshot.data?.exists ?? false)) {
          return const Center(
            child: Text(
              'Documento não encontrado',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // ✅ Dados disponíveis → renderiza o widget passado
        return widget.builder(context, snapshot);
      },
    );
  }
}
