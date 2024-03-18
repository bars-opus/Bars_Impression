import 'package:bars/utilities/exports.dart';

class Utils {
  // Utility method for safely getting a vibrant color from a palette
  static Color getPaletteVibrantColor(
      PaletteGenerator? palette, Color defaultColor) {
    // Check if palette is null
    if (palette == null) {
      return defaultColor;
    }

    // Check if vibrantColor is non-null and has a valid color
    if (palette.vibrantColor != null && palette.vibrantColor!.color != null) {
      return palette.vibrantColor!.color;
    }

    return palette.vibrantColor?.color ?? defaultColor;
  }

  // Utility method for safely getting a vibrant color from a palette
  static Color getPaletteDarkMutedColor(
      PaletteGenerator? palette, Color defaultColor) {
    // Check if palette is null
    if (palette == null) {
      return defaultColor;
    }

    // Check if vibrantColor is non-null and has a valid color
    if (palette.darkMutedColor != null &&
        palette.darkMutedColor!.color != null) {
      return palette.darkMutedColor!.color;
    }

    return palette.darkMutedColor?.color ?? defaultColor;
  }

  // Utility method for safely getting a vibrant color from a palette
  static Color getPaletteDominantColor(
      PaletteGenerator? palette, Color defaultColor) {
    // Check if palette is null
    if (palette == null) {
      return defaultColor;
    }

    // Check if vibrantColor is non-null and has a valid color
    if (palette.dominantColor != null && palette.dominantColor!.color != null) {
      return palette.dominantColor!.color;
    }

    return palette.dominantColor?.color ?? defaultColor;
  }

  // Utility method for safely getting a substring
  static String safeSubstring(String? value, int start, int end) {
    // Check if the string is null or shorter than the starting index
    if (value == null || value.length <= start) {
      return ''; // Return an empty string or some default value
    }

    // If the string is shorter than the end index, use the available length
    if (value.length < end) {
      return value.substring(start);
    }
    return value.length < end
        ? value.substring(start)
        : value.substring(start, end);
  }
}
