//
//  GLPGroupDetailsFootterView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import "GLPGroupDetailsFootterView.h"
#import "NSTimer+eocBlockSupports.h"

 
@interface GLPGroupDetailsFootterView ()

@property (nonatomic, strong) UILabel *titleLab;

/*背景View*/
@property (nonatomic, strong) GLPGroupDetailsTimeView *timeView;
@property (nonatomic, strong) UIButton *functionBtn;

@property (nonatomic, strong) UILabel *contentLab;

@end


@implementation GLPGroupDetailsFootterView

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


    UIView *leftLine = [[UIView alloc] init];
    [self addSubview:leftLine];
    leftLine.backgroundColor = [UIColor dc_colorWithHexString:@"#CC0000"];
    
    _titleLab = [[UILabel alloc] init];
    [self addSubview:_titleLab];
    _titleLab.font = [UIFont fontWithName:PFR size:15];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#CC0000"];
    _titleLab.text = @"距结束";
    _titleLab.textAlignment = NSTextAlignmentCenter;

    
    UIView *rightLine = [[UIView alloc] init];
    [self addSubview:rightLine];
    rightLine.backgroundColor = [UIColor dc_colorWithHexString:@"#CC0000"];
    
    _functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_functionBtn setTitle:@" 查看订单 " forState:0];
    _functionBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#CC0000"];
    [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _functionBtn.titleLabel.font = PFRFont(14);
    _functionBtn.tag = 800;
    [_functionBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_functionBtn];
    _functionBtn.hidden = YES;
    
    _timeView = [[GLPGroupDetailsTimeView alloc] init];
    _timeView.backgroundColor = [UIColor clearColor];
    [self addSubview:_timeView];
    _timeView.hidden = NO;
    
    _contentLab = [[UILabel alloc] init];
    [self addSubview:_contentLab];
    _contentLab.font = [UIFont fontWithName:PFR size:14];
    _contentLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _contentLab.text = @"X人成团，还差*人";
    _contentLab.textAlignment = NSTextAlignmentCenter;

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(10);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLab.left).offset(-10);
        make.centerY.equalTo(self.titleLab.centerY);
        make.size.equalTo(CGSizeMake(100, 1));
        //make.left.equalTo(self).offset(40);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.right).offset(10);
        make.centerY.equalTo(self.titleLab.centerY);
        make.size.equalTo(CGSizeMake(100, 1));
        //make.left.equalTo(self).offset(40);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.bottom).offset(20);
        make.centerX.equalTo(self.titleLab.centerX).offset(13);
        make.size.equalTo(CGSizeMake(120, 30));
    }];
    
    [_functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.bottom).offset(20);
        make.centerX.equalTo(self.titleLab.centerX);
        make.size.equalTo(CGSizeMake(120, 30));
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.bottom).offset(25);
        make.centerX.equalTo(self.titleLab.centerX);
    }];
    
    [_functionBtn dc_cornerRadius:15];

}

#pragma mark - set
-(void)setModel:(DCMyCollageListModel *)model{
    _model = model;
    
    //参与状态：0-等待参与，1-成功，2-失败，3-等待付款
    if ([_model.joinState isEqualToString:@"0"]) {
        _titleLab.text = @"距结束";
        
        _timeView.hidden = NO;
        _functionBtn.hidden = YES;
        _contentLab.text = @"2人成团，还差一人";
        
    }else if([_model.joinState isEqualToString:@"1"]) {
        _titleLab.text = @"拼团成功";
        
        _timeView.hidden = YES;
        _functionBtn.hidden = NO;
        _contentLab.text = [NSString stringWithFormat:@"%@人参团",_model.joinUserCount];
    }else if([_model.joinState isEqualToString:@"2"]) {
        _titleLab.text = @"拼团失败";
        
        _timeView.hidden = YES;
        _functionBtn.hidden = NO;
        _contentLab.text = @"拼团失败";

    }else if([_model.joinState isEqualToString:@"3"]) {
        _titleLab.text = @"等待付款";
        
        _timeView.hidden = NO;
        _functionBtn.hidden = YES;
        _contentLab.text = @"等待付款";
    }
    
    self.timeView.model = _model;
}



#pragma mark - actionMethod
- (void)bottomBtnClick:(UIButton *)buttton{
    !_GLPGroupDetailsFootterView_block ? : _GLPGroupDetailsFootterView_block();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




#pragma mark *******************************   时间倒计时View **************************************

@interface GLPGroupDetailsTimeView ()

@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, assign) CGFloat itemW;
//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger secondsCountDown;//倒计时总的秒数

@end


