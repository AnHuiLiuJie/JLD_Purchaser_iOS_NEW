//
//  GLBGuideItmeCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGuideItmeCell.h"

@interface GLBGuideItmeCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation GLBGuideItmeCell

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
    
    for (id class in self.contentView.subviews) {
        [class removeFromSuperview];
    }

    self.titles = @[@"药健康",@"药招标",@"药采购",@"药资讯",@"药消息",@"药集采",@"药交会",@"药种植",@"中药材"];
    self.images = @[@"yjk",@"yzb",@"ydycg",@"ydyzx",@"ydyxx",@"ycj",@"yjy",@"yzz",@"zyyp"];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    CGFloat itemW = 0.25*kScreenW;
    CGFloat itemH = itemW - 10;
    CGFloat spacingH = (kScreenW - 8*2 - itemW*3)/4;
    CGFloat spacingV = 10;
    
    for (int i = 0; i<self.titles.count; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger a = i/3;
        NSInteger b = i%3;
        
        CGFloat x = spacingH + (itemW + spacingH)*b;
        CGFloat y = spacingV + (itemH)*a;
        
        button.frame = CGRectMake(x, y, itemW, itemH);
        [button setImage:[UIImage imageNamed:self.images[i]] forState:0];
        [button setTitle:self.titles[i] forState:0];
        [button setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        button.titleLabel.font = PFRFont(12);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button dc_buttonIconTopWithSpacing:15];
        [self.contentView addSubview:button];
    }
    
    
    UIButton *button = self.contentView.subviews.lastObject;
    CGFloat height = CGRectGetMaxY(button.frame) + spacingV;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(height);
    }];
}


#pragma mark -
- (void)buttonClick:(UIButton *)button
{
    if (_itemCellBlock) {
        _itemCellBlock(button.tag);
    }
}


@end
