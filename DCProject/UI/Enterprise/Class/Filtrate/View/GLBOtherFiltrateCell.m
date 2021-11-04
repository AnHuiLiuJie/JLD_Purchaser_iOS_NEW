//
//  GLBOtherFiltrateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBOtherFiltrateCell.h"

@interface GLBOtherFiltrateCell ()

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;

@end

@implementation GLBOtherFiltrateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _spacing = 10;
        _itemW = (kScreenW - 14*2 - _spacing*2)/3 - 1;
        _itemH = 40;
        _x = 14;
        _y = 10;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - action
- (void)buttonClick:(UIButton *)button
{
    if (_otherCellBlock) {
        _otherCellBlock(button.tag);
    }
}


#pragma mark - setter
- (void)setPackageValueWithPackageArray:(NSArray *)packageArray selectPackageArray:(NSArray *)selectPackageArray
{
    for (id class in self.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    _x = 14;
    _y = 10;
    
    for (int i=0; i<packageArray.count; i++) {
        
        GLBPackageModel *model = packageArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%@(%@)",model.specs,model.valueCount] forState:0];
        button.titleLabel.font = PFRFont(14);
        button.tag = i;
        [button dc_cornerRadius:4];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isSelected = NO;
        for (int j = 0; j<selectPackageArray.count; j++) {
            GLBPackageModel *selectModel = selectPackageArray[j];
            if ([selectModel.specs isEqualToString:model.specs]) {
                isSelected = YES;
            }
        }
        if (isSelected) { //已选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
            
            
        } else { // 未选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#F0F2F2"];
        }
        
        [self.contentView addSubview:button];
        
        NSInteger row = i/3;
        NSInteger line = i%3;
        
        _x = 14 + line*(_itemW + _spacing);
        _y = 10 + row*(_itemH + _spacing);
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(self.x);
            make.top.equalTo(self.contentView.top).offset(self.y);
            make.size.equalTo(CGSizeMake(self.itemW, self.itemH));
        }];
    }
}



#pragma mark - 类型
- (void)setTypeValueWithTypeArray:(NSArray *)typeArray selectTypeArray:(NSArray *)selectTypeArray
{
    for (id class in self.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    _x = 14;
    _y = 10;
    
    for (int i=0; i<typeArray.count; i++) {
        
        NSString *title = typeArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:0];
        button.titleLabel.font = PFRFont(14);
        button.tag = i;
        [button dc_cornerRadius:4];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        if ([selectTypeArray containsObject:title]) { //已选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
            
            
        } else { // 未选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#F0F2F2"];
        }
        
        [self.contentView addSubview:button];
        
        NSInteger row = i/3;
        NSInteger line = i%3;
        
        _x = 14 + line*(_itemW + _spacing);
        _y = 10 + row*(_itemH + _spacing);
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(self.x);
            make.top.equalTo(self.contentView.top).offset(self.y);
            make.size.equalTo(CGSizeMake(self.itemW, self.itemH));
        }];
    }
}


#pragma mark - 店铺-经营范围
- (void)setRangValueWithRangArray:(NSArray *)rangArray selectRangArray:(NSArray *)selectRangArray
{
    for (id class in self.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    _x = 14;
    _y = 10;
    
    for (int i=0; i<rangArray.count; i++) {
        
        GLBRangModel *model = rangArray[i];
        NSString *title = model.valuessss;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:0];
        button.titleLabel.font = PFRFont(14);
        button.tag = i;
        [button dc_cornerRadius:4];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isSelected = NO;
        if (selectRangArray.count > 0) {
            for (GLBRangModel *selectModel in selectRangArray) {
                if ([selectModel.key isEqualToString:model.key]) {
                    isSelected = YES;
                }
            }
        }
        
        if (isSelected) { //已选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
            
            
        } else { // 未选中
            
            [button setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
            button.backgroundColor = [UIColor dc_colorWithHexString:@"#F0F2F2"];
        }
        
        [self.contentView addSubview:button];
        
        NSInteger row = i/3;
        NSInteger line = i%3;
        
        _x = 14 + line*(_itemW + _spacing);
        _y = 10 + row*(_itemH + _spacing);
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(self.x);
            make.top.equalTo(self.contentView.top).offset(self.y);
            make.size.equalTo(CGSizeMake(self.itemW, self.itemH));
        }];
    }
}


@end
