//
//  DCAPIManager+Activity.h
//  DCProject
//
//  Created by LiuMac on 2021/9/16.
//

#import "DCAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager (Activity)


#pragma mark -秒杀商品列表
- (void)person_b2c_activity_seckillWithCurrentPage:(NSString *)currentPage
                                              type:(NSString *)type
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark -秒杀商品详情，只查询跟秒杀相关的信息
- (void)person_b2c_activity_seckill_detailWithBatchId:(NSString *)batchId
                                              goodsId:(NSString *)goodsId
                                            seckillId:(NSString *)seckillId
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture;

#pragma mark -秒杀订阅
- (void)person_b2c_activity_seckill_subscribeWithBatchId:(NSString *)batchId
                                                 goodsId:(NSString *)goodsId
                                               seckillId:(NSString *)seckillId
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture;

#pragma mark -获取秒杀Tab
- (void)person_b2c_activity_seckill_tabWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark -拼团列表
- (void)person_b2c_activity_collageWithCurrentPage:(NSString *)currentPage
                                            joinId:(NSString *)joinId
                                           orderNo:(NSString *)orderNo
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark -拼团详情，只查询跟拼团相关的信息
- (void)person_b2c_activity_collage_detailWithBatchId:(NSString *)batchId
                                              goodsId:(NSString *)goodsId
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture;

#pragma mark -我的拼团列表
- (void)person_b2c_activity_collage_mycollageWithCurrentPage:(NSString *)batchId
                                                      joinId:(NSString *)joinId
                                                     orderNo:(NSString *)orderNo
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;

#pragma mark -我的拼团详情
- (void)person_b2c_activity_collage_mycollageDetailWithCurrentPage:(NSString *)batchId
                                                            joinId:(NSString *)joinId
                                                           orderNo:(NSString *)orderNo
                                                           success:(DCSuccessBlock)success
                                                          failture:(DCFailtureBlock)failture;
@end

NS_ASSUME_NONNULL_END
