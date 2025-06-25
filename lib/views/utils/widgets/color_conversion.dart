int stringToColorInt(String hexString) {
  final int hex = int.parse(hexString.substring(1), radix: 16);
  return hex | 0xFF000000;
}
