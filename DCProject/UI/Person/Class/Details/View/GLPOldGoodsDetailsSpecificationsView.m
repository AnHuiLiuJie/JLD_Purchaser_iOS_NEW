//
//  GLPOldGoodsDetailsSpecificationsView.m
//  DCProject
//
//  Created by Apple on 2021/3/19.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "GLPOldGoodsDetailsSpecificationsView.h"

@interface GLPOldGoodsDetailsSpecificationsView ()

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, strong) UIButton *defineBtn;
@end

static NSString *const defineBtnTitle = @"到货通知";
static CGFloat bottomBgView_X = 30;
static CGFloat bottomBgView_H = 50;

@implementation GLPOldGoodsDetailsSpecificationsView


- (instancetype)init{
    self = [super init];
    if (self) {
        //self.payCount = 1;
        //self.payCountLB.text = @"1";
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture1];

    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footView];
    [footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(21+kTabBarHeight);
    }];
    
    _defineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:_defineBtn];
    [_defineBtn addTarget:self action:@selector(defineBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    _defineBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_defineBtn setTitle:@"确定" forState:0];
    [_defineBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_defineBtn dc_cornerRadius:25];
    _defineBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    
    [_defineBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).offset(10);
        make.left.equalTo(footView).offset(bottomBgView_X);
        make.right.equalTo(footView).offset(-bottomBgView_X);
        make.height.equalTo(bottomBgView_H);
    }];
    
    UIView *cView = [[UIView alloc] init];
    cView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cView];
    [cView mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self);
        make.bottom.equalTo(footView.top);
    }];
    
    UIView *goodView = [[UIView alloc] init];
    [cView addSubview:goodView];
    [goodView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cView);
        make.left.equalTo(cView).offset(15);
        make.right.equalTo(cView).offset(-15);
        make.height.equalTo(100);
    }];
    self.goodIcon = [[UIImageView alloc] init];
    self.goodIcon.backgroundColor = [UIColor dc_colorWithHexString:@"#f0f0f0"];
    [goodView addSubview:self.goodIcon];
    [self.goodIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(goodView);
        make.width.equalTo(100);
    }];
    
    self.goodName = [[UILabel alloc] init];
    self.goodName.font = [UIFont systemFontOfSize:16];
    self.goodName.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    self.goodName.numberOfLines = 2;
    [goodView addSubview:self.goodName];
    [self.goodName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(goodView);
        make.left.equalTo(self.goodIcon.right).offset(10);
    }];
    
    self.goodNum = [[UILabel alloc] init];
    self.goodNum.text = @"库存1999";
    self.goodNum.font = [UIFont systemFontOfSize:12];
    self.goodNum.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    [goodView addSubview:self.goodNum];
    [self.goodNum mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodView).offset(-2);
        make.left.equalTo(self.goodIcon.right).offset(10);
        make.height.equalTo(17);
    }];
    self.goodTime = [[UILabel alloc] init];
    self.goodTime.text = @"(有效期至2020.10.27)";
    self.goodTime.font = [UIFont systemFontOfSize:12];
    self.goodTime.textColor = [UIColor dc_colorWithHexString:@"#FF5200"];
    [goodView addSubview:self.goodTime];
    [self.goodTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodView).offset(-2);
        make.left.equalTo(self.goodNum.right);
        make.height.equalTo(17);
    }];
    self.sendTimeLabel = [[UILabel alloc] init];
    self.sendTimeLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    self.sendTimeLabel.font = PFRFont(12);
    self.sendTimeLabel.text = @"24小时发货";
    [goodView addSubview:self.sendTimeLabel];
    [self.sendTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodView).offset(-2);
        make.right.equalTo(goodView.right).offset(-1);
        make.height.equalTo(17);
    }];
    
    self.goodPrice = [[UILabel alloc] init];
    self.goodPrice.text = @"¥378.00";
    self.goodPrice.font = [UIFont systemFontOfSize:20];
    self.goodPrice.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
    [goodView addSubview:self.goodPrice];
    [self.goodPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodNum.top).offset(-2);
        make.left.equalTo(self.goodIcon.right).offset(10);
        make.height.equalTo(28);
    }];
    self.goodPriceOld = [[UILabel alloc] init];
    self.goodPriceOld.text = @"¥378.00";
    self.goodPriceOld.font = [UIFont systemFontOfSize:14];
    self.goodPriceOld.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    [goodView addSubview:self.goodPriceOld];
    [self.goodPriceOld mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodNum.top).offset(-2);
        make.left.equalTo(self.goodPrice.right).offset(6);
        make.height.equalTo(28);
    }];
    
    UILabel *guigePrompt = [[UILabel alloc] init];
    guigePrompt.text = @"规格";
    guigePrompt.font = [UIFont systemFontOfSize:15];
    guigePrompt.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [cView addSubview:guigePrompt];
    [guigePrompt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodView.bottom).offset(10);
        make.left.equalTo(cView).offset(15);
        make.height.equalTo(30);
    }];
    
    NSInteger h = kScreenH- (21+kTabBarHeight)-kNavBarHeight-40-100-40-80-10;
    NSLog(@"===123:%ld",(long)h);
    self.scrollView = [[UIScrollView alloc] init];
    [cView addSubview:self.scrollView];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guigePrompt.bottom);
        make.left.equalTo(cView).offset(15);
        make.right.equalTo(cView).offset(-15);
        make.height.equalTo(h);
    }];
    
    //    kScreenH- (21+kTabBarHeight)-kNavBarHeight-40-100-40-80-10
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [cView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.bottom).offset(10);
        make.left.right.equalTo(cView);
        make.height.equalTo(1);
    }];
    
    UILabel *shuliang = [[UILabel alloc] init];
    shuliang.text = @"购买数量";
    shuliang.font = [UIFont systemFontOfSize:15];
    shuliang.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [cView addSubview:shuliang];
    [shuliang mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom);
        make.left.equalTo(cView).offset(15);
        make.height.equalTo(80);
        make.bottom.equalTo(cView);
    }];
    
    UIButton *jiaBtn = [[UIButton alloc] init];
    [jiaBtn addTarget:self action:@selector(jiaMethod) forControlEvents:UIControlEventTouchUpInside];
    [jiaBtn setTitle:@"＋" forState:0];
    [jiaBtn setTitleColor:[UIColor dc_colorWithHexString:@"#979797"] forState:0];
    jiaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    jiaBtn.layer.borderWidth = 1;
    jiaBtn.layer.borderColor = [UIColor dc_colorWithHexString:@"#E2E2E2"].CGColor;
    [cView addSubview:jiaBtn];
    [jiaBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cView).offset(-15);
        make.centerY.equalTo(shuliang);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    self.payCountLB = [[UILabel alloc] init];
    self.payCountLB.font = [UIFont systemFontOfSize:14];
    self.payCountLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    self.payCountLB.textAlignment = NSTextAlignmentCenter;
    [cView addSubview:self.payCountLB];
    [self.payCountLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jiaBtn.left);
        make.width.equalTo(70);
        make.height.equalTo(40);
        make.centerY.equalTo(jiaBtn);
    }];
    
    UIButton *jianBtn = [[UIButton alloc] init];
    [jianBtn addTarget:self action:@selector(jianMethod) forControlEvents:UIControlEventTouchUpInside];
    [jianBtn setTitle:@"－" forState:0];
    [jianBtn setTitleColor:[UIColor dc_colorWithHexString:@"#979797"] forState:0];
    jianBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    jianBtn.layer.borderWidth = 1;
    jianBtn.layer.borderColor = [UIColor dc_colorWithHexString:@"#E2E2E2"].CGColor;
    [cView addSubview:jianBtn];
    [jianBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payCountLB.left);
        make.centerY.equalTo(shuliang);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.userInteractionEnabled = YES;
    headView.tag = 1222;
    [self addSubview:headView];
    [headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cView.top);
        make.left.right.equalTo(self);
        make.height.equalTo(40);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    [headView addSubview:cancelBtn];
    [cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-10);
        make.top.equalTo(headView);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *headView = [self viewWithTag:1222];
    [headView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight];
