//
//  HomeRecommListVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "StoreFoolsGoodsVC.h"
#import "TRHomeCollectionCell2.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "GLPGoodsDetailsController.h"
@interface StoreFoolsGoodsVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    MJRefreshAutoNormalFooter*footer;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int allpage;
@end

@implementation StoreFoolsGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160+kStatusBarHeight)];
     [self.view addSubview:headView];
    UIImageView*bgImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160+kStatusBarHeight)];
    bgImageV.image = [UIImage imageNamed:@"home_bg"];
    bgImageV.contentMode=UIViewContentModeScaleToFill;
    [headView addSubview:bgImageV];
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, kStatusBarHeight+14, 20, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(30, kStatusBarHeight+14, kScreenW-60, 20)];
    titLab.textColor = [UIColor whiteColor];
    titLab.text=self.titleStr;
    titLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titLab];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    //[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 8;// 垂直方向的间距
    layout.minimumLineSpacing = 8; // 水平方向的间距
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 64+kStatusBarHeight, kScreenW-28, kScreenH-64-kStatusBarHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    [self.view addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"TRHomeCollectionCell2" bundle:nil] forCellWithReuseIdentifier:@"TRHomeCollectionCell2"];
    self.listArray = [NSMutableArray arrayWithCapacity:0];
    self.page = 1;
    [self getdata];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           self.page = 1;
           [self.listArray removeAllObjects];
           [self getdata];
       }];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page=self.page+1;
        if (self.page>self.allpage)
        {
            [self->footer endRefreshingWithNoMoreData];
            return ;
        }
        [self getdata];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer=footer;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getdata
{
    [[DCAPIManager shareManager]person_getFoolsGoodswithcatId:self.catidStr currentPage:[NSString stringWithFormat:@"%d",self.page] firmId:self.firmStr success:^(id response) {
        NSString *allpage = [NSString stringWithFormat:@"%@",response[@"data"][@"totalPage"]];
        self.allpage = [allpage intValue];
        NSArray *arr = response[@"data"][@"pageData"];
        [self.listArray addObjectsFromArray:arr];
        [self.collectionView reloadData];
       [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
    }];
}
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.listArray.count;
}
/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRHomeCollectionCell2*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRHomeCollectionCell2" forIndexPath:indexPath];
    if (cell==nil)
    {
        cell = [[TRHomeCollectionCell2 alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.buyBtn.tag = indexPath.item;
    [cell.buyBtn addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = self.listArray[indexPath.item];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"infoImg"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@",dic[@"infoPrice"]];
    cell.priceLab = [UILabel setupAttributeLabel:cell.priceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];

    cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"infoTitle"]];
    return cell;
}
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-36)/2, 135+172*(kScreenW-36)/2/172);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    
}

- (void)buyClick:(UIButton*)btn
{
   NSDictionary *dic = self.listArray[btn.tag];
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = [NSString stringWithFormat:@"%@",dic[@"infoId"]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
