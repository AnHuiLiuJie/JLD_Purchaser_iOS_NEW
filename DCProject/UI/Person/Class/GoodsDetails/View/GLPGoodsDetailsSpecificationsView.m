//
//  GLPGoodsDetailsSpecificationsView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/23.
//

#import "GLPGoodsDetailsSpecificationsView.h"
#import "GLBCountTFView.h"

@interface GLPGoodsDetailsSpecificationsView ()<GLPEditCountViewDelegate>
{
    CGFloat public_H;
}
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, strong) UIButton *defineBtn;
@property (nonatomic, strong) UILabel *liaoPrompt;//疗程装
@property (nonatomic, strong) UILabel *actLab;//活动提示
@property (nonatomic, strong) GLBCountTFView *countTFView;

@end

static NSString *const defineBtnTitle = @"到货通知";
static NSString *const defineBtn2Title = @"库存不足";
static NSString *const addBtnBtnTitle = @"原价购买";
static NSString *const buyBtnBtnTitle = @"立即开团";
static CGFloat bottomBgView_X = 30;
static CGFloat bottomBgView_H = 45;

@implementation GLPGoodsDetailsSpecificationsView


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
    self.goodOldPrice = [[UILabel alloc] init];
    self.goodOldPrice.text = @"¥378.00";
    self.goodOldPrice.font = [UIFont systemFontOfSize:14];
    self.goodOldPrice.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    [goodView addSubview:self.goodOldPrice];
    [self.goodOldPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodNum.top).offset(-2);
        make.left.equalTo(self.goodPrice.right).offset(6);
        make.height.equalTo(28);
    }];
    
    self.actLab = [[UILabel alloc] init];
    self.actLab.text = @"";
    self.actLab.font = [UIFont systemFontOfSize:12];
    self.actLab.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
    [goodView addSubview:self.actLab];
    [self.actLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodOldPrice.right).offset(6);
        make.centerY.equalTo(self.goodOldPrice.centerY);
    }];
    self.actLab.hidden = YES;
    
    
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
    //[cView dc_layerBorderWith:1 color:[UIColor redColor] radius:1];
    public_H = (21+kTabBarHeight)-kNavBarHeight-40-100-40-80-10;
    NSInteger h = kScreenH-public_H;
    NSLog(@"===123:%ld",(long)h);
    self.ggScrollView = [[UIScrollView alloc] init];
    [cView addSubview:self.ggScrollView];
    [self.ggScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guigePrompt.bottom);
        make.left.equalTo(cView).offset(15);
        make.right.equalTo(cView).offset(-15);
        make.height.equalTo(h);
    }];
    //    [self.ggScrollView  dc_layerBorderWith:1 color:[UIColor greenColor] radius:1];
    
    _liaoPrompt = [[UILabel alloc] init];
    _liaoPrompt.text = @"疗程装";
    _liaoPrompt.font = [UIFont systemFontOfSize:15];
    _liaoPrompt.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [cView addSubview:_liaoPrompt];
    [_liaoPrompt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ggScrollView.bottom).offset(5);
        make.left.equalTo(cView).offset(15);
        make.height.equalTo(30);
    }];
    _liaoPrompt.hidden = YES;
    
    NSInteger h2 = kScreenH-public_H-(30+5+15+h);
    NSLog(@"===345:%ld",(long)h);
    self.lcScrollView = [[UIScrollView alloc] init];
    [cView addSubview:self.lcScrollView];
    [_lcScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.liaoPrompt.bottom);
        make.left.equalTo(cView).offset(15);
        make.right.equalTo(cView).offset(-15);
        make.height.equalTo(h2);
    }];
    _lcScrollView.hidden = YES;
    //    [_lcScrollView  dc_layerBorderWith:1 color:[UIColor redColor] radius:1];
    
    //    kScreenH-public_H
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [cView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lcScrollView.bottom).offset(10);
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
    
    //    UIButton *jiaBtn = [[UIButton alloc] init];
    //    [jiaBtn addTarget:self action:@selector(jiaMethod) forControlEvents:UIControlEventTouchUpInside];
    //    [jiaBtn setTitle:@"＋" forState:0];
    //    [jiaBtn setTitleColor:[UIColor dc_colorWithHexString:@"#979797"] forState:0];
    //    jiaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    jiaBtn.layer.borderWidth = 1;
    //    jiaBtn.layer.borderColor = [UIColor dc_colorWithHexString:@"#E2E2E2"].CGColor;
    //    [cView addSubview:jiaBtn];
    //    [jiaBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(cView).offset(-15);
    //        make.centerY.equalTo(shuliang);
    //        make.size.equalTo(CGSizeMake(30, 30));
    //    }];
    
    self.countView = [[GLPEditCountView alloc] init];
    self.countView.delegate = self;
    [cView addSubview:self.countView];
    [self.countView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cView).offset(-15);
        make.centerY.equalTo(shuliang);
        make.size.equalTo(CGSizeMake(100, 33));
    }];
    
    //    self.payCountLB = [[UILabel alloc] init];
    //    self.payCountLB.font = [UIFont systemFontOfSize:14];
    //    self.payCountLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    //    self.payCountLB.textAlignment = NSTextAlignmentCenter;
    //    [cView addSubview:self.payCountLB];
    //    [self.payCountLB mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(jiaBtn.left);
    //        make.width.equalTo(70);
    //        make.height.equalTo(40);
    //        make.centerY.equalTo(jiaBtn);
    //    }];
    
    //    UIButton *jianBtn = [[UIButton alloc] init];
    //    [jianBtn addTarget:self action:@selector(jianMethod) forControlEvents:UIControlEventTouchUpInside];
    //    [jianBtn setTitle:@"－" forState:0];
    //    [jianBtn setTitleColor:[UIColor dc_colorWithHexString:@"#979797"] forState:0];
    //    jianBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    //    jianBtn.layer.borderWidth = 1;
    //    jianBtn.layer.borderColor = [UIColor dc_colorWithHexString:@"#E2E2E2"].CGColor;
    //    [cView addSubview:jianBtn];
    //    [jianBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.payCountLB.left);
    //        make.centerY.equalTo(shuliang);
    //        make.size.equalTo(CGSizeMake(30, 30));
    //    }];
    
    
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


