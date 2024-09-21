// validation_utils.dart

class ValidationUtils {
  static String? validateWebsiteUrl(String? value) {
    final pattern = r'^(https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(:[0-9]{1,5})?(\/.*)?$';
    RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'URL cannot be empty';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid URL';
    } else {
      return null;
    }
  }
}
