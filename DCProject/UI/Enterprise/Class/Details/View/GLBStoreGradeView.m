//
//  GLBStoreGradeView.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreGradeView.h"

@interface GLBStoreGradeView ()

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UIImageView *image4;
@property (nonatomic, strong) UIImageView *image5;

@end

@implementation GLBStoreGradeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _image1 = [[UIImageView alloc] init];
    [self addSubview:_image1];
    
    _image2 = [[UIImageView alloc] init];
    [self addSubview:_image2];
    
    _image3 = [[UIImageView alloc] init];
    [self addSubview:_image3];
    
    _image4 = [[UIImageView alloc] init];
    [self addSubview:_image4];
    
    _image5 = [[UIImageView alloc] init];
    [self addSubview:_image5];
    
    [self layoutIfNeeded];
}


#pragma mark - setter
- (void)setGrade:(NSInteger)grade
{
    _grade = grade;
    
    UIImage *image = nil;
    NSInteger count = 0;
    if (10<_grade && _grade<16) {
        image = [UIImage imageNamed:@"xx"];
        count = _grade - 10;
    }
    if (20<_grade && _grade<26) {
        image = [UIImage imageNamed:@"zuanshi"];
        count = _grade - 20;
    }
    if (30<_grade && _grade<36) {
        image = [UIImage imageNamed:@"hg"];
        count = _grade - 30;
    }
    
    _image1.image = image;
    _image2.image = image;
    _image3.image = image;
    _image4.image = image;
    _image5.image = image;
    
    if (count == 1) {
        
        _image1.hidden = NO;
        _image2.hidden = YES;
        _image3.hidden = YES;
        _image4.hidden = YES;
        _image5.hidden = YES;
        
    } else if (count == 2 ) {
        
        _image1.hidden = NO;
        _image2.hidden = NO;
        _image3.hidden = YES;
        _image4.hidden = YES;
        _image5.hidden = YES;
        
    } else if (count == 3 ) {
        
        _image1.hidden = NO;
        _image2.hidden = NO;
        _image3.hidden = NO;
        _image4.hidden = YES;
        _image5.hidden = YES;
        
    } else if (count == 4 ) {
        
        _image1.hidden = NO;
        _image2.hidden = NO;
        _image3.hidden = NO;
        _image4.hidden = NO;
        _image5.hidden = YES;
        
    } else if (count == 5 ) {
        
        _image1.hidden = NO;
        _image2.hidden = NO;
        _image3.hidden = NO;
        _image4.hidden = NO;
        _image5.hidden = NO;
        
    } else {
        
        _image1.hidden = YES;
        _image2.hidden = YES;
        _image3.hidden = YES;
        _image4.hidden = YES;
        _image5.hidden = YES;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
    
    [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.right).offset(8);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
    
    [_image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image2.right).offset(8);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
    
    [_image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image3.right).offset(8);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
    
    [_image5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image4.right).offset(8);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(10, 10));
    }];
}

@end