#pragma mark - set
- (void)setSpecList:(NSArray *)specList{
    _specList = specList;
}

- (void)setSpecModel:(GLPGoodsDetailsSpecModel *)specModel{
    _specModel = specModel;
    
    _specIdx = 0;
    _liaoIdx = -1;
    //    WEAKSELF;
    [self.specList enumerateObjectsUsingBlock:^(GLPGoodsDetailsSpecModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
        if(self.specModel.batchId.length != 0){
            if ([obj.goodsId isEqualToString:self.specModel.goodsId] && [obj.batchId isEqualToString:self.specModel.batchId]) {
                self.specIdx = idx;
                return;
            }
        }else{
            if ([obj.goodsId isEqualToString:self.specModel.goodsId] && self.specModel.batchId.length == 0) {
                self.specIdx = idx;
                return;
            }
            
        }
        
        if ([obj.goodsId isEqualToString:self.specModel.goodsId] && self.specModel.batchId.length == 0) {
            self.specIdx = idx;
            //            [obj.marketingMixList enumerateObjectsUsingBlock:^(GLPMarketingMixListModel *_Nonnull obj2, NSUInteger idx2, BOOL *_Nonnull stop2) {
            //                if ([obj2.batchId isEqualToString:self.specModel.batchId]) {
            //                    self.liaoIdx = idx2;
            //                    return;
            //                }
            //            }];
            return;
        }
    }];
    [self reloadGuigeScrollView];
}

//更新规格
- (void)reloadGuigeScrollView{
    int w = 15;
    int h = 10;
    for (int i = 0; i< _specList.count; i++) {
        GLPGoodsDetailsSpecModel *model = _specList[i];
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
        [self.ggScrollView addSubview:btn];
        if (self.specIdx == i) {
            btn.selected = YES;
        }
        
        w+=strw+50;
    }
    h+=43;
    self.ggScrollView.contentSize = CGSizeMake(kScreenW, h);
    h = h > kScreenH-public_H ? kScreenH-public_H : h;
    NSLog(@"===1234:%ld",(long)h);
    [self.ggScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(h);
    }];
    
    GLPGoodsDetailsSpecModel *specModel = self.specList[self.specIdx];
    [self reloadLiaochengScrollView:specModel];
}

