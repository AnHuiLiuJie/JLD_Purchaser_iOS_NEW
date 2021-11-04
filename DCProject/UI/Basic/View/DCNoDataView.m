//
//  DCNoDataView.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCNoDataView.h"

@interface DCNoDataView ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end

@implementation DCNoDataView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image button:(NSString *__nullable)button tip:(NSString *)tip{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI:frame image:image button:button tip:tip];
    }
    return self;
}

#pragma mark - 创建UI
- (void)setUpUI:(CGRect)frame image:(UIImage *)image button:(NSString *)button tip:(NSString *)tip{
    
    if (!image) return;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.image.frame = CGRectMake((kScreenW-80)/2, CGRectGetHeight(frame)*0.3,  80, 80);
    self.image.image = image;

    if (tip) {
        self.label.frame = CGRectMake(5, CGRectGetMaxY(self.image.frame) + 10, kScreenW-10, 30);
        self.label.text = tip;
    }
    
    if (button) {
        self.button.frame = CGRectMake(CGRectGetMinX(self.image.frame), CGRectGetMaxY(self.image.frame) + 80, CGRectGetWidth(self.image.frame), 36);
        [self.button setTitle:button forState:0];
    }
    
    self.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
}

- (void)noViewButtonClick{
    if (_noDataBlock) {
        _noDataBlock();
    }
}


#pragma mark - lazy load
- (UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc] init];
        [self addSubview:_image];
    }
    return _image;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor dc_colorWithHexString:@"#4B5668"] forState:0];
        _button.titleLabel.font = PFRFont(15);
        [_button dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"4B5668"] radius:18];
        [_button addTarget:nil action:@selector(noViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor dc_colorWithHexString:@"#4B5668"];
        _label.font = [UIFont fontWithName:PFRLight size:15];
        [self addSubview:_label];
    }
    return _label;
}

@end
