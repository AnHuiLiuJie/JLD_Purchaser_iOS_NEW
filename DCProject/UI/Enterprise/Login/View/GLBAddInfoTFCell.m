//
//  GLBAddInfoTFCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddInfoTFCell.h"

typedef NS_ENUM(NSInteger,GLBCellType){
    GLBCellTypeNormal = 0,  // 常规cell
    GLBCellTypeClick,       // 点击cell
    GLBCellTypeTip,         // 提示cell
    GLBCellTypeTitle,       // 只展示标题cell
    GLBCellTypeCode,        // 企业编码cell
};

@interface GLBAddInfoTFCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *iconImage;

// 类型
@property (nonatomic, assign) GLBCellType type;
//
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation GLBAddInfoTFCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    [self.contentView addSubview:_titleLabel];
    
    _textField = [[DCTextField alloc] init];
    _textField.type = DCTextFieldTypeDefault;
    _textField.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textField.font = PFRFont(14);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#EA504A"];
    _tipLabel.font = PFRFont(10);
    _tipLabel.text = @"*该企业信息已完成注册，继续使用该企业信息注册请先提交授权委托书";
    _tipLabel.hidden = YES;
    [self.contentView addSubview:_tipLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"dc_arrow_bottom_hei"];
    [self.contentView addSubview:_iconImage];

}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.type == GLBCellTypeClick) {
        if (_tfClickBlock) {
            _tfClickBlock();
        }
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_indexPath == [NSIndexPath indexPathForRow:0 inSection:1]) {
        if (_companyBlock) {
            _companyBlock(textField.text);
        }
    }
    if (_textFieldBlock) {
        _textFieldBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_textFieldBlock) {
        _textFieldBlock(textField.text);
    }
    return YES;
}


#pragma mark - 赋值
- (void)setRegrsterValueWithContents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath {
    
    self.type = GLBCellTypeNormal;
    self.textField.type = DCTextFieldTypeDefault;
    self.indexPath = indexPath;
    self.textField.delegate = self;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            self.titleLabel.text = @"用户名";
            self.textField.placeholder = @"6-20位数字、字母或下划线组合";
            self.textField.type = DCTextFieldTypeUserName;
            
        } else if (indexPath.row == 1) {
            
            self.titleLabel.text = @"登录密码";
            self.textField.placeholder = @"设置登录密码";
            self.textField.type = DCTextFieldTypePassWord;
            
        } else if (indexPath.row == 2) {
            
            self.titleLabel.text = @"确认登录密码";
            self.textField.placeholder = @"确认登录密码";
            self.textField.type = DCTextFieldTypePassWord;
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            self.titleLabel.text = @"企业名称";
            self.textField.placeholder = @"请您输入企业名称全称";
            
        } else if (indexPath.row == 1) {
            
            self.titleLabel.text = @"联系人";
            self.textField.placeholder = @"请输入联系人姓名";
            
        }
//        else if (indexPath.row == 2) {
//            
//            self.titleLabel.text = @"企业类型";
//            self.textField.placeholder = @"请选择企业类型";
//            self.type = GLBCellTypeClick;
//            
//            NSString *contentStr = contents[indexPath.section][indexPath.row];
//            if (contentStr && contentStr.length > 0) {
//                self.textField.text = contentStr;
//            }
//        }
        
    } else {
        
        if (indexPath.row == 0) {
            self.titleLabel.text = @"所在地区";
            self.textField.placeholder = @"请选择所在地区";
            self.type = GLBCellTypeClick;
            
            NSString *contentStr = contents[indexPath.section][indexPath.row];
            if (contentStr && contentStr.length > 0) {
                self.textField.text = contentStr;
            }
        }
    }
    
    [self updateMasonry];
}


#pragma mark -  赋值 上传资料
- (void)setAddInfoValueWithContents:(NSArray *)contents index:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    self.type = GLBCellTypeNormal;
    self.textField.userInteractionEnabled = YES;
    self.indexPath = indexPath;
    self.textField.delegate = self;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            self.titleLabel.text = @"企业编码";
            self.textField.userInteractionEnabled = NO;
//            self.type = GLBCellTypeCode;
            
//            if (index == 0) {
//                self.type = GLBCellTypeCode;
//            }
//            self.tipLabel.text = @"*企业编码在审核通过之后由平台分配";
//            self.tipLabel.textAlignment = NSTextAlignmentRight;
            
        } else if (indexPath.row == 1) {
            
            self.titleLabel.text = @"企业名称";
            self.textField.placeholder = @"请填写企业名称";
            
        } else if (indexPath.row == 2) {
            
            self.titleLabel.text = @"联系人";
            self.textField.placeholder = @"确认填写联系人";
            
        } else if (indexPath.row == 3) {
            
            self.titleLabel.text = @"企业类型";
            self.textField.placeholder = @"请选择企业类型";
            self.type = GLBCellTypeClick;
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            self.titleLabel.text = @"所在地区";
            self.textField.placeholder = @"请选择所在地区";
            self.type = GLBCellTypeClick;
        }
        
    } else if (indexPath.section == 2) {
        
        self.titleLabel.text = @"资质上传";
        self.textField.userInteractionEnabled = NO;
    }
    
    self.textField.text = contents[indexPath.section][indexPath.row];
    
    [self updateMasonry];
}


#pragma mark - masonry
- (void)updateMasonry
{
    self.iconImage.hidden = YES;
    
    if (self.type == GLBCellTypeNormal) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-15);
            make.left.equalTo(self.titleLabel.right);
            make.top.equalTo(self.titleLabel.top);
            make.bottom.equalTo(self.titleLabel.bottom);
        }];
        
    } else if (self.type == GLBCellTypeClick) {
        
        self.iconImage.hidden = NO;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-15);
            make.centerY.equalTo(self.titleLabel.centerY);
            make.size.equalTo(CGSizeMake(7, 5));
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.iconImage.left).offset(-5);
            make.left.equalTo(self.titleLabel.right);
            make.top.equalTo(self.titleLabel.top);
            make.bottom.equalTo(self.titleLabel.bottom);
        }];
        
    } else if (self.type == GLBCellTypeTip) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.top.equalTo(self.contentView.top);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-15);
            make.left.equalTo(self.titleLabel.right);
            make.top.equalTo(self.titleLabel.top);
            make.bottom.equalTo(self.titleLabel.bottom);
        }];
        
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipLabel.left);
            make.right.equalTo(self.textField.right);
            make.top.equalTo(self.tipLabel.bottom);
            make.bottom.equalTo(self.contentView.bottom).offset(-10);
        }];
        
    } else if (self.type == GLBCellTypeCode) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
        
        
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-15);
            make.left.equalTo(self.titleLabel.right);
            make.centerY.equalTo(self.titleLabel.centerY);
        }];
        
    } else if (self.type == GLBCellTypeTitle) {
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(15);
            make.top.equalTo(self.contentView.top);
            make.bottom.equalTo(self.contentView.bottom);
            make.size.equalTo(CGSizeMake(100, 50));
        }];
    }
        
}





@end
