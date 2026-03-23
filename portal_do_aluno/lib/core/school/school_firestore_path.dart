import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/core/school/school_context.dart';

class SchoolFirestorePath {
  SchoolFirestorePath({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> collection(
    String collectionName,
  ) {
    final schoolId = SchoolContext.currentSchoolId;
    if (schoolId == null || schoolId.isEmpty) {
      return _firestore.collection(collectionName);
    }

    return _firestore
        .collection('schools')
        .doc(schoolId)
        .collection(collectionName);
  }
}
