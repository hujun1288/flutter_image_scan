
//
//  SNFCreditScoreCameraService.m
//  SNCustomCamera
//
//  Created by User on 2018/8/28.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import "SNFCreditScoreCameraService.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SNFCreditScoreCameraBaseView.h"
#import "SNFCSCImagePickerController.h"

//定义图片存储的路径名称
#define PHOTO_PREFIX @"my_photo_"

@interface SNFCreditScoreCameraService()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,SNFCSCImagePickerControllerDelegate>
@property (nonatomic, strong)SNFCSCImagePickerController *pickControl;
@property (nonatomic, strong)SNFCreditScoreCameraBaseView *baseView;
@end
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kScaleX  [UIScreen mainScreen].bounds.size.width / 375.f
#define kScaleY  [UIScreen mainScreen].bounds.size.height / 667.f
#define kContentFrame CGRectMake(0, 0, kWidth, kHeight-165*kScaleY)
#define SNF_IMAGE_MAXSIZE 5000000
@implementation SNFCreditScoreCameraService


//打开拍照页面，此处添加进度条 ，避免再次点击
- (void)startCameraFromVC:(UIViewController *_Nonnull)sourceVC
               cameraType:(SNFCreditScoreCameraType)cameraType
                  success:(void (^)(NSString *showText))success
                  failure:(void (^)(void))failure
                   cancel:(void (^)(void))cancel {
    self.testSuccessBlock=success;
    self.pickControl = [[SNFCSCImagePickerController alloc] init];
    self.pickControl.delegate = self;
    self.pickControl.selectDelegate = self;
    self.pickControl.baseView.cameraType = cameraType;
    [sourceVC presentViewController:self.pickControl animated:YES completion:^{
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authStatus == AVAuthorizationStatusNotDetermined) {//第一次使用
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {//第一次，用户选择拒绝
                        [self.pickControl dismissViewControllerAnimated:YES completion:nil];
                    }
                });
            }];
        }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            //无权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未获得相机权限" message:@"\n开启后才能使用拍照功能" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.pickControl dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [sourceVC presentViewController:alert animated:YES completion:nil];
        }else if (authStatus == AVAuthorizationStatusAuthorized) {//用户已授权
            
        }
    }];
    
}


#pragma mark -- UIImagePickerControllerDelegate
//拍照完成，此处  释放 进度条
- (void)imagePickerController:(SNFCSCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    NSLog(@"图片width:%f,height:%f imageOrientation:%ld",image.size.width,image.size.height,image.imageOrientation);
//    if (image.imageOrientation == UIImageOrientationRight && self.pickControl.baseView.cameraType != SNFCreditScoreCameraRealEstateFront && self.pickControl.baseView.cameraType != SNFCreditScoreCameraRealEstateBack) {
//
//        //需要横屏拍摄，如果屏幕没有旋转过来，仍然是正向。这里旋转图片,横向显示
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformTranslate(transform, 0, image.size.height);
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
//                                                 CGImageGetBitsPerComponent(image.CGImage), 0,
//                                                 CGImageGetColorSpace(image.CGImage),
//                                                 CGImageGetBitmapInfo(image.CGImage));
//
//        CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
//        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//        image = [UIImage imageWithCGImage:cgimg];
//        CGContextRelease(ctx);
//        CGImageRelease(cgimg);
//    }
    [picker hiddenBtn];//拍照按钮隐藏  必须是拍照后隐藏，如果在拍照的同时隐藏那么会出现隐藏动画影响picker绘制问题，图片成像可能是黑色的。
    
    picker.preView.hidden = NO;
    picker.baseView.hidden = YES;
    
    //压缩
//    NSData *data = [self compressImageWith:image];
    

//    UIImage* image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:orientation];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    //存储地址
    self.filePath = [NSString stringWithFormat:@"%@/%@%llu.%@", [NSTemporaryDirectory()stringByStandardizingPath], PHOTO_PREFIX, recordTime, @"jpg"];
    
    NSData* data=UIImagePNGRepresentation(image);
    double length = [data length]/1000000;
    
    int width=picker.preView.bounds.size.width*2.6;
    int height=picker.preView.bounds.size.height*2.6;
    if (image.size.width>image.size.height) {
        int t=width;
        width=height;
        height=t;
    }
    NSLog(@"图片大小 length：%0.2fM filePath:%@ width:%d,height:%d",length,self.filePath,width,height);
    if (length>0.8) {  //图片大于 阀值(单位k) 才进行压缩
        UIImage* scaledImage = [self imageByScalingNotCroppingForSize:image toSize:CGSizeMake(width, height)]; //先缩小
        data = UIImageJPEGRepresentation(scaledImage, 75.0f/100.0f); //再压缩  质量压缩系数
    }
    image=[UIImage imageWithData:data];
    NSLog(@"压缩后图片大小 length：%0.2f M;image width:%f ;image height:%f",(double)([data length]/1000000.0f),image.size.width,image.size.height);
    picker.preView.image =image; //预览图  image
    
    NSError* err = nil; //记录存储错误信息
    if (![data writeToFile:self.filePath options:NSAtomicWrite error:&err]) {  //存储  失败
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
    } else {  //存储 成功
//        [resultStrings addObject:[[NSURL fileURLWithPath:filePath] absoluteString]];
    }
    
}


#pragma mark -- SNFCSCImagePickerControllerDelegate
- (void)creditScoreCameraActionType:(SNFCreditScoreCameraActionType)actionType {
    switch (actionType) {
        case SNFCreditScoreCameraTakePicture://拍摄
            break;
        case SNFCreditScoreCameraBack://返回
            [self.pickControl dismissViewControllerAnimated:YES completion:^{
            }];
            self.pickControl = nil;
            break;
        case SNFCreditScoreCameraReset://重新拍摄
            break;
        case SNFCreditScoreCameraConfirm://使用图片
            //图片上传
           
            self.testSuccessBlock(self.filePath);
            [self.pickControl dismissViewControllerAnimated:YES completion:nil];
            self.pickControl = nil;
            break;
        default:
            break;
    }
}

//压缩图片
- (NSData *)compressImageWith:(UIImage *)norImage {
    
    float ratio = 1.0;
    NSData *tempData = UIImageJPEGRepresentation(norImage, 1);
    ratio = (float)SNF_IMAGE_MAXSIZE / tempData.length;
    if (ratio - 1 < 0.0) {
        ratio = [[NSString stringWithFormat:@"%.2f", ratio] floatValue];
        ratio = ratio - 0.01;
        ratio = [[NSString stringWithFormat:@"%.2f", ratio] floatValue];
    } else {
        ratio = 1.0;
    }
    return UIImageJPEGRepresentation(norImage, ratio);
}

//缩放图片，传入 原始图片、目标尺寸：取长宽，作为最长边界
- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;
    
    if (CGSizeEqualToSize(imageSize, frameSize) == NO) { //图片尺寸和 目标尺寸不一致执行，targetWidth targetHeight 是最大边界，0的话无边界
        CGFloat widthFactor = targetWidth / width;  // 假设 800/3624=0.22
        CGFloat heightFactor = targetHeight / height;   // 假设 0/2448=0  800/2448=0.33
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor == 0.0) {
            scaleFactor = heightFactor;
        } else if (heightFactor == 0.0) {
            scaleFactor = widthFactor;
        } else if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(width * scaleFactor, height * scaleFactor);
    }
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"无法缩放图片");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
