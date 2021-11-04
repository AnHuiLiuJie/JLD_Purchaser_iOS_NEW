//
//  GLPNewTicketSelectVC.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPNewTicketSelectVC.h"
#import "NSMutableArray+WeakReferences.h"

static NSString *const GLPMainTicketCellID = @"GLPMainTicketCell";

#define kRowHeight 120

@interface GLPNewTicketSelectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectDataArray;

@end

@implementation GLPNewTicketSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setUpUI];
    
    NSMutableArray *indexArr = [NSMutableArray mutableArrayUsingWeakReferences];//解决强引用造成的问题
    indexArr = [self.firmModel.couponList  mutableCopy];
    self.dataArray = [indexArr mutableCopy];
    //self.dataArray = [self.firmModel.couponList mutableCopy];

    NSMutableArray *indexArr2 = [NSMutableArray mutableArrayUsingWeakReferences];//解决强引用造成的问题
    indexArr2 = [self.firmModel.defaultCoupon  mutableCopy];
    self.selectDataArray = [indexArr2 mutableCopy];
    
    [self.dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1) {
        couponModel.isSelected = NO;//初始化
        [self.selectDataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull seletcedModel, NSUInteger idx2, BOOL * _Nonnull stop2) {
            //seletcedModel.isSelected = YES;
            if ([seletcedModel.couponsId isEqualToString:couponModel.couponsId]) {
                couponModel.isSelected = YES;
            }
        }];
    }];
    [self changeShowType];
    
    
    [self.tableView reloadData];
}


- (void)setUpUI
{
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    CGFloat itemH = kScreenH/5 * 4;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - itemH, kScreenW, itemH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.text = @"选择优惠券";
    [_bgView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //_iconImage.image = [UIImage imageNamed:@"logo"];
    [_bgView addSubview:_iconImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];[UIColor dc_colorWithHexString:DC_BGColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    //_tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.separatorColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(GLPMainTicketCellID) forCellReuseIdentifier:GLPMainTicketCellID];
    [_bgView addSubview:_tableView];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:20];
    [_bgView addSubview:_confirmBtn];
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kScreenH - itemH, 0, 0, 0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(15);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.titleLabel.left).offset(-5);
        make.size.equalTo(CGSizeMake(18, 20));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom).offset(5);
        make.left.equalTo(self.bgView.left).offset(20);
        make.right.equalTo(self.bgView.right).offset(-20);
        make.bottom.equalTo(self.bgView.bottom).offset(-LJ_TabbarSafeBottomMargin-10);
        make.height.equalTo(45);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(0);
        make.bottom.equalTo(self.confirmBtn.top).offset(-10);
    }];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:clolor1];//渐变数组
    gradientLayer.startPoint = CGPointMake(0,0);
    gradientLayer.endPoint = CGPointMake(1,0);
    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
    gradientLayer.frame = CGRectMake(0,0,(kScreenW-20*2)/2,45);
    [_confirmBtn.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
}

#pragma mark - action 取消
- (void)cancelBtnClick:(UIButton *)button{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

//确定
- (void)confirmBtnClick:(UIButton *)button{
    NSMutableArray *listArr = [[NSMutableArray alloc] init];
    [self.dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1) {
        if (couponModel.isSelected) {
            [listArr addObject:couponModel];
        }
    }];
    !_GLPNewTicketSelectVC_block ? :_GLPNewTicketSelectVC_block(listArr);
    [self.view removeFromSuperview];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPMainTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPMainTicketCellID forIndexPath:indexPath];
    GLPCouponListModel *model = _dataArray[indexPath.section];
    cell.couponsModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPCouponListModel *seletcedModel = _dataArray[indexPath.section];
    /**
     优惠券选择
      1、店铺券2  和  商品券3  只可以选择一类
      2、不同的商品 优惠券 可以同时选中
      3、同一个商品 多个优惠券  只可以选择一张
     */
    __block CGFloat isSelectedNum = 0;
    //__block BOOL isSelected = seletcedModel.isSelected;
    __block NSInteger couponsClass = 0;
    [self.dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1) {
        if (couponModel.isSelected) {
            isSelectedNum++;
            couponsClass = [couponModel.couponsClass integerValue];
            if ([couponModel.couponsId isEqualToString:seletcedModel.couponsId]) {
                //点击点事同一个商品
                isSelectedNum--;
            }
        }
    }];
    
    
    if (isSelectedNum >= 0) {//不是最后一个
        seletcedModel.isSelected = !seletcedModel.isSelected;

        if (couponsClass != [seletcedModel.couponsClass integerValue]) {
            [_dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
                if ([couponModel.couponsClass integerValue] != [seletcedModel.couponsClass integerValue]) {
                    couponModel.isSelected = NO;//互斥
                }
            }];
        }else{
            if ([seletcedModel.couponsClass integerValue] == 3) {//商品券
                [_dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
                    if ([seletcedModel.couponsClass integerValue] == 2) {
                        couponModel.isSelected = NO;//互斥
                    }
                }];
                
                [self.dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
                    if ([couponModel.goodsId isEqualToString:seletcedModel.goodsId]) {
                        if (couponModel.isSelected && seletcedModel.isSelected) {
                            //[self.view makeToast:@"同个商品只能选择一张优惠券" duration:Toast_During position:CSToastPositionBottom];
                            couponModel.isSelected = NO;//一定要放在前
                            seletcedModel.isSelected = YES;
                        }
                    }
                }];
            }else if([seletcedModel.couponsClass integerValue] == 2){//店铺券
                [self.dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
                    if ([seletcedModel.couponsClass integerValue] == 3) {
                        couponModel.isSelected = NO;//互斥
                    }
                }];
            }
        }

    }else
        seletcedModel.isSelected = YES;//最后一个

    [self changeShowType];
    [self.tableView reloadData];

}

- (void)changeShowType{
    __block GLPCouponListModel *indexModel = nil;
    [_dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
        if (couponModel.isSelected) {
            indexModel = couponModel;
        }
        couponModel.showType = 3;
    }];
    
    [_dataArray enumerateObjectsUsingBlock:^(GLPCouponListModel * _Nonnull couponModel, NSUInteger idx1, BOOL * _Nonnull stop1){
        if (indexModel == nil) {
            couponModel.showType = 2;
        }else{
            if ([indexModel.couponsClass isEqualToString:couponModel.couponsClass]) {
                couponModel.showType = 2;
            }
            if (couponModel.isSelected) {
                couponModel.showType = 1;
            }
        }
    }];
}

//if (discountAmount111 == 0) { // 初始值
//    if (carModel.couponsClass == 2) {// 店铺通用券
//        if (couponsModel.couponsClass != 2) {
//            _isCanUsed = NO;
//        }
//    } else if (carModel.couponsClass == 3) { // 商品券
//        if (couponsModel.couponsClass != 3) {
//            _isCanUsed = NO;
//        }
//    }
//} else { // 非初始值
//    if (type == 2) {// 店铺通用券
//        if (couponsModel.couponsClass != 2) {
//            _isCanUsed = NO;
//        }
//    } else if (type == 3) { // 商品券
//        if (couponsModel.couponsClass != 3) {
//            _isCanUsed = NO;
//        }
//    }
//}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectTicketArray{
    if (!_selectTicketArray) {
        _selectTicketArray = [NSMutableArray array];
    }
    return _selectTicketArray;
}

@end
