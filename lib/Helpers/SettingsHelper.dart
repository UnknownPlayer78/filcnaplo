import 'dart:async';

import 'package:flutter/material.dart';

import 'package:filcnaplo/globals.dart';
import 'DBHelper.dart';

Map defaultShowCardType = {
  "AbsenceCard": true,
  "ChangedLessonCard": true,
  "EvaluationCard": true,
  "HomewordCard": true,
  "LessonCard": true,
  "NoteCard": true,
  "FirstQCard": true,
  "HalfYearCard": true,
  "ThirdQCard": true,
  "EndYearCard": true
};

class SettingsHelper {
  Future<void> _setPropertyBool(String name, dynamic value) async {
    Map<String, dynamic> settings = new Map();
    try {
      settings.addAll(await DBHelper().getSettingsMap());
    } catch (e) {
      print("[E] SettingsHelper._setPropertyBool(): " + e.toString());
    }

    settings[name] = value;
    await DBHelper().saveSettingsMap(settings);
    return null;
  }

  dynamic _getProperty(String name, dynamic defaultValue) async {
    Map<String, dynamic> settings = await DBHelper().getSettingsMap();
    if (settings == null) settings = new Map();
    if (settings.containsKey(name)) return (settings[name]);

    return defaultValue;
  }

  void setColoredMainPage(bool value) {
    _setPropertyBool("ColoredMainPage", value);
  }

  Future<bool> getColoredMainPage() async {
    return await _getProperty("ColoredMainPage", true);
  }

  void setDarkTheme(bool value) {
    _setPropertyBool("DarkTheme", value);
  }

  Future<bool> getDarkTheme() async {
    return await _getProperty("DarkTheme", false);
  }

  void setAmoled(bool value) {
    _setPropertyBool("Amoled", value);
  }

  Future<bool> getAmoled() async {
    return await _getProperty("Amoled", false);
  }

  void setNotification(bool value) {
    _setPropertyBool("Notification", value);
  }

  Future<bool> getNotification() async {
    return await _getProperty("Notification", false);
  }

  void setLogo(bool value) {
    isLogo = value;
    _setPropertyBool("Logo", value);
  }

  Future<bool> getLogo() async {
    return await _getProperty("Logo", true);
  }

  void setRefreshNotification(int value) {
    _setPropertyBool("RefreshNotification", value);
  }

  Future<int> getRefreshNotification() async {
    return await _getProperty("RefreshNotification", 60);
  }

  void setSingleUser(bool value) {
    _setPropertyBool("SingleUser", value);
  }

  Future<bool> getSingleUser() async {
    return await _getProperty("SingleUser", true);
  }

  void setSmartUserAgent(bool value) {
    _setPropertyBool("SmartUserAgent", value);
  }

  Future<bool> getSmartUserAgent() async {
    return await _getProperty("SmartUserAgent", true);
  }

  void setLang(String lang) {
    _setPropertyBool("lang", lang);
  }

  Future<String> getLang() async {
    return await _getProperty("lang", "hu");
  }

  void setTheme(int theme) {
    _setPropertyBool("theme", theme);
  }

  Future<int> getTheme() async {
    return await _getProperty("theme", 0);
  }

  void setNextLesson(bool nextLesson) {
    _setPropertyBool("next_lesson", nextLesson);
  }

  Future<bool> getNextLesson() async {
    return await _getProperty("next_lesson", true);
  }

  void setCanSyncOnData(bool canSyncOnData) {
    _setPropertyBool("canSyncOnData", canSyncOnData);
  }

  Future<bool> getCanSyncOnData() async {
    return await _getProperty("canSyncOnData", true);
  }

  Future<void> setEvalColor(int eval, Color color) async {
    await _setPropertyBool("grade_${eval}_color", color.value);
  }

  Future<bool> getAcceptTOS() async {
    return await _getProperty("acceptTOS", false);
  }

  Future<void> setAcceptTOS(bool value) async {
    await _setPropertyBool("acceptTOS", value);
  }

  Future<bool> getAcceptBlock() async {
    return await _getProperty("acceptBlockV3", false);
  }

  Future<void> setAcceptBlock(bool value) async {
    await _setPropertyBool("acceptBlockV3", value);
  }

  Future<Map> getShowCardType() async {
    return await _getProperty("showCardType", defaultShowCardType);
  }

  Future<void> setShowCardType(Map showCardType) async {
    await _setPropertyBool("showCardType", showCardType);
  }

  static const List<Color> COLORS = [
    Colors.red,
    Colors.brown,
    Colors.orange,
    Color.fromARGB(255, 253, 215, 52),
    Colors.green
  ];

  Future<Color> getEvalColor(int eval) async {
    return Color(await _getProperty("grade_${eval}_color", COLORS[eval].value));
  }
}
