//
//  GLPShoppingCarGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRRequestGoodsCell.h"

@interface TRRequestGoodsCell ()<GLPEditCountViewDelegate>

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *spacLabel;
@property (nonatomic, strong) UILabel *ydPriceLabel;
@property (nonatomic, strong) UILabel *allPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property(nonatomic,strong)TRRequestGoodsModel *cellmodel;
@end

@implementation TRRequestGoodsCell

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
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"weixuanz"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImage.clipsToBounds = YES;
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    [self.contentView addSubview:_goodsImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 2;

    [self.contentView addSubview:_titleLabel];
    
    _spacLabel = [[UILabel alloc] init];
    _spacLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _spacLabel.font = [UIFont fontWithName:PFR size:14];

    [self.contentView addSubview:_spacLabel];
    
    _ydPriceLabel = [[UILabel alloc] init];
    _ydPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _ydPriceLabel.font = [UIFont fontWithName:PFR size:12];

    [self.contentView addSubview:_ydPriceLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4A13"];
    _priceLabel.font = [UIFont fontWithName:PFRSemibold size:18];
    [self.contentView addSubview:_priceLabel];
    
    _allPriceLabel = [[UILabel alloc] init];
    _allPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4A13"];
    _allPriceLabel.font = [UIFont fontWithName:PFR size:12];
    [self.contentView addSubview:_allPriceLabel];
    
    _countView = [[GLPEditCountView alloc] init];
    _countView.delegate = self;
    [self.contentView addSubview:_countView];
    
    [self layoutIfNeeded];
}

#pragma mark - <GLPEditCountViewDelegate>
- (void)dc_countChangeWithCount:(NSInteger)count countView:(GLPEditCountView *)countView {
    [[DCAPIManager shareManager]person_goodsNumwithcartId:self.cellmodel.cartId quantity:[NSString stringWithFormat:@"%ld",(long)count] success:^(id response) {
        self.cellmodel.quantity = [NSString stringWithFormat:@"%ld",(long)count];
        if (self.goodsnumblock) {
            self.goodsnumblock(self.cellmodel);
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)dc_personCountAddWithCountView:(GLPEditCountView *)countView{
    NSInteger count = [countView.countTF.text intValue];
    count ++;
    [[DCAPIManager shareManager]person_goodsNumwithcartId:self.cellmodel.cartId quantity:[NSString stringWithFormat:@"%ld",(long)count] success:^(id response) {
        self.cellmodel.quantity = [NSString stringWithFormat:@"%ld",(long)count];
        if (self.goodsnumblock) {
            self.goodsnumblock(self.cellmodel);
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)dc_personCountSubWithCountView:(GLPEditCountView *)countView{
    NSInteger count = [countView.countTF.text intValue];
       count --;
       [[DCAPIManager shareManager]person_goodsNumwithcartId:self.cellmodel.cartId quantity:[NSString stringWithFormat:@"%ld",(long)count] success:^(id response) {
           self.cellmodel.quantity = [NSString stringWithFormat:@"%ld",(long)count];
           if (self.goodsnumblock) {
               self.goodsnumblock(self.cellmodel);
           }
       } failture:^(NSError *error) {
           
       }];
}
#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    self.editBtn.selected = !self.editBtn.selected;
    if (self.editBtn.selected==YES)
    {
        self.cellmodel.select = @"1";
    }
    else{
        self.cellmodel.select = @"0";
    }
    if (self.choseblock) {
        self.choseblock(self.cellmodel);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(25);
        make.left.equalTo(self.contentView.left).offset(40);
        make.size.equalTo(CGSizeMake(84, 84));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsImage.centerY);
        make.left.equalTo(self.contentView.left).offset(10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImage.right).offset(7);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.goodsImage.top).offset(-8);
    }];
    
    [_spacLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
    }];
    
    [_ydPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.titleLabel.right);
        make.top.equalTo(self.spacLabel.bottom).offset(12);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.bottom).offset(12);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [_allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.bottom).offset(5);
        make.left.equalTo(self.titleLabel.left);
    }];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.size.equalTo(CGSizeMake(130, 40));
    }];
}

- (void)setModel:(TRRequestGoodsModel *)model
{
    self.cellmodel=model;
    NSString *select = [NSString stringWithFormat:@"%@",model.select];
    if ([select isEqualToString:@"1"])
    {
        _editBtn.selected = YES;
    }
    else{
        _editBtn.selected = NO;
    }
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.goodsTitle];
    _spacLabel.text = [NSString stringWithFormat:@"%@",model.packingSpec];
    _ydPriceLabel.text = [NSString stringWithFormat:@"药店价:¥%@",model.marketPrice];
    _ydPriceLabel = [UILabel setupAttributeLabel:_ydPriceLabel textColor:_ydPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.sellPrice];
    CGFloat allprice = [model.sellPrice floatValue]*[model.quantity intValue];
    _allPriceLabel.text = [NSString stringWithFormat:@"单品小计：¥%.2f",allprice];
    _allPriceLabel = [UILabel setupAttributeLabel:_allPriceLabel textColor:_allPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

    _countView.countTF.text = [NSString stringWithFormat:@"%@",model.quantity];
}
@end
