//
//  GLPGoodsDetailsTicketCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/2.
//

#import "GLPGoodsDetailsTicketCell.h"

@interface GLPGoodsDetailsTicketCell ()
{
    CGFloat goods_spacing;
    CGFloat store_spacing;
    CGFloat platform_spacing;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) DiscountTicketInfoView *goodsView;
@property (nonatomic, strong) DiscountTicketInfoView *storeView;
@property (nonatomic, strong) DiscountTicketInfoView *platformView;

@end

static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat view_spacing_y = 5;

@implementation GLPGoodsDetailsTicketCell

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
    
    goods_spacing = 0;
    store_spacing = 0;
    platform_spacing = 0;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];

    _goodsView = [[DiscountTicketInfoView alloc] init];
    WEAKSELF;
    _goodsView.moreBtnBlock = ^{
        !weakSelf.GLPGoodsDetailsTicketCell_block ? : weakSelf.GLPGoodsDetailsTicketCell_block(1);
    };
    [self.bgView addSubview:_goodsView];
    
    _storeView = [[DiscountTicketInfoView alloc] init];
    _storeView.clipsToBounds = YES;
    _storeView.moreBtnBlock = ^{
        !weakSelf.GLPGoodsDetailsTicketCell_block ? : weakSelf.GLPGoodsDetailsTicketCell_block(2);
    };
    [self.bgView addSubview:_storeView];
    
    _platformView = [[DiscountTicketInfoView alloc] init];
    _platformView.clipsToBounds = YES;
    _platformView.moreBtnBlock = ^{
        !weakSelf.GLPGoodsDetailsTicketCell_block ? : weakSelf.GLPGoodsDetailsTicketCell_block(3);
    };
    [self.bgView addSubview:_platformView];
    
}

- (void)layoutSubviews {
    //[super layoutSubviews];

}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;

    goods_spacing = 0;
    store_spacing = 0;
    platform_spacing = 0;
    
    if (_detailModel.goodsCoupons.couponsId) {
        _goodsView.goodsTicketModel = _detailModel.goodsCoupons;
        goods_spacing = view_spacing_y;
        _goodsView.hidden = NO;
    }
    else{
        _goodsView.hidden = YES;
        goods_spacing = 0;
    }
        
    if (_detailModel.storeCoupons.couponsId.length != 0) {
        _storeView.storeTicketModel = _detailModel.storeCoupons;
        store_spacing = view_spacing_y;
        _storeView.hidden = NO;
    }
    else{
        _storeView.hidden = YES;
        store_spacing = 0;
    }
    
    if (_detailModel.bossCoupons.couponsId.length != 0) {
        _platformView.bossTicketModel = _detailModel.bossCoupons;
        _platformView.hidden = NO;
        platform_spacing = view_spacing_y;
    }
    else{
        _platformView.hidden = YES;
        platform_spacing = 0;
    }
    
    CGFloat hight = CGRectGetMaxY(_platformView.frame);
    CGFloat h1 = goods_spacing == 0 ? 0 : 44;
    hight = (1+store_spacing/44)*h1;
    [_goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.bgView.top).offset(goods_spacing);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(h1).priorityHigh();
    }];
    
    CGFloat h2 = store_spacing == 0 ? 0 : 44;
    hight = (1+store_spacing/44)*h2+hight;
    [_storeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.goodsView.bottom).offset(store_spacing);
        make.right.equalTo(self.bgView.right);
        make.height.equalTo(h2).priorityHigh();
    }];
    
    CGFloat h3 = platform_spacing == 0 ? 0 : 44;
    hight = (1+store_spacing/44)*h3+hight;
    [_platformView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.storeView.bottom).offset(platform_spacing);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom).offset(-view_spacing_y);//
        make.height.equalTo(h3).priorityHigh();
    }];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(hight).priorityHigh();
    }];
    
    [self layoutIfNeeded];

}


@end



#pragma #####################################################################################

@interface DiscountTicketInfoView ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation DiscountTicketInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"shangpyouhui"];
    [self addSubview:_bgImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#9E5E0B"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLabel.text = @"组合\n优惠";
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#9E5E0B"];
    _moneyLabel.font = PFRFont(11);
    _moneyLabel.text = @"下单后分享可得\n*元微信现金红包";
    _moneyLabel.numberOfLines = 2;
    [self addSubview:_moneyLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"dc_cell_more"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    !_moreBtnBlock ? : _moreBtnBlock();
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
        make.left.equalTo(self.bgImage.left).offset(27);
        make.centerY.equalTo(self.bgImage.centerY);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(22);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-5);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(35, 35));
    }];

}


#pragma mark - setter
- (void)setGoodsTicketModel:(GLPGoodsDetailTicketModel *)goodsTicketModel{
    _goodsTicketModel = goodsTicketModel;
    _titleLabel.text = @"商品\n优惠";
    _moneyLabel.text = [NSString stringWithFormat:@"订单满%@立减%@",_goodsTicketModel.requireAmount,_goodsTicketModel.discountAmount];
}

- (void)setStoreTicketModel:(GLPGoodsDetailTicketModel *)storeTicketModel{
    _storeTicketModel = storeTicketModel;
    _titleLabel.text = @"店铺\n优惠";
    _moneyLabel.text = [NSString stringWithFormat:@"订单满%@立减%@",_storeTicketModel.requireAmount,_storeTicketModel.discountAmount];

}

- (void)setBossTicketModel:(GLPGoodsDetailTicketModel *)bossTicketModel{
    _bossTicketModel = bossTicketModel;
    _moneyLabel.text = [NSString stringWithFormat:@"订单满%@立减%@",_bossTicketModel.requireAmount,_bossTicketModel.discountAmount];

}

@end
