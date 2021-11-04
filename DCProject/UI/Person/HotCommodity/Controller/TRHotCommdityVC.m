//
//  TRClassGoodsVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//
/*!
 *@brief  店铺中间按钮分类
 *@param  firmId 店铺ID
 *@param  brandId 品牌ID
 *@param  brandName 品牌名字
 *@param  currentPage 当前分页页码（默认为1
 *@param  descFlag 价格排序 排序方式:1.由高到低；2.由低到高。（默认由高到低）
 *@param  dosageForm 剂型
 *@param  goodsIds 刷选的goodsIDs
 *@param  goodsTitle 商品名
 *@param  frontClassIcon 标记icon
 *@param  frontClassName 标记名称
 *@param  marketPrice 返利价格
 *@param  manufactory 生产单位
 *@param  orderFlag 排序类型：sellPrice.价格排序；totalSales.销量排序；evalNum.评价数排序（默认是销量排序，由高到低）
 *@param  searchName 输入框输入的字符:通用名，商品名，症状
 *@param  symptom 症状
 *@param  useMethod 使用方法
 *@param  usePerson 使用人群
 */
#import "TRHotCommdityVC.h"
#import "TRStoreChoseVC.h"
#import "TRStoreGoodsModel.h"
#import "GLPGoodsDetailsController.h"
#import "GLPSearchGoodsController.h"
#import "YBPopupMenu.h"
#import "GLPMessageListVC.h"
#import "GLPTabBarController.h"
#import "AddGoodsVC.h"

#import "DCHoverFlowLayout.h"
#import "GLPGoodsSwitchGridCell.h"
#import "GLPGoodsListGridCell.h"
#import "DCHotHeaderView.h"
@interface TRHotCommdityVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,YBPopupMenuDelegate>
@property(nonatomic,copy) NSString *selectPrice;//0:选中 1:未选中
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,copy) NSString *descFlag;
@property(nonatomic,copy) NSString *orderFlag;
@property(nonatomic,copy) NSString *classId;//分类
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@property(nonatomic,copy) NSString *isFirst;//0:第一次数据 其他都不是
@property(nonatomic,strong) NSMutableArray *brandArray;//品牌数组
@property(nonatomic,strong) NSMutableArray *venderArray;//厂家数组
@property(nonatomic,strong) NSMutableArray *symptomsArray;//症状数组
@property(nonatomic,strong) NSMutableArray *dosagformArray;//药剂数组
@property(nonatomic,strong) NSMutableArray *userwayArray;//使用方法数组
@property(nonatomic,strong) NSMutableArray *userpeopleArray;//使用人群数组
@property(nonatomic,strong) NSMutableArray *selectbrandArray;//品牌选择数组
@property(nonatomic,strong) NSMutableArray *selectvenderArray;//厂家选择数组
@property(nonatomic,strong) NSMutableArray *selectsymptomsArray;//症状选择数组
@property(nonatomic,strong) NSMutableArray *selectdosagformArray;//药剂选择数组
@property(nonatomic,strong) NSMutableArray *selectuserwayArray;//使用方法选择数组
@property(nonatomic,strong) NSMutableArray *selectuserpeopleArray;//使用人群选择数组
@property (nonatomic,strong) UIView *morBG;
@property (nonatomic,strong) UIView *morcontBG;
@property(nonatomic,assign) NSInteger totalinter;
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isSwitchGrid;
@property(nonatomic,strong) UICollectionView *collectionView;

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

static NSString *const DCCustionHeadViewID = @"DCHotHeaderView";
static NSString *const GLPGoodsSwitchGridCellID = @"GLPGoodsSwitchGridCell";
static NSString *const GLPGoodsListGridCellID = @"GLPGoodsListGridCell";

