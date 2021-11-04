//
//  GLBMineHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMineHeadView.h"

@interface GLBMineHeadView ()
{
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UIButton *dayBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *renzhengImage;
@property (nonatomic, strong) UILabel *renzhengLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *careBtn;
@property (nonatomic, strong) UIButton *scoreBtn;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UIButton *userInfoBtn;

@property (nonatomic, strong) UIImageView *tipImage;

@end

@implementation GLBMineHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _itemW = kScreenW/4;
    _itemH = _itemW *0.8;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"wodebg"];
    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
    _bgImage.clipsToBounds = YES;
    [self addSubview:_bgImage];
    
    _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _exchangeBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.1];
    [_exchangeBtn setImage:[UIImage imageNamed:@"qiye"] forState:0];
    [_exchangeBtn setTitle:@" 切换" forState:0];
    [_exchangeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _exchangeBtn.titleLabel.font = PFRFont(13);
    _exchangeBtn.adjustsImageWhenHighlighted = NO;
    [_exchangeBtn dc_cornerRadius:13];
    _exchangeBtn.tag = 201;
    [_exchangeBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exchangeBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"wode_xx"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    _msgBtn.tag = 202;
    [_msgBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dayBtn setImage:[UIImage imageNamed:@"wode_rl"] forState:0];
    _dayBtn.adjustsImageWhenHighlighted = NO;
    _dayBtn.tag = 203;
    [_dayBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dayBtn];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _nameLabel.text = @"";
    [self addSubview:_nameLabel];
    
    _renzhengImage = [[UIImageView alloc] init];
    _renzhengImage.image = [UIImage imageNamed:@"wode_smzz"];
    [self addSubview:_renzhengImage];
    
    _renzhengLabel = [[UILabel alloc] init];
    _renzhengLabel.textColor = [UIColor dc_colorWithHexString:@"#E2FAF9"];
    _renzhengLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _renzhengLabel.text = @"";
    [self addSubview:_renzhengLabel];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setAttributedTitle:[self attributeWithCount:0 type:@"收藏夹"] forState:0];
    _collectBtn.adjustsImageWhenHighlighted = NO;
    _collectBtn.tag = 204;
    _collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _collectBtn.titleLabel.numberOfLines = 2;
    [_collectBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectBtn];
    
    _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_careBtn setAttributedTitle:[self attributeWithCount:0 type:@"关注店铺"] forState:0];
    _careBtn.adjustsImageWhenHighlighted = NO;
    _careBtn.tag = 205;
    _careBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _careBtn.titleLabel.numberOfLines = 2;
    [_careBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_careBtn];
    
    _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scoreBtn setAttributedTitle:[self attributeWithCount:0 type:@"积分"] forState:0];
    _scoreBtn.adjustsImageWhenHighlighted = NO;
    _scoreBtn.tag = 206;
    _scoreBtn.titleLabel.numberOfLines = 2;
    _scoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scoreBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scoreBtn];
    
    _seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeBtn setAttributedTitle:[self attributeWithCount:0 type:@"足迹"] forState:0];
    _seeBtn.adjustsImageWhenHighlighted = NO;
    _seeBtn.tag = 207;
    _seeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _seeBtn.titleLabel.numberOfLines = 2;
    [_seeBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_seeBtn];
    
    _moreImage = [[UIImageView alloc] init];
    _moreImage.image = [UIImage imageNamed:@"wode_xl"];
    [self addSubview:_moreImage];
    
    _userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userInfoBtn.backgroundColor = [UIColor clearColor];
    _userInfoBtn.tag = 208;
    [_userInfoBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userInfoBtn];
    
    _tipImage = [[UIImageView alloc] init];
    _tipImage.backgroundColor = [UIColor redColor];
    [_tipImage dc_cornerRadius:3];
    _tipImage.hidden = YES;
    [self addSubview:_tipImage];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)headBtnClick:(UIButton *)button
{
    if (_buttonClickBlock) {
        _buttonClickBlock(button.tag);
    }
}


