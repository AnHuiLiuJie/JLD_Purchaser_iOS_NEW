//
//  QJRefreshManager.h
//  QJStore
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN
@interface DCRefreshTool : NSObject

/// 创建单列
+ (DCRefreshTool *)shareTool;



/*!
 *@brief  默认下拉刷新：纯文字
 *
 *@param  block   下拉刷新回调方法
 *
 */
- (MJRefreshNormalHeader *)headerDefaultWithBlock:(dispatch_block_t)block;



/*!
 *@brief  默认上拉加载更多：纯文字
 *
 *@param  block   上拉加载回调方法
 *
 */
- (MJRefreshAutoNormalFooter *)footerDefaultWithBlock:(dispatch_block_t)block;



/*!
 *@brief  下拉刷新：gif
 *
 *@param  block   上拉加载回调方法
 *
 */
- (MJRefreshGifHeader *)headerGifWithBlock:(dispatch_block_t)block;


//#pragma mark -  下拉刷新：gif
- (MJRefreshGifHeader *)headerGifWithIsFirstRefresh:(BOOL)isFirstRefresh block:(dispatch_block_t)block;



/*!
 *@brief  默认下拉刷新：纯文字
 *
 *@param  block   下拉刷新回调方法
 *
 *@param  isFirstRefresh   是否第一次添加时就刷新
 */
- (MJRefreshNormalHeader *)headerDefaultWithIsFirstRefresh:(BOOL)isFirstRefresh block:(dispatch_block_t)block;



@end
NS_ASSUME_NONNULL_END
