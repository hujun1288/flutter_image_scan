package com.qizhi.flutter_plugin_scan;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterPlugin 自动定义 拍照插件，可以弹出拍照页面，并把拍照地址返回前端
 * 为了获取地址在当前页面启动 activity 获取结果后关闭当前 activity  避免用户感知到 当前页面的启动过程*/

public class FlutterPluginScanPlugin extends FlutterActivity implements MethodCallHandler {
  /** Plugin registration. */

  private static MethodChannel channel;
  Result result;

  private Activity activity;

  static FlutterPluginScanPlugin flutterPlugin=null;
  public static FlutterPluginScanPlugin  getFlutterPlugin(){   //单例模式  返回当前对象
    if (flutterPlugin==null)
      return flutterPlugin=new FlutterPluginScanPlugin();
    else
      return flutterPlugin;
  }

  public static void registerWith(Registrar registrar) {

    channel = new MethodChannel(registrar.messenger(), "flutter_plugin_scan");
    Log.d("Tag","FlutterPlugin onCreate channel:"+channel);

    FlutterPluginScanPlugin.getFlutterPlugin().setActivity(registrar.activity());
    registrar.addActivityResultListener(new ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d("TAG","requestCode:"+requestCode+" resultCode:"+resultCode+" Intent:"+data);

        if (registrar.activeContext() == null) {
          Toast.makeText(registrar.activity(), "页面加载失败，请稍后再试…", Toast.LENGTH_SHORT).show();
          FlutterPluginScanPlugin.getFlutterPlugin().getResult().success("faild:getApplicationContext is null");
        }
        if (requestCode == 68 && resultCode == Activity.RESULT_OK && data != null) {  //图片
//      ArrayList<String> fileNames = data.getStringArrayListExtra("MULTIPLEFILENAMES");
          String picPath=data.getStringExtra("path");
          Log.d("TAG","requestCode path:"+picPath);
          FlutterPluginScanPlugin.getFlutterPlugin().getResult().success("Android " + picPath);  //android.os.Build.VERSION.RELEASE 这是版本信息

//      if (fileNames!=null&&fileNames.size()>0) {
//        JSONArray res = new JSONArray(fileNames);
//        this.callbackContext.success(res);
//      } else {
//      this.callbackContext.error("something wrong");
//    }
        }else {
          FlutterPluginScanPlugin.getFlutterPlugin().getResult().success("faild:intent data is null");
        }

        return false;
      }
    });

//    通过 channel 启动插件方法；；如果 不需要启动 activity 获取数据的场景，可以不启动activity 直接返回android 底层获取的数据即可
    channel.setMethodCallHandler(FlutterPluginScanPlugin.getFlutterPlugin());
  }

//  @Override
//  public void onCreate(Bundle savedInstanceState) {
//
//    super.onCreate(savedInstanceState);
//    Log.d("Tag","FlutterPlugin onCreate this:"+this+" channel："+channel);
//
//    curActivity=this;
//
//    isVisiable=true;
//  }

  public Result getResult() {
    return result;
  }

  public void setResult(Result result) {
    this.result = result;
  }
  public Activity getActivity() {
    return activity;
  }

  public void setActivity(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    //判断channel 中的方法名称；一个flutter 底层可以对应多个channel 一个 channel 可以对应多个方法
    if (call.method!=null &&!call.method.isEmpty()) {  //call.method.equals("getPlatformVersion")
      FlutterPluginScanPlugin.getFlutterPlugin().setResult(result);  //设置回掉 对象

      openCameraPage(call.method.replaceAll("PhotoType.",""));
    } else {
      Log.d("Tag","onMethodCall notImplemented call.method:"+call.method);
      result.notImplemented();
    }
  }

  //打开拍照 取景页面
  public void openCameraPage(String str) {
    Activity activity=FlutterPluginScanPlugin.getFlutterPlugin().getActivity();
    Log.d("Tag","FlutterPlugin onMethodCall this:"+activity+" str:"+str);
    Intent intent = new Intent(activity, CameraActivity.class);

    if (str!=null&&str.contains("_"))
      intent.putExtra("MongolianLayerType",CameraActivity.MongolianLayerType.valueOf(str));
    if (intent.resolveActivity(activity.getPackageManager()) != null) {
      activity.startActivityForResult(intent, 68);
    }

  }



}
