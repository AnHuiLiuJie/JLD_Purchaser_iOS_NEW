//
//  GLPSetCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSetCell.h"
#import "DCCacheTool.h"
#import "DCPermitTool.h"

@interface GLPSetCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UISwitch *setSwitch;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation GLPSetCell

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
    _titleLabel.font = PFRFont(15);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor dc_colorWithHexString:@"#939393"];
    _contentLabel.font = PFRFont(15);
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_xh"];
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
- (void)switchClick:(UISwitch *)button
{

    if (self.indexPath.row == 0) {
        if (_switchBlock) {
            _switchBlock();
        }
        [[DCPermitTool shareTool] dc_openSetController];
    }else{
        if (_switchBlock_two) {
            _switchBlock_two(button.isOn);
        }
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
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



#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath withPhone:(NSString *)phone isOn:(BOOL)isOn{
    self.indexPath = indexPath;
    _titleLabel.text = titles[indexPath.section][indexPath.row];
    
    self.rightImage.hidden = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.rightImage.hidden = YES;
    }
    
    self.setSwitch.hidden = YES;
    if (indexPath.section == 2 && indexPath.row == 0) {
        self.setSwitch.hidden = NO;
        self.rightImage.hidden = YES;
        
        self.setSwitch.on = [[DCPermitTool shareTool] dc_isCanNotification];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        self.setSwitch.hidden = NO;
        self.rightImage.hidden = YES;
        self.setSwitch.on = isOn;
    }
    
    self.contentLabel.hidden = YES;
    if (indexPath.section == 0 && indexPath.row == 3) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = phone;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [[DCCacheTool shareTool] dc_readCacheString];
    }
    
}


@end
