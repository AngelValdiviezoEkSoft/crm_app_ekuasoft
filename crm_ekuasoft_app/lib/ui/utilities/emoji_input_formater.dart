import 'package:flutter/services.dart';

class EmojiInputFormatter extends TextInputFormatter {
  /*
  static final RegExp _emojiRegex = RegExp(
    r'[\u{1F600}-\u{1F64F}]|' // Emoticonos
    r'[\u{1F300}-\u{1F5FF}]|' // Símbolos y pictogramas
    r'[\u{1F680}-\u{1F6FF}]|' // Transporte y símbolos
    r'[\u{1F700}-\u{1F77F}]|' // Alquimia
    r'[\u{1F780}-\u{1F7FF}]|' // Geometría
    r'[\u{1F800}-\u{1F8FF}]|' // Complementos
    r'[\u{2600}-\u{26FF}]|'   // Símbolos misceláneos
    r'[\u{2700}-\u{27BF}]',   // Dingbats
    unicode: true,
  );
  */

  static final RegExp _emojiRegex = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String filteredText = newValue.text.replaceAll(_emojiRegex, '');
    return TextEditingValue(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}
