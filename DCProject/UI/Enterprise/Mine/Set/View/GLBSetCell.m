//
//  GLBSetCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSetCell.h"
#import "DCCacheTool.h"
#import "DCPermitTool.h"

@interface GLBSetCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UISwitch *setSwitch;

@end

@implementation GLBSetCell

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
    
    _iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = PFRFont(14);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _contentLabel.font = PFRFont(14);
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [self.contentView addSubview:_rightImage];
    
    _setSwitch = [[UISwitch alloc] init];
    _setSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [_setSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    _setSwitch.hidden = YES;
    _setSwitch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:_setSwitch];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)switchClick:(UIButton *)button
{
    if (_switchBlock) {
        _switchBlock();
    }
    [[DCPermitTool shareTool] dc_openSetController];
}


#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles icons:(NSArray *)icons indexPath:(NSIndexPath *)indexPath cellPhone:(NSString *) cellPhone{
    
    _iconImage.image = [UIImage imageNamed:icons[indexPath.section][indexPath.row]];
    _titleLabel.text = titles[indexPath.section][indexPath.row];
    
    self.iconImage.hidden = NO;
    if (indexPath.section == 0 && indexPath.row != 0) {
        self.iconImage.hidden = YES;
    }
    
    self.rightImage.hidden = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.rightImage.hidden = YES;
    }
    
    self.setSwitch.hidden = YES;
    if (indexPath.section == 1 && indexPath.row == 2) {
        self.setSwitch.hidden = NO;
        self.rightImage.hidden = YES;
        
        self.setSwitch.on = [[DCPermitTool shareTool] dc_isCanNotification];
    }
    
    self.contentLabel.hidden = YES;
    if (indexPath.section == 0 && indexPath.row == 2) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = cellPhone;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [[DCCacheTool shareTool] dc_readCacheString];
    }
    
    if (indexPath.section == 1 && indexPath.row == 4) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [NSString stringWithFormat:@"v%@",APP_VERSION];
    }
}



#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(120);
    }];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.titleLabel.right);
    }];
    
    [_setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-10);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(50, 30));
    }];
}


@end
