//
//  SNFCreditScoreCameraBaseView.h
//  SNCustomCamera
//
//  Created by User on 2018/8/29.
//  Copyright © 2018年 Raindew. All rights reserved.
//

#import <UIKit/UIKit.h>
//相机类型
typedef NS_ENUM(NSInteger, SNFCreditScoreCameraType) {
    //横屏
    SNFCreditScoreCameraDrivingFront = 0,//驾驶证正面
    SNFCreditScoreCameraDrivingBack,//驾驶证背面
    SNFCreditScoreCameraRunFront,//行驶证正面
    SNFCreditScoreCameraRunBack,//行驶证背面
    //竖屏
    SNFCreditScoreCameraRealEstateFront,//房产、不动产正面
    SNFCreditScoreCameraRealEstateBack,//房产、不动产背面
  
    PASSPORT_PERSON_INFO=100,  //护照个人信息
    PASSPORT_ENTRY_AND_EXIT,  //护照出入境
    IDCARD_POSITIVE,  //身份证正面
    IDCARD_NEGATIVE,  //身份证反面
    HK_MACAO_TAIWAN_PASSES_POSITIVE,  //港澳通行证正面
    HK_MACAO_TAIWAN_PASSES_NEGATIVE,  //港澳通行证反面
    BANK_CARD  //银行卡
};

//enum PhotoTypes {
//    PASSPORT_PERSON_INFO,  //护照个人信息
//    PASSPORT_ENTRY_AND_EXIT,  //护照出入境
//    IDCARD_POSITIVE,  //身份证正面
//    IDCARD_NEGATIVE,  //身份证反面
//    HK_MACAO_TAIWAN_PASSES_POSITIVE,  //港澳通行证正面
//    HK_MACAO_TAIWAN_PASSES_NEGATIVE,  //港澳通行证反面
//    BANK_CARD  //银行卡
//};
@interface SNFCreditScoreCameraBaseView : UIView
@property (nonatomic, assign)SNFCreditScoreCameraType cameraType;
@property (nonatomic, strong)UIView *sealView;//印章
@property (nonatomic, strong)UIView *titileView;//标题
@property (nonatomic, strong)UIView *photoView;//照片
@property (nonatomic, strong)UIImageView *contentImage;//照片
@property (nonatomic, strong)UIImageView *maskImage;// 蒙版照片

@end
