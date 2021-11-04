//
//  GLPMineOtherCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineOtherCell.h"

@interface GLPMineOtherCell ()
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button0;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@end

@implementation GLPMineOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];//这是谁写的页面 一点没扩展性，真垃圾草
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = RGB_COLOR(248, 248, 248);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _itemW = (kScreenW - 14*2)/5;
    _itemH = _itemW;
    _spacing = (kScreenW - _itemW*4 -14*2)/3;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:6];
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.text = @"我的服务";
    [_bgView addSubview:_titleLabel];
    
    _button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button0 setImage:[UIImage imageNamed:@"dc_my_pingtuan"] forState:0];
    [_button0 setTitle:@"我的拼团" forState:0];
    [_button0 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button0.titleLabel.font = PFRFont(12);
    _button0.adjustsImageWhenHighlighted = NO;
    [_button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button0.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button0 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button0];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setImage:[UIImage imageNamed:@"youhuiq"] forState:0];
    [_button1 setTitle:@"优惠券" forState:0];
    [_button1 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button1.titleLabel.font = PFRFont(12);
    _button1.adjustsImageWhenHighlighted = NO;
    [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button1.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button1 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setImage:[UIImage imageNamed:@"youhuiq"] forState:0];
    [_button2 setTitle:@"优惠券" forState:0];
    [_button2 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button2.titleLabel.font = PFRFont(12);
    _button2.adjustsImageWhenHighlighted = NO;
    [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button2.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button2 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button2];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setImage:[UIImage imageNamed:@"youhuiq"] forState:0];
    [_button3 setTitle:@"优惠券" forState:0];
    [_button3 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button3.titleLabel.font = PFRFont(12);
    _button3.adjustsImageWhenHighlighted = NO;
    [_button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button3.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button3 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button3];
    
    _button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button4 setImage:[UIImage imageNamed:@"youhuiq"] forState:0];
    [_button4 setTitle:@"优惠券" forState:0];
    [_button4 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button4.titleLabel.font = PFRFont(12);
    _button4.adjustsImageWhenHighlighted = NO;
    [_button4 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button4.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button4 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button4];
    
    _button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button5 setImage:[UIImage imageNamed:@"fen"] forState:0];
    [_button5 setTitle:@"分享" forState:0];
    [_button5 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button5.titleLabel.font = PFRFont(12);
    _button5.adjustsImageWhenHighlighted = NO;
    [_button5 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button5.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button5 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button5];
    
    
    _button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button6 setImage:[UIImage imageNamed:@"etp_center_log"] forState:0];
    [_button6 setTitle:@"自由创业者" forState:0];
    [_button6 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button6.titleLabel.font = PFRFont(12);
    _button6.adjustsImageWhenHighlighted = NO;
    [_button6 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _button6.bounds = CGRectMake(0, 0, _itemW, _itemH);
    [_button6 dc_buttonIconTopWithSpacing:15];
    [_bgView addSubview:_button6];
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (_otherCellBlock) {
        _otherCellBlock(button.tag);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = _itemW;
    CGFloat itemH = _itemH;
    CGFloat spacing = _spacing;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 14, 5, 14));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgView.top).offset(10);
    }];
    
    [_button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.titleLabel.bottom).offset(13);
        make.size.equalTo(CGSizeMake(itemW, itemH));
        //make.bottom.equalTo(self.bgView.bottom).offset(-15);//lj_change_约束
    }];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button0.right).offset(spacing);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button1.right).offset(spacing);
        make.centerY.equalTo(self.button1.centerY);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button2.right).offset(spacing);
        make.centerY.equalTo(self.button2.centerY);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(2);
        make.top.equalTo(self.button1.bottom).offset(15);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button4.right).offset(spacing);
        make.centerY.equalTo(self.button4.centerY).offset(0);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button5.right).offset(spacing);
        make.centerY.equalTo(self.button5.centerY).offset(0);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
}


#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    if (_indexPath.section == 1) {
        
        _titleLabel.text = @"我的服务";
        [_button0 setImage:[UIImage imageNamed:@"dc_my_pingtuan"] forState:0];
        [_button1 setImage:[UIImage imageNamed:@"youhuiq"] forState:0];
        [_button2 setImage:[UIImage imageNamed:@"shouhuodiz"] forState:0];
        [_button3 setImage:[UIImage imageNamed:@"wodepingj"] forState:0];
        [_button4 setImage:[UIImage imageNamed:@"yyaorr"] forState:0];
        [_button5 setImage:[UIImage imageNamed:@"etp_center_log"] forState:0];
        [_button6 setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:0];
        
        [_button0 setTitle:@"我的拼团" forState:0];//99
        [_button1 setTitle:@"优惠券" forState:0];//100
        [_button2 setTitle:@"收货地址" forState:0];//101
        [_button3 setTitle:@"我的评价" forState:0];//103
        [_button4 setTitle:@"用药人" forState:0];//105
        [_button5 setTitle:@"自由创业者" forState:0];//106
        [_button6 setTitle:@"未知" forState:0];//106
        
        _button0.hidden = NO;
        _button0.tag=99;
        _button1.tag=100;
        _button2.tag=101;
        _button3.tag=103;
        _button4.tag=105;
        _button5.tag = 106;
        _button6.tag = 107;
        _button6.hidden = YES;
        [_button1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.bottom).offset(-30-_itemH);
        }];
    } else if (indexPath.section == 2) {
        
        _titleLabel.text = @"其它功能";
        [_button0 setImage:[UIImage imageNamed:@"guanyuwomen"] forState:0];
        [_button1 setImage:[UIImage imageNamed:@"yijianfankui"] forState:0];
        [_button2 setImage:[UIImage imageNamed:@"jianchagengx"] forState:0];
        [_button3 setImage:[UIImage imageNamed:@"gerenshez"] forState:0];
        
        [_button0 setTitle:@"关于我们" forState:0];
        [_button1 setTitle:@"意见反馈" forState:0];
        [_button2 setTitle:@"当前版本" forState:0];
        [_button3 setTitle:@"个人设置" forState:0];
        
        _button0.tag=200;
        _button1.tag=201;
        _button2.tag=202;
        _button3.tag=203;
        _button4.hidden = YES;
        _button5.hidden = YES;
        _button6.hidden = YES;
        
//        _button0.hidden = YES;
//        [_button0 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(0, 0));
//        }];
        
        [_button1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.button0.right).offset(0);
            make.bottom.equalTo(self.bgView.bottom).offset(-15);
        }];
        
    }
}


@end
