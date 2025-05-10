import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // WAJIB buat File upload
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/mahasiswa.dart';

class MahasiswaController extends GetxController {
  var mahasiswaList = <Mahasiswa>[].obs;
  var isLoading = false.obs;

  final String mobileApiUrl = 'http://10.0.2.2:8000/api/mahasiswa';
  final String webApiUrl = 'http://127.0.0.1:8000/api/mahasiswa';
  String get apiUrl => kIsWeb ? webApiUrl : mobileApiUrl;

  @override
  void onInit() {
    super.onInit();
    fetchMahasiswa();
  }

  Future<void> fetchMahasiswa() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        mahasiswaList.value = data.map((e) => Mahasiswa.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addMahasiswa(Mahasiswa mhs, [File? imageFile]) async {
    try {
      isLoading(true);
      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan semua field (null -> kosong)
      request.fields.addAll(mhs.toJson().map((k, v) => MapEntry(k, v ?? '')));

      // Tambahkan file photo jika ada
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final newMhs = Mahasiswa.fromJson(json.decode(response.body));
        mahasiswaList.add(newMhs);
      } else {
        throw Exception('Gagal tambah data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error add: ${e.toString()}');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateMahasiswa(int id, Mahasiswa mhs) async {
    try {
      isLoading(true);
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mhs.toJson()),
      );
      if (response.statusCode == 200) {
        final updated = Mahasiswa.fromJson(json.decode(response.body));
        final idx = mahasiswaList.indexWhere((e) => e.id == id);
        if (idx != -1) mahasiswaList[idx] = updated;
      } else {
        throw Exception('Gagal update: ${response.statusCode}');
      }
    } catch (e) {
      print('Error update: ${e.toString()}');
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteMahasiswa(int id) async {
    try {
      isLoading(true);
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 204) {
        mahasiswaList.removeWhere((e) => e.id == id);
      } else {
        throw Exception('Gagal hapus: ${response.statusCode}');
      }
    } catch (e) {
      print('Error delete: ${e.toString()}');
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}