//点击规格Btn
- (void)guigeMethod:(UIButton *)selectBtn{
    selectBtn.selected = !selectBtn.selected;
    for (UIView *btn in self.ggScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.borderColor = btn.tag == selectBtn.tag ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
            ((UIButton *)btn).selected = btn.tag == selectBtn.tag;
        }
    }
    self.specIdx = selectBtn.tag - 100;
    
    GLPGoodsDetailsSpecModel *specModel = self.specList[self.specIdx];
    [self reloadLiaochengScrollView:specModel];
}

//更新疗程装
- (void)reloadLiaochengScrollView:(GLPGoodsDetailsSpecModel *)selectModel{
    
    if (selectModel.marketingMixList.count == 0) {
        //疗程装
        _liaoPrompt.hidden = YES;
        [self.liaoPrompt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        _lcScrollView.hidden = YES;
        [self.lcScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        [self reloadSelect];
        return;
    }
    for(UIView *view in [self.lcScrollView subviews]){
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [selectModel.marketingMixList enumerateObjectsUsingBlock:^(GLPMarketingMixListModel *_Nonnull marketModel, NSUInteger idx2, BOOL *_Nonnull stop2) {
        marketModel.isSelected = NO;
    }];
    _liaoIdx = -1;//重置
    
    _liaoPrompt.hidden = NO;
    _lcScrollView.hidden = NO;
    
    int w = 15;
    int h = 10;
    for (int i = 0; i< selectModel.marketingMixList.count; i++) {
        GLPMarketingMixListModel *model = selectModel.marketingMixList[i];
        NSString *str = model.mixTip;
        CGFloat strw = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        if (strw+40+w > kScreenW-30) {
            h+=43;
            w = 15;
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w, h, strw+40, 33)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(liaoChengMethod:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:str forState:0];
        [btn setTitleColor:[UIColor dc_colorWithHexString:@"#AFB1B1"] forState:0];
        [btn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = i == self.liaoIdx ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 16.5;
        [self.lcScrollView addSubview:btn];
        if (self.liaoIdx == i) {
            model.isSelected = YES;
            btn.selected = YES;
        }
        
        w+=strw+50;
    }
    h+=43;
    self.lcScrollView.contentSize = CGSizeMake(kScreenW, h);
    h = h > kScreenH-public_H-(30+5+15+self.ggScrollView.dc_height) ? kScreenH-public_H : h;
    NSLog(@"===1234:%ld",(long)h);
    [self.lcScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(h);
    }];
    [self reloadSelect];
}

//点击疗程
- (void)liaoChengMethod:(UIButton *)selectBtn{
    //    selectBtn.selected = !selectBtn.selected;
    for (UIView *btn in self.lcScrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.borderColor = [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
            //btn.layer.borderColor = btn.tag == selectBtn.tag ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
            //            ((UIButton *)btn).selected = btn.tag == selectBtn.tag;
            ((UIButton *)btn).selected = NO;
        }
    }
    if (self.liaoIdx == selectBtn.tag - 1000) {
        self.liaoIdx = -1;//重置
    }else{
        selectBtn.layer.borderColor = [UIColor dc_colorWithHexString:DC_BtnColor].CGColor;
        selectBtn.selected = YES;
        self.liaoIdx = selectBtn.tag - 1000;
    }
    
    [self reloadSelect];
}

//选择规格后 更新产品信息
- (void)reloadSelect{
    _specModel = _specList[self.specIdx];
    _specModel.liaoIdx = self.liaoIdx+1;//
    [_specModel.marketingMixList enumerateObjectsUsingBlock:^(GLPMarketingMixListModel *_Nonnull marketModel, NSUInteger idx2, BOOL *_Nonnull stop2) {
        marketModel.isSelected = NO;
    }];
    
    CGFloat sellPrice = _specModel.sellPrice;
    CGFloat goodOldPrice = _specModel.marketPrice;
    self.actLab.hidden = YES;
    if (_specModel.seckillAct.actId.length != 0) {
        self.actLab.hidden = NO;
        self.actLab.text = @"秒杀价";
        sellPrice = _specModel.seckillAct.actSellPrice;
        //goodOldPrice = _specModel.sellPrice;
    }
    if (_specModel.collageAct.actId.length != 0) {
        self.actLab.hidden = NO;
        self.actLab.text = @"拼团价";
        sellPrice = _specModel.collageAct.actSellPrice;
        //goodOldPrice = _specModel.sellPrice;
    }
    if (_specModel.group.actId.length != 0) {
        self.actLab.hidden = NO;
        self.actLab.text = @"团购价";
        sellPrice = _specModel.group.actSellPrice;
        //goodOldPrice = _specModel.sellPrice;
    }
    
    GLPMarketingMixListModel *marketModel = nil;
    NSInteger stock = _specModel.stock;
    if (self.liaoIdx != -1) {
        marketModel = _specModel.marketingMixList[self.liaoIdx];
        NSLog(@"A已有疗程装被选中: %@",marketModel.mixTip);
        marketModel.isSelected = YES;
        float beishu = self.specModel.stock / [marketModel.mixNum integerValue];
        NSInteger kucun = floor(beishu);
        stock = kucun;
        
        CGFloat sellOldPrice = _specModel.sellPrice *  [marketModel.mixNum floatValue];
        sellPrice = [marketModel.price floatValue] * [marketModel.mixNum floatValue];//totalPrice
        
        goodOldPrice = sellOldPrice-sellPrice;
        
        self.actLab.hidden = YES;
        //goodOldPrice = _specModel.sellPrice;
        
        if (goodOldPrice > 0) {
            self.goodPrice.text = [NSString stringWithFormat:@"¥%0.2f",sellPrice];
            self.goodOldPrice.attributedText = [NSString dc_strikethroughWithString:@""];
            self.goodOldPrice.text = [NSString stringWithFormat:@"省¥%0.2f",goodOldPrice];
            self.goodOldPrice.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
        }
        
    }else{
        self.goodPrice.text = [NSString stringWithFormat:@"¥%0.2f",sellPrice];
        self.goodOldPrice.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"¥%0.2f",goodOldPrice]];;
        self.goodOldPrice.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    }
    
    
    _goodPrice = [UILabel setupAttributeLabel:_goodPrice textColor:nil minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:19] forReplace:@"¥"];
    
    
    
    [self.goodIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_specModel.img]]];
    self.goodName.text = [NSString stringWithFormat:@"%@",_specModel.goodsTitle];
    if (_specModel.effectMonths && _specModel.effectMonths.length > 0) {
        self.goodTime.text = [NSString stringWithFormat:@"（有效期%@）",_specModel.effectMonths];
    }else{
        self.goodTime.text = @"";
    }
    
    if (self.payCount > stock) {
        self.payCount = stock;
        _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }
    self.goodNum.text = [NSString stringWithFormat:@"库存%ld",(long)_specModel.stock];
    
    if (stock == 0) {
        [self changeCoustomView:defineBtnTitle];
        _bottomBgView.hidden = YES;
        self.payCount = 0;
        _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }else{
        [self changeBottomBtn];
        
        if (self.payCount == 0) {
            self.payCount = 1;
            _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        }
    }
    
}

