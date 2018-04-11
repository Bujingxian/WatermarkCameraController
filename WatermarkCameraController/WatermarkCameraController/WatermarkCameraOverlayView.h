//
//  CustomCameraOverlayView.h
//  PickerController
//
//  Created by uxiu.me on 2018/4/11.
//  Copyright © 2018年 HangZhouFaDaiGuoJiMaoYi Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WatermarkCameraOverlayViewDelegate <NSObject>

@optional
/**取消拍摄*/
- (void)action_cancel;
/**重新拍摄*/
- (void)action_retake;
/**拍摄*/
- (void)action_shoot;
/**使用照片*/
- (void)action_use;
/**切换前、后摄像头*/
- (void)action_switch;

@end

@interface WatermarkCameraOverlayView : UIView

@property (nonatomic, strong)  UIView  *topBlackView;///< 顶部黑色区域
@property (nonatomic, strong)  UIImageView *topMarkView;///< 顶部水印背景
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong)  UILabel *dateLabel;

@property (nonatomic, strong)  UIImageView *bottomMarkView;///< 底部水印背景
@property (nonatomic, strong)  UIButton *userBtn;
@property (nonatomic, strong)  UIButton *addressBtn;

@property (nonatomic, strong)  UIView   *bottomBlackView;///< 底部黑色区域
@property (nonatomic, strong)  UIButton *cancelOrRetakeBtn;
@property (nonatomic, strong)  UIButton *shootBtn;
@property (nonatomic, strong)  UIButton *switchOrUsePicBtn;

@property (nonatomic, strong)  UIImageView *preview;///< 预览图片视图

@property (nonatomic,  weak ) id <WatermarkCameraOverlayViewDelegate> delegate;
@property (nonatomic, assign) BOOL isTwelveHandle;
@property (nonatomic, assign) NSInteger usedDeviceType;///<标记摄像头为 "前置" 还是 "后置"     0、 为后置；1、 为前置
@property (nonatomic,  copy ) NSString *userName;
@property (nonatomic,  copy ) NSString *address;

@end