#pragma mark -
- (NSMutableAttributedString *)attributeWithCount:(NSInteger)count type:(NSString *)type
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n%@",(long)count,type]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#303D55"],NSFontAttributeName:[UIFont fontWithName:PFRSemibold size:16]} range:NSMakeRange(0, attStr.length - type.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#8F93A3"],NSFontAttributeName:[UIFont fontWithName:PFR size:11]} range:NSMakeRange(attStr.length - type.length,  type.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 11;
    style.alignment = NSTextAlignmentCenter;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attStr.length)];
    
    return attStr;
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = _itemW;
    CGFloat height = _itemH;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom).offset(-5);
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom).offset(-5);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectBtn.right);
        make.centerY.equalTo(self.collectBtn.centerY);
        make.width.equalTo(self.collectBtn.width);
        make.height.equalTo(self.collectBtn.height);
    }];
    
    [_scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.careBtn.right);
        make.centerY.equalTo(self.collectBtn.centerY);
        make.width.equalTo(self.collectBtn.width);
        make.height.equalTo(self.collectBtn.height);
    }];
    
    [_seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreBtn.right);
        make.centerY.equalTo(self.collectBtn.centerY);
        make.width.equalTo(self.collectBtn.width);
        make.height.equalTo(self.collectBtn.height);
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.collectBtn.top);
    }];
    
    [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.top).offset(kStatusBarHeight + 5);
        make.size.equalTo(CGSizeMake(60, 26));
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.exchangeBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.left).offset(-5);
        make.centerY.equalTo(self.exchangeBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.exchangeBtn.bottom).offset(18);
        make.right.equalTo(self.right).offset(-30);
    }];
    
    [_renzhengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.top.equalTo(self.nameLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    [_renzhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.renzhengImage.right).offset(5);
        make.centerY.equalTo(self.renzhengImage.centerY);
        make.right.equalTo(self.nameLabel.right);
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15);
        make.centerY.equalTo(self.nameLabel.bottom);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];
    
    [_userInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.nameLabel.top);
        make.bottom.equalTo(self.renzhengImage.bottom);
    }];
    
    [_tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgBtn.top).offset(3);
        make.right.equalTo(self.msgBtn.right).offset(-3);
        make.size.equalTo(CGSizeMake(6, 6));
    }];
}


#pragma mark - setter
- (void)setCountDic:(NSDictionary *)countDic
{
    _countDic = countDic;
    
    // browsingNum 足迹数量
    // favorite 收藏夹数量
    // integral 积分
    // storeNum 关注店铺数量
    
    NSInteger browsingNum = 0;
    if (_countDic[@"browsingNum"]) {
        browsingNum = [_countDic[@"browsingNum"] integerValue];
    }
    
    NSInteger favorite = 0;
    if (_countDic[@"favorite"]) {
        favorite = [_countDic[@"favorite"] integerValue];
    }
    
    NSInteger integral = 0;
    if (_countDic[@"integral"]) {
        integral = [_countDic[@"integral"] integerValue];
    }
    
    NSInteger storeNum = 0;
    if (_countDic[@"storeNum"]) {
        storeNum = [_countDic[@"storeNum"] integerValue];
    }
    
    [_collectBtn setAttributedTitle:[self attributeWithCount:favorite type:@"收藏夹"] forState:0];
    [_careBtn setAttributedTitle:[self attributeWithCount:storeNum type:@"关注店铺"] forState:0];
    [_scoreBtn setAttributedTitle:[self attributeWithCount:integral type:@"积分"] forState:0];
    [_seeBtn setAttributedTitle:[self attributeWithCount:browsingNum type:@"足迹"] forState:0];
}


- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    NSString *title = @"";
    if (_infoDict && _infoDict[@"firmName"]) {
        title = _infoDict[@"firmName"];
    }
    
    NSString *auditState = @"";
    if (_infoDict && _infoDict[@"auditState"]) {
        auditState = _infoDict[@"auditState"];
    }
    
    _nameLabel.text = title;
    if (auditState && [auditState isEqualToString:@"2"]) {
        _renzhengLabel.text = @"已认证企业";
    } else {
        _renzhengLabel.text = @"未认证企业";
    }
}


- (void)setCount:(NSInteger)count
{
    _count = count;
    
    if (_count > 0) {
        _tipImage.hidden = NO;
    } else {
        _tipImage.hidden = YES;
    }
}

@end
