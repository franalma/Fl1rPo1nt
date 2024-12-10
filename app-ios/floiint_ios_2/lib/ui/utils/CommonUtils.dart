class CommonUtils {
  static int colorToInt(String value) {
    value = value.replaceAll("#", "");
    int colorInt = int.parse(value, radix: 16)| 0xFF000000;
    
    return colorInt;
  }
}
