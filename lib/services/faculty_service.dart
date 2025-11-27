import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/faculty_model.dart';

class FacultyService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('faculty');

  // 🔹 STREAM (auto update UI)
  Stream<List<Faculty>> getFacultyStream() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => Faculty.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList(),
    );
  }

  // 🔹 SEARCH (name, room, dept, email)
  Future<List<Faculty>> searchFaculty(String query) async {
    query = query.toLowerCase().trim();

    final snap = await _collection.get();

    return snap.docs
        .map(
          (d) => Faculty.fromFirestore(d.data() as Map<String, dynamic>, d.id),
        )
        .where(
          (f) =>
              f.name.toLowerCase().contains(query) ||
              f.roomNo.toLowerCase().contains(query) ||
              f.dept.toLowerCase().contains(query) ||
              f.email.toLowerCase().contains(query),
        )
        .toList();
  }

  // 🔹 UPDATE STATUS (teacher dashboard)
  Future<void> updateAvailability(String facultyId, String newStatus) async {
    await _collection.doc(facultyId).update({'availability': newStatus});
  }
}
