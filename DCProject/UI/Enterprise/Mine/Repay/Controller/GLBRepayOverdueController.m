//
//  GLBRepayOverdueController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayOverdueController.h"

#import "DCTextField.h"
#import "DCTextView.h"

#import "STPickerDate.h"

@interface GLBRepayOverdueController ()<UITextFieldDelegate,STPickerDateDelegate>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) DCTextField *timeTF;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) DCTextView *reasonTV;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *commintBtn;

@property (nonatomic, copy) NSString *minDate;
@property (nonatomic, copy) NSString *maxDate;

@end

@implementation GLBRepayOverdueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    if (_repayListModel) {
        [self requestTime];
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self createSTPickerDate:@"选择时间"];
    return NO;
}


#pragma mark - action
- (void)bgBtnClick:(UIButton *)button
{
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
}

- (void)commintBtnClick:(UIButton *)button
{
    if (self.timeTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择还款截止日期"];
        return;
    }
    
    if (self.reasonTV.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写还款原因"];
        return;
    }
    
    if (_repayOverdueBlock) {
        _repayOverdueBlock(self.timeTF.text,self.reasonTV.text);
    }
}



#pragma mark - 创建时间显示
- (void)createSTPickerDate:(NSString *)title
{
    if ([DC_KeyWindow.subviews.lastObject isKindOfClass:[STPickerDate class]]) {
        return;
    }
    STPickerDate *picker = [[STPickerDate alloc] init];
    [picker setTitle:title];
    picker.font = [UIFont fontWithName:PFR size:14];
    picker.heightPickerComponent = 35;
    [picker setContentMode:STPickerContentModeBottom];
    [picker setDelegate:self];
    [picker show];
}


#pragma mark - <STPickerDateDelegate>
- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)month];
    if (monthStr.length == 1) {
        monthStr = [@"0" stringByAppendingString:monthStr];
    }
    
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    if (dayStr.length == 1) {
        dayStr = [@"0" stringByAppendingString:dayStr];
    }
    
    NSString *selectStr = [NSString stringWithFormat:@"%ld-%@-%@",(long)year,monthStr,dayStr];
    self.timeTF.text = selectStr;
}


#pragma mark - 请求  获取可选日期
- (void)requestTime
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRepayOverdunTimeWithOrderNo:_repayListModel.orderNo success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            weakSelf.minDate = response[@"minDate"];
            weakSelf.maxDate = response[@"maxDate"];
            
            if ([weakSelf.minDate containsString:@" "]) {
                weakSelf.minDate = [weakSelf.minDate componentsSeparatedByString:@" "][0];
                weakSelf.maxDate = [weakSelf.maxDate componentsSeparatedByString:@" "][0];
                
                weakSelf.tipLabel.text = [NSString stringWithFormat:@"*请选择 %@至%@之间的日期",weakSelf.minDate,weakSelf.maxDate];
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"申请延期付款";
    [_bgView addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont fontWithName:PFR size:12];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    _countLabel.text = @"已申请 0 次延期 还可申请 3 次延期";
    [_bgView addSubview:_countLabel];
    
    _timelabel = [[UILabel alloc] init];
    _timelabel.font = [UIFont fontWithName:PFR size:12];
    _timelabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timelabel.text = @"申请还款截止日期：";
    [_bgView addSubview:_timelabel];
    
    _timeTF = [[DCTextField alloc] init];
    _timeTF.type = DCTextFieldTypeDefault;
    _timeTF.placeholder = @"请选择申请还款截止日期";
    _timeTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeTF.font = PFRFont(12);
    _timeTF.leftViewMode = UITextFieldViewModeAlways;
    _timeTF.delegate = self;
    _timeTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
    [_timeTF dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:14];
    [_bgView addSubview:_timeTF];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.font = [UIFont fontWithName:PFR size:10];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _tipLabel.text = @"*请选择 -至-之间的日期";
    [_bgView addSubview:_tipLabel];
    
    _reasonLabel = [[UILabel alloc] init];
    _reasonLabel.font = [UIFont fontWithName:PFR size:12];
    _reasonLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _reasonLabel.text = @"延期还款原因";
    [_bgView addSubview:_reasonLabel];
    
    _reasonTV = [[DCTextView alloc] init];
    _reasonTV.placeholder = @"输入延期还款原因";
    _reasonTV.font = PFRFont(12);
    _reasonTV.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _reasonTV.placeholderColor = [UIColor dc_colorWithHexString:@"#CCCCCC"];
    [_reasonTV dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#EDEDED"] radius:2];
    [_bgView addSubview:_reasonTV];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:@"#E6E6E6"];
    [_bgView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:@"#E6E6E6"];
    [_bgView addSubview:_line2];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(14);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commintBtn setTitle:@"确认还款" forState:0];
    [_commintBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _commintBtn.titleLabel.font = PFRFont(14);
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_commintBtn];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(-kNavBarHeight/2);
        make.width.equalTo(0.85*kScreenW);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top).offset(15);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.titleLabel.bottom).offset(23);
    }];
    
    [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.width.equalTo(120);
        make.top.equalTo(self.countLabel.bottom).offset(30);
    }];
    
    [_timeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timelabel.right).offset(15);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.centerY.equalTo(self.timelabel.centerY);
        make.height.equalTo(28);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.timelabel.bottom).offset(15);
    }];
    
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.tipLabel.bottom).offset(15);
    }];
    
    [_reasonTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(25);
        make.right.equalTo(self.bgView.right).offset(-25);
        make.top.equalTo(self.reasonLabel.bottom).offset(10);
        make.height.equalTo(80);
    }];
    
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.reasonTV.bottom).offset(20);
        make.height.equalTo(1);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.bottom);
        make.centerX.equalTo(self.bgView.centerX);
        make.size.equalTo(CGSizeMake(1, 40));
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.line2.left);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
    
    [_commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2.right);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.line1.bottom);
        make.bottom.equalTo(self.bgView.bottom);
    }];
}

@end
