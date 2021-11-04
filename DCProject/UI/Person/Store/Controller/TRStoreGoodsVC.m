//
//  TRStoreGoodsVC.m
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
 *@param  manufactory 生产单位
 *@param  orderFlag 排序类型：sellPrice.价格排序；totalSales.销量排序；evalNum.评价数排序（默认是销量排序，由高到低）
 *@param  searchName 输入框输入的字符:通用名，商品名，症状
 *@param  symptom 症状
 *@param  useMethod 使用方法
 *@param  usePerson 使用人群
 */
#import "TRStoreGoodsVC.h"
#import "DCHoverFlowLayout.h"
#import "GLPGoodsListGridCell.h"
#import "DCHotHeaderView.h"
#import "TRStoreChoseVC.h"
#import "TRStoreGoodsModel.h"
#import "GLPGoodsDetailsController.h"
@interface TRStoreGoodsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,copy) NSString *selectPrice;//0:选中 1:未选中
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,copy) NSString *descFlag;
@property(nonatomic,copy) NSString *orderFlag;
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
@end

static NSString *const GLPGoodsListGridCellID = @"GLPGoodsListGridCell";
static NSString *const DCCustionHeadViewID = @"DCHotHeaderView";

@implementation TRStoreGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalinter = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    self.choseBtn.backgroundColor = RGB_COLOR(250, 250, 250);
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
    
    self.collectionView.hidden = NO;
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
        
        if (self.page>self.allPage)
        {
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
    _morcontBG = [[UIView alloc]initWithFrame:CGRectMake(0, -200, kScreenW, 200)];
    _morcontBG.backgroundColor = [UIColor whiteColor];
    [_morBG addSubview:_morcontBG];
    [self vbg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(miss)];
    [_morBG addGestureRecognizer:tap];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCHoverFlowLayout *layout = [DCHoverFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 60,kScreenW, kScreenH-kStatusBarHeight-230-LJ_TabbarSafeBottomMargin);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [_collectionView registerClass:[DCHotHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID]; //头部View
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GLPGoodsListGridCell class]) bundle:nil] forCellWithReuseIdentifier:GLPGoodsListGridCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
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
    self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    [self.mrBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
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
        UILabel *la = [[UILabel alloc] init];
        la.text = arr[i];
        la.font = [UIFont systemFontOfSize:13];
        [bt addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(15);
        }];
        if (i == _totalinter) {
            UIImageView *icon3 = [[UIImageView alloc] init];
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
    [[DCAPIManager shareManager]person_getStoreGoodsListywithfirmId:[NSString stringWithFormat:@"%@",self.firmId] brandId:@"" brandName:brandStr currentPage:[NSString stringWithFormat:@"%d",self.page] descFlag:self.descFlag dosageForm:dosageFormStr goodsIds:@"" goodsTitle:@"" manufactory:manufactoryStr orderFlag:self.orderFlag searchName:@"" symptom:symptomStr useMethod:wayStr usePerson:peopleStr success:^(id response) {
        NSString *allpagestr = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allPage = [allpagestr intValue];
        NSArray *arr = response[@"data"][@"goodsList"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            TRStoreGoodsModel *model = [[TRStoreGoodsModel alloc]initWithDic:dic];
            NSArray *actModel = [GLPGoodsActivitiesModel mj_objectArrayWithKeyValuesArray:model.activities];
            model.activities = actModel;
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if ([self.isFirst isEqualToString:@"0"])
        {
            NSDictionary *typeDic=response[@"data"][@"facetList"];
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

- (IBAction)mrClick:(id)sender {
    //    self.mrBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    //    self.priceBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    //    [self.mrBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
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
    self.priceBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    self.mrBtn.backgroundColor = RGB_COLOR(250, 250, 250);
    [self.priceBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateSelected];
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
    self.choseBtn.backgroundColor = RGB_COLOR(241, 251, 250);
    self.choseImageV.image = [UIImage imageNamed:@"dc_arrow_down_lu"];
    TRStoreChoseVC *vc = [[TRStoreChoseVC alloc] init];
    //    vc.height = 200;
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
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
        if(self.selectbrandArray.count==0&&self.selectvenderArray.count==0&&self.selectsymptomsArray.count==0&&self.selectdosagformArray.count==0&&self.selectuserwayArray.count==0&&self.selectuserpeopleArray.count==0)
        {
            self.choseBtn.backgroundColor = RGB_COLOR(250, 250, 250);
            [self.choseBtn setTitleColor:RGB_COLOR(34, 34, 43) forState:UIControlStateNormal];
            self.choseImageV.image = [UIImage imageNamed:@"dc_arrow_down_hui"];
        }
        else{
            [self.choseBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
            self.choseBtn.backgroundColor = RGB_COLOR(241, 251, 250);
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
    
    [DC_KeyWindow.rootViewController addChildViewController:vc];
    [DC_KeyWindow.rootViewController.view addSubview:vc.view];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPGoodsListGridCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:GLPGoodsListGridCellID forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
//    cell.gwcBtn.tag = indexPath.row;
//    WEAKSELF;
//    cell.colonClickBlock = ^(NSInteger cellTag) {
//        //        TRStoreGoodsModel *model=self.dataArray[cellTag];
//        //        [[DCAPIManager shareManager]person_requestAddShoppingCarWithGoodsId:model.id quantity:@"1" success:^(id response) {
//        //            if (response) {
//        //                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
//        //            }
//        //        } failture:^(NSError *_Nullable error) {
//        //    }];
//        
//        //多规格原因进入详情页面
//        TRStoreGoodsModel *model = weakSelf.dataArray[cellTag];
//        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
//        vc.goodsId = [NSString stringWithFormat:@"%@",model.id];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//        NSLog(@"点击了同品牌%zd",cellTag);
//    };
    
    
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
    CGFloat store_H_LayoutConstraint = -5;
    if (model.purchased.length > 0) {
        store_H_LayoutConstraint = 12;
    }
    CGFloat type_H_LayoutContraint = -5;
    if (model.activities.count != 0) {
        type_H_LayoutContraint = 12;
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
    
    CGFloat titleH = [DCSpeedy getLabelHeightWithText:goodsTitle width:kScreenW-144 font:[UIFont systemFontOfSize:17]];
    titleH = titleH > 25 ? 42 : titleH;
    return CGSizeMake(kScreenW, 90+titleH+itemH);
}

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
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了商品第%zd",indexPath.row);
    TRStoreGoodsModel *model = self.dataArray[indexPath.row];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.collectionView)
    {
        CGFloat a = self.collectionView.contentSize.height;
        CGFloat c = a-kScreenH+kStatusBarHeight+230-60+LJ_TabbarSafeBottomMargin;
        
        NSString *y = [NSString stringWithFormat:@"%f",scrollView.contentOffset.y];
        if (c<=70)
        {
            if ([y floatValue]<0) {
                y=@"0";
            }
            if ([y floatValue]>c) {
                y = [NSString stringWithFormat:@"%f",c];
            }
        }
        else{
            if ([y floatValue]<0) {
                y=@"0";
            }
            if ([y floatValue]>70) {
                y=@"70";
            }
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:@{@"move":y}];
        if (c<=70)
        {
            if ([y floatValue]>=0&&[y floatValue]<=c)
            {
                self.collectionView.frame = CGRectMake(0, 60, kScreenW, kScreenH-kStatusBarHeight-230+[y floatValue]-LJ_TabbarSafeBottomMargin);
            }
        }
        else{
            if ([y floatValue]>=0&&[y floatValue]<=70)
            {
                self.collectionView.frame = CGRectMake(0, 60, kScreenW, kScreenH-kStatusBarHeight-230+[y floatValue]-LJ_TabbarSafeBottomMargin);
            }
        }
    }
}

@end
