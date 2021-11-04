//
//  GLBHomeHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/7/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBHomeHeadView.h"

#import "DCTitleRolling.h"

static NSString *const listCellID = @"UICollectionViewCell";

@interface GLBHomeHeadView ()<UICollectionViewDelegate,UICollectionViewDataSource,CDDRollingDelegate>
{
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) DCTitleRolling *titleView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSMutableArray<GLBAdvModel *> *dataArray;

@end

@implementation GLBHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.titles = @[@"热卖上新",@"中药材",@"药集采",@"领券中心",@"优惠促销",@"药资讯",@"药招标",@"药健康",@"药种植",@"药交会"];
    self.images = @[@"rmsx",@"zyyp",@"ycj",@"lqzx",@"yhcx",@"ydyzx",@"yzb",@"yjk",@"yzz",@"yjy"];
    
    CGFloat spacing = 10;
    _itemW = kScreenW / 5;
    _itemH = _itemW;
    
    WEAKSELF;
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.48*kScreenW)];
    _scrollView.placeholderImage = [UIImage imageNamed:@"ppic1"];
    _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        // 按钮点击
        if (weakSelf.bannerViewBlock) {
            weakSelf.bannerViewBlock(weakSelf.dataArray[currentIndex]);
        }
    };
    [self addSubview:_scrollView];
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    flowLayout.minimumLineSpacing = spacing;
    flowLayout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _scrollView.dc_height + 10, kScreenW, _itemH*2 + spacing) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self addSubview:_collectionView];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame) + 10, kScreenW , 1)];
    _line.backgroundColor = [UIColor dc_colorWithHexString:@"#F5F7F7"];
    [self addSubview:_line];
    
    NSArray *titles = @[@""];
    
    [_titleView removeFromSuperview];//先移除  再添加  待优化
    _titleView = [[DCTitleRolling alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_line.frame), kScreenW - 5 , 32) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
        *rollingTime = 0.25;
        *rollingGroupStyle = CDDRollingOneGroup;
        *rolTags = nil;
        *rolTitles = titles;
        *leftImage = @"yyzx";
        *interval = 6.0;
        *titleFont = 12;
        *isShowTagBorder = YES;
        *titleColor = [UIColor dc_colorWithHexString:@"#000000"];
        *rightbuttonTitle = @"更多";
    }];
    _titleView.delegate = self;
    [_titleView dc_beginRolling];
    _titleView.backgroundColor = [UIColor clearColor];
    [_titleView.rightButton addTarget:self action:@selector(moteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleView];
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UIImageView class]]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
        titleLabel.font = [UIFont fontWithName:PFRMedium size:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        
        CGFloat width = _itemW;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.centerX);
            make.width.height.equalTo(width*0.52);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.bottom);
            make.left.equalTo(cell.contentView.left);
            make.right.equalTo(cell.contentView.right);
            make.top.equalTo(imageView.bottom).offset(10);
        }];
    }
    
    UIImageView *image = cell.contentView.subviews.lastObject;
    image.image = [UIImage imageNamed:self.images[indexPath.item]];
    
    UILabel *titleLabel = cell.contentView.subviews.firstObject;
    titleLabel.text = self.titles[indexPath.item];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_homeHeadViewBlock) {
        _homeHeadViewBlock(indexPath.row);
    }
}


#pragma mark - <CDDRollingDelegate>
- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index{
    NSLog(@"index - %ld",(long)index);
    if (_newsBlock) {
        _newsBlock(_newsArray[index]);
    }
}


- (void)moteBtnAction:(UIButton *)button
{
    
    if (_moreBtnBlock) {
        _moreBtnBlock();
    }
}


#pragma mark - setter
- (void)setBannerArray:(NSMutableArray<GLBAdvModel *> *)bannerArray
{
    _bannerArray = bannerArray;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_bannerArray];
    
    NSMutableArray *images = [NSMutableArray array];
    [_bannerArray enumerateObjectsUsingBlock:^(GLBAdvModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *imageUrl = obj.adContent;
        if (!imageUrl || [imageUrl dc_isNull]) {
            imageUrl = @"";
        }
        [images addObject:imageUrl];
    }];
    
    _scrollView.imageURLStringsGroup = nil;
    _scrollView.imageURLStringsGroup = images;
}


- (void)setNewsArray:(NSMutableArray<GLBNewsModel *> *)newsArray
{
    _newsArray = newsArray;
    
    NSMutableArray *titles = [NSMutableArray array];
    [_newsArray enumerateObjectsUsingBlock:^(GLBNewsModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *title = obj.infoTitle;
        if (!title || [title dc_isNull] || title.length == 0) {
            title = obj.newsTitle;
        }
        [titles addObject:title];
    }];
    
    
    [_titleView removeFromSuperview];//先移除  再添加  待优化
    _titleView = [[DCTitleRolling alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_line.frame), kScreenW - 5 , 32) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
        *rollingTime = 0.25;
        *rollingGroupStyle = CDDRollingOneGroup;
        *rolTags = nil;
        *rolTitles = titles;
        *leftImage = @"yyzx";
        *interval = 6.0;
        *titleFont = 12;
        *isShowTagBorder = YES;
        *titleColor = [UIColor dc_colorWithHexString:@"#000000"];
        *rightbuttonTitle = @"更多";
    }];
    _titleView.delegate = self;
    [_titleView dc_beginRolling];
    _titleView.backgroundColor = [UIColor clearColor];
    [_titleView.rightButton addTarget:self action:@selector(moteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_titleView];
}


#pragma mark - lazy load
- (NSMutableArray<GLBAdvModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
