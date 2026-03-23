class SchoolContext {
  SchoolContext._();

  static String? _currentSchoolId;

  static String? get currentSchoolId => _currentSchoolId;

  static bool get hasSchool =>
      _currentSchoolId != null && _currentSchoolId!.trim().isNotEmpty;

  static void setSchool(String? schoolId) {
    final sanitized = schoolId?.trim();
    _currentSchoolId =
        sanitized == null || sanitized.isEmpty ? null : sanitized;
  }

  static void clear() {
    _currentSchoolId = null;
  }
}
