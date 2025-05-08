import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/mahasiswa_view.dart';
import 'views/add_mahasiswa_view.dart';
import 'views/edit_mahasiswa_view.dart';

void main() {
  runApp(BiodataApp());
}

class BiodataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mahasiswa App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MahasiswaView()),
        GetPage(name: '/add-mahasiswa', page: () => AddMahasiswaView()),
        GetPage(
          name: '/edit-mahasiswa/:id',
          page: () => EditMahasiswaView(id: int.parse(Get.parameters['id']!)),
        ),
      ],
    );
  }
}
