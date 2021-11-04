//
//  GLPMineHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineHeadView.h"

@interface GLPMineHeadView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UIButton *activityBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIButton *msgBtn;
@property (nonatomic, strong) UILabel *msgCountLabel;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *rengzhengImage;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *careBtn;
@property (nonatomic, strong) UIButton *scoreBtn;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UIButton *userInfoBtn;
@property(nonatomic,strong)UIImageView*bottomImageV;
@end

@implementation GLPMineHeadView

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
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"gerenzhongxbg"];
    _bgImage.contentMode = UIViewContentModeScaleToFill;
//    _bgImage.clipsToBounds = YES;
    [self addSubview:_bgImage];
    
    _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeBtn setImage:[UIImage imageNamed:@"qiehuan"] forState:0];
    [_exchangeBtn setTitle:@"个人版" forState:0];
    [_exchangeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _exchangeBtn.titleLabel.font = [UIFont fontWithName:PFRSemibold size:16];
    _exchangeBtn.adjustsImageWhenHighlighted = NO;
    _exchangeBtn.tag = 201;
    _exchangeBtn.bounds = CGRectMake(0, 0, 80, 26);
    [_exchangeBtn dc_buttonIconRightWithSpacing:5];
    _exchangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_exchangeBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exchangeBtn];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_msgBtn setImage:[UIImage imageNamed:@"wodexiaox-1"] forState:0];
    _msgBtn.adjustsImageWhenHighlighted = NO;
    _msgBtn.tag = 202;
    [_msgBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgBtn];
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn setImage:[UIImage imageNamed:@"shez"] forState:0];
    _setBtn.adjustsImageWhenHighlighted = NO;
    _setBtn.tag = 203;
    [_setBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_setBtn];
    
    _activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_activityBtn setImage:[UIImage imageNamed:@"qiand"] forState:0];
    _activityBtn.adjustsImageWhenHighlighted = NO;
    _activityBtn.tag = 204;
    [_activityBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_activityBtn];
    
    _msgCountLabel = [[UILabel alloc] init];
    _msgCountLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FC4516"];
    _msgCountLabel.font = PFRFont(10);
    _msgCountLabel.textColor = [UIColor whiteColor];
    _msgCountLabel.textAlignment = NSTextAlignmentCenter;
    [_msgCountLabel dc_layerBorderWith:1 color:[UIColor whiteColor] radius:9];
    _msgCountLabel.text = @"0";
    _msgCountLabel.hidden = YES;
    [self addSubview:_msgCountLabel];
    
    _headImage = [[UIImageView alloc] init];
    [_headImage dc_layerBorderWith:1 color:[UIColor whiteColor] radius:25];
    [self addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:PFRSemibold size:20];
    _nameLabel.text = @"";
    [self addSubview:_nameLabel];
    
    _rengzhengImage = [[UIImageView alloc] init];
    _rengzhengImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    _rengzhengImage.userInteractionEnabled = YES;
    [self addSubview:_rengzhengImage];
    UITapGestureRecognizer*authTag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(authenClick)];
    [_rengzhengImage addGestureRecognizer:authTag];
    _rengzhengImage.hidden = YES;
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    _phoneLabel.font = [UIFont fontWithName:PFR size:14];
    _phoneLabel.text = @"";
    [self addSubview:_phoneLabel];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setAttributedTitle:[self attributeWithCount:0 type:@"收藏夹"] forState:0];
    _collectBtn.adjustsImageWhenHighlighted = NO;
    _collectBtn.tag = 205;
    _collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _collectBtn.titleLabel.numberOfLines = 2;
    [_collectBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectBtn];
    
    _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_careBtn setAttributedTitle:[self attributeWithCount:0 type:@"关注店铺"] forState:0];
    _careBtn.adjustsImageWhenHighlighted = NO;
    _careBtn.tag = 206;
    _careBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _careBtn.titleLabel.numberOfLines = 2;
    [_careBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_careBtn];
    
    _scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scoreBtn setAttributedTitle:[self attributeWithCount:0 type:@"积分"] forState:0];
    _scoreBtn.adjustsImageWhenHighlighted = NO;
    _scoreBtn.tag = 207;
    _scoreBtn.titleLabel.numberOfLines = 2;
    _scoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scoreBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scoreBtn];
    
    _seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeBtn setAttributedTitle:[self attributeWithCount:0 type:@"足迹"] forState:0];
    _seeBtn.adjustsImageWhenHighlighted = NO;
    _seeBtn.tag = 208;
    _seeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _seeBtn.titleLabel.numberOfLines = 2;
    [_seeBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_seeBtn];
    
    _userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userInfoBtn.backgroundColor = [UIColor clearColor];
    _userInfoBtn.tag = 209;
    [_userInfoBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_userInfoBtn];
    
    _bottomImageV = [[UIImageView alloc] init];
    _bottomImageV.image = [UIImage imageNamed:@"mine_gg"];
    _bottomImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_bottomImageV addGestureRecognizer:tap];
    [self addSubview:_bottomImageV];
    [self layoutIfNeeded];
}
#pragma 领券中心
- (void)tapClick
{
    if (self.couponBlock) {
        self.couponBlock();
    }
}
#pragma 认证点击
- (void)authenClick
{
    if (self.authenBlock) {
        self.authenBlock();
    }
}

