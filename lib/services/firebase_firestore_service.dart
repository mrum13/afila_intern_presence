import 'dart:math';

import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/intern/models/presence_model.dart';
import 'package:afila_intern_presence/intern/models/user_model.dart';
import 'package:afila_intern_presence/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_method/d_method.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<bool> createData(
      {required String name,
      required String email,
      required String faceChar}) async {
    try {
      await _firebaseFirestore.collection('employee').doc(email).set({
        'name': name,
        'email': email,
        'face_char': faceChar,
      });

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Stream<List<Profile>> getData() { ///penggunaan snapshot untuk get data secara realtime
  //   return _firebaseFirestore
  //       .collection('pegawai')
  //       .orderBy('dateCreated', descending: true)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs.map(
  //           (e) {
  //             final data = Profile.fromJson(e.data());
  //             return data;
  //           },
  //         ).toList(),
  //       );
  // }

  Future<List<UserModel>> getDataEmployee() async {
    ///penggunaan get untuk get data tidak realtime
    final result = await _firebaseFirestore.collection('employee').get();

    return result.docs.map((event) {
      final data = UserModel.fromJson(event.data());
      return data;
    }).toList();
  }

  Future<InternModel> getCurrentUser(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('employee')
          .doc(docId)
          .get();

      if (doc.exists) {
        final data = InternModel.fromJson(doc.data() as Map<String, dynamic>);

        StorageService.saveFaceData(embedding: data.faceChar);

        return data;
      } else {
        throw Exception("Dokumen tidak ditemukan");
      }
    } catch (e) {
      throw Exception("Error ambil data: $e");
    }
  }

  Future<List<PresenceModel>> getHistoryPresence() async {
    try {
      final result = await _firebaseFirestore.collection('presence').get();

      String? docId = await StorageService.getDocId(); 

      var finalResult = result.docs
          .where((event) => event.id.contains(docId)) // filter berdasarkan docId
          .map((event) => PresenceModel.fromJson(event.data()))
          .toList();

      return finalResult;
    } catch (e) {
      throw Exception("Error ambil data: $e");
    }
  }
}
