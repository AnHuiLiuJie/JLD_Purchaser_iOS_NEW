//
//  GLBStoreItemView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreItemView.h"

@implementation GLBStoreItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _normalImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.dc_width - 20)/2, 14, 20, 20)];
    [self addSubview:_normalImage];
    
    _selectedImage = [[UIImageView alloc] initWithFrame:self.normalImage.frame];
    _selectedImage.hidden = YES;
    [self addSubview:_selectedImage];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.normalImage.frame) + 0, self.dc_width, 20)];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = PFRFont(11);
    [self addSubview:_titleLabel];

    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.dc_width, 20)];
    _countLabel.dc_centerY = _normalImage.dc_centerY;
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];

}


#pragma mark - setter
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        
        _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        if (_countLabel.text.length == 0) { // 图
            _selectedImage.hidden = NO;
            _normalImage.hidden = YES;
        } else { // 字
            _countLabel.hidden = NO;
            _normalImage.hidden = YES;
        }
        
    } else {
        
        _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        if (_countLabel.text.length == 0) { // 图
            _selectedImage.hidden = YES;
            _normalImage.hidden = NO;
        } else { // 字
            _countLabel.hidden = YES;
            _normalImage.hidden = NO;
        }
    }
}

@end
