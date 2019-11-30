#import "FlutterPluginScanPlugin.h"

#import "SNFCreditScoreCameraService.h"
#import "SNFCreditScoreCameraBaseView.h"
#import "SNFCSCImagePickerController.h"


@interface FlutterPluginScanPlugin()
@property (nonatomic, strong)SNFCreditScoreCameraService *service;
@end


@implementation FlutterPluginScanPlugin

FlutterResult _result;
UIViewController* _viewController;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_scan"
            binaryMessenger:[registrar messenger]];
  FlutterPluginScanPlugin* instance = [[FlutterPluginScanPlugin alloc] init];
    UIApplication* app=[UIApplication sharedApplication];
    _viewController=[[[app delegate] window] rootViewController];

  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
        _result=result;
        if (call.method!=nil&&![call.method isEqualToString:@""]) {
            //[@"getBatteryLevel" isEqualToString:call.method]
//            NSString* batteryLevel = [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
    //            result(batteryLevel);
            [self openCameraPage:call.method];
        } else {
            result(FlutterMethodNotImplemented);
        }
}

-(void)openCameraPage:(NSString*)str{
    SNFCreditScoreCameraType pt=IDCARD_POSITIVE;
    NSLog(@"MyTag:FlutterPluginScanPlugin openCameraPage:%@",str);
    if ([str containsString:@"PASSPORT_PERSON_INFO"]) {
        pt=PASSPORT_PERSON_INFO;
    }else if ([str containsString:@"PASSPORT_ENTRY_AND_EXIT"]) {
        pt=PASSPORT_ENTRY_AND_EXIT;
    }else if ([str containsString:@"IDCARD_POSITIVE"]) {
        pt=IDCARD_POSITIVE;
    }else if ([str containsString:@"IDCARD_NEGATIVE"]) {
        pt=IDCARD_NEGATIVE;
    }else if ([str containsString:@"HK_MACAO_TAIWAN_PASSES_POSITIVE"]) {
        pt=HK_MACAO_TAIWAN_PASSES_POSITIVE;
    }else if ([str containsString:@"HK_MACAO_TAIWAN_PASSES_NEGATIVE"]) {
        pt=HK_MACAO_TAIWAN_PASSES_NEGATIVE;
    }else if ([str containsString:@"BANK_CARD"]) {
        pt=BANK_CARD;
    }

    [self startWithType:pt];

}

- (void)startWithType:(SNFCreditScoreCameraType)type {

    self.service = [[SNFCreditScoreCameraService alloc] init];
    [self.service startCameraFromVC:_viewController cameraType:type success:^(NSString* showText){
        NSLog(@"MyTag:startCameraFromVC success. ");
        _result(self.service.filePath);
    } failure:^{
        NSLog(@"MyTag:startCameraFromVC failure. ");
    } cancel:^{
        NSLog(@"MyTag:startCameraFromVC cancel. ");
    }];
}

@end
