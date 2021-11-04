//
//  QJRefreshManager.m
//  QJStore
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "DCRefreshTool.h"

@interface DCRefreshTool ()

@property (nonatomic, strong) NSArray *gifImgs;

@end

@implementation DCRefreshTool


+ (DCRefreshTool *)shareTool{
    static DCRefreshTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark -  默认下拉刷新：纯文字
- (MJRefreshNormalHeader *)headerDefaultWithBlock:(dispatch_block_t)block
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.stateLabel.font = [UIFont fontWithName:PFR size:12];
    header.stateLabel.textColor = [UIColor dc_colorWithHexString:@"#8C9198" alpha:1]; // #8C9198
    header.lastUpdatedTimeLabel.hidden = YES; // 隐藏时间
    [header beginRefreshing];
    
    return header;
}


#pragma mark -  默认下拉刷新：纯文字
- (MJRefreshNormalHeader *)headerDefaultWithIsFirstRefresh:(BOOL)isFirstRefresh block:(dispatch_block_t)block
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.stateLabel.font = [UIFont fontWithName:PFR size:12];
    header.stateLabel.textColor = [UIColor dc_colorWithHexString:@"#8C9198" alpha:1]; // #8C9198
    header.lastUpdatedTimeLabel.hidden = YES; // 隐藏时间
    if (isFirstRefresh) {
        [header beginRefreshing];
    }
    return header;
}


//#pragma mark -  下拉刷新：gif
- (MJRefreshGifHeader *)headerGifWithBlock:(dispatch_block_t)block
{
    if (self.gifImgs.count == 0) {
        self.gifImgs = [NSArray dc_imageWithGIF:@"00000"];
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    // 设置普通状态的动画图片
    [header setImages:self.gifImgs forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.gifImgs forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.gifImgs forState:MJRefreshStateRefreshing];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES; // 隐藏时间
    [header beginRefreshing];
    
    return header;
}


//#pragma mark -  下拉刷新：gif
- (MJRefreshGifHeader *)headerGifWithIsFirstRefresh:(BOOL)isFirstRefresh block:(dispatch_block_t)block
{
    if (self.gifImgs.count == 0) {
        self.gifImgs = [NSArray dc_imageWithGIF:@"00000"];
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    // 设置普通状态的动画图片
    [header setImages:self.gifImgs forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.gifImgs forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.gifImgs forState:MJRefreshStateRefreshing];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES; // 隐藏时间
    if (isFirstRefresh) {
        [header beginRefreshing];
    }
    
    return header;
}



#pragma mark - 默认上拉加载更多：纯文字
- (MJRefreshAutoNormalFooter *)footerDefaultWithBlock:(dispatch_block_t)block
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    footer.stateLabel.font = [UIFont fontWithName:PFR size:12];
    footer.stateLabel.textColor = [UIColor dc_colorWithHexString:@"#8C9198" alpha:1]; // #8C9198
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    footer.hidden = YES;
    return footer;
}



@end
