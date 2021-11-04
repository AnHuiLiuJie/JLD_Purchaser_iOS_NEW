//
//  GLBClassTypeCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBClassTypeCell.h"

@interface GLBClassTypeCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation GLBClassTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.backgroundColor = [UIColor dc_colorWithHexString:@"#05BEB1"];
    _iconImage.hidden = YES;
    [self.contentView addSubview:_iconImage];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left);
        make.width.equalTo(4);
        make.height.equalTo(22);
    }];
}



#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray<GLBTypeModel *>  *)titles indexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)selectIndex
{
    _titleLabel.text = [titles[indexPath.row] catName];
    
    if (indexPath.row == selectIndex) {
        
        self.iconImage.hidden = NO;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#05BEB1"];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        self.iconImage.hidden = YES;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - 赋值 - 个人版
- (void)setPersonValueWithTitles:(NSArray<GLPClassModel *> *)titles indexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)selectIndex
{
    _titleLabel.text = [titles[indexPath.row] catName];
    
    if (indexPath.row == selectIndex) {
        
        self.iconImage.hidden = NO;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#05BEB1"];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        self.iconImage.hidden = YES;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

@end
