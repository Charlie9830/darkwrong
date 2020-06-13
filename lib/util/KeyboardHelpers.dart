import 'package:flutter/services.dart';

bool escapeDown(RawKeyDownEvent rawKey) {
  return rawKey.logicalKey == LogicalKeyboardKey.escape;
}

bool backspaceDown(RawKeyDownEvent rawKey) {
  return rawKey.logicalKey == LogicalKeyboardKey.backspace;
}

bool enterDown(RawKeyDownEvent rawKey) {
  return rawKey.logicalKey == LogicalKeyboardKey.enter ||
      rawKey.logicalKey == LogicalKeyboardKey.numpadEnter;
}
