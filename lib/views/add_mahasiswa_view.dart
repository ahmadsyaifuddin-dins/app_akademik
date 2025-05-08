// AddMahasiswaView - Enhanced UI
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/mahasiswa_controller.dart';
import '../models/mahasiswa.dart';

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
  String selectedSex = 'L';
  final alamatC = TextEditingController();
  final telpC = TextEditingController();

  final Map<String, String> sexOptions = {
    'L': 'Laki-laki',
    'P': 'Perempuan',
  };
  
  final _formKey = GlobalKey<FormState>();

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
              primary: Colors.green.shade600,
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newMhs = Mahasiswa(
      nama: namaC.text,
      npm: npmC.text,
      email: emailC.text,
      tempatLahir: tempatLahirC.text,
      tanggalLahir: tanggalLahirC.text,
      sex: selectedSex,
      alamat: alamatC.text,
      telp: telpC.text,
    );

    controller
        .addMahasiswa(newMhs)
        .then((_) {
          Get.back();
          Get.snackbar(
            "Sukses", 
            "Data berhasil ditambahkan",
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
            "Error", 
            "Gagal menambah data: $e",
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
        title: const Text("Tambah Mahasiswa"),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
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
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person_add, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Informasi Pribadi"),
                    _textFormField(
                      "Nama Lengkap", 
                      namaC, 
                      Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    _textFormField(
                      "NPM", 
                      npmC, 
                      Icons.badge,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NPM tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    _textFormField(
                      "Email", 
                      emailC, 
                      Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@')) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Tempat & Tanggal Lahir"),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _textFormField(
                            "Tempat Lahir", 
                            tempatLahirC, 
                            Icons.location_city,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                activeColor: Colors.green.shade600,
                                contentPadding: EdgeInsets.zero,
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle("Kontak & Alamat"),
                    _textFormField(
                      "No. Telepon", 
                      telpC, 
                      Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
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
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _submit,
                                icon: const Icon(Icons.save),
                                label: const Text(
                                  "SIMPAN DATA",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
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
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _textFormField(
    String label, 
    TextEditingController ctrl, 
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
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
