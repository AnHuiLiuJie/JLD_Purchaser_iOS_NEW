//
//  GLPSpikeHomeHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPSpikeHomeHeaderView.h"
#import "NSTimer+eocBlockSupports.h"

@interface GLPSpikeHomeHeaderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic, strong) UIButton *imgBtn;


@property (nonatomic, strong) UIView *lineView;

@end

@implementation GLPSpikeHomeHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _lineView = [[UIView alloc] init];
    [_bgView addSubview:_lineView];
    _lineView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_titleBtn];
    [_titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    [_titleBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_titleBtn setBackgroundImage:[UIImage imageNamed:@"dc_spike_timeType"] forState:UIControlStateSelected];
    [_titleBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    [_titleBtn setTitle:@"本期秒杀\n\n" forState:UIControlStateNormal];
    [_titleBtn setTitle:@"本期秒杀\n\n" forState:UIControlStateSelected];
    _titleBtn.selected = YES;
    _titleBtn.backgroundColor = [UIColor clearColor];
    _titleBtn.clipsToBounds = NO;

    
    _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_imgBtn];
    [_imgBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _imgBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    [_imgBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_imgBtn setBackgroundImage:[UIImage imageNamed:@"dc_spike_timeType"] forState:UIControlStateSelected];
    [_imgBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    [_imgBtn setTitle:@"下期预告\n\n" forState:UIControlStateNormal];
    [_imgBtn setTitle:@"下期预告\n\n" forState:UIControlStateSelected];
    _imgBtn.selected = NO;
    _imgBtn.backgroundColor = [UIColor clearColor];
    _imgBtn.clipsToBounds = NO;
    
    _timeBgView = [[GLPSpikeHomeTimeView alloc] init];
    WEAKSELF;
    _timeBgView.GLPSpikeHomeTimeView_block = ^{
        !weakSelf.GLPSpikeHomeHeaderView_block ? : weakSelf.GLPSpikeHomeHeaderView_block();
    };
    [_bgView addSubview:_timeBgView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(-10);
        make.left.equalTo(self.bgView.left).offset(15);
        make.size.equalTo(CGSizeMake(90, 90));
    }];
    
    [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(-10);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.size.equalTo(CGSizeMake(90, 90));
    }];
    
    [_timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBtn.bottom).offset(-15);
        make.centerX.equalTo(self.bgView.centerX).offset(0);
        make.size.equalTo(CGSizeMake(150, 30));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView.bottom).offset(-5);
        make.height.equalTo(5);
    }];
    
}

#pragma mark - Setter Getter Methods
- (void)setGoodsType:(NSInteger)goodsType{
    _goodsType = goodsType;
    
    if (_goodsType == 1) {
        [self titleBtnAction:_titleBtn];
    }else
        [self titleBtnAction:_imgBtn];
}

- (void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    
    _timeBgView.timeStr = _timeStr;
    _timeBgView.detailType = _goodsType;
}

- (void)titleBtnAction:(UIButton *)button{
    if ([button isEqual:_imgBtn]) {
        _titleBtn.selected = NO;
        _imgBtn.selected = YES;
        !_GLPSpikeHomeHeaderView_switchBlock ? : _GLPSpikeHomeHeaderView_switchBlock(2);
    }else{
        _titleBtn.selected = YES;
        _imgBtn.selected = NO;
        !_GLPSpikeHomeHeaderView_switchBlock ? : _GLPSpikeHomeHeaderView_switchBlock(1);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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

@interface GLPSpikeHomeTimeView ()

@property(nonatomic,strong) UILabel *secondLab;
@property(nonatomic,strong) UILabel *spacLab1;
@property(nonatomic,strong) UILabel *minuteLab;
@property(nonatomic,strong) UILabel *spacLab2;
@property(nonatomic,strong) UILabel *hourLab;
@property(nonatomic,strong) UILabel *spacLab3;

@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, assign) CGFloat itemW;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger secondsCountDown;//倒计时总的秒数

@end


@implementation GLPSpikeHomeTimeView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    

    CGFloat itemRadius = 2;
    //self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIColor *timeColor = [UIColor dc_colorWithHexString:@"#BB1019"];
    //UIColor *bgColor = [UIColor dc_colorWithHexString:@"#f6eedb" alpha:0.8] ;
    UIColor *otherColor = [UIColor dc_colorWithHexString:@"#333333"];
    NSInteger tiemSize = 18;
    NSInteger otherSize = 12;
    _itemW = 35;
    _itemH = 20;
    UIImage *image = [UIImage imageNamed:@"dc_time_bg.png"];
//    if (@available(iOS 13.0, *)) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.itemW, self.itemH), NO, 0.f);
        [image drawInRect:CGRectMake(0, 0, self.itemW-3, self.itemH)];
//    } else {
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.itemW+2, self.itemH), NO, 0.f);
//        [image drawInRect:CGRectMake(0, 0, self.itemW-3, self.itemH-3)];
//    }
    
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    _secondLab = [[UILabel alloc] init];
    _secondLab.textColor = timeColor;
    _secondLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _secondLab.text = @"00";
    _secondLab.backgroundColor = [UIColor colorWithPatternImage:lastImage];
    [_secondLab dc_cornerRadius:itemRadius];
    [self addSubview:_secondLab];

    
    _spacLab1 = [[UILabel alloc] init];
    _spacLab1.textColor = timeColor;
    _spacLab1.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab1.text = @":";
    [self addSubview:_spacLab1];
    _minuteLab = [[UILabel alloc] init];
    _minuteLab.textColor = timeColor;
    _minuteLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _minuteLab.text = @"00";
    _minuteLab.backgroundColor =  [UIColor colorWithPatternImage:lastImage];;
    [_minuteLab dc_cornerRadius:itemRadius];
    [self addSubview:_minuteLab];

    _spacLab2 = [[UILabel alloc] init];
    _spacLab2.textColor = timeColor;
    _spacLab2.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab2.text = @":";
    [self addSubview:_spacLab2];
    
    _hourLab = [[UILabel alloc] init];
    _hourLab.textColor = timeColor;
    _hourLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _hourLab.text = @"00";
    _hourLab.backgroundColor =  [UIColor colorWithPatternImage:lastImage];;
    [_hourLab dc_cornerRadius:itemRadius];
    [self addSubview:_hourLab];

    _spacLab3 = [[UILabel alloc] init];
    _spacLab3.textColor = otherColor;
    _spacLab3.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab3.text = @"距结束";
    [self addSubview:_spacLab3];
    
