//
//  DCAPIManager+Activity.m
//  DCProject
//
//  Created by LiuMac on 2021/9/16.
//

#import "DCAPIManager+Activity.h"

@implementation DCAPIManager (Activity)


#pragma mark -秒杀商品列表
- (void)person_b2c_activity_seckillWithCurrentPage:(NSString *)currentPage
                                              type:(NSString *)type
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage,@"type":type};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/seckill" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -秒杀商品详情，只查询跟秒杀相关的信息
- (void)person_b2c_activity_seckill_detailWithBatchId:(NSString *)batchId
                                              goodsId:(NSString *)goodsId
                                            seckillId:(NSString *)seckillId
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"batchId":batchId,@"goodsId":goodsId,@"seckillId":seckillId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/seckill/detail" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -秒杀订阅
- (void)person_b2c_activity_seckill_subscribeWithBatchId:(NSString *)batchId
                                                 goodsId:(NSString *)goodsId
                                               seckillId:(NSString *)seckillId
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"batchId":batchId,@"goodsId":goodsId,@"seckillId":seckillId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/seckill/subscribe" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -获取秒杀Tab
- (void)person_b2c_activity_seckill_tabWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/seckill/tab" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -拼团列表
- (void)person_b2c_activity_collageWithCurrentPage:(NSString *)currentPage
                                            joinId:(NSString *)joinId
                                           orderNo:(NSString *)orderNo
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage,@"joinId":joinId,@"orderNo":orderNo};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/collage" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -拼团详情，只查询跟拼团相关的信息
- (void)person_b2c_activity_collage_detailWithBatchId:(NSString *)batchId
                                              goodsId:(NSString *)goodsId
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"batchId":batchId,@"goodsId":goodsId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/collage/detail" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -我的拼团列表
- (void)person_b2c_activity_collage_mycollageWithCurrentPage:(NSString *)currentPage
                                                      joinId:(NSString *)joinId
                                                     orderNo:(NSString *)orderNo
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage,@"joinId":joinId,@"orderNo":orderNo};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/collage/mycollage" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark -我的拼团详情
- (void)person_b2c_activity_collage_mycollageDetailWithCurrentPage:(NSString *)currentPage
                                                            joinId:(NSString *)joinId
                                                           orderNo:(NSString *)orderNo
                                                           success:(DCSuccessBlock)success
                                                          failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage,@"joinId":joinId,@"orderNo":orderNo};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/collage/mycollageDetail" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

@end
