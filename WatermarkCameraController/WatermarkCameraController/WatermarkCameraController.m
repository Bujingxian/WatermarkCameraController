//
//  YSWatermarkCameraImagePickerController.m
//  PickerController
//
//  Created by uxiu.me on 2018/4/11.
//  Copyright © 2018年 HangZhouFaDaiGuoJiMaoYi Co. Ltd. All rights reserved.
//

#import "WatermarkCameraController.h"

@interface WatermarkCameraController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,WatermarkCameraOverlayViewDelegate>

@property (nonatomic, strong) WatermarkCameraOverlayView *customOverlayView;
@property (nonatomic, strong) UIImage  *shotImage;///< 拍摄的照片

@end

@implementation WatermarkCameraController

#pragma mark -
#pragma mark - ♻️ Lifecycle
- (instancetype)init {
    if (self = [super init]) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.delegate = self;
        self.showsCameraControls = NO;
        self.cameraOverlayView = self.customOverlayView;
        if (self.customOverlayView.usedDeviceType == 0) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize  previewSize = self.customOverlayView.preview.bounds.size;
    CGFloat offsety = 0.0;
    CGFloat scale = 1.0;
    if ((previewSize.height / previewSize.width) > (4.0 / 3.0)) {
        scale = 3.0 * previewSize.height / (4.0 * UIScreen.mainScreen.bounds.size.width);
        offsety = previewSize.height * (scale - 1) * 0.5;
    } else {
        
    }
    self.cameraViewTransform = CGAffineTransformMakeTranslation(0, CGRectGetMinY(self.customOverlayView.preview.frame) + offsety);
    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, scale, scale);
}

#pragma mark -
#pragma mark - 💤 LazyLoad
- (WatermarkCameraOverlayView *)customOverlayView {
    if (!_customOverlayView) {
        _customOverlayView = [[WatermarkCameraOverlayView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _customOverlayView.delegate = self;
    }
    return _customOverlayView;
}

- (void)setUserName:(NSString *)userName {
    _userName  = userName;
    self.customOverlayView.userName = userName;
}

- (void)setAddress:(NSString *)address {
    _address = address;
    self.customOverlayView.address = address;
}


#pragma mark -
#pragma mark - 🔨 CustomMethod
- (UIImage *)snapshotImageInView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
    if (![view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap;
    }
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

#pragma mark -
#pragma mark - 🎬 ActionMethod


#pragma mark -
#pragma mark - ⛓ DelegateMethod
#pragma mark   UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.isEditing) {
        //获得编辑后的图片
        UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
        self.customOverlayView.preview.image = editedImage;
    } else {
        //获取照片的原图
        UIImage *originalImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
        self.shotImage = originalImage;
        self.customOverlayView.preview.image = originalImage;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark   CustomWatermarkCameraOverlayViewDelegate
- (void)action_cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)action_shoot  {
    [self takePicture];
}

- (void)action_use    {
    UIImage *image = [self snapshotImageInView:self.customOverlayView.preview afterScreenUpdates:YES];
    self.shot(image);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)action_switch {
    if (self.customOverlayView.usedDeviceType == 0) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}

#pragma mark -
#pragma mark - 🌏 NetworkMethod



#pragma mark -
#pragma mark - 👁 OtherMethod



@end



