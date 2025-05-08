// Create a file named lib/utils/file_helper.dart

import 'package:flutter/foundation.dart' show kIsWeb;

// Import dart:io or a web alternative based on platform
import 'dart:io' if (dart.library.html) 'package:file/file.dart';
import 'package:image_picker/image_picker.dart';

// For Web
import 'package:universal_html/html.dart' as html;
import 'package:image_picker_web/image_picker_web.dart';

class FileHelper {
  // Pick image for mobile
  static Future<dynamic> pickImageMobile() async {
    if (kIsWeb) return null;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File.fromUri(Uri.parse(pickedFile.path));
    }
    return null;
  }

  // Pick image for web
  static Future<html.File?> pickImageWeb() async {
    if (!kIsWeb) return null;

    final media = await ImagePickerWeb.getImageInfo;
    if (media != null) {
      final blob = html.Blob([media.data!]);
      final file = html.File([blob], media.fileName!);
      return file;
    }
    return null;
  }

  // General method that works for both platforms
  static Future<dynamic> pickImage() async {
    if (kIsWeb) {
      return await pickImageWeb();
    } else {
      return await pickImageMobile();
    }
  }

  // Create preview URL for web images
  static String? createPreviewUrl(dynamic file) {
    if (kIsWeb && file is html.File) {
      return html.Url.createObjectUrlFromBlob(file);
    }
    return null;
  }
}
