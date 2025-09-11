extension StringExtension on String? {
  String toPhone() {
    if (this == null) return '';

    String digitsOnly = this!.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length != 11) return '';

    return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 7)} ${digitsOnly.substring(7, 11)}';
  }
}
