import 'package:bars/utilities/exports.dart';

class PickCropCamera {
  static Future<File?> pickedMedia({
    required Future<File> Function(File file) cropImage,
  }) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) return null;
    // ignore: unnecessary_null_comparison
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      return cropImage(file);
    }
  }
}