#pragma mark -
- (void)headBtnClick:(UIButton *)button
{
    if (_headViewBlock) {
        _headViewBlock(button.tag);
    }
}


#pragma mark -
- (NSMutableAttributedString *)attributeWithCount:(NSInteger)count type:(NSString *)type
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n%@",(long)count,type]];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#ffffff"],NSFontAttributeName:[UIFont fontWithName:PFRSemibold size:17]} range:NSMakeRange(0, attStr.length - type.length)];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#ffffff"],NSFontAttributeName:[UIFont fontWithName:PFR size:12]} range:NSMakeRange(attStr.length - type.length,  type.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    style.alignment = NSTextAlignmentCenter;
    [attStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attStr.length)];
    
    return attStr;
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = kScreenW/4;
    CGFloat height = width *0.8;
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.bottom.equalTo(self.bottom).offset(0);
    }];
    
    [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.top).offset(14);
        make.size.equalTo(CGSizeMake(80, 26));
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.exchangeBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.left).offset(-5);
        make.centerY.equalTo(self.exchangeBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.setBtn.left).offset(-5);
        make.centerY.equalTo(self.exchangeBtn.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_msgCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgBtn.right);
        make.top.equalTo(self.msgBtn.top);
        make.size.equalTo(CGSizeMake(18, 18));
    }];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.exchangeBtn.bottom).offset(5);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.right).offset(15);
        make.top.equalTo(self.headImage.top);
        make.width.lessThanOrEqualTo(200);
        make.height.offset(17);
    }];
    
    [_rengzhengImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(10);
        make.centerY.equalTo(self.nameLabel.centerY);
        make.size.equalTo(CGSizeMake(58, 24));
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.bottom.equalTo(self.headImage.bottom);
        make.right.equalTo(self.right);
    }];
    
    [_userInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_left);
        make.right.equalTo(self.headImage.mas_right);
        make.top.equalTo(self.headImage.mas_top);
        make.bottom.equalTo(self.headImage.bottom);
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.headImage.bottom).offset(5);
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
    
    [_bottomImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.collectBtn.bottom).offset(12);
        make.height.equalTo(108*kScreenW/375);
    }];
}

#pragma mark - setter
- (void)setNumDic:(NSDictionary *)numDic
{
    
    // browsingNum 足迹数量
    // favorite 收藏夹数量
    // integral 积分
    // storeNum 关注店铺数量
    
    NSInteger browsingNum = 0;
    if (numDic[@"browsingNum"]) {
        browsingNum = [numDic[@"browsingNum"] integerValue];
    }
    
    NSInteger favorite = 0;
    if (numDic[@"favorite"]) {
        favorite = [numDic[@"favorite"] integerValue];
    }
    
    NSInteger integral = 0;
    if (numDic[@"integral"]) {
        integral = [numDic[@"integral"] integerValue];
    }
    
    NSInteger storeNum = 0;
    if (numDic[@"storeNum"]) {
        storeNum = [numDic[@"storeNum"] integerValue];
    }
    
    [_collectBtn setAttributedTitle:[self attributeWithCount:favorite type:@"收藏夹"] forState:0];
    [_careBtn setAttributedTitle:[self attributeWithCount:storeNum type:@"关注店铺"] forState:0];
    [_scoreBtn setAttributedTitle:[self attributeWithCount:integral type:@"积分"] forState:0];
    [_seeBtn setAttributedTitle:[self attributeWithCount:browsingNum type:@"足迹"] forState:0];
}

- (void)setPersonDic:(NSDictionary *)personDic
{
    NSString *userName = [NSString stringWithFormat:@"%@",personDic[@"nickName"]];
    NSString *cellphone = [NSString stringWithFormat:@"%@",personDic[@"cellphone"]];
    NSString *userImg = [NSString stringWithFormat:@"%@",personDic[@"userImg"]];
    self.nameLabel.text=userName;
    self.phoneLabel.text=cellphone;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    NSString *idState = [NSString stringWithFormat:@"%@",personDic[@"idState"]];
    if ([idState isEqualToString:@"1"])
    {
       self.rengzhengImage.image = [UIImage imageNamed:@"weishim"];
    }
    else if ([idState isEqualToString:@"2"])
    {
        self.rengzhengImage.image = [UIImage imageNamed:@"shenhez"];
    }
    else if ([idState isEqualToString:@"3"])
    {
        self.rengzhengImage.image = [UIImage imageNamed:@"shiming"];
    }
    else{
        self.rengzhengImage.image = [UIImage imageNamed:@"shib"];
    }
}


#pragma mark - setter
- (void)setCount:(NSInteger)count
{
    _count = count;
    
    NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
    long unreadCount = 0;
    for (HDConversation *conv in hConversations) {
        unreadCount += conv.unreadMessagesCount;
    }
    
    if (_count + unreadCount > 0) {
        _msgCountLabel.hidden = NO;
        _msgCountLabel.text = [NSString stringWithFormat:@"%ld",_count + unreadCount];
    } else {
        _msgCountLabel.hidden = YES;
    }
}


@end
