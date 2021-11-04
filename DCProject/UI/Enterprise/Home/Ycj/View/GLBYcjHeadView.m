//
//  GLBYcjHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjHeadView.h"

@interface GLBYcjHeadView ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *mintueLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *pointLabel1;
@property (nonatomic, strong) UILabel *pointLabel2;

@property (nonatomic, assign) NSInteger timeIndex;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GLBYcjHeadView

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
    
    _image = [[UIImageView alloc] init];
//    _image.image = [UIImage imageNamed:@"ycj_banner"];
    [self addSubview:_image];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(12);
    _titleLabel.text = @"倒计时";
    [self addSubview:_titleLabel];
    
    _hourLabel = [[UILabel alloc] init];
    _hourLabel.textColor = [UIColor whiteColor];
    _hourLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _hourLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.text = @"00";
    [self addSubview:_hourLabel];
    
    _mintueLabel = [[UILabel alloc] init];
    _mintueLabel.textColor = [UIColor whiteColor];
    _mintueLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _mintueLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _mintueLabel.textAlignment = NSTextAlignmentCenter;
    _mintueLabel.text = @"00";
    [self addSubview:_mintueLabel];
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _secondLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.text = @"00";
    [self addSubview:_secondLabel];
    
    _pointLabel1 = [[UILabel alloc] init];
    _pointLabel1.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _pointLabel1.text = @":";
    _pointLabel1.font = PFRFont(14);
    [self addSubview:_pointLabel1];
    
    _pointLabel2 = [[UILabel alloc] init];
    _pointLabel2.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _pointLabel2.text = @":";
    _pointLabel2.font = PFRFont(14);
    [self addSubview:_pointLabel2];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.height.equalTo(kScreenW*0.26);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.image.bottom).offset(15);
        make.height.equalTo(20);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.left.equalTo(self.titleLabel.right).offset(15);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_pointLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.right).offset(3);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_mintueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.left.equalTo(self.pointLabel1.right).offset(3);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_pointLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mintueLabel.right).offset(3);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.left.equalTo(self.pointLabel2.right).offset(3);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
}


#pragma mark - setter
- (void)setYcjModel:(GLBYcjModel *)ycjModel
{
    _ycjModel = ycjModel;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:_ycjModel.actImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    NSString *endTime = _ycjModel.buyEndTime;
    self.timeIndex = [NSDate differenceWithDate:endTime];
    
    [self showTime];
    
    _index = 0;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timego:) userInfo:nil repeats:YES];
    NSString *yicIsEnd = [NSString stringWithFormat:@"%@",ycjModel.yicIsEnd];
    if ([yicIsEnd isEqualToString:@"2"])
    {
        _titleLabel.text = @"已结束";
        _hourLabel.hidden = YES;
        _mintueLabel.hidden = YES;
       _secondLabel.hidden = YES;
       _pointLabel1.hidden = YES;
        _pointLabel2.hidden = YES;
    }
    else{
        _titleLabel.text = @"倒计时";
        _hourLabel.hidden = NO;
        _mintueLabel.hidden = NO;
        _secondLabel.hidden = NO;
        _pointLabel1.hidden = NO;
        _pointLabel2.hidden = NO;
    }
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
        self.mintueLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
        self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
        
    } else if (diffict > 60) {
        
        NSInteger minute = diffict/60;
        NSInteger secend = diffict%60;
        
        self.hourLabel.text = @"00";
        self.mintueLabel.text = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
        self.secondLabel.text = secend < 10 ? [NSString stringWithFormat:@"0%ld",secend] : [NSString stringWithFormat:@"%ld",secend];
        
    } else if (diffict > 0){
        
        self.hourLabel.text = @"00";
        self.mintueLabel.text = @"00";
        self.secondLabel.text = diffict < 10 ? [NSString stringWithFormat:@"0%ld",diffict] : [NSString stringWithFormat:@"%ld",diffict];
        
    } else {
        
        self.hourLabel.text = @"00";
        self.mintueLabel.text = @"00";
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
