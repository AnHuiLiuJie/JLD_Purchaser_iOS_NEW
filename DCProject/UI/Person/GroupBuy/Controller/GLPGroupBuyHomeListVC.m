//
//  GLPGroupBuyHomeListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import "GLPGroupBuyHomeListVC.h"

// Controllers
#import "GLPGoodsDetailsController.h"
#import "GLPOrderDetailsViewController.h"
#import "GLPGroupDetailsVC.h"
#import "GLPToPayViewController.h"
#import "GLPConfirmOrderViewController.h"
// Models
#import "GLPNewShoppingCarModel.h"
// Views
#import "DCNoDataView.h"
#import "GLPGroupBuyHomeHeaderView.h"
#import "GLPGroupHomeTopToolView.h"
#import "GLPGroupBuyBottomTabView.h"
#import "EtpRuleDescriptionView.h"
/* cell */
#import "GLPGroupDetailsCell.h"
#import "GLPMeGroupBuyListCell.h"
/* head */
/* foot */
// Vendors
// Categories
#import "DCAPIManager+Activity.h"

// Others
@interface GLPGroupBuyHomeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int allpage;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) DCNoDataView *noorderDataView;

@property (nonatomic, strong) UIImageView *topImage;

/* headerView */
@property (strong , nonatomic)GLPGroupBuyHomeHeaderView *headerView;

@property (nonatomic, strong) GLPGroupHomeTopToolView *topToolView;
@property (nonatomic, strong) GLPGroupBuyBottomTabView *bottomView;

@property (nonatomic, strong) UIButton *descriptionBtn;
@end


static NSString *const GLPGroupDetailsCellID = @"GLPGroupDetailsCell";
static NSString *const GLPMeGroupBuyListCellID = @"GLPMeGroupBuyListCell";

