//
//  GLBYcjTypeView.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBYcjTypeView.h"

@interface GLBYcjTypeView ()



@end

@implementation GLBYcjTypeView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



#pragma mark - setter
- (void)setRolesArray:(NSArray<GLBYcjRolesModel *> *)rolesArray
{
    _rolesArray = rolesArray;
    
    self.backgroundColor = [UIColor whiteColor];
    
    for (id class in self.subviews) {
        [class removeFromSuperview];
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _titleLabel.font = PFRFont(12);
    _titleLabel.text = @"集采方案";
    [self addSubview:_titleLabel];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(self.right).offset(-15);
        make.top.equalTo(self.top);
        make.height.equalTo(20);
    }];
    
    
    for (int i=0; i<_rolesArray.count; i++) {
        
        GLBYcjRolesModel *model = _rolesArray[i];
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        typeLabel.font = PFRFont(14);
        typeLabel.text = [NSString stringWithFormat:@"满%ld-%ld件",(long)model.buyMinAmount,(long)model.buyMaxAmount];
        [self addSubview:typeLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        priceLabel.font = PFRFont(14);
        priceLabel.attributedText = [self dc_attributeStr:[NSString stringWithFormat:@"￥%.2f元/%@",model.returnAmount,model.chargeUnit]];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(15);
            make.width.lessThanOrEqualTo(150);
            make.top.equalTo(self.titleLabel.bottom).offset(i*32);
            make.height.equalTo(32);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(typeLabel.centerY);
            make.right.equalTo(self.right).offset(-15);
            make.left.equalTo(typeLabel.right).offset(5);
        }];
        
    }
}


#pragma mark -
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"返现价 %@",string]];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:11],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(0, 3)];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(3, attrStr.length - 3)];
    return attrStr;
}

@end
