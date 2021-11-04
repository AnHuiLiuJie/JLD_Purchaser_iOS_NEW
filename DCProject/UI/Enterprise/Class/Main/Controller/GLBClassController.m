//
//  GLBClassHomeController.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBClassController.h"

#import "GLBClassTypeCell.h"
#import "GLBClassNavigationBar.h"

#import "WSLWaterFlowLayout.h"

#import "GLBGoodsListController.h"
#import "GLBSearchPageController.h"

static NSString *const typeCellID = @"GLBClassTypeCell";
static NSString *const goodsCellID = @"UICollectionViewCell";
static NSString *const sectionID = @"UICollectionReusableView";

@interface GLBClassController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSLWaterFlowLayoutDelegate>
{
    CGFloat _itemW;
}

@property (nonatomic, strong) GLBClassNavigationBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WSLWaterFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<GLBTypeModel *> *typeArray;
@property (nonatomic, strong) NSMutableArray<GLBTypeModel *> *dataArray;

@property (nonatomic, assign) NSInteger selectIndex; //选中的类型 默认0

@end

@implementation GLBClassController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self requestDrugTypeData];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBClassTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellID forIndexPath:indexPath];
    [cell setValueWithTitles:self.typeArray indexPath:indexPath selectIndex:self.selectIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectIndex) {
        return;
    }
    
    self.selectIndex = indexPath.row;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[self.typeArray[indexPath.row] son]];
    
    [self.collectionView scrollsToTop];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 0 : [[self.dataArray[section - 1] son] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellID forIndexPath:indexPath];
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UIImageView class]]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F7F7"];
        [titleLabel dc_cornerRadius:3];
        [cell.contentView addSubview:titleLabel];
    }
    
    NSArray *array = [self.dataArray[indexPath.section - 1] son];
    GLBTypeModel *model = array[indexPath.item];
    
    UILabel *titleLabel = cell.contentView.subviews.firstObject;
    titleLabel.text = model.catName;
    
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(kScreenW - self.tableView.dc_width - 20*2 - 10, 26)].width + 10;
    
    NSLog(@" --- %lf",width);
    
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
        make.width.equalTo(width);
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GLBGoodsListController *vc = [GLBGoodsListController new];
    vc.catIds = [self.typeArray[_selectIndex] catId];
    vc.typeModel = self.dataArray[indexPath.section - 1];
    [self dc_pushNextController:vc];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.collectionView.dc_width, 44.0);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        return [UICollectionReusableView new];
    }
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID forIndexPath:indexPath];
    
    for (id class in header.subviews) {
        [class removeFromSuperview];
    }

    UILabel *titleLabel = [[UILabel alloc] init];
    [header addSubview:titleLabel];
    if (indexPath.section == 0) {
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    } else {
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#B8B8B8"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    }
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = [UIColor dc_colorWithHexString:@"#B3B3B3"];
    countLabel.font = [UIFont fontWithName:PFRMedium size:12];
    countLabel.textAlignment = NSTextAlignmentRight;
    [header addSubview:countLabel];
    
    if (indexPath.section == 0) {
        
        if ([self.typeArray count] > 0) {
            GLBTypeModel *typeModel = self.typeArray[self.selectIndex];
            titleLabel.text = [NSString stringWithFormat:@"%@全部",typeModel.catName];
            countLabel.text = [NSString stringWithFormat:@"%ld种",(long)typeModel.goodsNum];
        }
        
    } else {
        
        GLBTypeModel *model = self.dataArray[indexPath.section - 1];
        titleLabel.text = model.catName;
        countLabel.text = [NSString stringWithFormat:@"%ld种",(long)model.goodsNum];
    }
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.centerY);
        make.right.equalTo(header.right).offset(-10);
        make.width.equalTo(100);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.left).offset(20);
        make.centerY.equalTo(header.centerY);
        make.right.equalTo(countLabel.left);
    }];
    
    return header;
}


#pragma mark - <WSLWaterFlowLayoutDelegate>
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = [self.dataArray[indexPath.section - 1] son];
    GLBTypeModel *model = array[indexPath.item];
    
   CGSize size = [model.catName boundingRectWithSize:CGSizeMake(kScreenW - self.tableView.dc_width - 20*2 - 10, 26) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:12]} context:nil].size;
    return CGSizeMake(size.width + 10, 26);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.dc_width, 44.0);
}

/** 列间距*/
- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10.0;
}

/** 行间距*/
- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10.0f;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}


#pragma mark - 获取药品分类
- (void)requestDrugTypeData
{
    [self.typeArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDrugTypeWithCatIds:@"0" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.typeArray addObjectsFromArray:response];
            if (weakSelf.typeArray.count > 0) {
                [weakSelf.dataArray addObjectsFromArray:[weakSelf.typeArray[0] son]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, 80, kScreenH - kNavBarHeight - kTabBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        
        [_tableView registerClass:NSClassFromString(typeCellID) forCellReuseIdentifier:typeCellID];
    }
    return _tableView;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
//        CGFloat spacing = 6;
//        CGFloat itemW = (kScreenW - self.tableView.dc_width - spacing *2 - 20*2)/3;
//        CGFloat itemH = itemW + 20;
//
//        _itemW = itemW;
        
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.itemSize = CGSizeMake(itemW, itemH);
//        flowLayout.minimumLineSpacing = 15;
//        flowLayout.minimumInteritemSpacing = spacing;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 19, 0, 19);
        
        _flowLayout = [[WSLWaterFlowLayout alloc] init];
        _flowLayout.delegate = self;
        _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), kScreenW - CGRectGetMaxX(self.tableView.frame), CGRectGetHeight(self.tableView.frame)) collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:NSClassFromString(goodsCellID) forCellWithReuseIdentifier:goodsCellID];
        [_collectionView registerClass:NSClassFromString(sectionID) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID];
    }
    return _collectionView;
}

- (GLBClassNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBClassNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _navBar.searchBlock = ^{
            [weakSelf dc_pushNextController:[GLBSearchPageController new]];
        } ;
    }
    return _navBar;
}

- (NSMutableArray<GLBTypeModel *> *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (NSMutableArray<GLBTypeModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
