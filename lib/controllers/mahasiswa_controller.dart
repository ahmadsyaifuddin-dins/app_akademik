import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/mahasiswa.dart';

// For Web imports
import 'package:universal_html/html.dart' as html;
import 'package:image_picker_web/image_picker_web.dart';

// For Mobile imports
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:image_picker/image_picker.dart';

class MahasiswaController extends GetxController {
  var mahasiswaList = <Mahasiswa>[].obs;
  var isLoading = false.obs;

  // URL will be chosen based on platform
  final String mobileApiUrl =
      'http://10.0.2.2:8000/api/mahasiswa'; // for emulator
  final String webApiUrl = 'http://127.0.0.1:8000/api/mahasiswa'; // for web

  String get apiUrl => kIsWeb ? webApiUrl : mobileApiUrl;

  @override
  void onInit() {
    super.onInit();
    fetchMahasiswa(); // Load data when controller is activated
  }

  Future<void> fetchMahasiswa() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        mahasiswaList.value =
            data.map((item) => Mahasiswa.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to fetch student data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetchMahasiswa: $e');
    } finally {
      isLoading(false);
    }
  }

  // Method for adding a student
  Future<void> addMahasiswa(Mahasiswa mahasiswa, dynamic imageFile) async {
    try {
      isLoading(true);
      if (kIsWeb) {
        await _addMahasiswaWeb(mahasiswa, imageFile);
      } else {
        await _addMahasiswaMobile(mahasiswa, imageFile);
      }
    } catch (e) {
      print('Error addMahasiswa: $e');
      throw Exception("Failed to save data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Web implementation for adding a student
  Future<void> _addMahasiswaWeb(
    Mahasiswa mahasiswa,
    html.File? imageFile,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Add all form fields
    request.fields.addAll(
      mahasiswa.toJson().map((k, v) => MapEntry(k, v ?? '')),
    );

    // Handle image file for web
    if (imageFile != null) {
      // Convert the file to bytes
      final reader = html.FileReader();
      reader.readAsArrayBuffer(imageFile);
      await reader.onLoad.first;

      // Add file to request
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          reader.result as List<int>,
          filename: imageFile.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      final data = await http.Response.fromStream(response);
      mahasiswaList.add(Mahasiswa.fromJson(json.decode(data.body)));
    } else {
      throw Exception("Failed to save data: ${response.statusCode}");
    }
  }

  // Mobile implementation for adding a student
  Future<void> _addMahasiswaMobile(Mahasiswa mahasiswa, File? imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields.addAll(
      mahasiswa.toJson().map((k, v) => MapEntry(k, v ?? '')),
    );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      final data = await http.Response.fromStream(response);
      mahasiswaList.add(Mahasiswa.fromJson(json.decode(data.body)));
    } else {
      throw Exception("Failed to save data: ${response.statusCode}");
    }
  }

  // Method for updating a student
  Future<void> updateMahasiswa(
    int id,
    Mahasiswa mahasiswa,
    dynamic imageFile,
  ) async {
    try {
      isLoading(true);
      if (kIsWeb) {
        await _updateMahasiswaWeb(id, mahasiswa, imageFile);
      } else {
        await _updateMahasiswaMobile(id, mahasiswa, imageFile);
      }
    } catch (e) {
      print('Error updateMahasiswa: $e');
      throw Exception("Failed to update data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Web implementation for updating a student
  Future<void> _updateMahasiswaWeb(
    int id,
    Mahasiswa mahasiswa,
    html.File? imageFile,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/$id?_method=PUT'),
    );

    request.fields.addAll(
      mahasiswa.toJson().map((k, v) => MapEntry(k, v ?? '')),
    );

    if (imageFile != null) {
      // Convert the file to bytes
      final reader = html.FileReader();
      reader.readAsArrayBuffer(imageFile);
      await reader.onLoad.first;

      // Add file to request
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          reader.result as List<int>,
          filename: imageFile.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final data = await http.Response.fromStream(response);
      final updated = Mahasiswa.fromJson(json.decode(data.body));

      final index = mahasiswaList.indexWhere((m) => m.id == id);
      if (index != -1) {
        mahasiswaList[index] = updated;
      }
    } else {
      throw Exception("Failed to update data: ${response.statusCode}");
    }
  }

  // Mobile implementation for updating a student
  Future<void> _updateMahasiswaMobile(
    int id,
    Mahasiswa mahasiswa,
    File? imageFile,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/$id?_method=PUT'),
    );

    request.fields.addAll(
      mahasiswa.toJson().map((k, v) => MapEntry(k, v ?? '')),
    );

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final data = await http.Response.fromStream(response);
      final updated = Mahasiswa.fromJson(json.decode(data.body));

      final index = mahasiswaList.indexWhere((m) => m.id == id);
      if (index != -1) {
        mahasiswaList[index] = updated;
      }
    } else {
      throw Exception("Failed to update data: ${response.statusCode}");
    }
  }

  // Method for deleting a student
  Future<void> deleteMahasiswa(int id) async {
    try {
      isLoading(true);
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 204) {
        mahasiswaList.removeWhere((m) => m.id == id);
      } else {
        throw Exception('Failed to delete student data');
      }
    } catch (e) {
      print('Error deleteMahasiswa: $e');
    } finally {
      isLoading(false);
    }
  }

  // Method to pick image from web
  Future<html.File?> pickImageWeb() async {
    if (kIsWeb) {
      try {
        final media = await ImagePickerWeb.getImageInfo;
        if (media != null) {
          // Convert media to html.File
          final blob = html.Blob([media.data!]);
          final file = html.File([blob], media.fileName!);
          return file;
        }
      } catch (e) {
        print('Error picking web image: $e');
      }
    }
    return null;
  }

  // Method to pick image from mobile
  Future<File?> pickImageMobile() async {
    if (!kIsWeb) {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          return File(pickedFile.path);
        }
      } catch (e) {
        print('Error picking mobile image: $e');
      }
    }
    return null;
  }
}
