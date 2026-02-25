import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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

  static String stringOrEmpy(dynamic key) {
    return optionalString(key) ?? '';
  }

  static String requiredString(Map<String, dynamic> json, String key) {
    final value = optionalString(json[key]);
    if (value == null) {
      throw FormatException('O campo "$key" é obrigatório');
    }
    return value;
  }

  static DateTime requiredDAte(dynamic rawDate, {String key = 'date'}) {
    if (rawDate is Timestamp) {
      return rawDate.toDate();
    }
    if (rawDate is DateTime) {
      return rawDate;
    }
    if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate);

    }
    if(rawDate is String){
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException('O campo "$key" deve ser uma data válida');
    
  }
}
