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

class EditMahasiswaView extends StatefulWidget {
  final int id;
  const EditMahasiswaView({super.key, required this.id});

  @override
  State<EditMahasiswaView> createState() => _EditMahasiswaViewState();
}

class _EditMahasiswaViewState extends State<EditMahasiswaView> {
  final MahasiswaController controller = Get.find();

  late Mahasiswa mahasiswa;
  // This will be either File (mobile) or html.File (web)
  dynamic _pickedImage;
  String? _previewUrl;

  final namaC = TextEditingController();
  final npmC = TextEditingController();
  final emailC = TextEditingController();
  final tempatLahirC = TextEditingController();
  final tanggalLahirC = TextEditingController();
  final sexC = TextEditingController();
  final alamatC = TextEditingController();
  final telpC = TextEditingController();

  @override
  void initState() {
    super.initState();
    mahasiswa = controller.mahasiswaList.firstWhere((m) => m.id == widget.id);
    namaC.text = mahasiswa.nama;
    npmC.text = mahasiswa.npm;
    emailC.text = mahasiswa.email;
    tempatLahirC.text = mahasiswa.tempatLahir;
    tanggalLahirC.text = mahasiswa.tanggalLahir;
    sexC.text = mahasiswa.sex;
    alamatC.text = mahasiswa.alamat;
    telpC.text = mahasiswa.telp;
  }

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
      Get.snackbar("Validasi", "Nama, NPM, dan Email wajib diisi");
      return;
    }

    final updated = Mahasiswa(
      id: widget.id,
      nama: namaC.text,
      npm: npmC.text,
      email: emailC.text,
      tempatLahir: tempatLahirC.text,
      tanggalLahir: tanggalLahirC.text,
      sex: sexC.text,
      alamat: alamatC.text,
      telp: telpC.text,
      photo: mahasiswa.photo, // keep existing photo if not changed
    );

    controller
        .updateMahasiswa(widget.id, updated, _pickedImage)
        .then((_) {
          Get.back();
          Get.snackbar("Sukses", "Data berhasil diperbarui");
        })
        .catchError((e) {
          Get.snackbar("Gagal", "Gagal update data: $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://127.0.0.1:8000/uploads_avatar/${mahasiswa.photo}';

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Mahasiswa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _getImagePreview(imageUrl),
            ),
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
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Simpan Perubahan"),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _getImagePreview(String existingImageUrl) {
    if (_pickedImage != null) {
      if (kIsWeb && _previewUrl != null) {
        // Web image preview for newly selected image
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(_previewUrl!),
        );
      } else if (!kIsWeb) {
        // Mobile image preview for newly selected image
        return CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(_pickedImage),
        );
      }
    }
    
    // Existing image or default
    return CircleAvatar(
      radius: 50,
      backgroundImage:
          mahasiswa.photo != null ? NetworkImage(existingImageUrl) : null,
      backgroundColor: Colors.grey[300],
      child: mahasiswa.photo == null ? const Icon(Icons.camera_alt, size: 30) : null,
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