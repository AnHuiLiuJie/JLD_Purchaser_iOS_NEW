//
//  GLBEvaluateGardeView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBEvaluateGardeView.h"

@interface GLBEvaluateGardeView ()

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UIImageView *image4;
@property (nonatomic, strong) UIImageView *image5;

@end

@implementation GLBEvaluateGardeView

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
    _image1.image = [UIImage imageNamed:@"pjxxh"];
    [self addSubview:_image1];
    
    _image2 = [[UIImageView alloc] init];
    _image2.image = [UIImage imageNamed:@"pjxxh"];
    [self addSubview:_image2];
    
    _image3 = [[UIImageView alloc] init];
    _image3.image = [UIImage imageNamed:@"pjxxh"];
    [self addSubview:_image3];
    
    _image4 = [[UIImageView alloc] init];
    _image4.image = [UIImage imageNamed:@"pjxxh"];
    [self addSubview:_image4];
    
    _image5 = [[UIImageView alloc] init];
    _image5.image = [UIImage imageNamed:@"pjxxh"];
    [self addSubview:_image5];
    
    [self layoutIfNeeded];
}


#pragma mark - setter
- (void)setScore:(NSInteger)score
{
    _score = score;
    
    if (_score == 1) {
        
        _image1.image = [UIImage imageNamed:@"pjxx"];
        _image2.image = [UIImage imageNamed:@"pjxxh"];
        _image3.image = [UIImage imageNamed:@"pjxxh"];
        _image4.image = [UIImage imageNamed:@"pjxxh"];
        _image5.image = [UIImage imageNamed:@"pjxxh"];
        
    } else if (_score == 2 ) {
        
        _image1.image = [UIImage imageNamed:@"pjxx"];
        _image2.image = [UIImage imageNamed:@"pjxx"];
        _image3.image = [UIImage imageNamed:@"pjxxh"];
        _image4.image = [UIImage imageNamed:@"pjxxh"];
        _image5.image = [UIImage imageNamed:@"pjxxh"];
        
    } else if (_score == 3 ) {
        
        _image1.image = [UIImage imageNamed:@"pjxx"];
        _image2.image = [UIImage imageNamed:@"pjxx"];
        _image3.image = [UIImage imageNamed:@"pjxx"];
        _image4.image = [UIImage imageNamed:@"pjxxh"];
        _image5.image = [UIImage imageNamed:@"pjxxh"];
        
    } else if (_score == 4 ) {
        
        _image1.image = [UIImage imageNamed:@"pjxx"];
        _image2.image = [UIImage imageNamed:@"pjxx"];
        _image3.image = [UIImage imageNamed:@"pjxx"];
        _image4.image = [UIImage imageNamed:@"pjxx"];
        _image5.image = [UIImage imageNamed:@"pjxxh"];
        
    } else if (_score == 5 ) {
        
        _image1.image = [UIImage imageNamed:@"pjxx"];
        _image2.image = [UIImage imageNamed:@"pjxx"];
        _image3.image = [UIImage imageNamed:@"pjxx"];
        _image4.image = [UIImage imageNamed:@"pjxx"];
        _image5.image = [UIImage imageNamed:@"pjxx"];
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.right).offset(5);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image2.right).offset(5);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image3.right).offset(5);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
    
    [_image5 mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.image4.right).offset(5);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(14, 14));
    }];
}

@end
