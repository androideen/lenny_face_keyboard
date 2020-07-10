import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:lennyfacekeyboard/models/emoji.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static const EMOJI_ASSET_FOLDER = 'assets/emoji/';
  static const EMOJI_CUSTOM_FILENAME =
      'emoji_custom.txt'; //store user-define emoji
  static const EMOJI_RECENT_FILENAME = 'emoji_recent.txt'; //store latest 100

  Future<List<Emoji>> loadEmojiAsList(String category) async {
    String emojiString = await loadEmojiString(category);
    return stringToEmoji(emojiString);
  }

  List<Emoji> stringToEmoji(String emojiString) {
    final emojis = List<Emoji>();
    List<String> lines = LineSplitter.split(emojiString).toList();
    lines.forEach((element) {
      emojis.add(Emoji(element.trim()));
    });
    return emojis;
  }

  Future<String> loadEmojiString(String category) async {
    if (category == 'recent') {
      return await loadFromRecent();
    } else if (category == 'custom') {
      return await loadFromCustom();
    } else {
      return await rootBundle
          .loadString(EMOJI_ASSET_FOLDER + 'emoji_$category.txt');
    }
  }

  saveToCustom(String emoji) async {
    await _checkAndSaveFile(EMOJI_CUSTOM_FILENAME, emoji, 10000);
  }

  saveToRecent(String emoji) async {
    await _checkAndSaveFile(EMOJI_RECENT_FILENAME, emoji, 100);
  }

  _checkAndSaveFile(String fileName, String newEmoji, int limit) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    final old = file.readAsStringSync();

    //remove out of limit emoji and add new one to top of the list
    List<Emoji> emojies = stringToEmoji(old);
    if (emojies.length > limit) {
      emojies.removeLast();
    }
    List<String> text = List<String>();
    text.add(newEmoji);
    for (var e in emojies) {
      if (e.text != newEmoji) {
        text.add(e.text);
      }
    }
    await file.writeAsString(text.join("\n"));
  }

  Future<String> loadFromCustom() async {
    return await _loadFromAppFile(EMOJI_CUSTOM_FILENAME);
  }

  Future<String> loadFromRecent() async {
    return await _loadFromAppFile(EMOJI_RECENT_FILENAME);
  }

  Future<String> _loadFromAppFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    final exist = await file.exists();
    if (exist) {
      return file.readAsStringSync();
    } else {
      file.writeAsStringSync('', mode: FileMode.write);
      return '';
    }
  }

  Future delete(String category, String emoji) async{
    await _deleteEmoji(category, 'emoji_$category.txt', emoji);
  }

  _deleteEmoji(String category, String fileName, String emoji) async{
    List<Emoji> emojies = await loadEmojiAsList(category);
    List<String> text = List<String>();
    for (var e in emojies) {
      if (e.text != emoji) {
        text.add(e.text);
      }
    }
    //save emojies to file
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    print('${directory.path}/$fileName');
    await file.writeAsString(text.join("\n"));
  }
}