//    [_bottomBgView dc_cornerRadius:_bottomBgView.dc_height rectCorner:UIRectCornerAllCorners];

}

- (void)jiaMethod{
    if ([_defineBtn.titleLabel.text isEqualToString:defineBtnTitle] && (_specModel.stock == 0)) {
        self.payCount = 0;
        self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        return;
    }
    self.payCount++;
    if (self.specModel) {
        self.payCount = self.payCount > self.specModel.stock ? self.specModel.stock : self.payCount;
    }
    self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
}

- (void)jianMethod{
    if ([_defineBtn.titleLabel.text isEqualToString:defineBtnTitle] && (_specModel.stock == 0)) {
        self.payCount = 0;
        self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        return;
    }
    self.payCount--;
    self.payCount = self.payCount < 1 ? 1 : self.payCount;
    self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
}

#pragma mark - set
- (void)setSpecModels:(NSArray *)specModels{
    _specModels = specModels;
}

- (void)setSpecModel:(GLPGoodsDetailsSpecModel *)specModel{
    _specModel = specModel;
    
    _specIdx = 0;
    [self.specModels enumerateObjectsUsingBlock:^(GLPGoodsDetailsSpecModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.goodsId isEqualToString:self.specModel.goodsId] && self.specModel.batchId.length == 0) {
            self.specIdx = idx;
            return;
        }
    }];
    [self reloadScrollView];
}

