import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../controllers/mahasiswa_controller.dart';
import '../models/mahasiswa.dart';

// For Web
import 'package:universal_html/html.dart' as html;
import 'package:image_picker_web/image_picker_web.dart';

// For Mobile
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:image_picker/image_picker.dart';

class AddMahasiswaView extends StatefulWidget {
  const AddMahasiswaView({super.key});

  @override
  State<AddMahasiswaView> createState() => _AddMahasiswaViewState();
}

class _AddMahasiswaViewState extends State<AddMahasiswaView> {
  final MahasiswaController controller = Get.find();

  final namaC = TextEditingController();
  final npmC = TextEditingController();
  final emailC = TextEditingController();
  final tempatLahirC = TextEditingController();
  final tanggalLahirC = TextEditingController();
  final sexC = TextEditingController();
  final alamatC = TextEditingController();
  final telpC = TextEditingController();

  // This will be either File (mobile) or html.File (web)
  dynamic _pickedImage;
  String? _previewUrl;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web implementation
      final picked = await ImagePickerWeb.getImageInfo;
      if (picked != null) {
        final blob = html.Blob([picked.data!]);
        final file = html.File([blob], picked.fileName!);

        setState(() {
          _pickedImage = file;
          // Create a URL for preview
          _previewUrl = html.Url.createObjectUrlFromBlob(blob);
        });
      }
    } else {
      // Mobile implementation
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
          _previewUrl = null;
        });
      }
    }
  }

  void _submit() {
    if (namaC.text.isEmpty || npmC.text.isEmpty || emailC.text.isEmpty) {
      Get.snackbar("Validasi", "Nama, NPM dan Email wajib diisi");
      return;
    }

    final newMhs = Mahasiswa(
      nama: namaC.text,
      npm: npmC.text,
      email: emailC.text,
      tempatLahir: tempatLahirC.text,
      tanggalLahir: tanggalLahirC.text,
      sex: sexC.text,
      alamat: alamatC.text,
      telp: telpC.text,
      photo: null,
    );

    controller
        .addMahasiswa(newMhs, _pickedImage)
        .then((_) {
          Get.back();
          Get.snackbar("Sukses", "Data berhasil ditambahkan");
        })
        .catchError((e) {
          Get.snackbar("Error", "Gagal menambah data: $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Mahasiswa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(onTap: _pickImage, child: _getImagePreview()),
            const SizedBox(height: 20),
            _inputField("Nama", namaC),
            _inputField("NPM", npmC),
            _inputField("Email", emailC),
            _inputField("Tempat Lahir", tempatLahirC),
            _inputField("Tanggal Lahir", tanggalLahirC),
            _inputField("Jenis Kelamin", sexC),
            _inputField("Alamat", alamatC),
            _inputField("No. Telepon", telpC),
            const SizedBox(height: 20),
            Obx(
              () =>
                  controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Simpan"),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImagePreview() {
    if (_pickedImage != null) {
      if (kIsWeb && _previewUrl != null) {
        // Web image preview
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(_previewUrl!),
        );
      } else if (!kIsWeb) {
        // Mobile image preview
        return CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(_pickedImage),
        );
      }
    }

    // Default avatar when no image is selected
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[300],
      child: const Icon(Icons.camera_alt, size: 30),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
