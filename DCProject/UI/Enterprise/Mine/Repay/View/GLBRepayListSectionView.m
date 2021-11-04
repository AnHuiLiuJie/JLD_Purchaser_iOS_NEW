//
//  GLBRepayListSectionView.m
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBRepayListSectionView.h"

@interface GLBRepayListSectionView ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@end

@implementation GLBRepayListSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setTitle:@"" forState:0];
    [_button3 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button3.titleLabel.font = PFRFont(12);
    [_button3 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:12];
    [_button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button3];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:@"" forState:0];
    [_button2 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button2.titleLabel.font = PFRFont(12);
    [_button2 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:12];
    [_button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button2];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:@"" forState:0];
    [_button1 setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _button1.titleLabel.font = PFRFont(12);
    [_button1 dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#333333"] radius:12];
    [_button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button1];
    
    [self layoutIfNeeded];
}



#pragma mark - action
- (void)buttonClick:(UIButton *)button
{
    if (_successBlock) {
        _successBlock(button.titleLabel.text);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(67, 24));
    }];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.button3.left).offset(-10);
        make.size.equalTo(CGSizeMake(67, 24));
    }];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.button2.left).offset(-10);
        make.size.equalTo(CGSizeMake(67, 24));
    }];
}


#pragma mark - setter
- (void)setRepayListModel:(GLBRepayListModel *)repayListModel
{
    _repayListModel = repayListModel;

    //    账期状态：1-在途；2-待还款；3-还款中；4-已还款；5-逾期还款结束
    
    self.button1.hidden = YES;
    self.button2.hidden = YES;
    self.button3.hidden = YES;
    if (_repayListModel.periodState == 1) {
        
    } else if (_repayListModel.periodState == 2) {
        
    
        if (_repayListModel.canApplyDelay && [_repayListModel.canApplyDelay isEqualToString:@"1"]) { // 允许逾期还款
            
            self.button1.hidden = NO;
            self.button2.hidden = NO;
            self.button3.hidden = NO;
            [self.button1 setTitle:@"全额还款" forState:0];
            [self.button2 setTitle:@"部分还款" forState:0];
            [self.button3 setTitle:@"逾期申请" forState:0];
            
        } else {
            
            self.button2.hidden = NO;
            self.button3.hidden = NO;
            [self.button2 setTitle:@"全额还款" forState:0];
            [self.button3 setTitle:@"部分还款" forState:0];
        }
        
        
    } else if (_repayListModel.periodState == 3) {
        
        if (_repayListModel.canApplyDelay && [_repayListModel.canApplyDelay isEqualToString:@"1"]) { // 允许逾期还款
            
            self.button1.hidden = NO;
            self.button2.hidden = NO;
            self.button3.hidden = NO;
            [self.button1 setTitle:@"部分还款" forState:0];
            [self.button2 setTitle:@"逾期申请" forState:0];
            [self.button3 setTitle:@"还款记录" forState:0];
            
        } else {
            
            self.button2.hidden = NO;
            self.button3.hidden = NO;
            [self.button2 setTitle:@"部分还款" forState:0];
            [self.button3 setTitle:@"还款记录" forState:0];
        }
        
    } else if (_repayListModel.periodState == 4) {
        
        self.button3.hidden = NO;
        [self.button3 setTitle:@"还款记录" forState:0];
        
    } else if (_repayListModel.periodState == 5) {
        
        self.button3.hidden = NO;
        [self.button3 setTitle:@"还款记录" forState:0];
    }
    
}

@end