- (void)reloadScrollView{
    int w = 15;
    int h = 10;
    for (int i = 0; i< _specModels.count; i++) {
        GLPGoodsDetailsSpecModel *model = _specModels[i];
        NSString *str = model.attr;
        CGFloat strw = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        if (strw+40+w > kScreenW-30) {
            h+=43;
            w = 15;
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w, h, strw+40, 33)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(guigeMethod:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:str forState:0];
        [btn setTitleColor:[UIColor dc_colorWithHexString:@"#AFB1B1"] forState:0];
        [btn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = i == self.specIdx ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 16.5;
        [self.scrollView addSubview:btn];
        if (self.specIdx == i) {
            btn.selected = YES;
        }
        
        w+=strw+50;
    }
    h+=43;
    self.scrollView.contentSize = CGSizeMake(kScreenW, h);
    h = h > kScreenH- (21+kTabBarHeight)-kNavBarHeight-40-100-40-80-10 ? kScreenH- (21+kTabBarHeight)-kNavBarHeight-40-100-40-80-10 : h;
    NSLog(@"===1234:%ld",(long)h);
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(h);
    }];
    [self reloadSelect];
}

- (void)guigeMethod:(UIButton *)selectBtn{
    selectBtn.selected = !selectBtn.selected;
    for (UIView *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.borderColor = btn.tag == selectBtn.tag ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
            ((UIButton *)btn).selected = btn.tag == selectBtn.tag;
        }
    }
    self.specIdx = selectBtn.tag - 100;
    [self reloadSelect];
}

- (void)reloadSelect{
    _specModel = _specModels[self.specIdx];
    
    [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_specModel.img]]];
    self.goodName.text = [NSString stringWithFormat:@"%@",_specModel.goodsTitle];
    self.goodPrice.text = [NSString stringWithFormat:@"¥%0.2f",_specModel.sellPrice];
    _goodPrice = [UILabel setupAttributeLabel:_goodPrice textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];

    NSString *goodPriceOld = [NSString stringWithFormat:@"¥%0.2f",_specModel.marketPrice];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:goodPriceOld
                                                                                attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}];
    self.goodPriceOld.attributedText = attrStr;
    if (_specModel.effectMonths && _specModel.effectMonths.length > 0) {
        self.goodTime.text = [NSString stringWithFormat:@"（有效期%@）",_specModel.effectMonths];
    }else{
        self.goodTime.text = @"";
    }
    if (self.payCount > self.specModel.stock) {
        self.payCount = _specModel.stock;
        self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }
    self.goodNum.text = [NSString stringWithFormat:@"库存%ld",(long)_specModel.stock];
    if (_specModel.stock == 0) {
//        [_defineBtn setTitle:defineBtnTitle forState:0];
//        _defineBtn.hidden = NO;
        [self changeCoustomView];
        _bottomBgView.hidden = YES;
        self.payCount = 0;
        self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }else{
        _defineBtn.hidden = YES;
        self.bottomBgView.hidden = NO;
        [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.defineBtn);
        }];
        if (self.payCount == 0) {
            self.payCount = 1;
            self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        }

    }

}