@implementation GLPGroupDetailsTimeView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{

    CGFloat itemRadius = 3;
    UIColor *timeColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    UIColor *otherColor = [UIColor dc_colorWithHexString:@"#CC0000"];
    UIColor *bgColor = [UIColor dc_colorWithHexString:@"#CC0000" alpha:1.0] ;
    NSInteger tiemSize = 12;
    NSInteger otherSize = 12;
    _itemH = 20;
    _itemW = 20;
//    UIImage *image = [UIImage imageNamed:@"dc_time_bg.png"];  UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.itemW, self.itemH), NO, 0.f);
//    [image drawInRect:CGRectMake(0, 0, self.itemW, self.itemH)];
//    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    
    _secondLab = [[UILabel alloc] init];
    _secondLab.textColor = timeColor;
    _secondLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _secondLab.text = @"00";
    _secondLab.backgroundColor = bgColor;//[UIColor colorWithPatternImage:lastImage];
    [_secondLab dc_cornerRadius:itemRadius];
    _secondLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_secondLab];
    
    _spacLab1 = [[UILabel alloc] init];
    _spacLab1.textColor = otherColor;
    _spacLab1.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab1.text = @":";
    [self addSubview:_spacLab1];
    _minuteLab = [[UILabel alloc] init];
    _minuteLab.textColor = timeColor;
    _minuteLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _minuteLab.text = @"00";
    _minuteLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_minuteLab dc_cornerRadius:itemRadius];
    _minuteLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_minuteLab];
    
    _spacLab2 = [[UILabel alloc] init];
    _spacLab2.textColor = otherColor;
    _spacLab2.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab2.text = @":";
    [self addSubview:_spacLab2];
    _hourLab = [[UILabel alloc] init];
    _hourLab.textColor = timeColor;
    _hourLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _hourLab.text = @"00";
    _hourLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_hourLab dc_cornerRadius:itemRadius];
    _hourLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hourLab];
    
    _spacLab3 = [[UILabel alloc] init];
    _spacLab3.textColor = otherColor;
    _spacLab3.font = [UIFont fontWithName:PFR size:otherSize];
    _spacLab3.text = @"天";
    [self addSubview:_spacLab3];
    _dayLab = [[UILabel alloc] init];
    _dayLab.textColor = timeColor;
    _dayLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _dayLab.text = @"00";
    _dayLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_dayLab dc_cornerRadius:itemRadius];
    _dayLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dayLab];
}

#pragma mark - set

- (void)setModel:(DCMyCollageListModel *)model{
    _model = model;
    
    __block NSString *timeStr = model.endTime;
//    if ([_model.joinState isEqualToString:@"3"]) {
//        timeStr = model.endTime;
//    }
    if (timeStr.length == 0) {
        return;
    }
    
    [_countDownTimer invalidate];
    _countDownTimer = nil;

    NSString *endtime = [NSString stringWithFormat:@"%@",timeStr];
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curTime = [formatter stringFromDate:date];
    NSDate *endDate = [NSDate dateFromString:endtime];
    NSDate *currentDate = [NSDate dateFromString:curTime];
    NSTimeInterval vale = [endDate timeIntervalSinceDate:currentDate];
    int timenum = vale;
    if (vale>0)
    {
        self.secondsCountDown = timenum;
    }else{
        self.hourLab.text = @"00";
        self.minuteLab.text = @"00";
        self.secondLab.text = @"00";
        return;
    }
    
    //    self.secondsCountDown = 6*3600-(NSInteger) [DCSpeedy getTotalTimeForIntWithStartTime:[DCSpeedy getNowTimeTimesForm:@"yyyy-MM-dd HH:mm:ss"] endTime:timeStr];
        //设置定时器
        __weak typeof(self)weakSelf = self;
         _countDownTimer = [NSTimer eocScheduledTimerWithTimeInterval:1.0 block:^{
             [weakSelf countDownAction];
         } repeats:YES];
    
}

//实现倒计时动作
- (void)countDownAction{
    //倒计时-1
    self.secondsCountDown--;
    //重新计算 时/分/秒
    NSString *str_day = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/(3600*24)];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/3600];
    if ([str_day integerValue]>0) {
        str_hour = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown-[str_day integerValue]*3600*24)/3600];
    }
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown%60];
    self.dayLab.text = str_day;
    self.hourLab.text = str_hour;
    self.minuteLab.text = str_minute;
    self.secondLab.text = str_second;
    //NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    //self.timeLab.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
    //当倒计时到0时做需要的操作，
    if(self.secondsCountDown<=0){
        [self.countDownTimer invalidate];
        //self.passwordView.userInteractionEnabled = YES;
        !self.GLPGroupDetailsTimeView_endblock ? : self.GLPGroupDetailsTimeView_endblock(@"活动结束");
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.timeType == 1) {
        
        [_dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(self.itemH);
            make.width.equalTo(self.itemW);
        }];
        
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLab.mas_right).offset(0);
            make.centerY.equalTo(self.centerY).offset(0);
            make.size.equalTo(CGSizeMake(20, self.itemH));
        }];

    }else{
        [_dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(self.itemH);
            make.width.equalTo(0);
        }];
        
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLab.mas_right).offset(0);
            make.centerY.equalTo(self.centerY).offset(0);
            make.size.equalTo(CGSizeMake(0, self.itemH));
        }];
    }
    
    [_hourLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab3.mas_right);
        make.centerY.equalTo(self.spacLab3.centerY);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];
    
    [_spacLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLab.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        make.height.equalTo(self.hourLab.height);
    }];
    
    [_minuteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab2.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        //make.width.height.equalTo(self.hourLab.height);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];
    
    
    [_spacLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLab.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        make.height.equalTo(self.hourLab.height);
    }];
    
    [_secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab1.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        //make.width.height.equalTo(self.hourLab.height);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];

}

- (void)dealloc{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end


