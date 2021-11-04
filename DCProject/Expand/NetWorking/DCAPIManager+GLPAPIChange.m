//
//  DCAPIManager+GLPAPIChange.m
//  DCProject
//
//  Created by LiuMac on 2021/7/12.
//

#import "DCAPIManager+GLPAPIChange.h"

@implementation DCAPIManager (GLPAPIChange)

#pragma mark - x
- (void)glpRequest_b2c_XWithParam:(NSString *)param
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"param":param};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/remove" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSString class]]) {
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

#pragma mark - 添加购物车 或者 立即购买校验
- (void)glpRequest_b2c_new_tradeInfoWithDic:(NSDictionary *)paramDic
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture{
    NSDictionary *params = paramDic;
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

- (void)glpRequest_b2c_tradeInfoWithGoodsId:(NSString *)goodsId
                                    batchId:(NSString *)batchId
                                       cart:(NSArray *)cart
                                   quantity:(NSString *)quantity
                               sellerFirmId:(NSString *)sellerFirmId
                                  tradeType:(NSString *)tradeType
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,
                             @"batchId":batchId,
                             @"cart":cart,
                             @"quantity":quantity,
                             @"sellerFirmId":sellerFirmId,
                             @"tradeType":tradeType};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 我的购物车
- (void)glpRequest_b2c_tradeInfo_cartWithSuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/cart" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"]) {
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


#pragma mark - 修改购物车
/*!
 *@param act 操作类型：change-修改购物车数量；remove-从购物车中删除
 *@param cart 购物车编码
 *@param value 修改购物车数量，act-change必传
 */
- (void)glpRequest_b2c_tradeInfo_cart_editWithAct:(NSString *)act
                                             cart:(NSArray *)cart
                                            value:(NSString *)value
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"act":act,
                             @"cart":cart,
                             @"value":value};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/cart/edit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 我的购物车数量
- (void)glpRequest_b2c_tradeInfo_cart_sizeWithSuccess:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/cart/size" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSString class]]) {
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

#pragma mark - 订单确认页面
/*!
 *@param batchId 批次ID（非医药加入购物车、立即购买必传）
 *@param cart 购物车编码（购物车提交必填）
 *@param goodsId 商品id（加入购物车、立即购买必传）
 *@param quantity 购买数量，必传
 *@param sellerFirmId 商品归属企业ID，必传
 *@param tradeType 交易类型：1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
 */
- (void)glpRequest_b2c_tradeInfo_confirmOrder_newWith:(NSDictionary *)paramDic
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/confirmOrder" params:paramDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

- (void)glpRequest_b2c_tradeInfo_confirmOrderWithBatchId:(NSString *)batchId
                                                    cart:(NSArray *)cart
                                                 goodsId:(NSString *)goodsId
                                                quantity:(NSString *)quantity
                                            sellerFirmId:(NSString *)sellerFirmId
                                               tradeType:(NSString *)tradeType
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"batchId":batchId,
                             @"cart":cart,
                             @"goodsId":goodsId,
                             @"quantity":quantity,
                             @"sellerFirmId":sellerFirmId,
                             @"tradeType":tradeType};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/confirmOrder" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 运费计算接口
/*!
 *@param areaId 收货地址地区编码，空或者0表示选择默认
 *@param goodsList 需要参与计算的产品列表
 **@param goodsId 商品id
 **@param goodsWeight 商品单位重量（KG）
 **@param logisticsTplId 运费模板Id
 **@param quantity 购买数量
 **@param sellerFirmId 商品归属企业ID
 */
- (void)glpRequest_b2c_tradeInfo_freightWithAreaId:(NSString *)areaId
                                         goodsList:(NSArray *)goodsList
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"areaId":areaId,
                             @"goodsList":goodsList};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/freight" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        //[SVProgressHUD dismiss];
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
        //[SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 订单提交
/*!
 *@param addrId 收货地址id传）
 *@param batchId 批次ID（非医药加入购物车、立即购买必传）
 *@param billDesc 疾病症状描述
 *@param cart 购物车编码（购物车提交必填）
 *@param drugId 用药人Id
 *@param goodsId 商品id（加入购物车、立即购买必传）
 *@param prescriptionImg 处方单图片
 *@param quantity 购买数量，必传
 *@param sellerFirmId 商品归属企业ID，必传
 *@param shopList 订单对应的店铺列表，多店铺情况下，一个店铺一个订单
 * *@param couponsId 用户选择的优惠券
 * *@param firmId 企业Id
 * *@param leaveMsg 订单备注
 *@param supUrl 补充图片URL(线上开单)
 *@parame symptomList 处方单订单下各个处方商品的症状选择
 *@param tradeType 交易类型：1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
 */
- (void)glpRequest_b2c_tradeInfo_submitWithAddrId:(NSString *)addrId
                                          batchId:(NSString *)batchId
                                         billDesc:(NSString *)billDesc
                                             cart:(NSArray *)cart
                                           drugId:(NSString *)drugId
                                          goodsId:(NSString *)goodsId
                                  prescriptionImg:(NSString *)prescriptionImg
                                         quantity:(NSString *)quantity
                                     sellerFirmId:(NSString *)sellerFirmId
                                         shopList:(NSArray *)shopList
                                           supUrl:(NSString *)supUrl
                                      symptomList:(NSArray *)symptomList
                                        tradeType:(NSString *)tradeType
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":addrId,
                             @"batchId":batchId,
                             @"billDesc":billDesc,
                             @"cart":cart,
                             @"goodsId":goodsId,
                             @"drugId":drugId,
                             @"prescriptionImg":prescriptionImg,
                             @"quantity":quantity,
                             @"sellerFirmId":sellerFirmId,
                             @"shopList":shopList,
                             @"supUrl":supUrl,
                             @"symptomList":symptomList,
                             @"tradeType":tradeType};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/submit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

- (void)glpRequest_b2c_tradeInfo_submit_newWithPrameDic:(NSDictionary *)prameDic
                                                success:(DCSuccessBlock)success
                                               failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/submit" params:prameDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 添加买家评论
- (void)glpRequest_b2c_account_eval_account_collection_addWithPrameDic:(NSDictionary *)prameDic
                                                                success:(DCSuccessBlock)success
                                                              failture:(DCFailtureBlock)failture{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/eval/account/collection/add" params:prameDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 获取评论列表
- (void)glpRequest_b2c_account_eval_evalListWithPrameDic:(NSDictionary *)prameDic
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/eval/evalList" params:prameDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 评价页面入口
- (void)glpRequest_b2c_account_eval_orderEvalWithOrderNo:(NSString *)orderNo
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"orderNo":orderNo};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/eval/evalList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 我的评价列表
/*!
 *@param currentPage 当前分页页码（默认为1）
 */
- (void)glpRequest_b2c_account_eval_myEvalListWithCurrentPage:(NSString *)currentPage
                                                      success:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/eval/myEvalList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
