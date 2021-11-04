//
//  CGXPickerViewManager.m
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2018/1/8.
//  Copyright © 2018年 曹贵鑫. All rights reserved.
//

#import "CGXPickerViewManager.h"

@interface CGXPickerViewManager ()

@end
@implementation CGXPickerViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kPickerViewH = 200;
        _kTopViewH = 50;
        _pickerTitleSize  =15;
        _pickerTitleColor = [UIColor blackColor];
        _lineViewColor = CGXPickerRGBColor(225, 225, 225, 1);
        
        _titleLabelColor = CGXPickerRGBColor(0, 0, 0, 1);
        _titleSize = 20;
        _titleLabelBGColor = [UIColor whiteColor];
        
        _rightBtnTitle = @"确定";
        _rightBtnBGColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        _rightBtnTitleSize = 16;
        _rightBtnTitleColor = [UIColor whiteColor];
        
        _rightBtnborderColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        _rightBtnCornerRadius = 6;
        _rightBtnBorderWidth = 1;
        
        _leftBtnTitle = @"取消";
        _leftBtnBGColor = CGXPickerRGBColor(222, 222, 222, 1);
        _leftBtnTitleSize = 16;
        _leftBtnTitleColor = [UIColor grayColor];
        
        _leftBtnborderColor = CGXPickerRGBColor(222, 222, 222, 1);
        _leftBtnCornerRadius = 6;
        _leftBtnBorderWidth = 1;
        
    }
    return self;
}
@end
