import 'dart:math';

import 'package:afila_intern_presence/admin/models/office_data_model.dart';
import 'package:afila_intern_presence/admin/models/user_model.dart';
import 'package:afila_intern_presence/intern/models/presence_model.dart';
import 'package:afila_intern_presence/intern/models/user_model.dart';
import 'package:afila_intern_presence/common/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_method/d_method.dart';
import 'package:intl/intl.dart';

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

  Future<List<UserModel>> getDataEmployee() async {
    ///penggunaan get untuk get data tidak realtime
    final result = await _firebaseFirestore.collection('employee').get();

    var dataReversed = result.docs.reversed;

    return dataReversed.map((event) {
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
        StorageService.saveInternData(name: data.name);

        return data;
      } else {
        throw Exception("Dokumen tidak ditemukan");
      }
    } catch (e) {
      throw Exception("Error ambil data: $e");
    }
  }

  Future<List<PresenceModel>> getHistoryPresence({bool isAdmin = false}) async {
    try {
      final result = await _firebaseFirestore.collection('presence').get();

      String? docId = await StorageService.getDocId();

      var finalResult = result.docs
          .where(
              (event) => event.id.contains(isAdmin?'':docId)) // filter berdasarkan docId
          .map((event) => PresenceModel.fromJson(event.data()))
          .toList();

      return finalResult;
    } catch (e) {
      throw Exception("Error ambil data: $e");
    }
  }

  Future<bool> presence(
      {required String presenceStatement,
      required String status,
      required String checkInTime,
      required String checkOutTime}) async {
    try {
      String? docIdSaved = await StorageService.getDocId();
      String? internName = await StorageService.getInternData();

      // 1. Ubah String ke DateTime
      DateTime dateTimeCheckIn = DateTime.parse(checkInTime);
      DateTime dateTimeCheckOut = DateTime.parse(checkOutTime);

      // 2. Ubah DateTime ke Timestamp
      Timestamp timestampCheckIn = Timestamp.fromDate(dateTimeCheckIn);
      Timestamp timestampCheckOut = Timestamp.fromDate(dateTimeCheckOut);

      String docId =
          "${DateFormat('yyyy-MM-dd').format(DateTime.now())}|$docIdSaved";

      var docData =
          await _firebaseFirestore.collection('presence').doc(docId).get();

      if (docData.exists) {
        if (presenceStatement == "checkin") {
          await _firebaseFirestore.collection('presence').doc(docId).set({
            'status': status,
            'check_in': timestampCheckIn,
            'check_out': timestampCheckOut,
            'name': internName,
            'statement': 'checkin'
          });
        } else if (presenceStatement == "checkout") {
          await _firebaseFirestore.collection('presence').doc(docId).update(
              {'check_out': timestampCheckOut, 'statement': 'checkout'});
        }
      } else {
        await _firebaseFirestore.collection('presence').doc(docId).set({
          'status': status,
          'check_in': timestampCheckIn,
          'check_out': timestampCheckOut,
          'name': internName,
          'statement': 'checkin'
        });
      }

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> saveOrUpdateOfficeData(
      {required String lat, required String long}) async {
    try {
      var docData = await _firebaseFirestore
          .collection('office')
          .doc('office_data')
          .get();
      var data = docData.data();

      if (data!['lat']!=null || data['long']!=null) {
        await _firebaseFirestore.collection('office').doc('office_data').set({
          'lat': lat,
          'long': long,
        });
      } else {
        await _firebaseFirestore.collection('office').doc('office_data').update({
          'lat': lat,
          'long': long,
        });
      }

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

    Future<OfficeDataModel> getOfficeData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('office')
          .doc('office_data')
          .get();

      

      if (doc.exists) {
        final data = OfficeDataModel.fromJson(doc.data() as Map<String, dynamic>);
        await StorageService.saveOfficeLatLong(lat: data.lat, long: data.long);
        return data;
      } else {
        throw Exception("Dokumen tidak ditemukan");
      }
    } catch (e) {
      throw Exception("Error ambil data: $e");
    }
  }
}
