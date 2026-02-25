import 'package:cloud_firestore/cloud_firestore.dart';

class JsonParsingHelper {
  JsonParsingHelper._(); // fazendo isso eu não preciso ficar instaciando a classe com JsonParsingHelper()
  static String? optionalString(dynamic key) {
    if (key == null) {
      return null;
    }
    if (key is String) {
      final trimed = key.trim();
      return trimed.isEmpty ? null : trimed;
    }
    final parserd = key.toString().trim();
    return parserd.isEmpty ? null : parserd;
  }

  static String stringOrEmtpy(dynamic key) {
    return optionalString(key) ?? '';
  }

  static String requiredString(Map<String, dynamic> json, String key) {
    final value = optionalString(json[key]);
    if (value == null) {
      throw FormatException('O campo "$key" é obrigatório');
    }
    return value;
  }

  static DateTime requiredDate(dynamic rawDate, {String key = 'date'}) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }
    if (rawDate is DateTime) {
      return rawDate;
    }
    if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate);
    }
    if (rawDate is String) {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException('O campo "$key" deve ser uma data válida');
  }

  static int? optionalInt(dynamic key) {
    if (key == null) {
      return null;
    }
    if (key is int) {
      return key;
    }
    return int.tryParse(key.toString());
  }

  static int requiredInt(Map<String, dynamic> json, String key) {
    final value = optionalInt(json[key]);
    if (value == null) {
      throw Exception('O campo "$key" é obrigatório');
    }
    return value;
  }

  static bool? optionalBool(dynamic key) {
    if (key == null) {
      return null;
    }
    if (key is bool) {
      return key;
    }
    if (key is String) {
      final boo = key.toLowerCase().trim();
      if (boo == 'true' || boo == '1') {
        return true;
      }
      if (boo == 'false' || boo == '0') {
        return false;
      }
    }
    return null;
  }

  static double? optionalDouble(dynamic key) {
    if (key == null) {
      return null;
    }
    if (key is double) {
      return key;
    }
    return double.tryParse(key.toString());
  }

  static double requiredDouble(Map<String, dynamic> json, String key) {
    final value = optionalDouble(json[key]);
    if (value == null) {
      throw FormatException('O campo "$key" é obrigatório');
    }
    return value;
  }

  static bool requiredBool(Map<String, dynamic> json, String key) {
    final value = optionalBool(json[key]);
    if (value == null) {
      throw Exception('O campo "$key" é obrigatório');
    }
    return value;
  }

  static List<String> stringListOrEmpty(dynamic key) {
    if (key == null) {
      return [];
    }
    if (key is List<String>) {
      return key;
    }
    if (key is List<dynamic>) {
      return key.map((i) => i.toString()).toList();
    }
    return [];
  }
}
