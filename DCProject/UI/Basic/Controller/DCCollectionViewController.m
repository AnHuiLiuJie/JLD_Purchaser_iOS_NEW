//
//  DCCollectionViewController.m
//  DCProject
//
//  Created by bigbing on 2019/5/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCCollectionViewController.h"
#import "DCRefreshTool.h"

@interface DCCollectionViewController ()

@property (nonatomic, strong) UIView *noDataView;


@end

@implementation DCCollectionViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = nil;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - 点击按钮
- (void)noDataBtnClick:(UIButton *)button
{
    
}


#pragma mark -  添加刷新
- (void)addRefresh:(BOOL)isBegin
{
    [self addHeaderRefresh:isBegin];
    [self addFooterRefresh];
}


#pragma mark -  添加刷新 下拉
- (void)addHeaderRefresh:(BOOL)isBegin
{
    WEAKSELF;
    self.collectionView.mj_header = [[DCRefreshTool shareTool] headerGifWithIsFirstRefresh:isBegin block:^{
        [weakSelf loadNewCollectData:nil];
    }];
}

#pragma mark -  添加刷新 上拉
- (void)addFooterRefresh
{
    WEAKSELF;
    self.collectionView.mj_footer = [[DCRefreshTool shareTool] footerDefaultWithBlock:^{
        [weakSelf loadMoreCollectData:nil];
    }];
}


#pragma mark - 下拉刷新
- (void)loadNewCollectData:(id _Nullable)sender{
    
}

#pragma mark - 上拉加载更多
- (void)loadMoreCollectData:(id _Nullable)sender{
    
}

#pragma mark -  移除刷新
- (void)removeRefresh{
    
    [self endRefresh];
    
    [self.collectionView.mj_header removeFromSuperview];
    [self.collectionView.mj_footer removeFromSuperview];
}

#pragma mark - 结束刷新
- (void)endRefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark -  刷新CollectionView
- (void)reloadCollectionViewWithDatas:(NSArray *)datas hasNextPage:(BOOL)hasNextPage{
    
    [self endRefresh];
    
    if (datas && [datas count]>0) {
        
        self.noDataView.hidden = YES;
        
        if (!hasNextPage) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.collectionView.mj_footer.hidden = NO;
        
    }else {
        
        if (![self.view.subviews containsObject:self.noDataView] && !_isHiddenTip) {
            [self.view insertSubview:self.noDataView aboveSubview:self.collectionView];
            
            if (CGRectEqualToRect(self.noDataView.frame, CGRectZero)) {
                self.noDataView.frame = self.collectionView.frame;
                self.noDataImg.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y - kNavBarHeight/2);
                self.noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noDataImg.frame) + 10, kScreenW, 20);
                self.noDataBtn.frame = CGRectMake((self.collectionView.dc_width - 120)/2, CGRectGetMaxY(self.noDataLabel.frame) + 20, 120, 44);
            }
        }
        self.noDataView.hidden = NO;
        
        self.collectionView.mj_footer.hidden = YES;
    }
    
    [self.collectionView reloadData];
}


#pragma mark - lazy load
- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectZero];
        _noDataView.backgroundColor = [UIColor whiteColor];
        
        [_noDataView addSubview:self.noDataImg];
        [_noDataView addSubview:self.noDataLabel];
        [_noDataView addSubview:self.noDataBtn];
    }
    return _noDataView;
}

- (UIImageView *)noDataImg{
    if (!_noDataImg) {
        _noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW *0.36, kScreenW *0.36)];
        _noDataImg.image = [UIImage imageNamed:@"none"];
    }
    return _noDataImg;
}

- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noDataImg.frame) + 10, kScreenW, 20);
//        _noDataLabel.text = @"暂无数据~";
        _noDataLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _noDataLabel.font = PFRFont(14);
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}

- (UIButton *)noDataBtn{
    if (!_noDataBtn) {
        _noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noDataBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#3B95FF"];
        [_noDataBtn setTitleColor:[UIColor whiteColor] forState:0];
        _noDataBtn.titleLabel.font = PFRFont(14);
        [_noDataBtn addTarget:self action:@selector(noDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataBtn dc_cornerRadius:22];
        _noDataBtn.hidden = YES;
    }
    return _noDataBtn;
}

- (void)setIsHiddenTip:(BOOL)isHiddenTip
{
    _isHiddenTip = isHiddenTip;
}
@end