//确认
- (void)defineBtnMethod:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:defineBtnTitle]) {
        !_goodsDetailsSpecificationsView_Block ? : _goodsDetailsSpecificationsView_Block(self.specModel,0,0);
        !_GLPGoodsDetailsSpecificationsView_block ? : _GLPGoodsDetailsSpecificationsView_block();
        [self closePageMethod];
        return;
    }
    
    NSInteger showType = button == nil ? 0 : self.showType;
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specList[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        [self closePageMethod];
        
        !_goodsDetailsSpecificationsView_Block ? : _goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,showType);
    }
}

- (void)carBtnMethod:(UIButton *)button{
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specList[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        [self closePageMethod];
        !_goodsDetailsSpecificationsView_Block ? : _goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,button.tag);
    }
}

- (void)buyBtnMethod:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:buyBtnBtnTitle] && self.payCount > 1) {
        WEAKSELF;
        //view添加在window上面 在view上弹出UIAlertController
        if (@available(iOS 13.0, *)) {
            [[DCAlterTool shareTool] showCustomWithTitle:@"拼团商品购买数量限制1件" message:@"" customTitle1:@"继续开团" handler1:^(UIAlertAction * _Nonnull action) {
                [weakSelf closePageMethod];
                !weakSelf.goodsDetailsSpecificationsView_Block ? : weakSelf.goodsDetailsSpecificationsView_Block(weakSelf.specModel,1,button.tag);
            } customTitle2:@"取消" handler2:^(UIAlertAction * _Nonnull action) {
                
            }];
        }else{
            
            [[DCAlterTool shareTool] showCustomWithTitle:@"拼团商品购买数量限制1件" message:@"" customTitle1:@"继续开团" handler1:^(UIAlertAction * _Nonnull action) {
                !weakSelf.goodsDetailsSpecificationsView_Block ? : weakSelf.goodsDetailsSpecificationsView_Block(weakSelf.specModel,1,button.tag);
            } customTitle2:@"取消" handler2:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [self closePageMethod];
            
        }
        
        return;
    }
    if (self.specIdx > -1 && self.goodsDetailsSpecificationsView_Block) {
        GLPGoodsDetailsSpecModel *detailModel = _specList[self.specIdx];
        if (self.payCount > detailModel.stock) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
        
        [self closePageMethod];
        !_goodsDetailsSpecificationsView_Block ? : _goodsDetailsSpecificationsView_Block(self.specModel,self.payCount,button.tag);
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

- (void)changeBottomBtn{
    
    if (self.liaoIdx < 0 && _specModel.collageAct.actId.length != 0) {
        [_addBtn setTitle:addBtnBtnTitle forState:UIControlStateNormal];//803
        _addBtn.tag = 8033;
        [_buyBtn setTitle:buyBtnBtnTitle forState:UIControlStateNormal];//804
        _buyBtn.tag = 8044;
        
        self.defineBtn.hidden = YES;
        self.bottomBgView.hidden = NO;
        [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.defineBtn);
        }];
        return;
    }else{
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];//803
        _addBtn.tag = 803;
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];//804
        _buyBtn.tag = 804;
    }
    
    if (self.showType == 0) {
        self.defineBtn.hidden = YES;
        self.bottomBgView.hidden = NO;
        [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.defineBtn);
        }];
        
    }else{
        
        [self changeCoustomView:@"确定"];
        self.bottomBgView.hidden = YES;
    }
}

