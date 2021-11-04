//
//  GLPClassController.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPClassController.h"

#import "GLBClassTypeCell.h"
#import "GLBClassNavigationBar.h"

#import "GLPClassController.h"
#import "TRClassGoodsVC.h"
#import "GLPSearchGoodsController.h"


static NSString *const typeCellID = @"GLBClassTypeCell";
static NSString *const goodsCellID = @"UICollectionViewCell";
static NSString *const sectionID = @"UICollectionReusableView";

@interface GLPClassController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _itemW;
}

@property (nonatomic, strong) GLBClassNavigationBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<GLPClassModel *> *typeArray;
@property (nonatomic, strong) NSMutableArray<GLPClassModel *> *dataArray;

@property (nonatomic, assign) NSInteger selectIndex; //选中的类型 默认0

@end

@implementation GLPClassController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dc_statusBarStyle:UIStatusBarStyleDefault];

    if (self.navigationController.childViewControllers.count < 2) {
        [self dc_navBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.childViewControllers.count < 2) {
        [self dc_navBarHidden:NO];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    if (self.navigationController.childViewControllers.count < 2) {
        [self.view addSubview:self.navBar];
        [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.top.equalTo(self.view.top);
            make.height.equalTo(kNavBarHeight);
        }];
    } else {
        self.navigationItem.title = @"商品分类";
    }
    
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
    [cell setPersonValueWithTitles:self.typeArray indexPath:indexPath selectIndex:self.selectIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectIndex) {
        return;
    }
    
    self.selectIndex = indexPath.row;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[self.typeArray[indexPath.row] son]];
    
//    [self.collectionView scrollsToTop];//这个属性默认是开启的，然而失效的原因是一个Controller里包含两个以上（含两个）scrollView的时候，需要将其他几个scrollView的scrollsToTop属性设置为NO 将你需要的置为YES即可解决。
    [_collectionView setContentOffset:CGPointMake(0,0)animated:NO];

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
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont fontWithName:PFR size:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.clipsToBounds = YES;
        [cell.contentView addSubview:image];
        
        CGFloat width = _itemW;
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.centerX);
            make.top.equalTo(cell.contentView.top);
            make.width.equalTo(width);
            make.height.equalTo(width*0.75);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.bottom).offset(10);
            make.left.equalTo(image.left);
            make.right.equalTo(image.right);
        }];
    }
    
    NSArray *array = [self.dataArray[indexPath.section - 1] son];
    GLPClassModel *model = array[indexPath.item];
    
    UILabel *titleLabel = cell.contentView.subviews.firstObject;
    titleLabel.text = model.catName;
    
    UIImageView *image = cell.contentView.subviews.lastObject;
    [image sd_setImageWithURL:[NSURL URLWithString:model.catPic] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.dataArray[indexPath.section - 1] son];
    GLPClassModel *model = array[indexPath.item];
    TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
    vc.classId = [NSString stringWithFormat:@"%ld",model.catId];
    vc.goodsTagNameList = [NSString stringWithFormat:@"%@",model.catName];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.dc_width, 44.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        return [UICollectionReusableView new];
    }
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID forIndexPath:indexPath];
    
    for (id class in header.subviews) {
        [class removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.backgroundColor = [UIColor dc_colorWithHexString:@"#FFF9E6"];
        [header addSubview:bgImage];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF7A25"];
        titleLabel.font = PFRFont(18);
        [header addSubview:titleLabel];
        
        [bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header);
        }];
        
        
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(header.centerY);
        }];
        
        if ([self.typeArray count] > 0) {
            GLPClassModel *classModel = self.typeArray[self.selectIndex];
            titleLabel.text = [NSString stringWithFormat:@"%@",classModel.catName];
        }
        
    } else {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
        [header addSubview:titleLabel];
        
        [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header.left).offset(15);
            make.centerY.equalTo(header.centerY);
        }];
        
        GLPClassModel *model = self.dataArray[indexPath.section - 1];
        titleLabel.text = model.catName;
    }
    
    return header;
}


#pragma mark - 获取药品分类
- (void)requestDrugTypeData
{
    [self.typeArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [SVProgressHUD show];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestGoodsClassWithCatIds:@"0" success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.typeArray addObjectsFromArray:response];
            if (weakSelf.typeArray.count > 0) {
                [weakSelf.dataArray addObjectsFromArray:[weakSelf.typeArray[0] son]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];
        [SVProgressHUD dismiss];
    } failture:^(NSError *_Nullable error) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {

        
        CGFloat height = self.navigationController.childViewControllers.count > 1 ? 0 : kTabBarHeight;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, 80, kScreenH - kNavBarHeight - height) style:UITableViewStylePlain];
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
        
        CGFloat spacing = 6;
        CGFloat itemW = (kScreenW - self.tableView.dc_width - spacing *2 - 20*2)/3;
        CGFloat itemH = itemW + 20;
        
        _itemW = itemW;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = spacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 19, 0, 19);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableView.frame), CGRectGetMinY(self.tableView.frame), kScreenW - CGRectGetMaxX(self.tableView.frame), CGRectGetHeight(self.tableView.frame)) collectionViewLayout:flowLayout];
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
            [weakSelf dc_pushNextController:[GLPSearchGoodsController new]];
        };
    }
    return _navBar;
}

- (NSMutableArray<GLPClassModel *> *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (NSMutableArray<GLPClassModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
