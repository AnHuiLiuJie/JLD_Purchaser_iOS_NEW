//
//  GLBPromotionView.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBPromotionView.h"
#import "GLBGoodsTimeView.h"

@interface GLBPromotionView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *hourLabel;
//@property (nonatomic, strong) UILabel *minuteLabel;
//@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, strong) GLBGoodsTimeView *timeView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBPromotionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"spxq_ms"];
    [self addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = PFRFont(12);
    _titleLabel.text = @"距结束";
    [self addSubview:_titleLabel];
    
//    _hourLabel = [[UILabel alloc] init];
//    _hourLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
//    _hourLabel.font = [UIFont fontWithName:PFRMedium size:13];
//    _hourLabel.textAlignment = NSTextAlignmentCenter;
//    _hourLabel.backgroundColor = [UIColor whiteColor];
//    _hourLabel.text = @"00";
//    [self addSubview:_hourLabel];
//
//    _minuteLabel = [[UILabel alloc] init];
//    _minuteLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
//    _minuteLabel.font = [UIFont fontWithName:PFRMedium size:13];
//    _minuteLabel.textAlignment = NSTextAlignmentCenter;
//    _minuteLabel.backgroundColor = [UIColor whiteColor];
//    _minuteLabel.text = @"00";
//    [self addSubview:_minuteLabel];
//
//    _secondLabel = [[UILabel alloc] init];
//    _secondLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
//    _secondLabel.font = [UIFont fontWithName:PFRMedium size:13];
//    _secondLabel.textAlignment = NSTextAlignmentCenter;
//    _secondLabel.backgroundColor = [UIColor whiteColor];
//    _secondLabel.text = @"00";
//    [self addSubview:_secondLabel];
    
    _timeView = [[GLBGoodsTimeView alloc] init];
    [self addSubview:_timeView];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _countLabel.font = [UIFont fontWithName:PFR size:10];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FFF88E"];
    _countLabel.text = @"已抢购0盒";
    [_countLabel dc_cornerRadius:5];
    [self addSubview:_countLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(12);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(12, 14));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.centerY.equalTo(self.centerY);
    }];
    
//    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.right).offset(10);
//        make.centerY.equalTo(self.centerY);
//        make.size.equalTo(CGSizeMake(18, 18));
//    }];
//
//    [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.hourLabel.right).offset(10);
//        make.centerY.equalTo(self.centerY);
//        make.size.equalTo(CGSizeMake(18, 18));
//    }];
//
//    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.minuteLabel.right).offset(10);
//        make.centerY.equalTo(self.centerY);
//        make.size.equalTo(CGSizeMake(18, 18));
//    }];
    
    CGSize size = [_countLabel sizeThatFits:CGSizeMake(200, 18)];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-12);
        make.centerY.equalTo(self.centerY);
        make.height.equalTo(18);
        make.width.equalTo(size.width + 20);
    }];
    
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.right.equalTo(self.countLabel.left).offset(-10);
        make.height.equalTo(18);
        make.centerY.equalTo(self.centerY);
    }];
}


#pragma mark - setter
- (void)setPromoteModel:(GLBPromoteModel *)promoteModel
{
    _promoteModel = promoteModel;
    
    _countLabel.text = [NSString stringWithFormat:@"已抢购%ld盒",(long)_promoteModel.activitySales];
    _timeView.goodsModel = _promoteModel;
    
    _timeView.spacingLabel.textColor = [UIColor whiteColor];
    _timeView.spacingLabel1.textColor = [UIColor whiteColor];
    _timeView.spacingLabel2.textColor = [UIColor whiteColor];
    _timeView.spacingLabel3.textColor = [UIColor whiteColor];
}

@end