//    if (@available(iOS 13.0, *)) {
        [UILabel changeWordSpaceForLabel:_secondLab WithSpace:5.0];
        [UILabel changeWordSpaceForLabel:_minuteLab WithSpace:5.0];
        [UILabel changeWordSpaceForLabel:_hourLab WithSpace:5.0];
        
        _secondLab.textAlignment = NSTextAlignmentCenter;
        _minuteLab.textAlignment = NSTextAlignmentCenter;
        _hourLab.textAlignment = NSTextAlignmentCenter;
//    }


}


//实现倒计时动作
- (void)countDownAction{
    //倒计时-1
    self.secondsCountDown--;
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown%60];
    self.hourLab.text = str_hour;
    self.minuteLab.text = str_minute;
    self.secondLab.text = str_second;
    
//    if (@available(iOS 13.0, *)) {
//
//    }else{
//        [UILabel changeWordSpaceForLabel:_secondLab WithSpace:5.0];
//        [UILabel changeWordSpaceForLabel:_minuteLab WithSpace:5.0];
//        [UILabel changeWordSpaceForLabel:_hourLab WithSpace:5.0];
//
//        _secondLab.textAlignment = NSTextAlignmentCenter;
//        _minuteLab.textAlignment = NSTextAlignmentRight;
//        _hourLab.textAlignment = NSTextAlignmentCenter;
//    }

    //NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    //self.timeLab.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
    //当倒计时到0时做需要的操作，
    if(self.secondsCountDown<=0){
        [self.countDownTimer invalidate];
        //self.passwordView.userInteractionEnabled = YES;
        !self.GLPSpikeHomeTimeView_block ? : self.GLPSpikeHomeTimeView_block();
    }
}

#pragma mark - set
-(void)setDetailType:(NSInteger)detailType{
    _detailType = detailType;
}

- (void)setTimeStr:(NSString *)timeStr{//2021-09-17 09:59:59
    _timeStr = timeStr;
    
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    
    if (_timeStr.length == 0) {
        return;
    }
    
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
    }
    
//    self.secondsCountDown = 6*3600-(NSInteger) [DCSpeedy getTotalTimeForIntWithStartTime:[DCSpeedy getNowTimeTimesForm:@"yyyy-MM-dd HH:mm:ss"] endTime:timeStr];
    //设置定时器
    __weak typeof(self)weakSelf = self;
     _countDownTimer = [NSTimer eocScheduledTimerWithTimeInterval:1.0 block:^{
         [weakSelf countDownAction];
     } repeats:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.detailType == 1) {
        _spacLab3.text = @"距结束：";

    }else{
        _spacLab3.text = @"距开始：";
    }
    
    [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.centerY.equalTo(self.centerY).offset(0);
        make.height.equalTo(18);
    }];
    
    [_hourLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab3.mas_right);
        make.centerY.equalTo(self.spacLab3.centerY);
        make.height.equalTo(self.itemH);
        make.width.greaterThanOrEqualTo(self.itemW);
    }];
    
    [_spacLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLab.mas_right).offset(3);
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
        make.left.equalTo(self.minuteLab.mas_right).offset(3);
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