- (void)showType:(NSInteger)showType buyCount:(NSInteger)buyCount{
    self.showType = showType;
    self.payCount = buyCount;
    _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)buyCount];
    
    
    NSInteger stock = self.specModel.stock;
    if (self.liaoIdx != -1) {
        GLPMarketingMixListModel *marketModel = self.specModel.marketingMixList[self.liaoIdx];
        float beishu = self.specModel.stock / [marketModel.mixNum integerValue];
        int kucun = floor(beishu);
        stock = kucun;
    }
    
    if (stock == 0) {
        [self changeCoustomView:defineBtnTitle];
        _bottomBgView.hidden = YES;
        self.payCount = 0;
        _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    }else{
        [self changeBottomBtn];
        
        if (self.payCount == 0) {
            self.payCount = 1;
            _countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
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

- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBgView addSubview:_addBtn];
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];//803
        _addBtn.tag = 803;
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];//
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _addBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        [_addBtn addTarget:self action:@selector(carBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBgView addSubview:_buyBtn];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];//804
        _buyBtn.tag = 804;
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FD4F00"];
        _buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _buyBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        [_buyBtn addTarget:self action:@selector(buyBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBgView);
            make.top.equalTo(self.bottomBgView);
            make.bottom.equalTo(self.bottomBgView);
        }];
        
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomBgView);
            make.top.equalTo(self.bottomBgView);
            make.bottom.equalTo(self.bottomBgView);
            make.left.equalTo(self.addBtn.right).offset(10);
            make.width.equalTo(self.addBtn.width);
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
        [self.addBtn.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [self.addBtn dc_cornerRadius:bottomBgView_H/2];
        
        NSArray *clolor2 = [NSArray arrayWithObjects:
                            (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,
                            (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0,0);
        gradientLayer2.endPoint = CGPointMake(1,0);
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
        gradientLayer2.frame = CGRectMake(0,0,(kScreenW-bottomBgView_X*2-10)/2,bottomBgView_H);
        [_buyBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
        [_buyBtn dc_cornerRadius:bottomBgView_H/2];
        
        
        [self addSubview:_bottomBgView];
    }
    return _bottomBgView;;
}

- (void)changeCoustomView:(NSString *)title{
    _defineBtn.hidden = NO;
    [_defineBtn setTitle:title forState:0];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
                        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
                        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:clolor1];//渐变数组
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint = CGPointMake(1,0);
    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
    gradientLayer.frame = CGRectMake(0,0,(kScreenW-bottomBgView_X*2-10),bottomBgView_H);
    [_defineBtn.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
    [_defineBtn dc_cornerRadius:bottomBgView_H/2];
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

#pragma mark - <GLPEditCountViewDelegate>
// 加
- (void)dc_personCountAddWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text intValue];
    count ++;
    self.payCount = count;
    NSInteger stock = self.specModel.stock;
    if (self.liaoIdx != -1) {
        GLPMarketingMixListModel *marketModel = self.specModel.marketingMixList[self.liaoIdx];
        float beishu = self.specModel.stock / [marketModel.mixNum integerValue];
        int kucun = floor(beishu);
        stock = kucun;
    }
    if ([_defineBtn.titleLabel.text isEqualToString:defineBtnTitle] && (stock == 0)) {
        self.payCount = 0;
        self.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        return;
    }
    if (self.specModel) {
        self.payCount = self.payCount > stock ? stock : self.payCount;
    }
    self.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
}

// 减
- (void)dc_personCountSubWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text intValue];
    count --;
    self.payCount = count;
    NSInteger stock = self.specModel.stock;
    if (self.liaoIdx != -1) {
        GLPMarketingMixListModel *marketModel = self.specModel.marketingMixList[self.liaoIdx];
        float beishu = self.specModel.stock / [marketModel.mixNum integerValue];
        int kucun = floor(beishu);
        stock = kucun;
    }
    if ([_defineBtn.titleLabel.text isEqualToString:defineBtnTitle] && (stock == 0)) {
        self.payCount = 0;
        self.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
        return;
    }
    self.payCount = self.payCount < 1 ? 1 : self.payCount;
    self.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.payCount];
    
}

