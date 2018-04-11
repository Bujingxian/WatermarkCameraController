//
//  YSWatermarkCameraImagePickerController.h
//  PickerController
//
//  Created by uxiu.me on 2018/4/11.
//  Copyright © 2018年 HangZhouFaDaiGuoJiMaoYi Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatermarkCameraOverlayView.h"

@interface WatermarkCameraController : UIImagePickerController

/** 是否需要12小时制处理，default is NO */
@property (nonatomic, assign) BOOL isTwelveHandle;
@property (nonatomic,  copy ) NSString *userName;
@property (nonatomic,  copy ) NSString *address;
/**拍摄后获取到带水印的照片*/
@property (nonatomic,  copy ) void(^shot)(UIImage *image);

@end
