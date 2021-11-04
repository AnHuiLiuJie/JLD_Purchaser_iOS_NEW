//
//  GLBBatchModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBBatchModel : NSObject

@property (nonatomic, copy) NSString *batchId; // 批次ID
@property (nonatomic, copy) NSString *batchNum; // 批次编码
@property (nonatomic, copy) NSString *isSale; // 是否促销 1:促销<若为1则取促销价显示，拆零、整件价加上横杠或黑色处理,非1取拆零和整件>
@property (nonatomic, assign) CGFloat saleWholePrice; // 整件促销价<若当前商品促销，取该价格>
@property (nonatomic, assign) CGFloat saleZeroPrice; // 拆零促销价<若当前商品促销，取该价格>
@property (nonatomic, assign) CGFloat wholePrice; // 整件价<若当前商品非促销，取该价格，促销价不显示>
@property (nonatomic, assign) CGFloat zeroPrice; // 拆零价<若当前商品非促销，取该价格，促销价不显示>
@property (nonatomic, strong) NSArray *batchList;
@property (nonatomic, copy) NSString *stock; // 批次库存量
@property (nonatomic, copy) NSString *effectTime; // 有效期至

@end



@interface GLBBatchListModel : NSObject

@property (nonatomic, copy) NSString *batchId; // 批次ID
@property (nonatomic, copy) NSString *batchNum; // 批次编码

@end


NS_ASSUME_NONNULL_END
