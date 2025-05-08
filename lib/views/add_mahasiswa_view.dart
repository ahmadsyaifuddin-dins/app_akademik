import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mahasiswa_controller.dart';
import '../models/mahasiswa.dart';

// Halaman Tambah Mahasiswa tanpa upload foto
class AddMahasiswaView extends StatefulWidget {
  const AddMahasiswaView({Key? key}) : super(key: key);

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

  void _submit() {
    if (namaC.text.isEmpty || npmC.text.isEmpty || emailC.text.isEmpty) {
      Get.snackbar("Validasi", "Nama, NPM, dan Email wajib diisi");
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
    );

    controller
        .addMahasiswa(newMhs)
        .then((_) {
          Get.back();
          Get.snackbar("Sukses", "Data berhasil ditambahkan");
        })
        .catchError((e) {
          Get.snackbar("Error", "Gagal menambah data: \$e");
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

  Widget _inputField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