@implementation TRHotCommdityVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCHoverFlowLayout *layout = [DCHoverFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, kStatusBarHeight+111,kScreenW, kScreenH-kStatusBarHeight-111-LJ_TabbarSafeBottomMargin);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //        _collectionView.layer.borderColor = [UIColor redColor].CGColor;
        //        _collectionView.layer.borderWidth = 2;
        
        [_collectionView registerClass:[DCHotHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID]; //头部View
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPGoodsSwitchGridCell class]) bundle:nil] forCellWithReuseIdentifier:GLPGoodsSwitchGridCellID];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPGoodsListGridCell class]) bundle:nil] forCellWithReuseIdentifier:GLPGoodsListGridCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableDictionary *)cellDic{
    if (!_cellDic) {
        _cellDic = [[NSMutableDictionary alloc] init];;
    }
    return _cellDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpColl];
    
    _totalinter = 0;
    self.topHeight.constant=kStatusBarHeight;
    //self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    //self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    //self.choseBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    [self.mrBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
    [self.choseBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
    self.mrBtn.layer.masksToBounds = YES;
    self.mrBtn.layer.cornerRadius = 4;
    self.priceBtn.layer.masksToBounds = YES;
    self.priceBtn.layer.cornerRadius = 4;
    self.choseBtn.layer.masksToBounds = YES;
    self.choseBtn.layer.cornerRadius = 4;
    self.priceImageV.image = [UIImage imageNamed:@"sweixuanz"];
    self.priceBtn.hidden = NO;
    self.selectPrice = @"0";
    self.classId = @"";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.brandArray = [NSMutableArray arrayWithCapacity:0];
    self.venderArray = [NSMutableArray arrayWithCapacity:0];
    self.symptomsArray = [NSMutableArray arrayWithCapacity:0];
    self.dosagformArray = [NSMutableArray arrayWithCapacity:0];
    self.userwayArray = [NSMutableArray arrayWithCapacity:0];
    self.userpeopleArray = [NSMutableArray arrayWithCapacity:0];
    self.selectbrandArray = [NSMutableArray arrayWithCapacity:0];
    self.selectvenderArray = [NSMutableArray arrayWithCapacity:0];
    self.selectsymptomsArray = [NSMutableArray arrayWithCapacity:0];
    self.selectdosagformArray = [NSMutableArray arrayWithCapacity:0];
    self.selectuserwayArray = [NSMutableArray arrayWithCapacity:0];
    self.selectuserpeopleArray = [NSMutableArray arrayWithCapacity:0];
    self.orderFlag = @"";
    self.descFlag = @"";
    self.page = 1;
    self.isFirst = @"0";
    [self getGoodsList];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.dataArray removeAllObjects];
        [self getGoodsList];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        
        if (self.page>self.allPage){
            [self.collectionView.mj_footer endRefreshing];
            return ;
        }
        [self getGoodsList];
    }];
    _morBG = [[UIView alloc] init];
    _morBG.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_morBG];
    [_morBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.mas_equalTo(_collectionView.mas_top);
    }];
    _morBG.alpha = 0;
    _morBG.clipsToBounds = YES;
    _morcontBG = [[UIView alloc] initWithFrame:CGRectMake(0, -200, kScreenW, 200)];
    _morcontBG.backgroundColor = [UIColor whiteColor];
    [_morBG addSubview:_morcontBG];

    [self vbg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(miss)];
    [_morBG addGestureRecognizer:tap];
    UIButton *_good_Bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _good_Bt.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_good_Bt setImage:[UIImage imageNamed:@"dj"] forState:0];
    [self.view addSubview:_good_Bt];
    [_good_Bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.bottom.offset(-120);
        make.width.height.offset(63);
    }];
    [_good_Bt addTarget:self action:@selector(djgd) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_switchBtn addTarget:self action:@selector(switchViewButtonBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - initialize
- (void)setUpColl{
    self.view.backgroundColor = [UIColor whiteColor];
    // 默认列表视图
    NSString *type = [DCObjectManager dc_readUserDataForKey:DC_GoodsListType_key];
    _isSwitchGrid = [type boolValue];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
}

#pragma mark - 切换视图按钮点击
- (void)switchViewButtonBarItemClick:(UIButton *)button{
    button.selected = !button.selected;
    _isSwitchGrid = !_isSwitchGrid;
    NSString *dateString = _isSwitchGrid ? @"YES" : @"NO";
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:DC_GoodsListType_key];
    [self.collectionView reloadData];
}

- (void)djgd{
    AddGoodsVC *vc = [[AddGoodsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)miss{
    [UIView animateWithDuration:0.5 animations:^{
        self->_morBG.alpha = 0;
        self->_morcontBG.frame = CGRectMake(0, -200, kScreenW, 200);
        self->_mor_x.transform = CGAffineTransformRotate(self.mor_x.transform, M_PI);
    }];
}

- (void)xiao:(UIButton*)bt{
    _totalinter = bt.tag ;
    //self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    [self.mrBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    //self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    self.priceBtn.selected = NO;
    [self.priceBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
    self.priceImageV.image = [UIImage imageNamed:@"sweixuanz"];
    
    [self.dataArray removeAllObjects];
    //    [self getGoodsList];
    if (_totalinter == 0) {
        self.selectPrice = @"0";
        self.orderFlag = @"0";
        self.descFlag = @"0";
        self.page = 1;
        [_mrBtn setTitle:@"综合" forState:0];
    }
    if (_totalinter == 1) {
        self.selectPrice = @"0";
        self.orderFlag = @"totalSales";
        self.descFlag = @"1";
        self.page = 1;
        [_mrBtn setTitle:@"销量" forState:0];
    }
    if (_totalinter == 2) {
        self.selectPrice = @"0";
        self.orderFlag = @"totalSales";
        self.descFlag = @"2";
        self.page = 1;
        [_mrBtn setTitle:@"销量" forState:0];
    }
    if (_totalinter == 3) {
        self.selectPrice = @"0";
        self.orderFlag = @"evalNum";
        self.descFlag = @"1";
        self.page = 1;
        [_mrBtn setTitle:@"评价" forState:0];
    }
    [self getGoodsList];
    [self miss];
}

- (void)vbg{
    for (UIView *v in _morcontBG.subviews) {
        [v removeFromSuperview];
    }
    NSArray *arr = @[@"综合",@"销量高到低",@"销量低到高",@"评价高到低"];
    for (int i = 0; i<arr.count; i++) {
        UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_morcontBG addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(50*i);
            make.height.offset(50);
        }];
        bt.tag = i;
        [bt addTarget:self action:@selector(xiao:) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *la = [[UILabel alloc]init];
        la.text = arr[i];
        la.font = [UIFont systemFontOfSize:13];
        [bt addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(15);
        }];
        if (i == _totalinter) {
            UIImageView *icon3 = [[UIImageView alloc]init];
            icon3.image = [UIImage imageNamed:@"ssgx"];
            [bt addSubview:icon3];
            [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.right.offset(-15);
            }];
            la.textColor = [UIColor dc_colorWithHexString:@"59BFB6"];
        }
    }
}

- (void)getGoodsList
{
    if ([self.isFirst isEqualToString:@"0"])
    {
        [self.venderArray removeAllObjects];
        [self.brandArray removeAllObjects];
        [self.symptomsArray removeAllObjects];
        [self.dosagformArray removeAllObjects];
        [self.userpeopleArray removeAllObjects];
        [self.userwayArray removeAllObjects];
    }
    
    NSString *brandStr=@"";
    for (int i=0; i<self.selectbrandArray.count; i++)
    {
        if (i==0)
        {
            brandStr=self.selectbrandArray[0];
        }
        else{
            brandStr = [NSString stringWithFormat:@"%@,%@",brandStr,self.selectbrandArray[i]];
        }
    }
    NSString *dosageFormStr=@"";
    for (int i=0; i<self.selectdosagformArray.count; i++)
    {
        if (i==0)
        {
            dosageFormStr=self.selectdosagformArray[0];
        }
        else{
            dosageFormStr = [NSString stringWithFormat:@"%@,%@",dosageFormStr,self.selectdosagformArray[i]];
        }
    }
    NSString *manufactoryStr=@"";
    for (int i=0; i<self.selectvenderArray.count; i++)
    {
        if (i==0)
        {
            manufactoryStr=self.selectvenderArray[0];
        }
        else{
            manufactoryStr = [NSString stringWithFormat:@"%@,%@",manufactoryStr,self.selectvenderArray[i]];
        }
    }
    NSString *symptomStr=@"";
    for (int i=0; i<self.selectsymptomsArray.count; i++)
    {
        if (i==0)
        {
            symptomStr=self.selectsymptomsArray[0];
        }
        else{
            symptomStr = [NSString stringWithFormat:@"%@,%@",symptomStr,self.selectsymptomsArray[i]];
        }
    }
    NSString *wayStr=@"";
    for (int i=0; i<self.selectuserwayArray.count; i++)
    {
        if (i==0)
        {
            wayStr=self.selectuserwayArray[0];
        }
        else{
            wayStr = [NSString stringWithFormat:@"%@,%@",wayStr,self.selectuserwayArray[i]];
        }
    }
    NSString *peopleStr=@"";
    for (int i=0; i<self.selectuserpeopleArray.count; i++)
    {
        if (i==0)
        {
            peopleStr=self.selectuserpeopleArray[0];
        }
        else{
            peopleStr = [NSString stringWithFormat:@"%@,%@",peopleStr,self.selectuserpeopleArray[i]];
        }
    }
    [[DCAPIManager shareManager]person_getClassGoodsListywithcatId:[NSString stringWithFormat:@"%@",self.classId] brandId:@"" goodsTagNameList:@"" brandName:brandStr currentPage:[NSString stringWithFormat:@"%d",self.page] descFlag:self.descFlag dosageForm:dosageFormStr goodsIds:@"" goodsTitle:@"" manufactory:manufactoryStr orderFlag:self.orderFlag searchName:@"" symptom:symptomStr useMethod:wayStr usePerson:peopleStr success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allPage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"goodsList"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            TRStoreGoodsModel *model = [[TRStoreGoodsModel alloc] initWithDic:dic];
            NSArray *actModel = [GLPGoodsActivitiesModel mj_objectArrayWithKeyValuesArray:model.activities];
            model.activities = actModel;
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if ([self.isFirst isEqualToString:@"0"])
        {
            NSDictionary *typeDic = response[@"data"][@"facetList"];
            NSArray *brandarr = typeDic[@"brandName"];
            [self.brandArray addObjectsFromArray:brandarr];
            NSArray *venderarr = typeDic[@"manufactoryStr"];
            [self.venderArray addObjectsFromArray:venderarr];
            NSArray *dosagarr = typeDic[@"dosageForm"];
            [self.dosagformArray addObjectsFromArray:dosagarr];
            NSArray *symptonarr = typeDic[@"symptom"];
            [self.symptomsArray addObjectsFromArray:symptonarr];
            NSArray *peoplearr = typeDic[@"usePerson"];
            [self.userpeopleArray addObjectsFromArray:peoplearr];
            NSArray *wayarr = typeDic[@"useMethod"];
            [self.userwayArray addObjectsFromArray:wayarr];
            self.isFirst = @"1";
        }
        
    } failture:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (IBAction)searchClick:(id)sender {
    GLPSearchGoodsController*vc = [[GLPSearchGoodsController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mrClick:(id)sender {
    //    self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    //     [self.mrBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    //    self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    //    self.priceBtn.selected = NO;
    //    [self.priceBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
    //    self.priceImageV.image = [UIImage imageNamed:@"sweixuanz"];
    //    self.selectPrice = @"0";
    //    self.orderFlag = @"totalSales";
    //    self.descFlag = @"1";
    //    self.page = 1;
    //    [self.dataArray removeAllObjects];
    //    [self getGoodsList];
    
    [self vbg];
    if (_morBG.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self->_morBG.alpha = 1;
            self->_morcontBG.frame = CGRectMake(0, 0, kScreenW, 200);
            self->_mor_x.transform = CGAffineTransformRotate(self.mor_x.transform,M_PI);
        }];
    }else{
        //        self->_mor_x.transform = CGAffineTransformRotate(self.mor_x.transform, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self->_morBG.alpha = 0;
            self->_morcontBG.frame = CGRectMake(0, -200, kScreenW, 200);
            self->_mor_x.transform = CGAffineTransformRotate(self.mor_x.transform, M_PI);
        }];
    }
}

- (IBAction)priceClick:(id)sender {
    
    self.priceBtn.selected = !self.priceBtn.selected;
    //self.priceBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    [self.priceBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateSelected];
    //self.mrBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    [self.mrBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
    if ([self.selectPrice isEqualToString:@"0"])
    {
        self.priceBtn.selected = NO;
        self.priceImageV.image = [UIImage imageNamed:@"shaux1"];
        self.selectPrice = @"1";
        self.descFlag = @"1";
    }
    else{
        if (self.priceBtn.selected==YES)
        {
            self.priceImageV.image = [UIImage imageNamed:@"shgaix2"];
            self.descFlag = @"2";
        }
        else{
            self.priceImageV.image = [UIImage imageNamed:@"shaux1"];
            self.descFlag = @"1";
        }
    }
    self.orderFlag = @"sellPrice";
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getGoodsList];
}

