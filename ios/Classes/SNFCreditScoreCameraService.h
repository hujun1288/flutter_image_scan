//
//  SNFCreditScoreCameraService.h
//  SNCustomCamera
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNFCreditScoreCameraBaseView.h"

@interface SNFCreditScoreCameraService : NSObject


typedef void(^successBlock)(NSString *showText);

@property (nonatomic,strong) successBlock testSuccessBlock;


- (void)startCameraFromVC:(UIViewController *_Nonnull)sourceVC
              cameraType:(SNFCreditScoreCameraType)cameraType
                 success:(void (^)(NSString *showText))success
                 failure:(void (^)(void))failure
                   cancel:(void (^)(void))cancel;

@property (nonatomic,retain) NSString* filePath;  //文件地址

@end
