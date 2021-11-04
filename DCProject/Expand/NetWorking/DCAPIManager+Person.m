//
//  DCAPIManager+Person.m
//  DCProject
//
//  Created by bigbing on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAPIManager+Person.h"

#import "GLPAdModel.h"
#import "GLPHomeDataModel.h"
#import "GLPGoodsEvaluateModel.h"
#import "GLPGoodsQusetionModel.h"
#import "GLPGoodsDetailModel.h"
#import "GLPGoodsAddressModel.h"
#import "GLPGoodsSimilarModel.h"
#import "GLPGoodsMatchModel.h"
#import "GLPGoodsLickModel.h"
#import "GLPGoodsTicketModel.h"
#import "GLPShoppingCarModel.h"
#import "GLPClassModel.h"
#import "GLPSearchHotGoodsModel.h"
#import "GLPMineCollectModel.h"
#import "GLPMineSeeModel.h"
#import "GLPTicketSgnModel.h"


@implementation DCAPIManager (Person)

#pragma mark - 广告位
- (void)person_requestAdvWithAdCode:(NSString *)adCode
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"adCode":adCode};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/info/ad" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPAdModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            //failture(error);
        }
    }];
}


#pragma mark - 首页推荐位
- (void)person_requestHomeRecommendWithZoneCode:(NSString *)zoneCode
                                           type:(NSString *)type
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"zoneCode":zoneCode,@"type":type};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/recomm" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPHomeDataModel *homeDataModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                homeDataModel = [GLPHomeDataModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(homeDataModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 首页主页面几个(中间广告位,季节数据,热销数据 4个楼层 热点推荐)合集
- (void)person_requestHomeMainAllListWithsuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/recomm/index" params:@{} httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPHomeNewDataModel *homeDataModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                homeDataModel = [GLPHomeNewDataModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(homeDataModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取用户推广类型 0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】
- (void)person_requestHomeRecommendTypeSuccess:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/pioneer/extend_type" params:@{} httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dict);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取未读消息数量
- (void)person_requestNoReadMsgCountWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/info/infomessage/countNoRead" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情 统一新接口
- (void)person_requestNewGoodsDetailsWithGoodsId:(NSString *)goodsId
                                         batchId:(NSString *)batchId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"id":goodsId,@"batchId":batchId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/detail" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPGoodsDetailModel *detailModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                detailModel = [GLPGoodsDetailModel mj_objectWithKeyValues:dict[@"data"]];
                NSArray *loveGoods = [GLPGoodsLickGoodsModel mj_objectArrayWithKeyValuesArray:detailModel.shopHotGoods];
                detailModel.shopHotGoods = loveGoods;
                NSArray *actModel = [GLPGoodsActivitiesModel mj_objectArrayWithKeyValuesArray:detailModel.activities];
                detailModel.activities = actModel;
            
                GLPGoodsDetailsSpecModel *attr = [GLPGoodsDetailsSpecModel  mj_objectWithKeyValues:detailModel.attr];
                GLPGoodsActivitiesModel *cModel = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attr.collageAct];
                GLPGoodsActivitiesModel *sModel = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attr.seckillAct];
                GLPGoodsActivitiesModel *gModel = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attr.group];

                NSArray *list = [GLPMarketingMixListModel mj_keyValuesArrayWithObjectArray:attr.marketingMixList];
                attr.marketingMixList = list;
                attr.collageAct = cModel;
                attr.seckillAct = sModel;
                attr.group = gModel;
                detailModel.attr = attr;
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(detailModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情:运费与默认收货地址
- (void)person_requestGoodsDetailsDefaultAddressWithAreaId:(NSString *)areaId
                                                   goodsId:(NSString *)goodsId
                                            logisticsTplId:(NSInteger)logisticsTplId
                                                  quantity:(NSInteger)quantity
                                                   success:(DCSuccessBlock)success
                                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{
        @"areaId":areaId,
        @"goodsId":goodsId,
        @"logisticsTplId":@(logisticsTplId),
        @"quantity":@(quantity)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/default" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPGoodsAddressModel *addressModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(addressModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情：购买了此商品的用户还购买了
- (void)person_requestGoodsDetailsSimliarGoodsWithGoodsId:(NSString *)goodsId
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/buyother" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPGoodsSimilarModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情：处方搭配
- (void)person_requestGoodsDetailsMatchWithGoodsCode:(NSString *)goodsCode
                                                type:(NSInteger)type
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsCode":goodsCode,
                             @"type":@(type)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/prescript" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPGoodsMatchModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 商品详情：商品评论
- (void)person_requestGoodsDetailEvaluetaWithGoodsId:(NSString *)goodsId
                                         currentPage:(NSInteger)currentPage
                                   isHaveEvalContent:(NSInteger)isHaveEvalContent
                                        sellerFirmId:(NSString *)sellerFirmId
                                                star:(NSInteger)star
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"currentPage":@(currentPage),
                             @"isHaveEvalContent":@"",
                             @"sellerFirmId":sellerFirmId,
                             @"star":@""};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/goodsEval" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPGoodsEvaluateModel *evaluateModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                evaluateModel = [GLPGoodsEvaluateModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(evaluateModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情：问答专区
- (void)person_requestGoodsDetailQuestionWithGoodsId:(NSString *)goodsId
                                                type:(NSInteger)type
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"type":@"2"};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/question" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPGoodsQusetionModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 商品详情：问答、评价、浏览此商品的用户还购买了 三合一接口
- (void)person_request_goodsInfo_detail_otherInfoWithGoodsId:(NSString *)goodsId
                                                  certifiNum:(NSString *)certifiNum
                                                 packingSpec:(NSString *)packingSpec
                                                sellerFirmId:(NSString *)sellerFirmId
                                                   goodsCode:(NSString *)goodsCode
                                            goodsTagNameList:(NSString *)goodsTagNameList
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"sellerFirmId":sellerFirmId,
                             @"certifiNum":certifiNum,
                             @"packingSpec":packingSpec,
                             @"goodsCode":goodsCode,
                             @"goodsTagNameList":goodsTagNameList
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/detail/otherInfo" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dict[@"data"]);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品详情：猜你喜欢
- (void)person_requestGoodsDetailLickWithGoodsId:(NSString *)goodsId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/love" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLPGoodsLickModel *lickModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                lickModel = [GLPGoodsLickModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(lickModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 商品优惠券
- (void)person_requestGoodsTicketWithGoodsId:(NSString *)goodsId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/goods/item" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPGoodsTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 企业店铺优惠券
- (void)person_requestStoreTicketWithFirmId:(NSString *)firmId
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/store/item" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPGoodsTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 加入购物车
- (void)person_requestAddShoppingCarWithGoodsId:(NSString *)goodsId
                                        batchId:(NSString *)batchId
                                       quantity:(NSString *)quantity
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock _Nullable)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"batchId":batchId,
                             @"quantity":quantity
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/addcart" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车列表
- (void)person_requestShoppingCarListWithSuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/getCart" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPShoppingCarModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 修改购物车商品数量
- (void)person_requestChangeShoppingCarCountWithCartId:(NSString *)cartId
                                              quantity:(NSString *)quantity
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartId":cartId,
                             @"quantity":quantity};
    
    [DC_KeyWindow dc_disable];
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/addQuantity" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        [SVProgressHUD dismiss];
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取商品分类
- (void)person_requestGoodsClassWithCatIds:(NSString *)catIds
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"catIds":catIds};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/goodsCat" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPClassModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 搜索热销商品
- (void)person_requestSearchHotGoodsWithCurrentPage:(NSInteger)currentPage
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(1)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product/hotword" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]] ) {
                    [dataArray addObjectsFromArray:[GLPSearchHotGoodsModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
                }
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 搜索商品联想
- (void)person_requestSearchWordWithSearchName:(NSString *)searchName
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"searchName":searchName};
    
    //    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product/word" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 搜索商品联想
