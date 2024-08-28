class ApiConstants {
  static const HOST = "https://localhost:5001/api/v1";
}

class RegexConstants {
  static const NZPHONEREGEX =
      r'^(((\+?64\s*[-\.]?[3-9]|\(?0[3-9]\)?)\s*[-\.]?\d{3}\s*[-\.]?\d{4})|((\+?64\s*[-\.\(]?2\d{1}[-\.\)]?|\(?02\d{1}\)?)\s*[-\.]?\d{3}\s*[-\.]?\d{3,5})|((\+?64\s*[-\.]?[-\.\(]?800[-\.\)]?|[-\.\(]?0800[-\.\)]?)\s*[-\.]?\d{3}\s*[-\.]?(\d{2}|\d{5})))$';
  static const NZPLATEREGEX =
      r'^(\b(?=[a-zA-Z]*\d)(?=\d*[a-zA-Z])[a-zA-Z\d]{6}\b)$';
}
