//
//  EtpServiceFeeSearchView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpServiceFeeSearchView.h"
/* 时间选择 */
#import "YZTimePicker.h"

@interface EtpServiceFeeSearchView()<YZTimePickerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) YZTimePicker *timePicker;

@end


static NSString *const StartTimePromptStr = @"请选择开始时间";
static NSString *const EndTimePromptStr = @"请选择结束时间";



@implementation EtpServiceFeeSearchView

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
        
        self.contentView.backgroundColor = [RGB_COLOR(0, 0, 0) colorWithAlphaComponent:0.5f];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(3, _bgView.dc_height/2)];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(templateSingleTapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)templateSingleTapAction:(id)sender
{
    [self dismissWithAnimation:YES];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"EtpServiceFeeSearchView" owner:self options:nil] lastObject];
    _contentView.frame = self.bounds;
    [self addSubview:_contentView];
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    
    [DCSpeedy dc_changeControlCircularWith:_resetBtn AndSetCornerRadius:_resetBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#333333"] canMasksToBounds:YES];
    [DCSpeedy dc_changeControlCircularWith:_defineBtn AndSetCornerRadius:_defineBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    [_resetBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_defineBtn addTarget:self action:@selector(defineAction:) forControlEvents:UIControlEventTouchUpInside];

    [_orderTF addTarget:self action:@selector(order_tfDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_goodsNameTF addTarget:self action:@selector(goods_tfDidChange:) forControlEvents:UIControlEventEditingChanged];

    [DCSpeedy dc_changeControlCircularWith:_starView AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#C8C8C8"] canMasksToBounds:YES];
    [DCSpeedy dc_changeControlCircularWith:_endView AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#C8C8C8"] canMasksToBounds:YES];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapAction:)];
    [_starView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTapAction:)];
    [_endView addGestureRecognizer:tapGesture2];
    
    [_allBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.tag = 1;
    [_allBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor dc_colorWithHexString:DC_AppThemeColor] forState:UIControlStateSelected];
    [DCSpeedy dc_changeControlCircularWith:_allBtn AndSetCornerRadius:2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    _allBtn.selected = NO;

    [_myBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _myBtn.tag = 2;
    [_myBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_myBtn setTitleColor:[UIColor dc_colorWithHexString:DC_AppThemeColor] forState:UIControlStateSelected];
    [DCSpeedy dc_changeControlCircularWith:_myBtn AndSetCornerRadius:2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    _myBtn.selected = NO;
    
    [_twoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _twoBtn.tag = 3;
    [_twoBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_twoBtn setTitleColor:[UIColor dc_colorWithHexString:DC_AppThemeColor] forState:UIControlStateSelected];
    [DCSpeedy dc_changeControlCircularWith:_twoBtn AndSetCornerRadius:2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    _twoBtn.selected = NO;
    
    [_thridBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _thridBtn.tag = 4;
    [_thridBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_thridBtn setTitleColor:[UIColor dc_colorWithHexString:DC_AppThemeColor] forState:UIControlStateSelected];
    [DCSpeedy dc_changeControlCircularWith:_thridBtn AndSetCornerRadius:2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    _thridBtn.selected = NO;
    
    _startTimeLab.tag = 100;
    //_startTimeLab.text = [self getLastDayTimes];
    _startTimeLab.text = StartTimePromptStr;
    _endTimeLab.tag = 200;
    _endTimeLab.text = EndTimePromptStr;
    //endTimeLab.text = [self getCurrentTimes];
}

#pragma mark - set model
- (void)setModel:(PSFSearchConditionModel *)model{
    _model = model;
    
    _orderTF.text = _model.orderNo;
    _goodsNameTF.text = _model.goodsName;
    if (_model.startTime.length != 0) {
        _startTimeLab.text = _model.startTime;
    }
    if (_model.endTime.length != 0) {
        _endTimeLab.text = _model.endTime;
    }
    
    if ([_model.level isEqualToString:@"1"]) {
        _myBtn.selected = YES;
    }else if ([_model.level isEqualToString:@"2"]){
        _twoBtn.selected = YES;
    }else if ([_model.level isEqualToString:@"3"]){
        _thridBtn.selected = YES;
    }else {
        _allBtn.selected = YES;
    }
}

- (void)setShowType:(NSInteger)showType{
    _showType = showType;
    if (_showType == 1) {
        _searchTypeView_H_LayoutConstraint.constant = 0;
        _typeBgView.hidden = YES;
    }
}

#pragma mark - textField
- (void)order_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 100) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:100];
        [SVProgressHUD showInfoWithStatus:@"请输入有效订单号"];
    }
}

- (void)goods_tfDidChange:(UITextField *)textField
{
    if (textField.text.length > 50) {
        ((UITextField *)textField).text = [((UITextField *)textField).text substringToIndex:50];
        [SVProgressHUD showInfoWithStatus:@"请输入正确的商品名"];
    }
}

#pragma mark - 重置
- (void)resetAction:(id)sender
{
    _orderTF.text = @"";
    _goodsNameTF.text = @"";
    //_startTimeLab.text = [self getLastDayTimes];
    //_endTimeLab.text = [self getCurrentTimes];
    _startTimeLab.text = StartTimePromptStr;
    _endTimeLab.text = EndTimePromptStr;
    _allBtn.selected = YES;
    _myBtn.selected = NO;
    _twoBtn.selected = NO;
    _thridBtn.selected = NO;
    
}

#pragma mark - 筛选 提交
- (void)defineAction:(id)sender
{
    self.model.orderNo = self.orderTF.text;
    
    self.model.goodsName = self.goodsNameTF.text;
    
    if (self.myBtn.selected == YES) {
        self.model.level = @"1";
    }else if (self.twoBtn.selected == YES){
        self.model.level = @"2";
    }else if (self.thridBtn.selected == YES){
        self.model.level = @"3";
    }else {
        self.model.level = @"";
    }
    
    if (![self.startTimeLab.text isEqualToString:StartTimePromptStr] && [self.endTimeLab.text isEqualToString:EndTimePromptStr]) {
        [SVProgressHUD showInfoWithStatus:@"请选择结束时间"];
        return;
    }
    
    if ([self.startTimeLab.text isEqualToString:StartTimePromptStr] && ![self.endTimeLab.text isEqualToString:EndTimePromptStr]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开始时间"];
        return;;
    }
    
    if (![self.startTimeLab.text isEqualToString:StartTimePromptStr] && ![self.endTimeLab.text isEqualToString:EndTimePromptStr]) {
        self.model.startTime = self.startTimeLab.text;
        self.model.endTime = self.endTimeLab.text;
    }else{
        self.model.startTime = @"";
        self.model.endTime = @"";
    }

    !_etpServiceFeeSearchViewAction_Block ? : _etpServiceFeeSearchViewAction_Block(self.model);
    [self dismissWithAnimation:YES];
}

- (NSString *)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

- (NSString *)getLastDayTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:datenow];//前一天
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:lastDay];
    return currentTimeString;
}

#pragma mark - 选择时间
- (void)startTapAction:(id)sender
{
    [self transformImageView:_startImg];
    [self startTimeAction:nil];
}

- (void)transformImageView:(UIImageView *)img
{
    CGAffineTransform transform = img.transform;
    if (transform.d < 0) {
        img.transform = CGAffineTransformMakeScale(1,1);
    }else{
        img.transform = CGAffineTransformMakeScale(1,-1);
    }
}

- (void)endTapAction:(id)sender
{
    [self transformImageView:_endImg];
    [self endTimeAction:nil];
}

#pragma mark - 客源类型
- (void)buttonAction:(UIButton *)button{
    _allBtn.selected = NO;
    _myBtn.selected = NO;
    _twoBtn.selected = NO;
    _thridBtn.selected = NO;
    NSInteger tag = button.tag;
    button.selected = YES;
    if (tag == 1) {
        //全部
    }else if(tag == 2){
        //我的客源
    }else if(tag == 2){
        //二级客源
    }else if(tag == 2){
        //三级客源
    }
}

#pragma mark - 时间选择
- (void)startTimeAction:(id)sender{
    if (_startTimeLab.tag == 100) {
        _startTimeLab.tag = 101;
    }else
        _startTimeLab.tag = 100;
    
    // 初始化日历 开始
    [self initCalendarView:0];
}

- (void)endTimeAction:(id)sender{
    // 初始化日历 结束
    if (_endTimeLab.tag == 200) {
        _endTimeLab.tag = 201;
    }else
        _endTimeLab.tag = 200;
    
    [self initCalendarView:1];
}

- (void)initCalendarView:(NSInteger )type {
    NSString *timeStr = @"";
    NSString *titleStr = StartTimePromptStr;
    if (type == 0) {
        timeStr = _startTimeLab.text;
    }else{
        timeStr = _endTimeLab.text;
        titleStr = EndTimePromptStr;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [NSDate date];
    NSDate *endDate = date;
    if (![timeStr isEqualToString:StartTimePromptStr] && ![timeStr isEqualToString:EndTimePromptStr]) {
        date = [formatter dateFromString:timeStr];
    }else{
        if (type == 0) {
            timeStr = [self getLastDayTimes];
        }else{
            timeStr = [self getCurrentTimes];
        }
        date = [formatter dateFromString:timeStr];
    }
    
    NSDate *myDate = date;
    
    NSString *startStr = @"2018-01-01";//用于选择起始的 一个限制条件
    NSDate *startDate = [formatter dateFromString:startStr];
    
    [self.timePicker setPickerWithMyDate:myDate startDate:startDate endDate:endDate Title:titleStr];
}

#pragma mark - MyPickerToolDelegate
- (void)toobarDonBtnHaveClick:(YZTimePicker *)pickView date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *time = [dateFormatter stringFromDate:date];
    if (_startTimeLab.tag == 101) {
        _startTimeLab.tag = 100;
        NSDate *ydata = [dateFormatter dateFromString:_endTimeLab.text];
        NSDate *nowDate = [self fitTimezoneWithDate:ydata];;
        BOOL isAday = date.timeIntervalSince1970 - nowDate.timeIntervalSince1970 > 0;
        if (isAday && ![_endTimeLab.text isEqualToString:EndTimePromptStr]) {
            [SVProgressHUD showErrorWithStatus:@"选择大于结束的时间"];
        }else{
            _startTimeLab.text = time;
        }
        
    }
    
    if (_endTimeLab.tag == 201) {
        _endTimeLab.tag = 200;
        NSDate *ydata = [dateFormatter dateFromString:_startTimeLab.text];
        NSDate *nowDate = [self fitTimezoneWithDate:ydata];;
        BOOL isAday = date.timeIntervalSince1970 - nowDate.timeIntervalSince1970 >= 0;
        if (!isAday && ![_startTimeLab.text isEqualToString:StartTimePromptStr]) {
            [SVProgressHUD showErrorWithStatus:@"选择小于结束的时间"];
        }else{
            _endTimeLab.text = time;
        }
        
    }
}

- (NSDate *)fitTimezoneWithDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date  dateByAddingTimeInterval:interval];
    
    return date;
}

- (YZTimePicker *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[YZTimePicker alloc] init];
        _timePicker.delegate = self;
        
        WEAKSELF;
        _timePicker.removeViewBlock = ^{
            if (weakSelf.startTimeLab.tag == 101) {
                [weakSelf transformImageView:weakSelf.startImg];
            }else{
                if (weakSelf.endTimeLab.tag != 201) {
                    [weakSelf transformImageView:weakSelf.startImg];
                }
            }
            
            if (weakSelf.endTimeLab.tag == 201) {
                [weakSelf transformImageView:weakSelf.endImg];
            }else{
                if (weakSelf.startTimeLab.tag != 101) {
                    [weakSelf transformImageView:weakSelf.endImg];
                }
            }
            
//            weakSelf.startTimeLab.tag = 100;
//            weakSelf.endTimeLab.tag = 200;;

        };
    }
    
    return _timePicker;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//#pragma mark - 弹出视图方法
//- (void)showWithAnimation:(BOOL)animation {
//    //1. 获取当前应用的主窗口
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//    [keyWindow addSubview:self];
//    if (animation) {
//        // 动画前初始位置
//        CGRect rect = self.bgView.frame;
//        rect.origin.y = SCREEN_HEIGHT;
//        self.bgView.frame = rect;
//        // 浮现动画
//        [UIView animateWithDuration:0.3 animations:^{
//            CGRect rect = self.bgView.frame;
//            rect.origin.y -= SCREEN_HEIGHT + kStatusBarHeight + LJ_TabbarSafeBottomMargin;
//            self.bgView.frame = rect;
//        }];
//    }
//}
//

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.backgroundColor = [UIColor whiteColor];;
        CGRect rect = self.bgView.frame;
        rect.origin.y -= self.bgView.dc_height-kStatusBarHeight;
        NSLog(@"%f",rect.origin.y);
        self.bgView.frame = rect;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        !self.did_removeView_Block ? : self.did_removeView_Block();
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