@implementation GLPGroupBuyHomeListVC

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPGroupDetailsCell class]) bundle:nil] forCellReuseIdentifier:GLPGroupDetailsCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPMeGroupBuyListCell class]) bundle:nil] forCellReuseIdentifier:GLPMeGroupBuyListCellID];
        
        _descriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _descriptionBtn.frame = CGRectMake(kScreenW-100, kNavBarHeight+5, 100, 30);
        [_descriptionBtn addTarget:self action:@selector(descriptionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _descriptionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _descriptionBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
        [_descriptionBtn setTitle:@"规则详情" forState:UIControlStateNormal];
        [_descriptionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _descriptionBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#C4462C" alpha:0.8];
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_descriptionBtn byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft size:CGSizeMake(_descriptionBtn.dc_height/2, _descriptionBtn.dc_height/2)];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)listArray{
    if (!_listArray){
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (DCNoDataView *)noorderDataView{
    if (!_noorderDataView) {
//        _noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-50-kNavBarHeight-LJ_TabbarSafeBottomMargin) image:[UIImage imageNamed:@"dc_no_goods"] button:nil tip:@"暂无拼团～"];
        _noorderDataView = [[DCNoDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-50-kNavBarHeight-LJ_TabbarSafeBottomMargin) image:[UIImage imageNamed:@"dc_no_goods"] button:nil tip:@"暂无拼团～"];
        _noorderDataView.hidden = YES;
    }
    return _noorderDataView;
}

- (GLPGroupBuyHomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[GLPGroupBuyHomeHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, kNavBarHeight, kScreenW, 140+kNavBarHeight);
    }
    return _headerView;
}

- (GLPGroupHomeTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[GLPGroupHomeTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{ //点击了左侧
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _topToolView.rightItemClickBlock = ^(NSInteger tag) {
            UIImage *image = [weakSelf makeImageWithView:weakSelf.view withSize:CGSizeMake(kScreenW, kScreenW*4/5)];
            NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
            NSString *string = [NSString stringWithFormat:@"/geren/app_code.html?userId=%@",userId];
            [[DCUMShareTool shareClient] shareInfoWithTitle:@"药批发、药采购，就上金利达！" content:@"金利达-拼团" url:string image:image pathUrl:@"/pages/drug/collage"];
        };

        NSArray *clolor2 = [NSArray arrayWithObjects:
                            (id)[UIColor dc_colorWithHexString:@"#ea4228" alpha:1].CGColor,
                            (id)[UIColor dc_colorWithHexString:@"#ea4228" alpha:0.1].CGColor,nil];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        [gradientLayer2 setColors:clolor2];//渐变数组
        gradientLayer2.startPoint = CGPointMake(0.5,0.2);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
        gradientLayer2.endPoint = CGPointMake(0.5,1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
        gradientLayer2.locations = @[@(0),@(1.0)];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
        gradientLayer2.frame = CGRectMake(0, 0, kScreenW, kNavBarHeight);
        [self.topToolView.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序
        
//                _topToolView.backgroundColor = [UIColor clearColor];
    }
    return _topToolView;
}

- (void)descriptionBtnAction:(UIButton *)button{
    EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
    view.titile_str = @"规则详情";
    view.content_str = @"拼团规则";
    view.frame = DC_KEYWINDOW.bounds;
    [DC_KEYWINDOW addSubview:view];
}

#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [[UIImageView alloc] init];
        [_topImage setImage:[UIImage imageNamed:@"dc_groupBuy_bg"]];
        _topImage.contentMode = UIViewContentModeScaleToFill;
        _topImage.frame = CGRectMake(0, -kNavBarHeight, kScreenW, kScreenW);
        [self.view sendSubviewToBack:_topImage];
    }
    return _topImage;
}

- (GLPGroupBuyBottomTabView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GLPGroupBuyBottomTabView alloc] init];
        WEAKSELF;
        _bottomView.GLPGroupBuyBottomTabView_btnBlock = ^(NSInteger tag) {
            if (tag == 1) {
                weakSelf.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-50-LJ_TabbarSafeBottomMargin);
                weakSelf.descriptionBtn.hidden = NO;
                weakSelf.noorderDataView.hidden = NO;
                weakSelf.showType = 1;
                weakSelf.topImage.hidden = NO;
                weakSelf.topToolView.hidden = NO;
                [weakSelf dc_statusBarStyle:UIStatusBarStyleLightContent];
                [weakSelf dc_navBarHidden:YES animated:NO];
                weakSelf.title = @"拼团";
                weakSelf.headerView.frame = CGRectMake(0, 0, kScreenW, 120+kNavBarHeight);
                //weakSelf.noorderDataView.hidden = YES;
            }else{
                weakSelf.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-50-kNavBarHeight-LJ_TabbarSafeBottomMargin);
                weakSelf.descriptionBtn.hidden = YES;
                weakSelf.showType = 2;
                weakSelf.topImage.hidden = YES;
                weakSelf.topToolView.hidden = YES;
                [weakSelf dc_navBarHidden:NO animated:NO];
                [weakSelf dc_statusBarStyle:UIStatusBarStyleDefault];
                [weakSelf dc_navBarLucency:NO];//解决侧滑显示白色
                weakSelf.title = @"我的拼团";
                weakSelf.headerView.frame = CGRectMake(0, 0, kScreenW, 0);
                weakSelf.noorderDataView.hidden = NO;
            }
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        _bottomView.frame = CGRectMake(0, kScreenH-(50+LJ_TabbarSafeBottomMargin), kScreenW, 50+LJ_TabbarSafeBottomMargin);
    }
    return _bottomView;
}

