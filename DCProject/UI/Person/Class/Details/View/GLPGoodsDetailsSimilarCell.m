//
//  GLPGoodsDetailsSimilarCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsSimilarCell.h"

@interface GLPGoodsDetailsSimilarCell ()
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollBgView;

@end

@implementation GLPGoodsDetailsSimilarCell

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
    
    _itemW = 74;
    _itemH = _itemW + 20 + 20 + 5;
    _spacing = (kScreenW - _itemW*4 - 16*2)/3;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"浏览此商品的用户还购买了";
    [self.contentView addSubview:_titleLabel];
    
    _scrollBgView = [[UIScrollView alloc] init];
    [self.contentView addSubview:_scrollBgView];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom).offset(0);
        make.height.equalTo(_itemH);
    }];

}


#pragma mark - setter
- (void)setSimilarArray:(NSMutableArray<GLPGoodsSimilarModel *> *)similarArray
{
    _similarArray = similarArray;
    
    if (_similarArray.count > 0) {
        for (int i=0; i<_similarArray.count; i++) {
            GLPGoodsSimilarModel *similarModel = _similarArray[i];
            GLPGoodsDetailsSimilarGoodsView *view = [[GLPGoodsDetailsSimilarGoodsView alloc] init];
            [self.scrollBgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
                make.centerY.equalTo(self.scrollBgView.centerY);
                make.height.equalTo(_itemH);
                make.width.equalTo(_itemW);
            }];
            view.similarModel = similarModel;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            view.tag = i;
            [view addGestureRecognizer:tap3];
        }
    }
    self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_similarArray.count, _itemH);
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView * view = recognizer.view;
    if (_similarArray.count > 0) {
        if (_similarCellBlock) {
            _similarCellBlock(_similarArray[view.tag]);
        }
    }
}


@end



#pragma mark - 商品
@interface GLPGoodsDetailsSimilarGoodsView ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GLPGoodsDetailsSimilarGoodsView

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
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF2800"];
    _priceLabel.font = PFRFont(14);
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
        make.height.equalTo(self.width).multipliedBy(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.goodsImage.bottom).offset(3);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.titleLabel.bottom).offset(3);
    }];
}


#pragma mark - setter
- (void)setSimilarModel:(GLPGoodsSimilarModel *)similarModel
{
    _similarModel = similarModel;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_similarModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _similarModel.goodsTitle;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_similarModel.sellPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor  minFont:[UIFont fontWithName:PFR size:10] maxFont:[UIFont fontWithName:PFRMedium size:15] forReplace:@"¥"];
}


@end