- (void)person_requestSearchWordKeyWithKey:(NSString *)keyStr
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"key":keyStr};
    
    //    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product/dropdown" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 收藏的商品列表
- (void)person_requestCollectGoodsListWithCurrentPage:(NSInteger)currentPage
                                            goodsName:(NSString *)goodsName
                                              success:(DCMoreListSuccessBlock)success
                                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"goodsName":goodsName};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/goods" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        CommonListModel *commonModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLPMineCollectModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
                }
                commonModel = [CommonListModel mj_objectWithKeyValues:dict[@"data"]];
                
                NSInteger totalPage = [dict[@"data"][@"totalPage"] integerValue];
                if (totalPage > 0 && totalPage > currentPage) {
                    hasNextPage = YES;
                }
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray,hasNextPage,commonModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 浏览记录列表
- (void)person_requestSeeGoodsListWithCurrentPage:(NSInteger)currentPage
                                          success:(DCMoreListSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/accesses" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        CommonListModel *commonModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                commonModel = [CommonListModel mj_objectWithKeyValues:dict[@"data"]];
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLPMineSeeModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
                }
                
                NSInteger totalPage = [dict[@"data"][@"totalPage"] integerValue];
                if (totalPage > 0 && totalPage > currentPage) {
                    hasNextPage = YES;
                }
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray,hasNextPage,commonModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 添加浏览记录
- (void)person_requestAddSeeCountWithGoodsId:(NSString *)goodsId
                                   goodsName:(NSString *)goodsName
                                  goodsTitle:(NSString *)goodsTitle
                                     linkUrl:(NSString *)linkUrl
                                sellerFirmId:(NSInteger)sellerFirmId
                              sellerFirmName:(NSString *)sellerFirmName
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"goodsName":goodsName,
                             @"goodsTitle":goodsTitle,
                             @"linkUrl":linkUrl,
                             @"sellerFirmId":@(sellerFirmId),
                             @"sellerFirmName":sellerFirmName
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/accesses/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 查看商品规格 新接口
- (void)person_requestGetNewGoodSpecByGoodsId:(NSString *)goodsId
                                   certifiNum:(NSString *)certifiNum
                                 sellerFirmId:(NSString *)sellerFirmId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"certifiNum":certifiNum,@"sellerFirmId":sellerFirmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/attrs" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict[@"data"]);
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 查看商品规格
- (void)person_requestGetGoodSpecByGoodsId:(NSString *)goodsId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goods/view/attrs" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict[@"data"]);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 删除浏览记录
- (void)person_requestDeleteSeeRecordWithAccessIds:(NSString *)accessIds
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"accessIds":accessIds};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/accesses/remove" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车券列表
- (void)person_requestShoppingCarTicketWithFirmId:(NSString *)firmId
                                         goodsIds:(NSString *)goodsIds
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"goodsIds":goodsIds};
    [SVProgressHUD show];
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/getCartcoup" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLPTicketSgnModel *ticketSgnModel = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]] ) {
                ticketSgnModel = [GLPTicketSgnModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(ticketSgnModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车确认提交页获取运费
- (void)person_requestShoppingCarYunfeiWithAreaId:(NSString *)areaId
                                          cartIds:(NSString *)cartIds
                                     sellerFirmId:(NSString *)sellerFirmId
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"areaId":areaId,
                             @"cartIds":cartIds,
                             @"sellerFirmId":sellerFirmId
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/getTrans" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(dict);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 提交订单
- (void)person_requestOrderCommintWithEntrance:(NSString *)entrance
                                        addrId:(NSString *)addrId
                                       cartIds:(NSString *)cartIds
                                sellerFirmList:(NSArray *)sellerFirmList
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"entrance":entrance,
                             @"cartIds":cartIds,
                             @"addrId":addrId,
                             @"sellerFirmList":sellerFirmList
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/submit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 请求 用户通过购物车确认订单（需求清单）Dynamic wallpaper engine
- (void)person_requestCartNotarizeWithCartIds:(NSString *)cartIds
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartIds":cartIds};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/cartNotarize" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车提交订单接口(新)
- (void)person_requestShoppingCarCommintWithAaddrId:(NSString *)addrId
                                            cartIds:(NSString *)cartIds
                                     sellerFirmList:(NSArray *)sellerFirmList
                                             drugId:(NSString *)drugId
                                    prescriptionImg:(NSString *)prescriptionImg
                                           billDesc:(NSString *)billDesc
                                             supUrl:(NSString *)supUrl
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartIds":cartIds,
                             @"addrId":addrId,
                             @"sellerFirmList":sellerFirmList,
                             @"drugId":drugId,
                             @"prescriptionImg":prescriptionImg,
                             @"supUrl":supUrl,
                             @"billDesc":billDesc};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/appSubmit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - (立即购买)提交订单接口(新)
- (void)person_buyNowWidthGoodsId:(NSString *)goodsId
                         quantity:(NSString *)quantity
                           addrId:(NSString *)addrId
                         leaveMsg:(NSString *)leaveMsg
                         couponId:(NSString *)couponId
                          buytype:(nonnull NSString *)type
                           drugId:(NSString *)drugId
                          symptom:(NSString *)symptom
                  prescriptionImg:(NSString *)prescriptionImg
                         billDesc:(NSString *)billDesc
                           supUrl:(NSString *)supUrl
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"quantity":quantity,
                             @"addrId":addrId,
                             @"leaveMsg":leaveMsg,
                             @"couponId":couponId,
                             @"buyType":type,
                             @"drugId":drugId,
                             @"symptom":symptom,
                             @"prescriptionImg":prescriptionImg,
                             @"supUrl":supUrl,
                             @"billDesc":billDesc};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/buyNowAppSubmit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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


