//
//  CustomCameraOverlayView.m
//  PickerController
//
//  Created by uxiu.me on 2018/4/11.
//  Copyright © 2018年 HangZhouFaDaiGuoJiMaoYi Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WatermarkCameraOverlayView.h"

@interface WatermarkCameraOverlayView ()

@property (nonatomic,  copy ) NSString *timeString;
@property (nonatomic,  copy ) NSString *dateString;

@end

@implementation WatermarkCameraOverlayView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDataSource];
        [self setupUI];
    }
    return self;
}

- (void)initDataSource {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    NSString *dateString = [timeStr substringWithRange:NSMakeRange(0, 10)];
    self.timeString = [timeStr substringWithRange:NSMakeRange(11, 5)];
    NSString *weekDay = [self weekdayStringFromDate:[NSDate date]];
    self.dateString = [NSString stringWithFormat:@"%@ %@",dateString,weekDay];
    if (self.isTwelveHandle) {
        BOOL hasAMPM = [self isTwelveMechanism];
        int time = [self currentIntTime];
        self.timeString = hasAMPM ? [NSString stringWithFormat:@"%@%@",self.timeString,(time > 12 ? @"pm" : @"am")] : self.timeString;
    }
}

- (void)setupUI {
    [self addSubview:self.preview];
//    [self addSubview:self.topMarkView];
//    [self addSubview:self.bottomBlackView];
    
    [self addSubview:self.topBlackView];
    [self addSubview:self.bottomBlackView];
    [self.preview addSubview:self.topMarkView];
    [self.preview addSubview:self.bottomMarkView];
    
    [self.topMarkView addSubview:self.timeLabel];
    [self.topMarkView addSubview:self.dateLabel];
    [self.bottomMarkView addSubview:self.userBtn];
    [self.bottomMarkView addSubview:self.addressBtn];
    [self.bottomBlackView addSubview:self.cancelOrRetakeBtn];
    [self.bottomBlackView addSubview:self.shootBtn];
    [self.bottomBlackView addSubview:self.switchOrUsePicBtn];
    self.timeLabel.text = self.timeString;
    self.dateLabel.text = self.dateString;
}

#pragma mark - Action Method
- (void)cancelOrRetake:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"取消"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(action_cancel)]) {
            [self.delegate action_cancel];
        }
    } else {
        self.preview.image = [[UIImage alloc] init];
        self.shootBtn.hidden = NO;
        [self.cancelOrRetakeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.switchOrUsePicBtn setTitle:@" " forState:UIControlStateNormal];
        [self.switchOrUsePicBtn setImage:[UIImage imageNamed:@"cameraBack"] forState:UIControlStateNormal];
    }
}

- (void)shoot:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(action_shoot)]) {
        [self.delegate action_shoot];
    }
    button.hidden = YES;
    [self.cancelOrRetakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [self.switchOrUsePicBtn setTitle:@"使用" forState:UIControlStateNormal];
    [self.switchOrUsePicBtn setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
}

- (void)switchOrUsePic:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"使用"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(action_use)]) {
            [self.delegate action_use];
        }
    } else {
        if (self.usedDeviceType == 0) {
            [NSUserDefaults.standardUserDefaults setInteger:1 forKey:@"UsedDeviceType"];
        } else {
            [NSUserDefaults.standardUserDefaults setInteger:0 forKey:@"UsedDeviceType"];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(action_switch)]) {
            [self.delegate action_switch];
        }
    }
}

#pragma mark - set get
- (void)setUserName:(NSString *)userName {
    _userName = userName;
    [self.userBtn setTitle:[NSString stringWithFormat:@" %@",userName] forState:UIControlStateNormal];
}

- (void)setAddress:(NSString *)address {
    _address = address;
    [self.addressBtn setTitle:address forState:UIControlStateNormal];
}

- (NSInteger)usedDeviceType {
    return [NSUserDefaults.standardUserDefaults integerForKey:@"UsedDeviceType"];
}

- (UIView *)topBlackView {
    if (!_topBlackView) {
        _topBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50)];
        _topBlackView.backgroundColor = UIColor.blackColor;
    }
    return _topBlackView;
}

- (UIImageView *)topMarkView {
    if (!_topMarkView) {
//        _topMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBlackView.frame), UIScreen.mainScreen.bounds.size.width, 100)];
        _topMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 100)];
        _topMarkView.image = [UIImage imageNamed:@"markTopMView"];
    }
    return _topMarkView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self labelWithFrame:CGRectMake(20, 20, 150, 30) fontSize:30 alignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [self labelWithFrame:CGRectMake(20, CGRectGetMaxY(self.timeLabel.frame), 200, 15) fontSize:14 alignment:NSTextAlignmentLeft];
    }
    return _dateLabel;
}

