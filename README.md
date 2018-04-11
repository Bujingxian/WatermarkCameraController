# WatermarkCameraController
使用UIImagePickerController做的水印相机，自定义拍照页面，鸣谢[ZHGWaterMarkCameraDIY](https://github.com/WangZhGuangDev/ZHGWaterMarkCameraDIY)


## 调用方式

```objective-c

- (IBAction)shot:(id)sender {
    
    WatermarkCameraController *controller = [[WatermarkCameraController alloc] init];
    controller.userName = @"优秀的我 uxiu.me";
    controller.address = @"浙江省杭州市滨江区科技馆街寰宇商务中心";
    controller.shot = ^(UIImage *image) {
        self.preview.image = image;
    };
    [self presentViewController:controller animated:NO completion:nil];
}

```

## 屏幕截图

![截图](https://github.com/Bujingxian/WatermarkCameraController/blob/master/水印相机.gif)


