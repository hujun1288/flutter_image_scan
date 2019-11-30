import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_scan/flutter_plugin_scan.dart';


//这是 系统生成的获取 应用平台版本号的demo
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _photoPath = 'Unknown';  //图片地址

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPluginScan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _photoPath = platformVersion;
    });
  }

  /// 获取图片地址
  Future<void> getPhotoPath(PhotoType photoType) async {
    String photoPath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      switch(photoType){
        case PhotoType.BANK_CARD:
          photoPath = await FlutterPluginScan.bankCardPhoto;
          break;
        case PhotoType.IDCARD_POSITIVE:
          photoPath = await FlutterPluginScan.idCardPhoto;
          break;
        case PhotoType.IDCARD_NEGATIVE:
          photoPath = await FlutterPluginScan.idCardPhotoNegative;
          break;
        case PhotoType.PASSPORT_PERSON_INFO:
          photoPath = await FlutterPluginScan.passportPersonInfo;
          break;
        case PhotoType.PASSPORT_ENTRY_AND_EXIT:
          photoPath = await FlutterPluginScan.passportEntryAndExit;
          break;
        case PhotoType.HK_MACAO_TAIWAN_PASSES_POSITIVE:
          photoPath = await FlutterPluginScan.hkTaiwanPassesPositive;
          break;
        case PhotoType.HK_MACAO_TAIWAN_PASSES_NEGATIVE:
          photoPath = await FlutterPluginScan.hkTaiwanPassesNegative;
          break;
        default:
          photoPath = await FlutterPluginScan.platformVersion;
      }

    } on PlatformException {
      photoPath = 'Failed to get photoPath.';
    }

    if (!mounted) return;
    print('photoPath:$photoPath');
    setState(() {
      _photoPath = photoPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Center(
                child: ListView(children: <Widget>[
                  Text('photoPath: $_photoPath\n'),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面'),
                    onPressed: ()=>getPhotoPath(PhotoType.platformVersion),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 银行卡'),
                    onPressed: ()=>getPhotoPath(PhotoType.BANK_CARD),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 身份证正面'),
                    onPressed: ()=>getPhotoPath(PhotoType.IDCARD_POSITIVE),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 身份证反面'),
                    onPressed: ()=>getPhotoPath(PhotoType.IDCARD_NEGATIVE),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 护照信息'),
                    onPressed: ()=>getPhotoPath(PhotoType.PASSPORT_PERSON_INFO),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 护照出入'),
                    onPressed: ()=>getPhotoPath(PhotoType.PASSPORT_ENTRY_AND_EXIT),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 港澳通行证正面'),
                    onPressed: ()=>getPhotoPath(PhotoType.HK_MACAO_TAIWAN_PASSES_POSITIVE),),
                  MaterialButton(color: Colors.blue,
                    textColor: Colors.white,
                    child: Text('打开拍照页面 港澳通行证反面'),
                    onPressed: ()=>getPhotoPath(PhotoType.HK_MACAO_TAIWAN_PASSES_NEGATIVE),),

                ],
                )
            )));
  }
}