- (void)getlistData{
    WEAKSELF;
    NSString *currentPage = [NSString stringWithFormat:@"%d",_page];
    NSString *joinId = @"";
    NSString *orderNo = @"";
    if (self.showType == 1) {
        [[DCAPIManager shareManager] person_b2c_activity_collageWithCurrentPage:currentPage joinId:joinId orderNo:orderNo success:^(id  _Nullable response) {
            NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
            weakSelf.allpage = [allpage intValue];
            NSArray *arr = response[@"data"][@"pageData"];
            NSArray *listArr = [DCCollageListModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.dataArray addObjectsFromArray:listArr];
            
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArray.count>0)
            {
                weakSelf.noorderDataView.hidden = YES;
            }
            else{
                weakSelf.noorderDataView.hidden = NO;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } failture:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else{
        [[DCAPIManager shareManager] person_b2c_activity_collage_mycollageWithCurrentPage:currentPage joinId:joinId orderNo:orderNo success:^(id  _Nullable response) {
            NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
            weakSelf.allpage = [allpage intValue];
            NSArray *arr = response[@"data"][@"pageData"];
            NSArray *listArr = [DCMyCollageListModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.listArray addObjectsFromArray:listArr];
            
            [weakSelf.tableView reloadData];
            if (weakSelf.listArray.count>0)
            {
                weakSelf.noorderDataView.hidden = YES;
            }
            else{
                weakSelf.noorderDataView.hidden = NO;
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } failture:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.showType == 1) {
        self.descriptionBtn.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-50-LJ_TabbarSafeBottomMargin);
        self.topImage.hidden = NO;
        self.topToolView.hidden = NO;
        [self dc_statusBarStyle:UIStatusBarStyleLightContent];
        [self dc_navBarHidden:YES animated:animated];
        [self dc_navBarLucency:YES];//解决侧滑显示白色
        self.title = @"拼团";
        self.headerView.frame = CGRectMake(0, 0, kScreenW, 120+kNavBarHeight);
    }else{
        self.descriptionBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-50-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        self.topImage.hidden = YES;
        self.topToolView.hidden = YES;
        [self dc_statusBarStyle:UIStatusBarStyleDefault];
        [self dc_navBarHidden:NO animated:animated];
        [self dc_navBarLucency:NO];//解决侧滑显示白色
        self.title = @"我的拼团";
        self.headerView.frame = CGRectMake(0, 0, kScreenW, 0);
        self.bottomView.leftBtn.selected = NO;
        self.bottomView.rightBtn.selected = YES;
    }
        
    if (!_isFirstLoad) {
        [self.dataArray removeAllObjects];
        [self.listArray removeAllObjects];
        [self getlistData];
        _isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self dc_navBarTitleWithFont:[UIFont fontWithName:PFR size:18] color:[UIColor clearColor]];//与对称出现 [UIColor dc_colorWithHexString:@"#333333"]

    [self.view addSubview:self.topImage];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.descriptionBtn];
    
    [self.view addSubview:self.topToolView];
    [self.view addSubview:self.bottomView];
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    self.noorderDataView.hidden = YES;
    [self.tableView addSubview:self.noorderDataView];

    self.page = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataArray removeAllObjects];
        [self.listArray removeAllObjects];
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        if (self.page>self.allpage)
        {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
            footView.backgroundColor = RGB_COLOR(247, 247, 247);
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = RGB_COLOR(51, 51, 51);
            lab.font = [UIFont systemFontOfSize:14];
            lab.text = @"已经到底了";
            [footView addSubview:lab];
            footView.backgroundColor = [UIColor clearColor];
            self.tableView.tableFooterView = footView;
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        self.tableView.tableFooterView = nil;
        [self getlistData];
    }];
    
    [self setUpHeaderCenterView];
}

#pragma mark - 初始化头尾
- (void)setUpHeaderCenterView{
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.showType == 1) {
        return self.dataArray.count;
    }else
        return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    if (self.showType == 1) {
        GLPGroupDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPGroupDetailsCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.section];
        cell.GLPGroupDetailsCell_btnBlock = ^(NSString * _Nonnull btnTitle, DCCollageListModel * _Nonnull model) {
            if ([btnTitle isEqualToString:@"拼团"]) {
                GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
                vc.goodsId = model.goodsId;
                vc.batchId = model.batchId;
                [weakSelf dc_pushNextController:vc];
            }else if([btnTitle isEqualToString:@"未开始"]){
                [weakSelf.view makeToast:@"未开始" duration:Toast_During position:CSToastPositionCenter];
            }else if([btnTitle isEqualToString:@"已结束"]){
                [weakSelf.view makeToast:@"已结束" duration:Toast_During position:CSToastPositionCenter];
            }
        };
        return cell;
    }else{
        GLPMeGroupBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPMeGroupBuyListCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.listArray[indexPath.section];
        WEAKSELF;
        cell.GLPMeGroupBuyListCell_btnBlock = ^(NSString *title,NSInteger tag) {
            
            DCMyCollageListModel *model = weakSelf.listArray[indexPath.section];
            if ([title isEqualToString:@"查看订单"]) {
                GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
                vc.orderNo_Str = model.orderNo;
                WEAKSELF;
                vc.GLPOrderDetailsViewController_block = ^{
                    weakSelf.isFirstLoad = NO;
                };
                [self dc_pushNextController:vc];
            }else if([title isEqualToString:@"拼团中"]){
                GLPGroupDetailsVC *vc = [[GLPGroupDetailsVC alloc] init];
                vc.model = model;
                [weakSelf dc_pushNextController:vc];
            }else if([title isEqualToString:@"活动结束"]){
                [weakSelf.view makeToast:@"活动结束" duration:Toast_During position:CSToastPositionCenter];
            }else if([title isEqualToString:@"已售罄"]){
                [weakSelf.view makeToast:@"该商品已售罄" duration:Toast_During position:CSToastPositionCenter];
            }else if([title isEqualToString:@"再开一团"]){
                [weakSelf requestBuyGoods:model];
            }else if([title isEqualToString:@"去付款"]){
                GLPToPayViewController *vc = [[GLPToPayViewController alloc] init];
                vc.orderNoStr = model.orderNo;
                vc.isNeedBackOrder = NO;
                vc.firmIdStr = model.sellerFirmId;
                [weakSelf dc_pushNextController:vc];
            }
        };
        return cell;
    }
}

