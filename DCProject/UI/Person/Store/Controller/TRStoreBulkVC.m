//
//  TRStoreRecommendVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRStoreBulkVC.h"
#import "XRWaterfallLayout.h"
#import "TRRecommCollectionCell.h"
#import "TRTopView2.h"
#import "TRStoreRecomModel.h"
#import "TRStoreActivityModel.h"
#import "GLPGoodsDetailsController.h"
@interface TRStoreBulkVC ()<UICollectionViewDataSource, XRWaterfallLayoutDelegate,UICollectionViewDelegate>
{
    MJRefreshAutoNormalFooter*footer;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong)TRTopView2*view2;
@property(nonatomic,strong) NSMutableArray *topArray;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allPage;
@end

@implementation TRStoreBulkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    
    //设置各属性的值
    //    waterfall.rowSpacing = 10;
    //    waterfall.columnSpacing = 10;
    //    waterfall.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //或者一次性设置
    [waterfall setColumnSpacing:8 rowSpacing:8 sectionInset:UIEdgeInsetsMake(10, 14, 10, 14)];
    
    
    //设置代理，实现代理方法
    waterfall.delegate = self;
    /*
     //或者设置block
     [waterfall setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
     //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
     XRImage *image = self.images[indexPath.item];
     return image.imageH / image.imageW *itemWidth;
     }];
     */
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenW, kScreenH-kStatusBarHeight-170-LJ_TabbarSafeBottomMargin) collectionViewLayout:waterfall];
    self.collectionView.backgroundColor = RGB_COLOR(248, 248, 248);
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRRecommCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TRRecommCollectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.view2 = [[TRTopView2 alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
    self.collectionView.contentInset = UIEdgeInsetsMake(48, 0, 0, 0);
    self.view2.clickblock = ^(NSString *_Nonnull actId) {
        GLPGoodsDetailsController*vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId=actId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.collectionView addSubview:self.view2];
    [self.view addSubview:self.collectionView];
   
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.topArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    [self gettopdata];
    [self getbottomData];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        if (self.page>self.allPage)
        {
            [self->footer endRefreshingWithNoMoreData];
            return ;
        }
        [self getbottomData];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer=footer;
}

- (void)gettopdata
{
    [[DCAPIManager shareManager]person_getStoreBulkwithfirmId:self.firmId currentPage:@"1" success:^(id response) {
        NSArray *arr = response[@"data"][@"pageData"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            TRStoreActivityModel *model = [[TRStoreActivityModel alloc]initWithDic:dic];
            [self.topArray addObject:model];
        }
        self.collectionView.contentInset = UIEdgeInsetsMake((197*kScreenW/375+9)*self.topArray.count+48, 0, 0, 0);
        self.view2.frame = CGRectMake(0, -(197*kScreenW/375+9)*self.topArray.count-48, kScreenW, (197*kScreenW/375+9)*self.topArray.count+38);
        self->_view2.dataArray=self.topArray;
        [self.collectionView reloadData];
    } failture:^(NSError *error) {
        
    }];
   
   
}

- (void)getbottomData
{
    [[DCAPIManager shareManager]person_getStoreCommoditieswithfirmId:self.firmId currentPage:[NSString stringWithFormat:@"%d",self.page] success:^(id response) {
        NSArray *arr = response[@"data"][@"pageData"];
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            TRStoreRecomModel *model = [[TRStoreRecomModel alloc]initWithDic:dic];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
          [self.collectionView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
          [self.collectionView.mj_footer endRefreshing];
    }];
}
//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    TRStoreRecomModel *model = self.dataArray[indexPath.item];
    NSString *isGroup = [NSString stringWithFormat:@"%@",model.isGroup];
    NSString *isAct = [NSString stringWithFormat:@"%@",model.isAct];
    if ([isGroup isEqualToString:@"1"])
    {
        return 172*kScreenW/375+136;
    }
    else{
        if ([isAct isEqualToString:@"1"])
        {
            return 172*kScreenW/375+136;
        }
        else{
            return 172*kScreenW/375+113;
        }
        
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRRecommCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRRecommCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    TRStoreRecomModel *model = self.dataArray[indexPath.item];
    NSString *isGroup = [NSString stringWithFormat:@"%@",model.isGroup];
    NSString *isAct = [NSString stringWithFormat:@"%@",model.isAct];
    if ([isGroup isEqualToString:@"1"])
    {
        if ([isAct isEqualToString:@"1"])
        {
            cell.bqImageV1.hidden = NO;
            cell.bqImageV2.hidden = NO;
            cell.bqImageV1.image = [UIImage imageNamed:@"tuan"];
            cell.bqImageV2.image = [UIImage imageNamed:@"cu"];
        }
        else{
            cell.bqImageV1.hidden = NO;
            cell.bqImageV2.hidden = YES;
            cell.bqImageV1.image = [UIImage imageNamed:@"tuan"];
        }
    }
    else{
        if ([isAct isEqualToString:@"1"])
        {
            cell.bqImageV1.hidden = NO;
            cell.bqImageV2.hidden = YES;
            cell.bqImageV1.image = [UIImage imageNamed:@"cu"];
        }
        else{
            cell.bqImageV1.hidden = YES;
            cell.bqImageV2.hidden = YES;
        }
    }
    cell.imageVheight.constant = 172*kScreenW/375;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.goodsImg1] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",model.goodsName];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",model.sellPrice];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
    cell.numLab.text = [NSString stringWithFormat:@"%@",model.packingSpec];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TRStoreRecomModel *model = self.dataArray[indexPath.item];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",model.goodsId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.collectionView)
    {
        NSString *y = [NSString stringWithFormat:@"%f",scrollView.contentOffset.y];
       
        if ([y floatValue]<0) {
                    y=@"0";
                }
        if ([y floatValue]>70) {
                    y=@"70";
            }
              
        [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:@{@"move":y}];
        
           if ([y floatValue]>=0&&[y floatValue]<=70)
            {
                self.collectionView.frame = CGRectMake(0, 0, kScreenW, kScreenH-kStatusBarHeight-170+[y floatValue]-LJ_TabbarSafeBottomMargin);
            }
    }
}
@end
