//
//  ViewController.m
//  WatermarkCameraController
//
//  Created by uxiu.me on 2018/4/11.
//  Copyright © 2018年 HangZhouFaDaiGuoJiMaoYi Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "WatermarkCameraController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UIButton *shotBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)shot:(id)sender {
    
    WatermarkCameraController *controller = [[WatermarkCameraController alloc] init];
    controller.userName = @"优秀的我 uxiu.me";
    controller.address = @"浙江省杭州市滨江区科技馆街寰宇商务中心";
    controller.shot = ^(UIImage *image) {
        self.preview.image = image;
    };
    [self presentViewController:controller animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