#pragma mark - 数据提交 购买
- (void)requestBuyGoods:(DCMyCollageListModel *)model{
    //立刻开团
    NSString *goodsId = model.goodsId;//-*-
    NSString *batchId = model.batchId;//-*-
    NSString *quantity = @"1";//-*-
    NSString *sellerFirmId = model.sellerFirmId;//-*-
    NSString *tradeType = @"4";//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
    NSArray *cart = @[];
    
    __block NSString *actType = @"2";//1-秒杀；2-拼团；
    __block NSString *actId = model.collageId;//秒杀或者拼团的Id
    NSString *joinId = @"";//参与时存发起拼团ID（拼团购买使用）
    NSString *mixId = @"";//组合装Id
    
    NSDictionary *paramDic = @{@"goodsId":goodsId,
                               @"batchId":batchId,
                               @"quantity":quantity,
                               @"sellerFirmId":sellerFirmId,
                               @"tradeType":tradeType,
                               @"cart":cart,
                               @"actType":actType,
                               @"actId":actId,
                               @"joinId":joinId,
                               @"mixId":mixId};
    WEAKSELF;
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_confirmOrder_newWith:paramDic success:^(id  _Nullable response) {
        GLPNewShoppingCarModel *model = [GLPNewShoppingCarModel mj_objectWithKeyValues:response[@"data"]];
        NSArray *firmList = [GLPFirmListModel mj_objectArrayWithKeyValuesArray:model.firmList];
        for (GLPFirmListModel *firmModel in firmList) {
            NSArray *actInfoList = [ActInfoListModel mj_objectArrayWithKeyValuesArray:firmModel.actInfoList];
            NSArray *cartGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.cartGoodsList];
            NSArray *couponList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.couponList];
            NSArray *defaultCoupon = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.defaultCoupon];
            for (ActInfoListModel *actModel in actInfoList) {
                NSArray *actInfoList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:actModel.actGoodsList];
                actModel.actGoodsList = [actInfoList mutableCopy];
            }
            firmModel.actInfoList = [actInfoList mutableCopy];
            firmModel.cartGoodsList = [cartGoodsList mutableCopy];
            firmModel.couponList = couponList;
            firmModel.defaultCoupon = defaultCoupon;
        }
        model.firmList = firmList;
        GLPConfirmOrderViewController *vc = [GLPConfirmOrderViewController new];
        vc.actDic = paramDic;
        vc.ispay = @"1";
        vc.mainModel = model;
        NSDictionary *dict = @{@"type":@"创建订单详情页"};//UM统计 自定义搜索关键词事件
        [MobClick event:UMEventCollection_31 attributes:dict];
        //            vc.shoppingcarArray = array;
        //            vc.ispay = @"1";
        //            vc.goodsId = self.goodsId;
        //            vc.quanlity = [NSString stringWithFormat:@"%ld",self.buyCount];
        
        [weakSelf dc_pushNextController:vc];
        
    } failture:^(NSError * _Nullable error) {
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == 1) {
        return 130;
    }else
        return 210;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showType == 2) {
        DCMyCollageListModel *model = self.listArray[indexPath.section];
        GLPGroupDetailsVC *vc = [[GLPGroupDetailsVC alloc] init];
        vc.model = model;
        self.isFirstLoad = NO;
        [self dc_pushNextController:vc];
    }else{
        DCMyCollageListModel *model = self.dataArray[indexPath.section];
        if ([model.collageState integerValue] == 1) {
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [self dc_pushNextController:vc];
        }else{
            GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
            vc.goodsId = model.goodsId;
            vc.batchId = model.batchId;
            [self dc_pushNextController:vc];
        }
    }
    
}

- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
