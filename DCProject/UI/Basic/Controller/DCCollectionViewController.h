//
//  DCCollectionViewController.h
//  DCProject
//
//  Created by bigbing on 2019/5/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface DCCollectionViewController : DCBasicViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 tableView
 */
@property (nonatomic, strong) UICollectionView *_Nullable collectionView;


/**
 是否隐藏无数据提示 default NO
 */
@property (nonatomic, assign) BOOL isHiddenTip;

// 无数据提示图片
@property (nonatomic, strong) UIImageView *noDataImg;
// 无数据提示label
@property (nonatomic, strong) UILabel *noDataLabel;
// 无数据提示按钮
@property (nonatomic, strong) UIButton *noDataBtn;


/// 添加 上拉刷新 + 下拉加载更多
- (void)addRefresh:(BOOL)isBegin;

/// 添加 下拉刷新
- (void)addHeaderRefresh:(BOOL)isBegin;

/// 添加刷新 上拉
- (void)addFooterRefresh;

/// 移除刷新
- (void)removeRefresh;

/// 结束刷新
- (void)endRefresh;

/// 下拉刷新方法
- (void)loadNewCollectData:(id _Nullable)sender;

/// 上拉加载更多方法
- (void)loadMoreCollectData:(id _Nullable)sender;

/// 自定义刷新方法  待完善
- (void)reloadCollectionViewWithDatas:(NSArray *)datas hasNextPage:(BOOL)hasNextPage;

/// 点击按钮
- (void)noDataBtnClick:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
