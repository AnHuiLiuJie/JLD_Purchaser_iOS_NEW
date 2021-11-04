//
//  GLPGoodsDetailsAllActivityCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/18.
//

#import "GLPGoodsDetailsAllActivityCell.h"

#import "NSTimer+eocBlockSupports.h"

@interface GLPGoodsDetailsAllActivityCell ()

/*背景View*/
@property (nonatomic, strong) UIView *bgView;
/*背景View*/
@property (nonatomic, strong) UIView *timeView;
/*秒*/
@property(nonatomic,strong) UILabel *secondLab;
@property(nonatomic,strong) UILabel *spacLab1;
/*分*/
@property(nonatomic,strong) UILabel *minuteLab;
@property(nonatomic,strong) UILabel *spacLab2;
/*时*/
@property(nonatomic,strong) UILabel *hourLab;
@property(nonatomic,strong) UILabel *spacLab3;
/*天*/
@property(nonatomic,strong) UILabel *dayLab;

/*内容*/
@property(nonatomic,strong) UILabel *titleLab;

@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, assign) CGFloat itemW;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger secondsCountDown;//倒计时总的秒数
/*规则详情*/
@property (nonatomic, strong) UIButton *functionBtn;

@end

static CGFloat cell_spacing_x = 5;
static CGFloat cell_spacing_y = 3;
static CGFloat cell_spacing_h = 44;


@implementation GLPGoodsDetailsAllActivityCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];

    _timeView = [[UIView alloc] init];
    _timeView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_timeView];

    CGFloat itemRadius = 3;
    UIColor *timeColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    UIColor *otherColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    UIColor *bgColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:1.0] ;
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
    [_timeView addSubview:_secondLab];
    
    _spacLab1 = [[UILabel alloc] init];
    _spacLab1.textColor = otherColor;
    _spacLab1.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab1.text = @":";
    [_timeView addSubview:_spacLab1];
    _minuteLab = [[UILabel alloc] init];
    _minuteLab.textColor = timeColor;
    _minuteLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _minuteLab.text = @"00";
    _minuteLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_minuteLab dc_cornerRadius:itemRadius];
    _minuteLab.textAlignment = NSTextAlignmentCenter;
    [_timeView addSubview:_minuteLab];
    
    _spacLab2 = [[UILabel alloc] init];
    _spacLab2.textColor = otherColor;
    _spacLab2.font = [UIFont fontWithName:PFRMedium size:otherSize];
    _spacLab2.text = @":";
    [_timeView addSubview:_spacLab2];
    _hourLab = [[UILabel alloc] init];
    _hourLab.textColor = timeColor;
    _hourLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _hourLab.text = @"00";
    _hourLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_hourLab dc_cornerRadius:itemRadius];
    _hourLab.textAlignment = NSTextAlignmentCenter;
    [_timeView addSubview:_hourLab];
    
    _spacLab3 = [[UILabel alloc] init];
    _spacLab3.textColor = otherColor;
    _spacLab3.textAlignment = NSTextAlignmentCenter;
    _spacLab3.font = [UIFont fontWithName:PFR size:otherSize];
    _spacLab3.text = @"天";
    [_timeView addSubview:_spacLab3];
    _dayLab = [[UILabel alloc] init];
    _dayLab.textColor = timeColor;
    _dayLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _dayLab.text = @"00";
    _dayLab.backgroundColor =  bgColor;//[UIColor colorWithPatternImage:lastImage];;
    [_dayLab dc_cornerRadius:itemRadius];
    _dayLab.textAlignment = NSTextAlignmentCenter;
    [_timeView addSubview:_dayLab];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = otherColor;
    _titleLab.font = [UIFont fontWithName:PFR size:otherSize];
    _titleLab.text = @"后恢复原价";//2人成团，不成退款
    [_bgView addSubview:_titleLab];
    
    _functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_functionBtn setTitle:@"规则详情" forState:0];
    [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _functionBtn.titleLabel.font = PFRFont(10);
    [_functionBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_functionBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xbai"] forState:0];
    _functionBtn.adjustsImageWhenHighlighted = NO;
//    _functionBtn.bounds = CGRectMake(0, 0, btn_H, btn_H);
    [_functionBtn dc_buttonIconRightWithSpacing:57];
    [_bgView addSubview:_functionBtn];
}

#pragma mark - Setter Getter Methods
-(void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;

    __block NSString *actTips = @"";
    __block NSString *timeStr = @"";
    [_detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([actModel.actType isEqualToString:@"seckill"]) {
            actTips = @"秒杀价";
            timeStr = actModel.endTime;
        }else if([actModel.actType isEqualToString:@"collage"]) {
            actTips = @"拼团价";
            timeStr = actModel.endTime;
        }else if([actModel.actType isEqualToString:@"group"]) {
            actTips = @"团购价";
            timeStr = actModel.endTime;
        }
    }];
    
    _titleLab.text = @"";
    if (self.detailType == GLPGoodsDetailTypeCollage) {
        _timeView.hidden = YES;
        _functionBtn.hidden = NO;
        _titleLab.text = @"2人拼团，不成退款";
    }else if (self.detailType == GLPGoodsDetailTypeGroup){
        _timeView.hidden = NO;
        _functionBtn.hidden = YES;
        _dayLab.hidden = NO;
        _spacLab3.hidden = NO;
        _titleLab.text = @"后恢复原价";
    }else if (self.detailType == GLPGoodsDetailTypeSeckill){
        _timeView.hidden = NO;
        _functionBtn.hidden = YES;
        _dayLab.hidden = YES;
        _spacLab3.hidden = YES;
        _titleLab.text = @"后恢复原价";
    }
    
    [self layoutIfNeeded];
    
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
    }
    