#pragma mark - 退出登录
- (void)person_requestLogoutWithSuccess:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/logout" params:nil httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 第三方用户授权登录
- (void)person_requestThirdLogoutWithBlindId:(NSString *)blindId
                                     channel:(NSInteger)channel
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"aliasId":[[DCHelpTool shareClient] dc_uuidFitLength],
                             @"blindId":blindId,
                             @"channel":@(channel),
                             @"userType":@"1"
                             
    };
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login/blindId" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (success) {
            success(dict);
        }
        //        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
        //
        //
        //
        //        }
        //        else {
        //            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        //        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 第三方会员注册
- (void)person_requestThirdRegisterWithCellphone:(NSString *)cellphone
                                      tempUserId:(NSString *)tempUserId
                                    thirdLoginId:(NSString *)thirdLoginId
                                       thirdType:(NSInteger)thirdType
                                       validInfo:(NSString *)validInfo
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSString *goods = [DCObjectManager dc_readUserDataForKey:@"goodsId"];
    NSString *stm = [DCObjectManager dc_readUserDataForKey:@"stm"];
    NSString *utmUserId = [DCObjectManager dc_readUserDataForKey:@"utmUserId"];
    NSString *pioneerUserId = [DCObjectManager dc_readUserDataForKey:@"pioneerUserId"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"cellphone":cellphone,
                                                                                  @"tempUserId":tempUserId,
                                                                                  @"thirdLoginId":thirdLoginId,
                                                                                  @"thirdType":@(thirdType),
                                                                                  @"validInfo":validInfo}];
    if (goods.length >1) {
        [params setValue:goods?goods:@"" forKey:@"goodsId"];
        [params setValue:stm?stm:@"" forKey:@"stm"];
        [params setValue:utmUserId?utmUserId:@"" forKey:@"utmUserId"];
    }
    if (pioneerUserId.length >1) {
        [params setValue:pioneerUserId forKey:@"pioneerUserId"];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/regThird" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
                [DCObjectManager dc_removeUserDataForkey:pioneerUserId];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 到货通知明细，如果明细为空则返回用户默认手机号
- (void)personRequest_b2c_goodsInfo_detail_arrival_noticeWithGoodsId:(NSString *)goodsId
                                                             serialId:(NSString *)serialId
                                                              success:(DCSuccessBlock)success
                                                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"serialId":serialId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/detail_arrival_notice" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -期望通知时间列表
- (void)personRequest_b2c_goodsInfo_expect_time_listWithSuccess:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/expect_time_list" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
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

#pragma mark - 订阅到货通知
- (void)personRequest_b2c_goodsInfo_subscribe_noticeWithGoodsId:(NSString *)goodsId
                                                  buyerCellphone:(NSString *)buyerCellphone
                                                      expectTime:(NSString *)expectTime
                                                           isSms:(NSString *)isSms
                                                        serialId:(NSString *)serialId
                                                         success:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"buyerCellphone":buyerCellphone,
                             @"expectTime":expectTime,
                             @"isSms":isSms,
                             @"serialId":serialId};
    
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/subscribe_notice" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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


#pragma mark - 商品无库存情况下，查询推荐产品
- (void)personRequest_b2c_goodsInfo_detail_noStockRecommendWithGoodsId:(NSString *)goodsId
                                                              goodsName:(NSString *)goodsName
                                                                success:(DCSuccessBlock)success
                                                               failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"goodsName":goodsName};
    
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/goodsInfo/detail/noStockRecommend" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
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
