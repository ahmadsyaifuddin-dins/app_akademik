import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/mahasiswa_view.dart';
import 'views/add_mahasiswa_view.dart';
import 'views/edit_mahasiswa_view.dart';

void main() {
  runApp(AkademikApp());
}

class AkademikApp extends StatelessWidget {
  const AkademikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Akademik App',
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