//    self.secondsCountDown = 6*3600-(NSInteger) [DCSpeedy getTotalTimeForIntWithStartTime:[DCSpeedy getNowTimeTimesForm:@"yyyy-MM-dd HH:mm:ss"] endTime:timeStr];
    //设置定时器
    __weak typeof(self)weakSelf = self;
     _countDownTimer = [NSTimer eocScheduledTimerWithTimeInterval:1.0 block:^{
         [weakSelf countDownAction];
     } repeats:YES];
}


#pragma mark - action
- (void)functionBtnClick:(UIButton *)button{
    !_GLPGoodsDetailsAllActivityCell_block ? : _GLPGoodsDetailsAllActivityCell_block(@"规则详情");
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
        !self.GLPGoodsDetailsAllActivityCell_block ? : self.GLPGoodsDetailsAllActivityCell_block(@"活动结束");
    }
}

- (void)layoutSubviews{
//    [super layoutSubviews];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    if (self.detailType == GLPGoodsDetailTypeCollage) {
        [_timeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(5);
            make.top.equalTo(self.bgView.top).offset(0);
            make.bottom.equalTo(self.bgView.bottom).offset(0);
            make.width.equalTo(0);
        }];
    }else{
        CGFloat timeViewW = 110;
        if (self.detailType == GLPGoodsDetailTypeGroup) {
            timeViewW = 135;
        }
        [_timeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(5);
            make.top.equalTo(self.bgView.top).offset(0);
            make.bottom.equalTo(self.bgView.bottom).offset(0);
            make.width.equalTo(timeViewW);
        }];
        
        if (self.detailType == GLPGoodsDetailTypeSeckill) {
            
            [_dayLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.timeView.mas_left).offset(5);
                make.centerY.equalTo(self.timeView.centerY);
                make.size.equalTo(CGSizeMake(0, self.itemH));
            }];
            
            [_spacLab3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.dayLab.mas_right).offset(0);
                make.centerY.equalTo(self.timeView.centerY).offset(0);
                make.size.equalTo(CGSizeMake(0, self.itemH));
            }];

        }else{
            [_dayLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.timeView.mas_left);
                make.centerY.equalTo(self.timeView.centerY);
                make.height.equalTo(self.itemH);
                make.width.equalTo(self.itemW);
            }];
            
            [_spacLab3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.dayLab.mas_right).offset(2);
                make.centerY.equalTo(self.timeView.centerY).offset(0);
                make.size.equalTo(CGSizeMake(20, self.itemH));
            }];
        }
    }
    

    [_hourLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab3.mas_right);
        make.centerY.equalTo(self.spacLab3.centerY);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];
    
    [_spacLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLab.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        make.height.equalTo(self.hourLab.height);
    }];
    
    [_minuteLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab2.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        //make.width.height.equalTo(self.hourLab.height);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];
    
    
    [_spacLab1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLab.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        make.height.equalTo(self.hourLab.height);
    }];
    
    [_secondLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab1.mas_right).offset(5);
        make.centerY.equalTo(self.hourLab.centerY);
        //make.width.height.equalTo(self.hourLab.height);
        make.height.equalTo(self.itemH);
        make.width.equalTo(self.itemW);
    }];
    
    [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView.mas_right).offset(0);
        make.centerY.equalTo(self.bgView.centerY).offset(0);
    }];
    
    [_functionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.centerY.equalTo(self.bgView.centerY).offset(0);
    }];
    
}

- (void)dealloc{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end


