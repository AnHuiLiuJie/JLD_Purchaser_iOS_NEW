//
//  GLPGoodsDetailsOldTicketCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsOldTicketCell.h"

@interface GLPGoodsDetailsOldTicketCell ()
{
    CGFloat goods_spacing;
    CGFloat store_spacing;
    CGFloat platform_spacing;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) GLPGoodsDetailsTicketView *goodsView;
@property (nonatomic, strong) GLPGoodsDetailsTicketView *storeView;
@property (nonatomic, strong) GLPGoodsDetailsTicketView *platformView;

@end

@implementation GLPGoodsDetailsOldTicketCell

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
    
    goods_spacing = 14;
    store_spacing = 0;
    platform_spacing = 0;
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    
    _goodsView = [[GLPGoodsDetailsTicketView alloc] init];
    _goodsView.clipsToBounds = YES;
    WEAKSELF;
    _goodsView.moreBtnBlock = ^{
        if (weakSelf.ticketBlock) {
           weakSelf.ticketBlock(1);
        }
    };
    [self.contentView addSubview:_goodsView];
    
    _storeView = [[GLPGoodsDetailsTicketView alloc] init];
    _storeView.clipsToBounds = YES;
    _storeView.moreBtnBlock = ^{
        if (weakSelf.ticketBlock) {
            weakSelf.ticketBlock(2);
        }
    };
    [self.contentView addSubview:_storeView];
    
    _platformView = [[GLPGoodsDetailsTicketView alloc] init];
    _platformView.clipsToBounds = YES;
    _platformView.moreBtnBlock = ^{
        if (weakSelf.ticketBlock) {
            weakSelf.ticketBlock(2);
        }
    };
    [self.contentView addSubview:_platformView];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h1 = goods_spacing == 0 ? 0 : 42;
    [_goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.bgView.top).offset(goods_spacing);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(h1);
    }];
    
    CGFloat h2 = store_spacing == 0 ? 0 : 42;
    [_storeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.goodsView.bottom).offset(store_spacing);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(h2);
    }];
    
    CGFloat h3 = platform_spacing == 0 ? 0 : 42;
    [_platformView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.storeView.bottom).offset(platform_spacing);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.contentView.bottom).offset(-14);//
        make.height.equalTo(h3);
    }];
    
    CGFloat hight = CGRectGetMaxY(_platformView.frame);
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(hight+20).priorityHigh();
        //make.height.equalTo(hight+20).priorityHigh();
    }];

}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;

    goods_spacing = 14;
    store_spacing = 20;
    platform_spacing = 20;
    
    if (_detailModel.goodsCoupons.couponsId) {
        _goodsView.goodsTicketModel = _detailModel.goodsCoupons;
        goods_spacing = 20;
    }
    else{
        goods_spacing = 0;
    }
        
    if (_detailModel.storeCoupons.couponsId) {
        _storeView.storeTicketModel = _detailModel.storeCoupons;
        store_spacing = 20;
    }
    else{
        store_spacing = 0;
    }
    
    if (_detailModel.bossCoupons.couponsId) {
        _platformView.bossTicketModel = _detailModel.bossCoupons;
        platform_spacing = 20;
    }
    else{
        platform_spacing = 0;
    }
    
    [self layoutIfNeeded];

}


@end


#pragma mark - 券
@interface GLPGoodsDetailsTicketView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLPGoodsDetailsTicketView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"shangpyouhui"];
    [self addSubview:_bgImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#B7790A"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#B77A0B"];
    _moneyLabel.font = PFRFont(13);
    _moneyLabel.text = @"";
    [self addSubview:_moneyLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"zjankai"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    if (_moreBtnBlock) {
        _moreBtnBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(240);
        make.height.equalTo(42);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.left).offset(12);
        make.centerY.equalTo(self.bgImage.centerY);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(16);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];

}


#pragma mark - setter
- (void)setGoodsTicketModel:(GLPGoodsDetailTicketModel *)goodsTicketModel
{
    _goodsTicketModel = goodsTicketModel;
    
    _titleLabel.text = @"品种专享";
    NSDictionary *dic1 = [goodsTicketModel mj_keyValues];
    if ([dic1 dc_isNull]||[dic1 isEqualToDictionary:@{}])
    {
        _moneyLabel.text = @"";
    }
    else{
        _moneyLabel.text = [NSString stringWithFormat:@"满%@减%@",_goodsTicketModel.requireAmount,_goodsTicketModel.discountAmount];
    }
   
}


- (void)setStoreTicketModel:(GLPGoodsDetailTicketModel *)storeTicketModel
{
    _storeTicketModel = storeTicketModel;
    _titleLabel.text = @"领商家券";
    NSDictionary *dic2 = [storeTicketModel mj_keyValues];
    if ([dic2 dc_isNull]||[dic2 isEqualToDictionary:@{}]){
        _moneyLabel.text = @"";
    }else
       _moneyLabel.text = [NSString stringWithFormat:@"满%@减%@",_storeTicketModel.requireAmount,_storeTicketModel.discountAmount];
}


- (void)setBossTicketModel:(GLPGoodsDetailTicketModel *)bossTicketModel
{
    _bossTicketModel = bossTicketModel;
    
    _titleLabel.text = @"平台优惠";
    NSDictionary *dic3 = [bossTicketModel mj_keyValues];
    if ([dic3 dc_isNull]||[dic3 isEqualToDictionary:@{}])
    {
        _moneyLabel.text = @"";
    }
    else{
        _moneyLabel.text = [NSString stringWithFormat:@"满%@减%@",_bossTicketModel.requireAmount,_bossTicketModel.discountAmount];
    }
}

@end
