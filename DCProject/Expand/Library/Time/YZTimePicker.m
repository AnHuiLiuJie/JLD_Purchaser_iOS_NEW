//
//  YZTimePicker.m
//  YZTimePicker
//
//  Created by cuimingwei on 16/9/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "YZTimePicker.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MYFONT(s) [UIFont systemFontOfSize:s]
#define RGBHEX(hex)  [UIColor colorWithRed:(float)((hex >> 16) & 0xFF)/255.0f green:(float)((hex >> 8) & 0xFF)/255.0f blue:(float)((hex) & 0xFF)/255.0f alpha:1.0f]

@interface YZTimePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong)NSDate *startDate;
@property (nonatomic, strong)NSDate *endDate;
@property (nonatomic, strong)NSDate *myDate;

@property (strong, nonatomic) NSDateComponents *myComponents;
@property (nonatomic, strong)NSCalendar *calendar;
@end


@implementation YZTimePicker
- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 248)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self setUpPickView];
        [self setFrameWith];
        [self setToolViews];
        
    }
    return self;
}

- (void)setFrameWith{
    
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
}


- (void)setUpPickView{
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = [UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.frame = CGRectMake(0, 58, WIDTH,_pickerView.frame.size.height);
    [self.bottomView addSubview:pickView];
}

//设置工具栏
- (void)setToolViews
{
    
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(0, 0, 80, 57);
    [cancalBtn setImage:[UIImage imageNamed:@"pregnant_button_cancal"] forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cancalBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(WIDTH-80, 0, 80, 57);
    [okBtn setImage:[UIImage imageNamed:@"pregnant_button_OK"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:okBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, WIDTH-160, 57)];
    _titleLabel.font = MYFONT(15);
    _titleLabel.textColor = RGBHEX(0xfe98bd);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.userInteractionEnabled = YES;
    [self.bottomView addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 57, WIDTH, 1)];
    lineView.backgroundColor = RGBHEX(0xf2f2f2);
    [self.bottomView addSubview:lineView];
}

//只显示一定时间范围内的 年 月 日
- (void)setPickerWithMyDate:(NSDate *)myDate startDate:(NSDate *)startDate endDate:(NSDate *)endDate Title:(NSString *)title
{
    _startDate = startDate;
    _endDate = endDate;
    _myDate = [self fitTimezoneWithDate:myDate];
    
    if ([_myDate compare:_startDate] == NSOrderedAscending) {
        _myDate = _startDate;
    }
    if ([_myDate compare:_endDate] == NSOrderedDescending) {
        _myDate = _endDate;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _titleLabel.text = [formatter stringFromDate:myDate];
    
    _calendar = [NSCalendar currentCalendar]; ;
    
    NSDateComponents *minimumDateComponents = [self getDateComponentsWithDate:_startDate];
    NSDateComponents *maximumDateComponents = [self getDateComponentsWithDate:_endDate];
    _myComponents = [self getDateComponentsWithDate:self.myDate];
    
    [_pickerView reloadAllComponents];//这次刷新，是为了防止二次弹出的时候不受第一次的影响。
    
    [_pickerView selectRow:_myComponents.year-minimumDateComponents.year inComponent:0 animated:YES];
    
    if (_myComponents.year == minimumDateComponents.year) {
        [_pickerView selectRow:_myComponents.month-minimumDateComponents.month inComponent:1 animated:YES];
    }else if (_myComponents.year == maximumDateComponents.year) {
        [_pickerView selectRow:_myComponents.month-1 inComponent:1 animated:YES];
    }else{
        [_pickerView selectRow:_myComponents.month-1 inComponent:1 animated:YES];
    }
    
    if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
        [_pickerView selectRow:_myComponents.day-minimumDateComponents.day inComponent:2 animated:YES];
    }else{
        [_pickerView selectRow:_myComponents.day-1 inComponent:2 animated:YES];
    }
    
    [_pickerView reloadAllComponents];
    [self show];
}

//NSDateComponents是时间的组成的集合如年月日时分秒等等
- (NSDateComponents *)getDateComponentsWithDate:(NSDate *)date
{
    NSDateComponents *c = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return c;
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{//年，月，日
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRows = 0;
    
    NSDateComponents *minimumDateComponents = [self getDateComponentsWithDate:_startDate];
    NSDateComponents *maximumDateComponents = [self getDateComponentsWithDate:_endDate];
    
    if (component == 0) {//年
        
        numberOfRows = (maximumDateComponents.year - minimumDateComponents.year) + 1;
        
        return numberOfRows;
        
    }else if (component == 1){//月
        
        numberOfRows = [_calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:self.myDate].length;
        if (_myComponents.year == minimumDateComponents.year) {
            numberOfRows = numberOfRows-minimumDateComponents.month+1;
        }
        if (_myComponents.year == maximumDateComponents.year) {
            numberOfRows = maximumDateComponents.month;
        }
        
        if (_myComponents.year == maximumDateComponents.year && _myComponents.year == minimumDateComponents.year) {
            numberOfRows = maximumDateComponents.month - minimumDateComponents.month + 1;
        }
        
        return numberOfRows;
        
    }else{
        
        numberOfRows = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.myDate].length;
        
        if (_myComponents.year == maximumDateComponents.year && _myComponents.month == maximumDateComponents.month) {
            numberOfRows = maximumDateComponents.day;
        }
        if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
            numberOfRows = numberOfRows-minimumDateComponents.day+1;
        }
        
        return numberOfRows;
    }
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *rowTitle=nil;
    NSDateComponents *minimumDateComponents = [self getDateComponentsWithDate:_startDate];
    NSDateComponents *maximumDateComponents = [self getDateComponentsWithDate:_endDate];
    
    if (component == 0) {//年
        rowTitle = [NSString stringWithFormat:@"%ld年",minimumDateComponents.year+row];
        return rowTitle;
        
    }else if (component == 1){//月
        
        rowTitle = [NSString stringWithFormat:@"%.2ld月",row+1];
        if (_myComponents.year == minimumDateComponents.year) {
            rowTitle = [NSString stringWithFormat:@"%.2ld月",row+minimumDateComponents.month];
        }
        if (_myComponents.year == maximumDateComponents.year) {
            rowTitle = [NSString stringWithFormat:@"%.2ld月",row+1];
        }
        if (_myComponents.year == maximumDateComponents.year && _myComponents.year == minimumDateComponents.year) {
            rowTitle = [NSString stringWithFormat:@"%.2ld月",row+minimumDateComponents.month];
        }
        
        return rowTitle;
        
    }else{//日
        
        rowTitle = [NSString stringWithFormat:@"%.2ld日",row+1];
        if (_myComponents.year == maximumDateComponents.year && _myComponents.month == maximumDateComponents.month) {
            rowTitle = [NSString stringWithFormat:@"%.2ld日",row+1];
        }
        if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
            rowTitle = [NSString stringWithFormat:@"%.2ld日",row+minimumDateComponents.day];
        }
        return rowTitle;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSDateComponents *minimumDateComponents = [self getDateComponentsWithDate:_startDate];
    NSDateComponents *maximumDateComponents = [self getDateComponentsWithDate:_endDate];
    
    if (component == 0) {//年
        _myComponents.year = minimumDateComponents.year + row;
        
        if (_myComponents.year == minimumDateComponents.year) {
            
            if (_myComponents.month < minimumDateComponents.month) {
                _myComponents.month = minimumDateComponents.month+_myComponents.month-1;
            }
            [_pickerView selectRow:_myComponents.month-minimumDateComponents.month inComponent:1 animated:NO];
            
        }else if (_myComponents.year == maximumDateComponents.year) {
            _myComponents.month = [pickerView selectedRowInComponent:1]+1;
            if (_myComponents.month > maximumDateComponents.month) {
                _myComponents.month = maximumDateComponents.month;
            }
            [_pickerView selectRow:_myComponents.month-1 inComponent:1 animated:NO];
        }else{
            
            _myComponents.month = [pickerView selectedRowInComponent:1]+1;
            [_pickerView selectRow:_myComponents.month-1 inComponent:1 animated:NO];
        }
        
        
        if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
            if (_myComponents.day < minimumDateComponents.day) {
                _myComponents.day = minimumDateComponents.day;
            }
            [_pickerView selectRow:_myComponents.day-minimumDateComponents.day inComponent:2 animated:NO];
        }else if (_myComponents.year == maximumDateComponents.year && _myComponents.month == maximumDateComponents.month) {
            if (_myComponents.day > maximumDateComponents.day) {
                _myComponents.day = maximumDateComponents.day;
            }
            [_pickerView selectRow:_myComponents.day-1 inComponent:2 animated:NO];
        }else{
            
            _myComponents.day = [pickerView selectedRowInComponent:2]+1;
            if (_myComponents.day > [self getDaysInMonth:_myComponents.month year:_myComponents.year]) {
                _myComponents.day = [self getDaysInMonth:_myComponents.month year:_myComponents.year];
            }
            
            [_pickerView selectRow:_myComponents.day-1 inComponent:2 animated:NO];
        }
    }else if (component == 1){//月
        
        _myComponents.month = row+1;
        
        if (_myComponents.year == minimumDateComponents.year) {
            _myComponents.month = minimumDateComponents.month+row;
        }
        
        if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
            if (_myComponents.day < minimumDateComponents.day) {
                _myComponents.day = minimumDateComponents.day;
            }
            [_pickerView selectRow:_myComponents.day-minimumDateComponents.day inComponent:2 animated:NO];
        }else if (_myComponents.year == maximumDateComponents.year && _myComponents.month == maximumDateComponents.month) {
            if (_myComponents.day > maximumDateComponents.day) {
                _myComponents.day = maximumDateComponents.day;
            }
            [_pickerView selectRow:_myComponents.day-1 inComponent:2 animated:NO];
        }else{
            _myComponents.day = [pickerView selectedRowInComponent:2]+1;
            if (_myComponents.day > [self getDaysInMonth:_myComponents.month year:_myComponents.year]) {
                _myComponents.day = [self getDaysInMonth:_myComponents.month year:_myComponents.year];
            }
            [_pickerView selectRow:_myComponents.day-1 inComponent:2 animated:NO];
        }
        
    }else{//日
        
        _myComponents.day = row+1;
        if (_myComponents.year == minimumDateComponents.year && _myComponents.month == minimumDateComponents.month) {
            _myComponents.day = row+minimumDateComponents.day;
        }
    }
    
    self.myDate = [_calendar dateFromComponents:_myComponents];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self.myDate];
    self.myDate = [self.myDate  dateByAddingTimeInterval: interval];
    
    [_pickerView reloadAllComponents];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _titleLabel.text = [formatter stringFromDate:_myDate];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = RGBHEX(0x666666);
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:MYFONT(18)];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return WIDTH/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)remove{
    !_removeViewBlock ? : _removeViewBlock();
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, HEIGHT, WIDTH, 248);
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)show{
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.bottomView.frame = CGRectMake(0, HEIGHT-248, WIDTH, 248);
    }];
}


- (void)doneClick
{
    [self remove];
    
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:date:)]) {
        [self.delegate toobarDonBtnHaveClick:self date:_myDate];
    }
    
}

- (NSInteger )getDaysInMonth:(NSInteger )month year:(NSInteger)year
{
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        return 31;
    }else if(month == 2){
        if ((year%4==0 && year%100!=0) || year%400==0) {
            return 29;
        }
        return 28;
    }else{
        return 30;
    }
}

- (NSDate *)fitTimezoneWithDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date  dateByAddingTimeInterval:interval];
    
    return date;
}

/**
 *设置PickView的颜色
 */
- (void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}


@end
