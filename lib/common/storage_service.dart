import 'dart:convert';
import 'package:d_method/d_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyFaces = "faces";
  static const String _docId = "docId";
  static const String _officeData = "officeData";
  static const String _internData = "internData";

  /// Tambah data wajah baru
  static Future<void> saveFaceData({required String embedding}) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan kembali
    await prefs.setString(_keyFaces, json.encode(embedding));
  }

  static Future<void> saveInternData({required String name}) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan kembali
    await prefs.setString(_internData, name);
  }

  /// Ambil semua data wajah
  static Future<List<double>> getFaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_keyFaces);

    if (dataString != null) {
      var data = jsonDecode(dataString);
      List<dynamic> decoded = jsonDecode(data);

      List<double> doubles = decoded.map((e) => (e as num).toDouble()).toList();

      return doubles;
    }
    return [];
  }

  static Future<String> getInternData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_internData);
    return dataString!;
  }

  static Future<void> saveDocId({
    required String docId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan kembali
    await prefs.setString(_docId, docId);
  }

  static Future<String> getDocId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_docId);

    return dataString!;
  }

  static Future<void> saveOfficeLatLong({
    required String lat,
    required String long,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Simpan kembali
    await prefs.setString(_officeData, jsonEncode({'lat': lat, 'long': long}));
  }

  static Future<String> getOfficeLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_officeData);
    var dataDecoded = jsonDecode(data!);

    return data;
  }
}
