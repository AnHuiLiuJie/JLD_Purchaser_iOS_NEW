//
//  GLBRankFiltrateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRankFiltrateCell.h"

@interface GLBRankFiltrateCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImage;

@end

@implementation GLBRankFiltrateCell

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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _titleLabel.font = PFRFont(14);
    [self.contentView addSubview:_titleLabel];
    
    _selectImage = [[UIImageView alloc] init];
    _selectImage.image = [UIImage imageNamed:@"ssgx"];
    _selectImage.hidden = YES;
    [self.contentView addSubview:_selectImage];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(15);
    }];
    
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(13, 10));
    }];
}


#pragma mark -
- (void)setValueWithArray:(NSArray *)array indexPath:(NSIndexPath *)indexPath selectIndexPath:(NSIndexPath *)selectIndexPath
{
    _titleLabel.text = array[indexPath.row];
    
    if (selectIndexPath && selectIndexPath == indexPath) {
        self.selectImage.hidden = NO;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    } else {
        self.selectImage.hidden = YES;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    }
}


#pragma mark - 厂家
- (void)setCompanyValueWithCompanyArray:(NSArray *)companyArray indexPath:(NSIndexPath *)indexPath selectCompanyArray:(NSArray *)selectCompanyArray
{
    GLBFactoryModel *companyModel = companyArray[indexPath.row];
    
    _titleLabel.text = companyModel.factoryName;
    
    BOOL isSelected = NO;
    for (int i=0; i<selectCompanyArray.count; i++) {
        GLBFactoryModel *selectModel = selectCompanyArray[i];
        if ([selectModel.factoryName isEqualToString:companyModel.factoryName]) {
            isSelected = YES;
        }
    }
    
    if (isSelected) {
        self.selectImage.hidden = NO;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    } else {
        self.selectImage.hidden = YES;
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    }
}

@end