- (UIView *)bottomBlackView {
    if (!_bottomBlackView) {
        _bottomBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 109, UIScreen.mainScreen.bounds.size.width, 109)];
        _bottomBlackView.backgroundColor = UIColor.blackColor;
    }
    return _bottomBlackView;
}

- (UIButton *)cancelOrRetakeBtn {
    if (!_cancelOrRetakeBtn) {
        _cancelOrRetakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelOrRetakeBtn.frame = CGRectMake(8, (CGRectGetHeight(self.bottomBlackView.frame) - 60) / 2.0, 60, 60);
        [_cancelOrRetakeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelOrRetakeBtn setTitle:@"重拍" forState:UIControlStateSelected];
        [_cancelOrRetakeBtn addTarget:self action:@selector(cancelOrRetake:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelOrRetakeBtn;
}

- (UIButton *)shootBtn {
    if (!_shootBtn) {
        _shootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shootBtn.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 68) / 2.0, (CGRectGetHeight(self.bottomBlackView.frame) - 68) / 2.0, 68, 68);
        [_shootBtn setImage:[UIImage imageNamed:@"cameraPress"] forState:UIControlStateNormal];
        [_shootBtn addTarget:self action:@selector(shoot:) forControlEvents:UIControlEventTouchDown];
    }
    return _shootBtn;
}

- (UIButton *)switchOrUsePicBtn {
    if (!_switchOrUsePicBtn) {
        _switchOrUsePicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchOrUsePicBtn.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 68, (CGRectGetHeight(self.bottomBlackView.frame) - 60) / 2.0, 60, 60);
        [_switchOrUsePicBtn setTitle:@" " forState:UIControlStateNormal];
        //[_switchOrUsePicBtn setTitle:@"使用" forState:UIControlStateSelected];
        [_switchOrUsePicBtn setImage:[UIImage imageNamed:@"cameraBack"] forState:UIControlStateNormal];
        //[_switchOrUsePicBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_switchOrUsePicBtn addTarget:self action:@selector(switchOrUsePic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchOrUsePicBtn;
}

- (UIImageView *)bottomMarkView {
    if (!_bottomMarkView) {
        _bottomMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"markBottomMView"]];
//        _bottomMarkView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height - CGRectGetHeight(self.bottomBlackView.frame) - 100, UIScreen.mainScreen.bounds.size.width, 100);
        _bottomMarkView.frame = CGRectMake(0, CGRectGetHeight(self.preview.frame) - 100, UIScreen.mainScreen.bounds.size.width, 100);
    }
    return _bottomMarkView;
}

- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _userBtn.userInteractionEnabled = NO;
        _userBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _userBtn.frame = CGRectMake(20, 35, UIScreen.mainScreen.bounds.size.width - 40, 20);
        [_userBtn setImage:[UIImage imageNamed:@"markUser"] forState:UIControlStateNormal];
    }
    return _userBtn;
}

- (UIButton *)addressBtn {
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _addressBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _addressBtn.frame = CGRectMake(20, 60, UIScreen.mainScreen.bounds.size.width - 40, 20);
        _addressBtn.userInteractionEnabled = NO;
    }
    return _addressBtn;
}

- (UIImageView *)preview {
    if (!_preview) {
        _preview = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBlackView.frame), UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - CGRectGetHeight(self.topBlackView.frame) - CGRectGetHeight(self.bottomBlackView.frame))];
        _preview.contentMode = UIViewContentModeScaleAspectFill;
//        _preview = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _preview.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _preview;
}

#pragma mark - 工具方法
- (CGFloat)calculateRowWidth:(NSString *)string fontSize:(CGFloat)fontSize fontHeight:(CGFloat) fontHeight{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, fontHeight)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

- (UILabel *)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.textAlignment = alignment;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

- (int)currentIntTime {
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    [formatter0 setDateFormat:@"HH"];
    NSString *str = [formatter0 stringFromDate:[NSDate date]];
    int time = [str intValue];
    return time;
}

- (BOOL)isTwelveMechanism {
    //获取系统是24小时制或者12小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsARange = [formatStringForHours rangeOfString:@"a"];
    BOOL isTwelveMechanism = containsARange.location != NSNotFound;
    /** isTwelveMechanism = YES 12小时制，否则是24小时制 */
    return isTwelveMechanism;
}

/**
 *  获取星期几
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
