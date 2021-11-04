//
//  GLPHomeNavigationBar.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeNavigationBar.h"

@interface GLPHomeNavigationBar ()

//@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIImageView *msgImage;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation GLPHomeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)wr_setBackgroundAlpha:(CGFloat)alpha {
    self.alpha = alpha;
}

- (void)setUpUI
{
//    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_backBtn setImage:[UIImage imageNamed:@"tuic"] forState:0];
//    _backBtn.adjustsImageWhenHighlighted = NO;
//    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_backBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    [_msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"sy_fenx"] forState:0];
    _shareBtn.adjustsImageWhenHighlighted = NO;
    [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];
    
    _searchView = [[UIView alloc] init];
    _searchView.backgroundColor = [UIColor whiteColor];
    [_searchView dc_cornerRadius:15];
    _searchView.userInteractionEnabled = YES;
    [self addSubview:_searchView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewClick:)];
    [_searchView addGestureRecognizer:tap];
    
    _searchImage = [[UIImageView alloc] init];
    _searchImage.image = [UIImage imageNamed:@"dc_ss_hei"];
    [_searchView addSubview:_searchImage];
    
    _searchLabel = [[UILabel alloc] init];
    _searchLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _searchLabel.font = PFRFont(11);
    _searchLabel.text = @"搜索你需要的商品";
    [_searchView addSubview:_searchLabel];
    
    _msgImage = [[UIImageView alloc] init];
    _msgImage.backgroundColor = [UIColor redColor];
    [_msgImage dc_layerBorderWith:1 color:[UIColor whiteColor] radius:4];
    [_msgImage dc_cornerRadius:4];
    _msgImage.hidden = YES;
    [self addSubview:_msgImage];
    
    [self layoutIfNeeded];
}


#pragma mark - 点击事件
- (void)backBtnClick:(UIButton *)button
{
    if (_navBarBlock) {
        _navBarBlock(900);
    }
}

- (void)msgBtnClick:(UIButton *)button
{
    if (_navBarBlock) {
        _navBarBlock(901);
    }
}

- (void)searchViewClick:(id)sender
{
    if (_navBarBlock) {
        _navBarBlock(902);
    }
}

- (void)shareBtnClick:(id)sender
{
    if (_navBarBlock) {
        _navBarBlock(903);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).mas_offset(-10);
        make.bottom.equalTo(self.mas_bottom);
        make.width.height.equalTo(44);
    }];
    
    [_msgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgBtn.mas_top).mas_offset(5);
        make.right.equalTo(self.msgBtn.mas_right).mas_offset(-3);
        make.size.equalTo(CGSizeMake(8, 8));
    }];
    
//    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.left).offset(10);
//        make.centerY.equalTo(self.msgBtn.centerY);
//        make.width.height.equalTo(44);
//    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.mas_left).mas_offset(0);
        make.bottom.equalTo(self.mas_bottom);
        make.width.height.equalTo(44);
    }];
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(15);
        make.right.equalTo(self.shareBtn.mas_left).mas_offset(-5);
        make.centerY.equalTo(self.msgBtn.mas_centerY);
        make.height.equalTo(30);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView.mas_centerY);
        make.left.equalTo(self.searchView.mas_left).mas_offset(10);
        make.width.height.equalTo(12);
    }];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchImage.mas_right).mas_offset(10);
        make.right.equalTo(self.searchView.mas_right).mas_offset(-10);
        make.centerY.equalTo(self.searchView.mas_centerY);
    }];
}


#pragma mark - setter
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    
    if (_isTop) {
        [_msgBtn setImage:[UIImage imageNamed:@"xiaoxi-1"] forState:0];
        [_shareBtn setImage:[UIImage imageNamed:@"sy_fenxhei"] forState:0];
//        [_backBtn setImage:[UIImage imageNamed:@""] forState:0];
        _searchView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor alpha:1];
    }else{
        [_msgBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:0];
        [_shareBtn setImage:[UIImage imageNamed:@"sy_fenx"] forState:0];
//        [_backBtn setImage:[UIImage imageNamed:@"tuic"] forState:0];
        _searchView.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:1];
    }
}


- (void)setCount:(NSInteger)count
{
    _count = count;
    
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long unreadCount = 0;
    for (HDConversation *conv in hConversations) {
        unreadCount += conv.unreadMessagesCount;
    }
    NSLog(@"环信服务器=====未读消息数量：%ld",unreadCount);
    
    if (_count + unreadCount > 0) {
        _msgImage.hidden = NO;
    } else {
        _msgImage.hidden = YES;
    }
}

@end
