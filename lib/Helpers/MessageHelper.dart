import 'dart:async';
import 'dart:convert' show utf8, json;

import 'package:filcnaplo/Helpers/RequestHelper.dart';

import 'package:filcnaplo/Datas/Message.dart';
import 'package:filcnaplo/Datas/User.dart';
import 'package:filcnaplo/Helpers/DBHelper.dart';

class MessageHelper {
  Future<List<Message>> getMessages(User user, bool showErrors) async {
    List<Message> messages = new List();
    try {
      String code = await RequestHelper().getBearerToken(user, showErrors);
      String messageSting =
          await RequestHelper().getMessages(code, user.schoolCode);
      var messagesJson = json.decode(messageSting);
      DBHelper().addMessagesJson(messagesJson, user);

      for (var messageElement in messagesJson) {
        if (messageElement["uzenet"] != null) {
          Message message = Message.fromJson(messageElement);
          messages.add(message);
        }
      }
      messages.sort((Message a, Message b) => b.date.compareTo(a.date));
    } catch (e) {
      print("[E] MessageHelper.getMessages(): " + e.toString());
    }

    return messages;
  }

  Future<List<Message>> getMessagesOffline(User user) async {
    List<Message> messages = new List();
    try {
      List messagesJson = await DBHelper().getMessagesJson(user);

      for (var messageElement in messagesJson) {
        if (messageElement["uzenet"] != null) {
          Message message = Message.fromJson(messageElement);
          messages.add(message);
        }
      }
      messages.sort((Message a, Message b) => b.date.compareTo(a.date));
    } catch (e) {
      print("[E] MessageHelper.getMessagesOffline(): " + e.toString());
    }

    return messages;
  }

  Future<Message> getMessageById(User user, int id) async {
    Message message;
    try {
      String code = await RequestHelper().getBearerToken(user, true);
      String messageSting =
          await RequestHelper().getMessageById(id, code, user.schoolCode);
      var messagesJson = json.decode(messageSting);
      DBHelper().addMessageByIdJson(id, messagesJson, user);

      message = Message.fromJson(messagesJson);
    } catch (e) {
      print("[E] MessageHelper.getMessageById(): " + e.toString());
    }

    return message;
  }

  Future<Message> getMessageByIdOffline(User user, int id) async {
    Message message;
    try {
      Map<String, dynamic> messagesJson =
          await DBHelper().getMessageByIdJson(id, user);
      message = Message.fromJson(messagesJson);
    } catch (e) {
      print("[E] MessageHelper.getMessageByIdOffline(): " + e.toString());
    }

    return message;
  }
}
