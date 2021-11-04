//
//  TRStoreActivityModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRStoreActivityModel : NSObject
@property(nonatomic,copy)NSString *actTitle;//商品名称
@property(nonatomic,copy)NSString *actImg;//商品图片
@property(nonatomic,copy)NSString *actEtime;//活动结束时间
@property(nonatomic,copy)NSString *id;//活动id
@property(nonatomic,copy)NSString *joinNum;//参加数量
@property(nonatomic,copy)NSString *goodsId;//商品id
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
