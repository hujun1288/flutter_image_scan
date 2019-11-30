import 'dart:async';

import 'package:flutter/services.dart';
///照片类型的 枚举 方便调用
enum PhotoType{
  platformVersion,
  IDCARD_POSITIVE,
  IDCARD_NEGATIVE,
  BANK_CARD,
  PASSPORT_PERSON_INFO,
  PASSPORT_ENTRY_AND_EXIT,
  HK_MACAO_TAIWAN_PASSES_POSITIVE,
  HK_MACAO_TAIWAN_PASSES_NEGATIVE
}

class FlutterPluginScan {
  static const MethodChannel _channel =
  const MethodChannel('flutter_plugin_scan');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion'); //'getPlatformVersion'
    return version;
  }
  static Future<String> get idCardPhoto async {  //身份证 正面
    final String path = await _channel.invokeMethod(PhotoType.IDCARD_POSITIVE.toString());  //'getIdCardPhoto'
    return path;
  }
  static Future<String> get idCardPhotoNegative async {  //身份证 反面
    final String path = await _channel.invokeMethod(PhotoType.IDCARD_POSITIVE.toString());
    return path;
  }
  static Future<String> get bankCardPhoto async {   //  银行卡
    final String path = await _channel.invokeMethod(PhotoType.BANK_CARD.toString());  //'getBankCardPhoto'
    return path;
  }
  static Future<String> get passportPersonInfo async {   //  护照个人信息
    final String path = await _channel.invokeMethod(PhotoType.PASSPORT_PERSON_INFO.toString());
    return path;
  }
  static Future<String> get passportEntryAndExit async {   //  护照出入信息
    final String path = await _channel.invokeMethod(PhotoType.PASSPORT_ENTRY_AND_EXIT.toString());
    return path;
  }
  static Future<String> get hkTaiwanPassesPositive async {   //  港澳通行证正面
    final String path = await _channel.invokeMethod(PhotoType.HK_MACAO_TAIWAN_PASSES_POSITIVE.toString());
    return path;
  }
  static Future<String> get hkTaiwanPassesNegative async {   //  港澳通行证反面
    final String path = await _channel.invokeMethod(PhotoType.HK_MACAO_TAIWAN_PASSES_NEGATIVE.toString());
    return path;
  }
}
