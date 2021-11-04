//
//  GLBStoreFiltrateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreFiltrateCell.h"

@interface GLBStoreFiltrateCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBStoreFiltrateCell

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
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = PFRFont(14);
    [_titleLabel dc_cornerRadius:3];
    [self.contentView addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.font = PFRFont(12);
    _countLabel.text = @"2013种";
    [self.contentView addSubview:_countLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(40);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.lessThanOrEqualTo(200);
        make.left.equalTo(self.titleLabel.right);
    }];
}


#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath selectedArray:(NSArray *)selectedArray {
    self.titleLabel.text = titles[indexPath.row];
    
    if ([selectedArray containsObject:indexPath]) {
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        
    } else {
        
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        self.titleLabel.backgroundColor = [UIColor clearColor];
    }
}



#pragma mark - 赋值
- (void)setValueWithStoreModel:(GLBStoreFiltrateModel *)storeModel selectArray:(NSArray *)selectArray
{
    _titleLabel.text = [NSString stringWithFormat:@" %@ ",storeModel.suppierFirmName];
    _countLabel.text = [NSString stringWithFormat:@"%ld种",(long)storeModel.valueCount];
    
    BOOL isSelected = NO;
    for (int i=0; i<selectArray.count; i++) {
        GLBStoreFiltrateModel *selectModel = selectArray[i];
        if (selectModel.suppierFirmId.length > 0 && [selectModel.suppierFirmId isEqualToString:storeModel.suppierFirmId]) {
            isSelected = YES;
        }
    }
    
    if (isSelected) {
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        
    } else {
        
        self.titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        self.titleLabel.backgroundColor = [UIColor clearColor];
    }
}

@end
