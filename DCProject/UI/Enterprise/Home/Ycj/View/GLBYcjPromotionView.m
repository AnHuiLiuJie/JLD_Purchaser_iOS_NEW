//
//  GLBYcjPromotionView.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjPromotionView.h"

@interface GLBYcjPromotionView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *fullCountLabel;
@property (nonatomic, strong) UILabel *sellCountLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger timeIndex;

@end

@implementation GLBYcjPromotionView

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
    
    _hourLabel = [[UILabel alloc] init];
    _hourLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _hourLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.backgroundColor = [UIColor whiteColor];
    _hourLabel.text = @"00";
    [self addSubview:_hourLabel];
    
    _minuteLabel = [[UILabel alloc] init];
    _minuteLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _minuteLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    _minuteLabel.backgroundColor = [UIColor whiteColor];
    _minuteLabel.text = @"00";
    [self addSubview:_minuteLabel];
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _secondLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.backgroundColor = [UIColor whiteColor];
    _secondLabel.text = @"00";
    [self addSubview:_secondLabel];
    
    _fullCountLabel = [[UILabel alloc] init];
    _fullCountLabel.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    _fullCountLabel.font = [UIFont fontWithName:PFR size:12];
    _fullCountLabel.text = @"件装量：0盒";
    [self addSubview:_fullCountLabel];
    
    _sellCountLabel = [[UILabel alloc] init];
    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    _sellCountLabel.font = [UIFont fontWithName:PFR size:12];
    _sellCountLabel.text = @"已购量：0盒";
    [self addSubview:_sellCountLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    _priceLabel.font = [UIFont fontWithName:PFR size:12];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.attributedText = [self dc_attributeStr:@"0.000"];
    [self addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}



#pragma mark -
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价 ￥%@",string]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(0, 2)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:20]} range:NSMakeRange(2, attStr.length - 2)];
    return attStr;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(12);
        make.top.equalTo(self.top).offset(9);
        make.size.equalTo(CGSizeMake(12, 14));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
    CGSize size = [_hourLabel sizeThatFits:CGSizeMake(200, 18)];
    
    [_hourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(size.width + 10, 18));
    }];
    
    [_minuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.right).offset(10);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    [_secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.right).offset(10);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    [_fullCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.left);
        make.top.equalTo(self.iconImage.bottom).offset(18);
    }];
    
    [_sellCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullCountLabel.right).offset(20);
        make.centerY.equalTo(self.fullCountLabel.centerY);
    }];
    
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-12);
        make.centerY.equalTo(self.fullCountLabel.centerY);
    }];
}


#pragma mark - setter
- (void)setYcjModel:(GLBYcjModel *)ycjModel
{
    _ycjModel = ycjModel;
    
    if (_ycjModel.goods && [_ycjModel.goods count] > 0) {
        GLBYcjGoodsModel *goodsModel = _ycjModel.goods[0];
        _priceLabel.attributedText = [self dc_attributeStr:[NSString stringWithFormat:@"%.3f",[goodsModel.price floatValue]]];
         _sellCountLabel.text = [NSString stringWithFormat:@"已购量：%ld盒",goodsModel.buyAmount] ;
        _fullCountLabel.text = [NSString stringWithFormat:@"件装量：%ld盒",goodsModel.pkgPackingNum] ;
    }
    
    NSString *endTime = _ycjModel.buyEndTime;
    self.timeIndex = [NSDate differenceWithDate:endTime];
    
    [self showTime];
    
    _index = 0;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timego:) userInfo:nil repeats:YES];
    
    [self layoutSubviews];
}


- (void)timego:(id)sender
{
    _index ++;
    
    [self showTime];
}


- (void)showTime
{
    NSInteger diffict = self.timeIndex - _index;
    if (diffict > 60*60) {
        
        NSInteger house = diffict/(60*60);
        NSInteger other = diffict%(60*60);
        NSInteger minute = other/60;
        NSInteger secend = other%60;
        
        self.hourLabel.text = house < 10 ? [NSString stringWithFormat:@"0%ld",house] : [NSString stringWithFormat:@"%ld",house];
        self.minuteLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
        self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
        
    } else if (diffict > 60) {
        
        NSInteger minute = diffict/60;
        NSInteger secend = diffict%60;
        
        self.hourLabel.text = @"00";
        self.minuteLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
        self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
        
    } else if (diffict > 0){
        
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = diffict < 10 ? [NSString stringWithFormat:@"0%ld",diffict] : [NSString stringWithFormat:@"%ld",diffict];
        
    } else {
        
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
        
        [_timer invalidate];
        _timer = nil;
        _index = 0;
    }
}



- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    _index = 0;
}

@end