- (void)defineBtnMethod:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:defineBtnTitle]) {
        self.goodsDetailsSpecificationsView_Block(self.specModel,0,0);
        !_GLPOldGoodsDetailsSpecificationsView_block ? : _GLPOldGoodsDetailsSpecificationsView_block();
        [self closePageMethod];
        return;
    }
    
    NSInteger showType = button == nil ? 0 : self.showType;
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specModels[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        [self closePageMethod];
        self.goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,showType);
    }
}

- (void)carBtnMethod:(UIButton *)button{
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specModels[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        [self closePageMethod];
        self.goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,1);
    }
}

- (void)buyBtnMethod:(UIButton *)button{
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specModels[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        [self closePageMethod];
        self.goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,2);
    }
}

- (void)cancelMethod{
    [self defineBtnMethod:nil];
    //[self closePageMethod];
}

- (void)closePageMethod{
    self.isShow = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //[self.layer setOpacity:0];
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showType:(NSInteger)showType buyCount:(NSInteger)buyCount{
    self.showType = showType;
    self.payCount = buyCount;
    self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)buyCount];
    if (self.showType == 0) {
        _defineBtn.hidden = YES;
        self.bottomBgView.hidden = NO;
        [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.defineBtn);
        }];
    }else{
        _defineBtn.hidden = NO;
        _bottomBgView.hidden = YES;
    }
    
    if (_specModel.stock == 0) {
//        [_defineBtn setTitle:defineBtnTitle forState:0];
//        _defineBtn.hidden = NO;
        [self changeCoustomView];
        _bottomBgView.hidden = YES;
        self.payCount = 0;
        self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }else{
        _defineBtn.hidden = YES;
        self.bottomBgView.hidden = NO;
        [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.defineBtn);
        }];
        if (self.payCount == 0) {
            self.payCount = 1;
            self.payCountLB.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        }

    }
    
    self.isShow = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //[self.layer setOpacity:1.0];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    [self defineBtnMethod:nil];
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}


- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBgView addSubview:carBtn];
        [carBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [carBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        carBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];//
        carBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        carBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        [carBtn addTarget:self action:@selector(carBtnMethod:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBgView addSubview:buyBtn];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FD4F00"];
        buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        buyBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        [buyBtn addTarget:self action:@selector(buyBtnMethod:) forControlEvents:UIControlEventTouchUpInside];

        [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView);
            make.top.equalTo(self.bottomBgView);
            make.bottom.equalTo(self.bottomBgView);

        }];
        
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomBgView);
            make.top.equalTo(self.bottomBgView);
            make.bottom.equalTo(self.bottomBgView);
            make.left.equalTo(carBtn.right).offset(10);
            make.width.equalTo(carBtn);
        }];
        
        NSArray *clolor1 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [gradientLayer setColors:clolor1];//渐变数组
        gradientLayer.startPoint = CGPointMake(0,0);
        gradientLayer.endPoint = CGPointMake(1,0);
        gradientLayer.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer.frame = CGRectMake(0,0,(kScreenW-bottomBgView_X*2-10)/2,bottomBgView_H);
        [carBtn.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [carBtn dc_cornerRadius:bottomBgView_H/2];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
            (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,
            (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = CGRectMake(0,0,(kScreenW-bottomBgView_X*2-10)/2,bottomBgView_H);
        [buyBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [buyBtn dc_cornerRadius:bottomBgView_H/2];


        [self addSubview:_bottomBgView];
    }
    return _bottomBgView;;
}

- (void)changeCoustomView{
    _defineBtn.hidden = NO;
    [_defineBtn setTitle:defineBtnTitle forState:0];

    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    [gradientLayer setColors:clolor1];//渐变数组
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint = CGPointMake(1,0);
    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
    gradientLayer.frame = CGRectMake(0,0,kScreenW-bottomBgView_X*2,bottomBgView_H);
    [_defineBtn.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
//    [_defineBtn.layer addSublayer:gradientLayer];//使用这个方法则要考虑在addSubview前不进行属性操作
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
