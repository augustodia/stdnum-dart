class StdnumDartUtils {
  static bool isOnlyDigits(String string) {
    final regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(string);
  }
}
