class TextUtils {
  static final RegExp _whiteSpaces = RegExp('\\s+');
  static final RegExp _onlyLetters = RegExp('^[A-Za-z ]+\$'); 

  static List<String> splitIntoWords(String text) {
    return text.split(_whiteSpaces);
  }

  static bool isNumeric(String text) {
    if( text.isEmpty ) return false;
    final n = int.tryParse(text);
    return (n==null) ? false : true;
  }

  static bool isAllLetters(String text) {
    if(text.isEmpty ) return false;
    return _onlyLetters.hasMatch(text);
  }

  static bool areNamesInText(String text, List<String> words) {
    bool containsAll = true;
    for (String word in words) {
      if(!text.contains(' $word')) { containsAll = false; break; }
    }
    return containsAll;
  }

}