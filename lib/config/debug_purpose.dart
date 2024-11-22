
// ANSI color codes
import 'package:flutter/foundation.dart';

const String reset = '\x1B[0m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';

// Method to print green text
void printGreen(var message) {
  if (kDebugMode) {
    print('$green$message$reset');
  }
}

// Method to print red text
void printRed(var message) {
  if (kDebugMode) {
    print('$red$message$reset');
  }
}

// Method to print yellow text
void printYellow(var message) {
  if (kDebugMode) {
    print('$yellow$message$reset');
  }
}


void printBlue(String message) {
if (kDebugMode) {
  print('\x1B[34m$message\x1B[0m');
} // ANSI escape codes for blue text
}