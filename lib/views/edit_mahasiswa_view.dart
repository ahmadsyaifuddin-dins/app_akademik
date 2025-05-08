import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mahasiswa_controller.dart';
import '../models/mahasiswa.dart';

class EditMahasiswaView extends StatefulWidget {
  final int id;
  const EditMahasiswaView({Key? key, required this.id}) : super(key: key);

  @override
  State<EditMahasiswaView> createState() => _EditMahasiswaViewState();
}

class _EditMahasiswaViewState extends State<EditMahasiswaView> {
  final MahasiswaController controller = Get.find();
  late Mahasiswa mahasiswa;

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
      photo: mahasiswa.photo,
    );

    controller
        .updateMahasiswa(widget.id, updated)
        .then((_) {
          Get.back();
          Get.snackbar("Sukses", "Data berhasil diperbarui");
        })
        .catchError((e) {
          Get.snackbar("Gagal", "Gagal update data: \$e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Mahasiswa")),
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
                        child: const Text("Simpan Perubahan"),
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
