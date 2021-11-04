//
//  GLBGoodsTimeView.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsTimeView.h"

@interface GLBGoodsTimeView ()
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger timeIndex;

@end

@implementation GLBGoodsTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _dayLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F9F7"];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _dayLabel.text = @"00";
    [_dayLabel dc_cornerRadius:2];
    [self addSubview:_dayLabel];
    
    _spacingLabel = [[UILabel alloc] init];
    _spacingLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _spacingLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _spacingLabel.text = @"天";
    [self addSubview:_spacingLabel];
    
    _hourLabel = [[UILabel alloc] init];
    _hourLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _hourLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F9F7"];
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _hourLabel.text = @"00";
    [_hourLabel dc_cornerRadius:2];
    [self addSubview:_hourLabel];
    
    _spacingLabel1 = [[UILabel alloc] init];
    _spacingLabel1.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _spacingLabel1.font = [UIFont fontWithName:PFRMedium size:12];
    _spacingLabel1.text = @"时";
    [self addSubview:_spacingLabel1];
    
    _minuteLabel = [[UILabel alloc] init];
    _minuteLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _minuteLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F9F7"];
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    _minuteLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _minuteLabel.text = @"00";
    [_minuteLabel dc_cornerRadius:2];
    [self addSubview:_minuteLabel];
    
    _spacingLabel2 = [[UILabel alloc] init];
    _spacingLabel2.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _spacingLabel2.font = [UIFont fontWithName:PFRMedium size:12];
    _spacingLabel2.text = @"分";
    [self addSubview:_spacingLabel2];
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _secondLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F9F7"];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _secondLabel.text = @"00";
    [_secondLabel dc_cornerRadius:2];
    [self addSubview:_secondLabel];
    
    _spacingLabel3 = [[UILabel alloc] init];
    _spacingLabel3.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _spacingLabel3.font = [UIFont fontWithName:PFRMedium size:12];
    _spacingLabel3.text = @"秒";
    [self addSubview:_spacingLabel3];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [_dayLabel sizeThatFits:CGSizeMake(300, 18)];
    
    [_dayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(size.width + 10, 18));
    }];
    
    [_spacingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.right).offset(3);
        make.centerY.equalTo(self.dayLabel.centerY);
    }];
    
    [_hourLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacingLabel.right).offset(3);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 18));
    }];
    
    [_spacingLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.right).offset(3);
        make.centerY.equalTo(self.hourLabel.centerY);
    }];
    
    [_minuteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacingLabel1.right).offset(3);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 18));
    }];
    [_spacingLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.right).offset(3);
        make.centerY.equalTo(self.hourLabel.centerY);
    }];
    
    [_secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacingLabel2.right).offset(3);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 18));
    }];
    [_spacingLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLabel.right).offset(3);
        make.centerY.equalTo(self.hourLabel.centerY);
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLBPromoteModel *)goodsModel
{
    _goodsModel = goodsModel;
     if ([_goodsModel.promotionEtime dc_isNull]||_goodsModel.promotionEtime.length==0) {
           [self showTime];
     }
     else{
         NSString *endTime = _goodsModel.promotionEtime;
            self.timeIndex = [NSDate differenceWithDate:endTime];
            
            [self showTime];
            
            _index = 0;
            [_timer invalidate];
            _timer = nil;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timego:) userInfo:nil repeats:YES];
     }
   
    
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
    if ([_goodsModel.promotionEtime dc_isNull]||_goodsModel.promotionEtime.length==0) {
        self.spacingLabel.hidden = YES;
        self.spacingLabel1.hidden = YES;
        self.spacingLabel2.hidden = YES;
        self.hourLabel.hidden = YES;
        self.minuteLabel.hidden = YES;
        self.secondLabel.hidden = YES;
        self.spacingLabel3.hidden = YES;
    }
    else
    {
        self.spacingLabel.hidden = NO;
        self.spacingLabel1.hidden = NO;
        self.spacingLabel2.hidden = NO;
        self.hourLabel.hidden = NO;
        self.minuteLabel.hidden = NO;
        self.secondLabel.hidden = NO;
        self.spacingLabel3.hidden = NO;
    }
    if ([_goodsModel.promotionEtime dc_isNull]||_goodsModel.promotionEtime.length==0) {
         self.dayLabel.text = @"长期有效";
    }
    else{
         if (diffict > 60*60*24)
           {
               NSInteger day=diffict/(60*60*24);
               NSInteger other = diffict%(60*60*24);
               NSInteger house = other/(60*60);
               NSInteger other1 = diffict%(60*60);
               NSInteger minute = other1/60;
               NSInteger secend = other1%60;
               
               self.dayLabel.text=day< 10 ? [NSString stringWithFormat:@"0%ld",day] : [NSString stringWithFormat:@"%ld",day];
               self.hourLabel.text = house < 10 ? [NSString stringWithFormat:@"0%ld",house] : [NSString stringWithFormat:@"%ld",house];
               self.minuteLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
               self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
           }
        else if (diffict > 60*60) {
               
               NSInteger house = diffict/(60*60);
               NSInteger other = diffict%(60*60);
               NSInteger minute = other/60;
               NSInteger secend = other%60;
               self.dayLabel.text = @"00";
               self.hourLabel.text = house < 10 ? [NSString stringWithFormat:@"0%ld",house] : [NSString stringWithFormat:@"%ld",house];
               self.minuteLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
               self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
               
           } else if (diffict > 60) {
               
               NSInteger minute = diffict/60;
               NSInteger secend = diffict%60;
               self.dayLabel.text = @"00";
               self.hourLabel.text = @"00";
               self.minuteLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
               self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
               
           } else if (diffict > 0){
               self.dayLabel.text = @"00";
               self.hourLabel.text = @"00";
               self.minuteLabel.text = @"00";
               self.secondLabel.text = diffict < 10 ? [NSString stringWithFormat:@"0%ld",diffict] : [NSString stringWithFormat:@"%ld",diffict];
               
           } else {
               self.dayLabel.text = @"00";
               self.hourLabel.text = @"00";
               self.minuteLabel.text = @"00";
               self.secondLabel.text = @"00";
               
               [_timer invalidate];
               _timer = nil;
               _index = 0;
           }
    }
    
   
    
   
    
   
}



- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    _index = 0;
}


@end