// 改变
- (void)dc_personCountChangeWithCountView:(GLPEditCountView *)countView
{
    if (![DC_KeyWindow.subviews containsObject:self.countTFView]) {
        [DC_KeyWindow addSubview:self.countTFView];
        self.countTFView.textField.text = countView.countTF.text;
        WEAKSELF;
        self.countTFView.successBlock = ^{
            
            NSInteger stock = weakSelf.specModel.stock;
            if (weakSelf.liaoIdx != -1) {
                GLPMarketingMixListModel *marketModel = weakSelf.specModel.marketingMixList[weakSelf.liaoIdx];
                float beishu = self.specModel.stock / [marketModel.mixNum integerValue];
                int kucun = floor(beishu);
                stock = kucun;
            }
            
            if ([weakSelf.defineBtn.titleLabel.text isEqualToString:defineBtnTitle] && (stock == 0)) {
                weakSelf.payCount = 0;
                weakSelf.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.payCount];
                return;
            }
            
            NSInteger count = [weakSelf.countTFView.textField.text integerValue];
            if (count < 1) {
                [SVProgressHUD showInfoWithStatus:@"不能小于1件"];
                return;
            }
            
            if (stock > 0) {
                if (count > stock) { // 大于库存
                    [SVProgressHUD showInfoWithStatus:@"超过库存啦～"];
                    return;
                }
                weakSelf.payCount = count;
                
            } else {
                weakSelf.payCount = count;
            }
            weakSelf.countView.countTF.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.payCount];
            
        };
        
        [self.countTFView.textField becomeFirstResponder];
        [self.countTFView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}

- (GLBCountTFView *)countTFView{
    if (!_countTFView) {
        _countTFView = [[GLBCountTFView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _countTFView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
