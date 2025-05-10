// EditMahasiswaView - Enhanced UI
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/mahasiswa_controller.dart';
import '../models/mahasiswa.dart';

class EditMahasiswaView extends StatefulWidget {
  final int id;
  const EditMahasiswaView({super.key, required this.id});

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
  String selectedSex = 'L';
  final alamatC = TextEditingController();
  final telpC = TextEditingController();

  final Map<String, String> sexOptions = {
    'L': 'Laki-laki',
    'P': 'Perempuan',
  };

  @override
  void initState() {
    super.initState();
    mahasiswa = controller.mahasiswaList.firstWhere((m) => m.id == widget.id);
    namaC.text = mahasiswa.nama;
    npmC.text = mahasiswa.npm;
    emailC.text = mahasiswa.email;
    tempatLahirC.text = mahasiswa.tempatLahir;
    tanggalLahirC.text = mahasiswa.tanggalLahir;
    selectedSex = mahasiswa.sex; // Will be 'L' or 'P' from the database
    alamatC.text = mahasiswa.alamat;
    telpC.text = mahasiswa.telp;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tanggalLahirC.text.isNotEmpty 
          ? _parseDate(tanggalLahirC.text)
          : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        // Format as YYYY-MM-DD for MySQL
        tanggalLahirC.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  
  DateTime _parseDate(String dateStr) {
    try {
      // Try to parse the date regardless of format
      return DateTime.parse(dateStr);
    } catch (e) {
      // If parsing fails, return today's date
      return DateTime.now();
    }
  }

  void _submit() {
    if (namaC.text.isEmpty || npmC.text.isEmpty || emailC.text.isEmpty) {
      Get.snackbar(
        "Validasi", 
        "Nama, NPM, dan Email wajib diisi",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final updated = Mahasiswa(
      id: widget.id,
      nama: namaC.text,
      npm: npmC.text,
      email: emailC.text,
      tempatLahir: tempatLahirC.text,
      tanggalLahir: tanggalLahirC.text,
      sex: selectedSex,
      alamat: alamatC.text,
      telp: telpC.text,
      photo: mahasiswa.photo,
    );

    controller
        .updateMahasiswa(widget.id, updated)
        .then((_) {
          Get.back();
          Get.snackbar(
            "Sukses", 
            "Data berhasil diperbarui",
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check_circle, color: Colors.green),
          );
        })
        .catchError((e) {
          Get.snackbar(
            "Gagal", 
            "Gagal update data: $e",
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade800,
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error, color: Colors.red),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Mahasiswa"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle("Informasi Pribadi"),
                  _inputField(
                    "Nama Lengkap", 
                    namaC, 
                    Icons.person,
                    isRequired: true
                  ),
                  _inputField(
                    "NPM", 
                    npmC, 
                    Icons.badge,
                    isRequired: true
                  ),
                  _inputField(
                    "Email", 
                    emailC, 
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle("Tempat & Tanggal Lahir"),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _inputField(
                          "Tempat Lahir", 
                          tempatLahirC, 
                          Icons.location_city
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: IgnorePointer(
                            child: TextField(
                              controller: tanggalLahirC,
                              decoration: InputDecoration(
                                labelText: "Tanggal Lahir",
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle("Jenis Kelamin"),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: sexOptions.entries.map((entry) => Expanded(
                            child: RadioListTile<String>(
                              title: Text(entry.value),
                              value: entry.key,
                              groupValue: selectedSex,
                              onChanged: (value) {
                                setState(() {
                                  selectedSex = value!;
                                });
                              },
                              activeColor: Colors.blue.shade800,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _sectionTitle("Kontak & Alamat"),
                  _inputField(
                    "No. Telepon", 
                    telpC, 
                    Icons.phone,
                    keyboardType: TextInputType.phone
                  ),
                  TextField(
                    controller: alamatC,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 45),
                        child: Icon(Icons.home),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                "SIMPAN PERUBAHAN",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _inputField(
    String label, 
    TextEditingController ctrl, 
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: isRequired ? "$label *" : label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}