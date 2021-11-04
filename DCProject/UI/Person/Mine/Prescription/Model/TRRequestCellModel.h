//
//  TRRequestCellModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRRequestCellModel : NSObject
@property(nonatomic,copy)NSString *requireAmount;//金额要求
@property(nonatomic,copy)NSString *discountAmount;//金额要求
@property(nonatomic,copy)NSString *goodsTotalPrice;//商品总价
@property(nonatomic,copy)NSString *discAfterTotalPrice;//活动总价
@property(nonatomic,strong)NSArray *actCartGoodsList;//活动商品列表
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
