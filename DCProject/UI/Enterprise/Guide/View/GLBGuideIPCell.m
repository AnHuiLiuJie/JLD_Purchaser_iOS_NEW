//
//  GLBGuideIPCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGuideIPCell.h"
#import "DCTextField.h"

@interface GLBGuideIPCell ()

@property (nonatomic, strong) UILabel *ipLabel;
@property (nonatomic, strong) DCTextField *textField;
@property (nonatomic, strong) UIButton *doneBtn;

@end

@implementation GLBGuideIPCell

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
    
//    NSString *ipStr = [DCObjectManager dc_readUserDataForKey:DC_IP_Key];
    
    NSString *ipStr = @"这个方法已经废弃了";
    
    _ipLabel = [[UILabel alloc] init];
    _ipLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _ipLabel.font = PFRFont(14);
    _ipLabel.text = [NSString stringWithFormat:@"企业地址：%@",ipStr];
    [self.contentView addSubview:_ipLabel];
    
    _textField = [[DCTextField alloc] init];
    _textField.placeholder = @"请输入请求地址，如：http://192.168.0.106:8086";
    _textField.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textField.font = PFRFont(14);
    [_textField dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:5];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:_textField];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"确定修改" forState:0];
    [_doneBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _doneBtn.titleLabel.font = PFRFont(14);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_doneBtn dc_cornerRadius:5];
    [self.contentView addSubview:_doneBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)doneBtnClick:(UIButton *)button
{
    if (self.textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入请求地址"];
        return;
    }
    
//    [DCObjectManager dc_saveUserData:self.textField.text forKey:DC_IP_Key];
    
    _ipLabel.text = [NSString stringWithFormat:@"企业地址：%@",self.textField.text];
    
    if (_reloadBlock) {
        _reloadBlock();
    }
    
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(40);
    }];
    
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ipLabel.left);
        make.right.equalTo(self.ipLabel.right);
        make.top.equalTo(self.ipLabel.bottom);
        make.height.equalTo(50);
    }];
    
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ipLabel.left);
        make.top.equalTo(self.textField.bottom).offset(10);
        make.size.equalTo(CGSizeMake(80, 40));
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
}



@end
