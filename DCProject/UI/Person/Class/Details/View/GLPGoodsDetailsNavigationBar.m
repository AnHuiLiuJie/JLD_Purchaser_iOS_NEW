//
//  GLPGoodsDetailsNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsNavigationBar.h"

@interface GLPGoodsDetailsNavigationBar ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UILabel *msgCountLabel;
@property (nonatomic, strong) UIButton *goodsBtn;
@property (nonatomic, strong) UIButton *evaluateBtn;
@property (nonatomic, strong) UIButton *recommendBtn;
@property (nonatomic, strong) UIButton *descBtn;

@property (nonatomic, strong) UIImageView *line;

@end

@implementation GLPGoodsDetailsNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFFFF" alpha:0];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_bei"] forState:0];
    _backBtn.adjustsImageWhenHighlighted = NO;
    _backBtn.tag = 700;
    [_backBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"dc_spxq_more"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    _msgBtn.tag = 701;
    [_msgBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _msgCountLabel = [[UILabel alloc] init];
    _msgCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FC4516"];
    _msgCountLabel.font = PFRFont(10);
    _msgCountLabel.textColor = [UIColor whiteColor];
    _msgCountLabel.textAlignment = NSTextAlignmentCenter;
    [_msgCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:9];
    _msgCountLabel.text = @"0";
    _msgCountLabel.hidden = YES;
    [self addSubview:_msgCountLabel];
    
    _goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsBtn setTitle:@"商品" forState:0];
    [_goodsBtn setTitleColor:[UIColor dc_colorWithHexString:@"#4C4A49"] forState:0];
    [_goodsBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
    _goodsBtn.titleLabel.font = PFRFont(15);
    _goodsBtn.tag = 702;
    [_goodsBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goodsBtn];
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_evaluateBtn setTitle:@"评价" forState:0];
    [_evaluateBtn setTitleColor:[UIColor dc_colorWithHexString:@"#4C4A49"] forState:0];
    [_evaluateBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
    _evaluateBtn.titleLabel.font = PFRFont(15);
    _evaluateBtn.tag = 703;
    [_evaluateBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_evaluateBtn];
    
    _descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_descBtn setTitle:@"详情" forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:@"#4C4A49"] forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
    _descBtn.titleLabel.font = PFRFont(15);
    _descBtn.tag = 704;
    [_descBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_descBtn];
    
    _recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recommendBtn setTitle:@"推荐" forState:0];
    [_recommendBtn setTitleColor:[UIColor dc_colorWithHexString:@"#4C4A49"] forState:0];
    [_recommendBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
    _recommendBtn.titleLabel.font = PFRFont(15);
    _recommendBtn.tag = 704;
    [_recommendBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recommendBtn];
    
    _descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_descBtn setTitle:@"详情" forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:@"#4C4A49"] forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
    _descBtn.titleLabel.font = PFRFont(15);
    _descBtn.tag = 705;
    [_descBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_descBtn];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [self addSubview:_line];
    
    _recommendBtn.hidden = YES;
    _descBtn.hidden = YES;
    _goodsBtn.hidden = YES;
    _evaluateBtn.hidden = YES;
    _line.hidden = YES;
    _goodsBtn.selected = YES;
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)navBtnClick:(UIButton *)button
{
    if (button.tag > 701 ) {
        if (button.selected) {
            return;
        } else {
            _goodsBtn.selected = NO;
            _evaluateBtn.selected = NO;
            _descBtn.selected = NO;
            _recommendBtn.selected = NO;
            button.selected = YES;
            
            [self layoutSubviews];
        }
    }
    
    if (_navbarBlock) {
        _navbarBlock(button.tag);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.bottom.equalTo(self.bottom).offset(-4);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.backBtn.centerY);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    [_msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.right);
        make.top.equalTo(self.msgBtn.top);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    [_evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX).offset(-18);
        make.centerY.equalTo(self.backBtn.centerY);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    [_goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.centerY);
        make.right.equalTo(self.evaluateBtn.left).offset(-10);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    [_recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.centerY);
        make.left.equalTo(self.evaluateBtn.right).offset(10);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    [_descBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.centerY);
        make.left.equalTo(self.recommendBtn.right).offset(10);
        make.size.equalTo(CGSizeMake(36, 36));
    }];
    
    
    if (self.goodsBtn.selected) {
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.goodsBtn.centerX);
            make.bottom.equalTo(self.bottom).offset(-5);
            make.size.equalTo(CGSizeMake(28, 1));
        }];
        
    } else if (self.evaluateBtn.selected) {
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.evaluateBtn.centerX);
            make.bottom.equalTo(self.bottom).offset(-5);
            make.size.equalTo(CGSizeMake(28, 1));
        }];
        
    } else if (self.recommendBtn.selected) {
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recommendBtn.centerX);
            make.bottom.equalTo(self.bottom).offset(-5);
            make.size.equalTo(CGSizeMake(28, 1));
        }];
        
    }else if (self.descBtn.selected) {
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.descBtn.centerX);
            make.bottom.equalTo(self.bottom).offset(-5);
            make.size.equalTo(CGSizeMake(28, 1));
        }];
        
    }
    
    
}


#pragma mark - setter
- (void)setIsTop:(BOOL)isTop
{
    _isTop = isTop;
    
    if (_isTop) {
        _recommendBtn.hidden = NO;
        _descBtn.hidden = NO;
        _goodsBtn.hidden = NO;
        _evaluateBtn.hidden = NO;
        _line.hidden = NO;
        [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_hei"] forState:0];
        [_msgBtn setImage:[UIImage imageNamed:@"zhankaugengduocaozuo"] forState:0];
        
    } else {
        _recommendBtn.hidden = YES;
        _descBtn.hidden = YES;
        _goodsBtn.hidden = YES;
        _evaluateBtn.hidden = YES;
        _line.hidden = YES;
        [_backBtn setImage:[UIImage imageNamed:@"dc_fanhui_bei"] forState:0];
        [_msgBtn setImage:[UIImage imageNamed:@"dc_spxq_more"] forState:0];
    }
}


#pragma mark - setter
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex == 1) {
        
        _goodsBtn.selected = YES;
        _evaluateBtn.selected = NO;
        _recommendBtn.selected = NO;
        _descBtn.selected = NO;
        
    } else if (currentIndex == 2) {
        
        _goodsBtn.selected = NO;
        _evaluateBtn.selected = YES;
        _recommendBtn.selected = NO;
        _descBtn.selected = NO;
        
    } else if (currentIndex == 3) {
        
        _goodsBtn.selected = NO;
        _evaluateBtn.selected = NO;
        _recommendBtn.selected = YES;
        _descBtn.selected = NO;
        
    }else if (currentIndex == 4) {
        
        _goodsBtn.selected = NO;
        _evaluateBtn.selected = NO;
        _recommendBtn.selected = NO;
        _descBtn.selected = YES;
        
    }
    
    [self layoutSubviews];
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long unreadCount = 0;
    for (HDConversation *conv in hConversations) {
        unreadCount += conv.unreadMessagesCount;
    }
    
    if (_count + unreadCount > 0) {
        self.msgCountLabel.hidden = NO;
        self.msgCountLabel.text = [NSString stringWithFormat:@"%ld",count + unreadCount];
    } else {
        self.msgCountLabel.hidden = YES;
    }
}
@end
