import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class StorageService {
  static const String key = "notes";

  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList(key) ?? [];

    return data.map((e) => Note.fromJson(json.decode(e))).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data =
    notes.map((e) => json.encode(e.toJson())).toList();

    await prefs.setStringList(key, data);
  }
}