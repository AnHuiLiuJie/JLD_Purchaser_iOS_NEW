//
//  GLBGoodsTagView.m
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsTagView.h"

@interface GLBGoodsTagView ()

@property (nonatomic, strong) UILabel *kzLabel;// 控销或招标
@property (nonatomic, strong) UILabel *cxLabel; // 促销
@property (nonatomic, strong) UILabel *basicLabel; // 基药
@property (nonatomic, strong) UILabel *ticketLabel; // 券

@end

@implementation GLBGoodsTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.kzLabel = [[UILabel alloc] init];
    self.kzLabel.textColor = [UIColor dc_colorWithHexString:@"#2CC0FF"];
    self.kzLabel.font = PFRFont(10);
    self.kzLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#D6F3FF"];
    self.kzLabel.textAlignment = NSTextAlignmentCenter;
    self.kzLabel.text = @"控";
    [self.kzLabel dc_cornerRadius:2];
    self.kzLabel.hidden = YES;
    [self addSubview:self.kzLabel];
    
    self.cxLabel = [[UILabel alloc] init];
    self.cxLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    self.cxLabel.font = PFRFont(10);
    self.cxLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FFECD0"];
    self.cxLabel.textAlignment = NSTextAlignmentCenter;
    self.cxLabel.text = @"促";
    [self.cxLabel dc_cornerRadius:2];
    self.cxLabel.hidden = YES;
    [self addSubview:self.cxLabel];
    
    self.basicLabel = [[UILabel alloc] init];
    self.basicLabel.textColor = [UIColor dc_colorWithHexString:@"#2CC0FF"];
    self.basicLabel.font = PFRFont(10);
    self.basicLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#D6F3FF"];
    self.basicLabel.textAlignment = NSTextAlignmentCenter;
    self.basicLabel.text = @"基";
    [self.basicLabel dc_cornerRadius:2];
    self.basicLabel.hidden = YES;
    [self addSubview:self.basicLabel];
    
    self.ticketLabel = [[UILabel alloc] init];
    self.ticketLabel.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    self.ticketLabel.font = PFRFont(10);
    self.ticketLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FFECD0"];
    self.ticketLabel.textAlignment = NSTextAlignmentCenter;
    self.ticketLabel.text = @"";
    [self.ticketLabel dc_cornerRadius:2];
    self.ticketLabel.hidden = YES;
    [self addSubview:self.ticketLabel];
}



#pragma mark - setter
- (void)setGoodsModel:(GLBGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    self.kzLabel.hidden = YES;
    if ([_goodsModel.saleCtrl isEqualToString:@"1"]) { // 控销
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"控";
    } else if ([_goodsModel.saleCtrl isEqualToString:@"2"]) { // 招标
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"标";
    }
    
    self.cxLabel.hidden = YES;
    if ([_goodsModel.isPromotion isEqualToString:@"1"]) { // 促销
        self.cxLabel.hidden = NO;
    }
    
    self.basicLabel.hidden = YES;

    
    self.ticketLabel.hidden = YES;
    if ([_goodsModel.isCoupon isEqualToString:@"1"] && _goodsModel.actTitle.length > 0) { // 券
        self.ticketLabel.hidden = NO;
        self.ticketLabel.text = _goodsModel.actTitle;
    }
    
    [self updataMasonry];
}


- (void)setStoreGoodsModel:(GLBStoreGoodsModel *)storeGoodsModel
{
    _storeGoodsModel = storeGoodsModel;
    
    self.kzLabel.hidden = YES;
    if ([_storeGoodsModel.isCtrlSale isEqualToString:@"1"]) { // 控销
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"控";
    } else if ([_storeGoodsModel.isCtrlSale isEqualToString:@"2"]) { // 招标
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"标";
    }
    
    self.cxLabel.hidden = YES;
    if ([_storeGoodsModel.isPromotion isEqualToString:@"1"]) { // 促销
        self.cxLabel.hidden = NO;
    }
    
    self.basicLabel.hidden = YES;
    if ([_storeGoodsModel.isBasicMedc isEqualToString:@"1"]) { // 是基药
        self.cxLabel.hidden = NO;
    }
    
    self.ticketLabel.hidden = YES;;
    NSString *actTitle = [NSString stringWithFormat:@"%@",_storeGoodsModel.actTitle];
    if ([_storeGoodsModel.isCoupon isEqualToString:@"1"] && actTitle.length > 0) {
        self.ticketLabel.hidden = NO;
        self.ticketLabel.text = actTitle;
    }
    
    [self updataMasonry];
}


#pragma mark - 商品列表
- (void)setGoodsListModel:(GLBGoodsListModel *)goodsListModel
{
    _goodsListModel = goodsListModel;
    
    self.kzLabel.hidden = YES;
    if ([_goodsListModel.isCtrlSale isEqualToString:@"1"]) { // 控销
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"控";
    } else if ([_goodsListModel.isCtrlSale isEqualToString:@"2"]) { // 招标
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"标";
    }
    
    self.cxLabel.hidden = YES;
    if ([_goodsListModel.isPromotion isEqualToString:@"1"]) { // 促销
        self.cxLabel.hidden = NO;
    }
    
    self.basicLabel.hidden = YES;
    if ([_goodsListModel.isBasicMedc isEqualToString:@"1"]) { // 是基药
        self.cxLabel.hidden = NO;
    }
    
    self.ticketLabel.hidden = YES;
    if ([_goodsListModel.isCoupon isEqualToString:@"1"] && _goodsListModel.actTitle.length > 0) { // 优惠券
        self.ticketLabel.hidden = NO;
        self.ticketLabel.text = _goodsListModel.actTitle;
    }
    
    [self updataMasonry];
}


#pragma mark -
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.kzLabel.hidden = YES;
    if ([_detailModel.saleCtrl isEqualToString:@"1"]) { // 控销
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"控";
    } else if ([_detailModel.saleCtrl isEqualToString:@"2"]) { // 招标
        self.kzLabel.hidden = NO;
        self.kzLabel.text = @"标";
    }
    
    
    self.cxLabel.hidden = YES;
    if ([_detailModel.isPromotion isEqualToString:@"1"]) { // 促销
        self.cxLabel.hidden = NO;
    }
    
    
    self.basicLabel.hidden = YES;
    if ([_detailModel.isBasicMedc isEqualToString:@"1"]) { // 基药
        self.basicLabel.hidden = NO;
    }
    
    
    self.ticketLabel.hidden = YES;
    
    [self updataMasonry];
}



#pragma mark - updataMasonry
- (void)updataMasonry
{
    CGFloat x = 0;
    
    [self.kzLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 14));
    }];
    
    if (!self.kzLabel.hidden) {
        x = x + 22 + 5;
    }
    
    [self.cxLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 14));
    }];
    
    
    if (!self.cxLabel.hidden) {
        x = x + 22 + 5;
    }
    
    [self.basicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(22, 14));
    }];
    
    
    if (!self.basicLabel.hidden) {
        x = x + 22 + 5;
    }
    CGSize size = [self.ticketLabel sizeThatFits:CGSizeMake(kScreenW, 14)];
    
    [self.ticketLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(x);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(size.width + 20, 14));
    }];
}

@end
