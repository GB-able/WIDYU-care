class Validators {
  static String? chainValidators(
      String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "이메일을 입력해주세요.";
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return "이메일 형식이 충족되지 않았어요.";
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "연락처를 입력해주세요.";
    } else if (value.length != 13) {
      return "연락처는 11자리로 입력해주세요.";
    }
    return null;
  }

  static String? birthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "생년월일을 입력해주세요.";
    } else if (value.length != 12) {
      return "생년월일은 8자리로 입력해주세요.";
    }
    return null;
  }

  static String? emptyValidator(String? value, {String data = "값을"}) {
    if (value == null || value.isEmpty) {
      return "$data 입력해주세요.";
    }
    return null;
  }
}
