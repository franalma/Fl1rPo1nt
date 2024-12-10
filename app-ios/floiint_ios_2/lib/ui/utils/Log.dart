import 'package:logger/logger.dart';

class Log {
  static final logger = Logger();

  static void d(String message) {
    logger.d(message); // Debug
  }
}
