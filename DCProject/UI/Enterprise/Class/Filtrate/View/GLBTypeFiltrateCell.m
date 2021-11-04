//
//  GLBTypeFiltrateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBTypeFiltrateCell.h"

@interface GLBTypeFiltrateCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBTypeFiltrateCell

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
    _titleLabel.font = PFRFont(13);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel dc_cornerRadius:4];
    [self.contentView addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = PFRFont(11);
    [_countLabel dc_cornerRadius:10];
    _countLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F2F9F7"];
    [self.contentView addSubview:_countLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(200, 30)];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(size.width + 20, 30));
    }];
    
    CGSize size1 = [_countLabel sizeThatFits:CGSizeMake(200, 20)];
    
    [_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.contentView.centerY);
        make.size.equalTo(CGSizeMake(size1.width + 20, 20));
    }];
}


#pragma mark - 赋值
- (void)setValueWithTypeModel:(GLBTypeModel *)typeModel selectArray:(NSArray *)selectArray
{
    self.titleLabel.text = typeModel.catName;
    self.countLabel.text = [NSString stringWithFormat:@"%ld种",typeModel.goodsNum];
    
    BOOL isSelected = NO;
    for (int i=0; i<selectArray.count; i++) {
        GLBTypeModel *selectModel = selectArray[i];
        if ([selectModel.catId isEqualToString: typeModel.catId]) {
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
    
    [self layoutSubviews];
}


@end
