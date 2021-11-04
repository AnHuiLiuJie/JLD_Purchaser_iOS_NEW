//
//  GLPGoodsDetailsMatchCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsMatchCell.h"

@interface GLPGoodsDetailsMatchCell (){
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIScrollView *scrollBgView;

@end

@implementation GLPGoodsDetailsMatchCell

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
    
    _itemW = 50;
    _itemH = _itemW + 10;
    _spacing = (kScreenW - 15*2 - 5*2 - _itemW*3 - 100)/4;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"处方搭配";
    [self.contentView addSubview:_titleLabel];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"chufangdapei"];
    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [_bgImage dc_cornerRadius:7];
    [self.contentView addSubview:_bgImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _nameLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _priceLabel.font = [UIFont fontWithName:PFR size:12];
//    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.numberOfLines = 2;
    _priceLabel.text = @"";
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FF7E27"];
    [_priceLabel dc_cornerRadius:14];
    [self.contentView addSubview:_priceLabel];
    
    _scrollBgView = [[UIScrollView alloc] init];
    [self.contentView addSubview:_scrollBgView];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = _spacing;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
        make.height.equalTo(80);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImage.centerY).offset(-5);
        make.left.equalTo(self.bgImage.left).offset(8);
        make.width.equalTo(100);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.top.equalTo(self.nameLabel.bottom).offset(10);
        make.height.equalTo(28);
    }];
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.right).offset(spacing);
        make.centerY.equalTo(self.bgImage.centerY);
        make.height.equalTo(self.bgImage);
        make.right.equalTo(self.bgImage.right);
    }];
}


#pragma mark - setter
- (void)setMatchModel:(GLPGoodsMatchModel *)matchModel
{
    _matchModel = matchModel;
    
    _nameLabel.text = _matchModel.preName;
    _priceLabel.text = [NSString stringWithFormat:@" %@ ",_matchModel.preDesc];
    if (_matchModel.goodsList > 0) {
        for (int i =0; i<_matchModel.goodsList.count; i++) {
            GLPGoodsMatchGoodsModel *goodsModel = _matchModel.goodsList[i];
            GLPGoodsDetailsMatchGoodsView *view = [[GLPGoodsDetailsMatchGoodsView alloc] init];
            [self.scrollBgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
                make.centerY.equalTo(self.scrollBgView.centerY);
                make.height.equalTo(_itemH);
                make.width.equalTo(_itemW);
            }];
            view.goodsModel = goodsModel;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            view.tag = i;
            [view addGestureRecognizer:tap3];
        }
    }
    self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_matchModel.goodsList.count, self.bgImage.dc_height);

}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView * view = recognizer.view;
    if (_matchModel && _matchModel.goodsList && _matchModel.goodsList.count > 0) {
        if (_matchCellBlock) {
            _matchCellBlock(_matchModel.goodsList[view.tag]);
        }
    }
}


@end



#pragma mark - 商品
@interface GLPGoodsDetailsMatchGoodsView ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GLPGoodsDetailsMatchGoodsView

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
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:9];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _priceLabel.font = PFRFont(8);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"¥0.00";
    [self addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.height.equalTo(self.width).multipliedBy(0.8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.goodsImage.bottom).offset(2);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.titleLabel.bottom).offset(0);
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(GLPGoodsMatchGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _goodsModel.goodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsModel.sellPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
}

@end
