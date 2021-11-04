//
//  GLBRepayFullController.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayFullController.h"

@interface GLBRepayFullController ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *commintBtn;

@end

@implementation GLBRepayFullController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
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
    if (_completeBlock) {
        _completeBlock();
    }
}


#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本次还款金额为￥%@\n是否确认还款？",string]];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:18],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(8, string.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 30;
    style.alignment = NSTextAlignmentCenter;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
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
    _titleLabel.text = @"还款金额确认";
    [_bgView addSubview:_titleLabel];
    
    NSString *money = @"";
    if (_repayListModel) {
        money = [NSString stringWithFormat:@"%.2f",_repayListModel.paymentAmount];
    }
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _descLabel.attributedText = [self dc_attributeStr:money];
    _descLabel.numberOfLines = 0;
    _descLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_descLabel];
    
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
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(-0);
        make.top.equalTo(self.titleLabel.bottom).offset(40);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.descLabel.bottom).offset(40);
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
