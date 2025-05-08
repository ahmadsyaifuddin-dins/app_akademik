import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mahasiswa_controller.dart';
import 'package:flutter/cupertino.dart';

class MahasiswaView extends StatelessWidget {
  MahasiswaView({super.key});
  final MahasiswaController controller = Get.put(MahasiswaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Data Mahasiswa",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan navigasi ke halaman tambah mahasiswa
          Get.toNamed('/add-mahasiswa');
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.mahasiswaList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 20),
                  Text(
                    "Memuat data mahasiswa...",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.mahasiswaList.length,
                itemBuilder: (context, index) {
                  final mahasiswa = controller.mahasiswaList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header dengan nama
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              mahasiswa.photo != null
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      'http://127.0.0.1:8000/uploads_avatar/${mahasiswa.photo}',
                                    ),
                                    radius: 22,
                                  )
                                  : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 22,
                                    child: Text(
                                      mahasiswa.nama
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mahasiswa.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "NPM: ${mahasiswa.npm}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Body dengan informasi mahasiswa
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.email_outlined,
                                "Email",
                                mahasiswa.email,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.location_city_outlined,
                                "Tempat Lahir",
                                mahasiswa.tempatLahir,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.calendar_today_outlined,
                                "Tanggal Lahir",
                                mahasiswa.tanggalLahir,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                mahasiswa.sex == 'L'
                                    ? Icons.male_outlined
                                    : Icons.female_outlined,
                                "Jenis Kelamin",
                                mahasiswa.sex,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.home_outlined,
                                "Alamat",
                                mahasiswa.alamat,
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.phone_outlined,
                                "Nomor Telepon",
                                mahasiswa.telp,
                              ),
                            ],
                          ),
                        ),

                        // Footer dengan action buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Tombol Edit
                              TextButton.icon(
                                onPressed: () {
                                  // Implementasi edit mahasiswa
                                  if (mahasiswa.id != null) {
                                    Get.toNamed(
                                      '/edit-mahasiswa/${mahasiswa.id}',
                                    );
                                  }
                                },
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: const Text("Edit"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue.shade700,
                                ),
                              ),
                              // Tombol Hapus
                              TextButton.icon(
                                onPressed: () {
                                  _showDeleteConfirmation(
                                    context,
                                    mahasiswa.id!,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                label: const Text("Hapus"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  // Widget untuk membuat baris informasi
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus Mahasiswa"),
            content: const Text("Yakin ingin menghapus data mahasiswa ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller
                      .deleteMahasiswa(id)
                      .then((_) {
                        Navigator.pop(context); // tutup dialog
                        Get.snackbar(
                          "Sukses",
                          "Data berhasil dihapus",
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.green.shade900,
                        );
                      })
                      .catchError((e) {
                        Navigator.pop(context);
                        Get.snackbar(
                          "Gagal",
                          "Gagal hapus data: $e",
                          backgroundColor: Colors.red.shade100,
                          colorText: Colors.red.shade900,
                        );
                      });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );
  }
}