- (IBAction)choseClick:(id)sender {
    [self.choseBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    //self.choseBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    self.choseImageV.image = [UIImage imageNamed:@"dc_arrow_down_lu"];
    TRStoreChoseVC *vc = [[TRStoreChoseVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.choseblock = ^(NSArray *_Nonnull randArr, NSArray *_Nonnull vendArr, NSArray *_Nonnull symptomsArr, NSArray *_Nonnull dosageFormArr, NSArray *_Nonnull wayArr, NSArray *_Nonnull peopleArr) {
        [self.selectbrandArray removeAllObjects];
        [self.selectvenderArray removeAllObjects];
        [self.selectsymptomsArray removeAllObjects];
        [self.selectdosagformArray removeAllObjects];
        [self.selectuserwayArray removeAllObjects];
        [self.selectuserpeopleArray removeAllObjects];
        [self.selectbrandArray addObjectsFromArray:randArr];
        [self.selectvenderArray addObjectsFromArray:vendArr];
        [self.selectsymptomsArray addObjectsFromArray:symptomsArr];
        [self.selectdosagformArray addObjectsFromArray:dosageFormArr];
        [self.selectuserwayArray addObjectsFromArray:wayArr];
        [self.selectuserpeopleArray addObjectsFromArray:peopleArr];
        [self.dataArray removeAllObjects];
        self.page = 1;
        [self getGoodsList];
        if (self.selectbrandArray.count==0&&self.selectvenderArray.count==0&&self.selectsymptomsArray.count==0&&self.selectdosagformArray.count==0&&self.selectuserwayArray.count==0&&self.selectuserpeopleArray.count==0)
        {
            //self.choseBtn.backgroundColor = RGB_COLOR(250, 250, 250);
            [self.choseBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
            self.choseImageV.image = [UIImage imageNamed:@"dc_arrow_down_hui"];
        }
        else{
            [self.choseBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
            //self.choseBtn.backgroundColor = RGB_COLOR(241, 251, 250);
            self.choseImageV.image = [UIImage imageNamed:@"dc_arrow_down_lu"];
        }
    };
    vc.bandArr = self.brandArray;
    vc.symptomsArr = self.symptomsArray;
    vc.dosageFormArr = self.dosagformArray;
    vc.venderArr = self.venderArray;
    vc.wayArr = self.userwayArray;
    vc.peopleArr = self.userpeopleArray;
    vc.selectbandArr = self.selectbrandArray;
    vc.selectvenderArr = self.selectvenderArray;
    vc.selectsymptomsArr = self.selectsymptomsArray;
    vc.selectdosageFormArr = self.selectdosagformArray;
    vc.selectwayArr = self.selectuserwayArray;
    vc.selectpeopleArr = self.selectuserpeopleArray;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    //[self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)moreClick:(id)sender {
    [self showPopupMenu];
}

#pragma mark - 展示弹框  选中的cell样式可自定义  待优化
- (void)showPopupMenu {
    YBPopupMenu *popupMenu = [YBPopupMenu showAtPoint:CGPointMake(kScreenW - 60, kNavBarHeight - 10) titles:@[@"消息",@"首页",@"商品分类",@"购物车",@"我的"] icons:@[@"xiangqxiaoxi",@"xiangqshouye",@"xiangqingspfenlei",@"xiangqigouwuc",@"xiangqwode"] menuWidth:138 delegate:self];
    popupMenu.dismissOnSelected = YES;
    popupMenu.isShowShadow = YES;
    popupMenu.delegate = self;
    popupMenu.offset = 10;
    popupMenu.type = YBPopupMenuTypeDark;
    popupMenu.fontSize = 16;
    popupMenu.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    popupMenu.borderWidth = 0;
    popupMenu.cornerRadius = 5;
    popupMenu.minSpace = 10;
    popupMenu.arrowPosition = YBPopupMenuPriorityDirectionRight;
    popupMenu.backColor = [UIColor dc_colorWithHexString:@"666666" alpha:0.9];
    popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight;
}

#pragma mark - <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) { // 消息
        GLPMessageListVC *vc = [[GLPMessageListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else { // 首页 商品分类 购物车 我的
        
        GLPTabBarController *vc = [[GLPTabBarController alloc] init];
        vc.selectedIndex = index - 1;
        DC_KeyWindow.rootViewController = vc;
        
    }
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPGoodsListGridCell *cell = nil;
    cell = (_isSwitchGrid) ? [collectionView dequeueReusableCellWithReuseIdentifier:GLPGoodsSwitchGridCellID forIndexPath:indexPath] :[collectionView dequeueReusableCellWithReuseIdentifier:GLPGoodsListGridCellID forIndexPath:indexPath] ;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        DCHotHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
        reusableview = headView;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRStoreGoodsModel *model = _dataArray[indexPath.row];
    CGFloat itemH = 0;
    CGFloat store_H_LayoutConstraint = -8;
    if (model.purchased.length > 0) {
        store_H_LayoutConstraint = 5;
    }
    CGFloat type_H_LayoutContraint = -8;
    if (model.activities.count != 0) {
        type_H_LayoutContraint = 5;
    }
    itemH = store_H_LayoutConstraint+type_H_LayoutContraint;
    
    NSInteger blankNum = 0;
    NSString *goodsTitle = model.goodsTitle;
    if (model.frontClassName.length > 0) {
        //NSString *frontClassName = [NSString stringWithFormat:@" %@   ",model.frontClassName];
        blankNum = model.frontClassName.length*2+5;
    }
    for (NSInteger i=0; i< blankNum; i++) {
        goodsTitle = [NSString stringWithFormat:@" %@",goodsTitle];
    }
    
    if (_isSwitchGrid) {
        CGFloat titleH = [DCSpeedy getLabelHeightWithText:goodsTitle width:(kScreenW - 4)/2-15 font:[UIFont systemFontOfSize:15]];
        titleH = titleH > 25 ? 42 : titleH;
        return CGSizeMake((kScreenW - 4)/2-1, (kScreenW - 4)/2+itemH+titleH);
    }else{
        CGFloat titleH = [DCSpeedy getLabelHeightWithText:goodsTitle width:kScreenW-144 font:[UIFont systemFontOfSize:17]];
        titleH = titleH > 25 ? 42 : titleH;
        return CGSizeMake(kScreenW, 90+titleH+itemH);
    }
    //return (_isSwitchGrid) ? CGSizeMake((kScreenW - 4)/2-1, (kScreenW - 4)/2 + 80) : CGSizeMake(kScreenW, 164) ;//列表、网格Cell
}

//- (NSInteger)getNeed_hidde_num:(TRStoreGoodsModel *)youSelectItem
//{
//    NSInteger row_num = 1;
//    int x = arc4random() % 3;
//    row_num = x;
//    NSDictionary *dic = youSelectItem.goodsCouponsBean;
//    if (dic==nil||[dic isEqualToDictionary:@{}])
//    {
//        if ([youSelectItem.totalSales  intValue] <100) {
//            row_num++;
//        }
//    }
//
//    NSString *goodsTagNameList = youSelectItem.goodsTagNameList;
//    if (goodsTagNameList.length!=0)
//    {
//        NSArray *arr = [goodsTagNameList componentsSeparatedByString:@","];
//        if (arr.count==0)
//        {
//            row_num++;
//        }
//    }
//    return row_num;
//}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 4); //头部
}

#pragma mark - 边间距属性默认为0
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
    
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (_isSwitchGrid) ? 4 : 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了商品第%zd",indexPath.row);
    TRStoreGoodsModel *model = self.dataArray[indexPath.row];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",model.id];
    vc.batchId = model.batchId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
