//
//  DCAPIManager.m
//  DCProject
//
//  Created by bigbing on 2019/4/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAPIManager.h"

#import "GLBProvinceModel.h"
#import "GLBAdvModel.h"
#import "GLBPromoteModel.h"
#import "GLBCompanyModel.h"
#import "GLBGoodsModel.h"
#import "GLBNewsModel.h"
#import "GLBTypeModel.h"
#import "GLBYcjModel.h"
#import "GLBCompanyTypeModel.h"
#import "GLBPlantPeopleModel.h"
#import "GLBPlantDrugModel.h"
#import "GLBStoreFiltrateModel.h"
#import "GLBAddressModel.h"
#import "GLBBrowseModel.h"
#import "GLBCollectModel.h"
#import "GLBExhibitModel.h"
#import "GLBCareModel.h"
#import "GLBGoodsDetailModel.h"
#import "GLBStoreModel.h"
#import "GLBStoreTicketModel.h"
#import "GLBAptitudeModel.h"
#import "GLBExhibitModel.h"
#import "GLBRecordModel.h"
#import "GLBPackageModel.h"
#import "GLBFactoryModel.h"
#import "GLBGoodsListModel.h"
#import "GLBUserInfoModel.h"
#import "GLBGoodsTicketModel.h"
#import "GLBIntentionModel.h"
#import "GLBOrderModel.h"
#import "GLBShoppingCarModel.h"
#import "GLBGoodsDetailTicketModel.h"
#import "GLBStoreListModel.h"
#import "GLBBatchModel.h"
#import "GLBMineTicketModel.h"
#import "GLBRepayListModel.h"
#import "GLBRepayRecordModel.h"
#import "GLBStoreEvaluateModel.h"
#import "GLBEvaluateDetailModel.h"
#import "GLBStoreGoodsModel.h"
#import "GLBRegisterModel.h"
#import "GLBQualificateModel.h"
#import "GLBMessageModel.h"
#import "GLBSearchGoodsModel.h"
#import "GLBSearchStoreModel.h"
#import "GLBRepayInfoModel.h"
#import "GLBOrderSuccessModel.h"
#import "GLBRangModel.h"
#import "GLBUpdateModel.h"
#import "GLBProtocolModel.h"
#import "DCUserModel.h"
#import "DH_EncryptAndDecrypt.h"

@implementation DCAPIManager

#pragma mark - 单列
+ (DCAPIManager *)shareManager {
    static DCAPIManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


#pragma mark - 登录
- (void)dc_requestPsdLoginWithLoginName:(NSString *)loginName
                               loginPwd:(NSString *)loginPwd
                               userType:(NSString *)userType
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"loginName":loginName,
                             @"loginPwd":loginPwd,
                             @"userType":userType,
                             @"aliasId":[[DCHelpTool shareClient] dc_uuidFitLength]}; // 设备号
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/account/login" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                // 储存token userId
                NSString *token = dict[@"data"][@"token"];
                NSString *userId = dict[@"data"][@"userId"];
                [DCObjectManager dc_saveUserData:token forKey:DC_Token_Key];
                [DCObjectManager dc_saveUserData:userId forKey:DC_UserID_Key];
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


#pragma mark - 获取图片验证码
- (void)dc_requestImageCodeWithToken:(NSString *)token
                              userId:(NSString *)userId
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (token) {
        [params setValue:token forKey:@"token"];
    }
    if (userId) {
        [params setValue:userId forKey:@"userId"];
    }
    [params setValue:APP_VERSION forKey:@"version"];
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/common/vcode/img" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseObject mj_JSONObject]];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSString *imgCode= dict[@"data"][@"imgCode"];
                NSString *decryptString = [DH_EncryptAndDecrypt decryptWithContent:imgCode key:DC_Encrypt_Key];
                NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
                [data setValue:decryptString forKey:@"imgCode"];
                [dict setObject:data forKey:@"data"];
                
                if (success) {
                    success(dict[@"data"]);
                }
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


#pragma mark - 获取短信验证码
- (void)dc_requestSendSMSCodeWithCaptcha:(NSString *)captcha
                             phoneNumber:(NSString *)phoneNumber
                                   token:(NSString *)token
                                  userId:(NSString *)userId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"captcha":captcha,
                             @"phoneNumber":phoneNumber,
                             @"token":token,
                             @"userId":userId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/common/vcode/sms" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            [SVProgressHUD showSuccessWithStatus:dict[@"data"]];
            
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


#pragma mark - 校验短信验证码
- (void)dc_requestCheckSMSCodeWithCaptcha:(NSString *)captcha
                              phoneNumber:(NSString *)phoneNumber
                                    token:(NSString *)token
                                   userId:(NSString *)userId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"captcha":captcha,
                             @"phoneNumber":phoneNumber,
                             @"token":token,
                             @"userId":userId};
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/register/check/sms" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 重置密码
- (void)dc_requestResetPswWithCaptcha:(NSString *)captcha
                          phoneNumber:(NSString *)phoneNumber
                                token:(NSString *)token
                               userId:(NSString *)userId
                            loginName:(NSString *)loginName
                               newPwd:(NSString *)newPwd
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"captcha":captcha,
                             @"phoneNumber":phoneNumber,
                             @"token":token,
                             @"userId":userId,
                             @"loginName":loginName,
                             @"newPwd":newPwd};
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/login/retrievepwd" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 获取地区
- (void)dc_requestAllAreaWithSuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    [[DCHttpClient shareClient] requestWithPath:@"/common/areas" params:nil httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"son"] && [dict[@"data"][@"son"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLBProvinceModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"son"]]];
                }
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 广告位
- (void)dc_requestAdvWithCode:(NSString *)code
                      success:(DCSuccessBlock)success
                     failture:(DCFailtureBlock)failture
{
    NSDictionary *parmas = @{@"code":code};
    
    [[DCHttpClient shareClient] requestWithPath:@"/info/ad" params:parmas httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBAdvModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            //failture(error);
        }
    }];
}


#pragma mark - 首页促销推荐
- (void)dc_requestHomePromoteWithDataKey:(NSString *)dataKey
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *parmas = @{@"dataKey":dataKey};
    
    [[DCHttpClient shareClient] requestWithPath:@"/info/rec/discount" params:parmas httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBPromoteModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 首页促销推荐
- (void)dc_requestHomeCompanyWithDataKey:(NSString *)dataKey
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *parmas = @{@"dataKey":dataKey};
    
    [[DCHttpClient shareClient] requestWithPath:@"/info/rec/firm" params:parmas httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBCompanyModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 首页推荐商品
- (void)dc_requestHomeGoodsWithDataKey:(NSString *)dataKey
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *parmas = @{@"dataKey":dataKey};
    
    [[DCHttpClient shareClient] requestWithPath:@"/info/rec/goods" params:parmas httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBGoodsModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 首页医药资讯
- (void)dc_requestHomeNewsWithDataKey:(NSString *)dataKey
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *parmas = @{@"dataKey":dataKey};
    
    [[DCHttpClient shareClient] requestWithPath:@"/info/rec/news" params:parmas httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBNewsModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取药品分类
- (void)dc_requestDrugTypeWithCatIds:(NSString *)catIds
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/common/goodsCat" params:@{@"catIds":catIds} httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBTypeModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取企业类型分类
- (void)dc_requestCompanyTypeWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    [[DCHttpClient shareClient] requestWithPath:@"/common/firmCat" params:nil httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBCompanyTypeModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        if (failture) {
            failture(error);
        }
    }];
}



#pragma mark - 药采集数据
- (void)dc_requestDrugCollectWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/yjc" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                GLBYcjModel *model = [GLBYcjModel mj_objectWithKeyValues:dict[@"data"]];
                
                if (success) {
                    success(model);
                }
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


#pragma mark - 种植户列表
- (void)dc_requestPlantPeopleListWithGrowerName:(NSString *)growerName
                                    currentPage:(NSInteger)currentPage
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"growerName":growerName,
                             @"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/plant/grower" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLBPlantPeopleModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 原药品种植列表
- (void)dc_requestPlantDrugListWithVarietyName:(NSString *)varietyName
                                   currentPage:(NSInteger)currentPage
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"varietyName":varietyName,
                             @"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/plant" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLBPlantDrugModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 新闻资讯列表
- (void)dc_requestNewsListWithCatId:(NSString *)catId
                         searchName:(NSString *)searchName
                        currentPage:(NSInteger)currentPage
                            success:(DCListSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"catId":catId,
                             @"searchName":searchName,
                             @"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/info/news" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLBNewsModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 筛选-商家列表
- (void)dc_requestFiltrateStoreListWithCatId:(NSString *)catId
                                  searchName:(NSString *)searchName
                                 currentPage:(NSInteger)currentPage
                                     success:(DCListSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"catId":catId,
                             @"searchName":searchName,
                             @"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/info/news" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    [dataArray addObjectsFromArray:[GLBNewsModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 收货地址列表
- (void)dc_requestAddressListWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/address" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBAddressModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 新增收货地址
- (void)dc_requestAddAddressWithAreaId:(NSInteger)areaId
                              recevier:(NSString *)recevier
                             cellphone:(NSString *)cellphone
                             isDefault:(NSInteger)isDefault
                            streetInfo:(NSString *)streetInfo
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"areaId":@(areaId),
                             @"isDefault":@(isDefault),
                             @"recevier":recevier,
                             @"cellphone":cellphone,
                             @"streetInfo":streetInfo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/address/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 编辑收货地址
- (void)dc_requestEditAddressWithAddrId:(NSInteger)addrId
                                 areaId:(NSInteger)areaId
                               recevier:(NSString *)recevier
                              cellphone:(NSString *)cellphone
                              isDefault:(NSInteger)isDefault
                             streetInfo:(NSString *)streetInfo
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":@(addrId),
                             @"areaId":@(areaId),
                             @"isDefault":@(isDefault),
                             @"recevier":recevier,
                             @"cellphone":cellphone,
                             @"streetInfo":streetInfo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/address/edit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 删除收货地址
- (void)dc_requestDeleteAddressWithAddrId:(NSInteger)addrId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":@(addrId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/address/del" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 浏览记录
- (void)dc_requestBrowseRecordWithCurrentPage:(NSInteger)currentPage
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/accesses" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBBrowseModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 删除浏览记录
- (void)dc_requestDeleteBrowseWithAccessId:(NSInteger)accessId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"accessId":@(accessId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/accesses/remove" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 添加收藏
- (void)dc_requestAddCollectWithInfoId:(NSString *)infoId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"infoId":infoId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection/add" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 收藏列表
- (void)dc_requestCollectListWithCurrentPage:(NSInteger)currentPage
                                   goodsName:(NSString *)goodsName
                                     success:(DCListSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"goodsName":goodsName};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBCollectModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 移除收藏
- (void)dc_requestDeleteCollectWithCollectionId:(NSArray *)collectionId
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"collectionId":collectionId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection/remove" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 取消收藏
- (void)dc_requestCancelCollectWithInfoId:(NSString *)infoId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"infoId":infoId};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection/remove/info" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 查询商品/店铺是否被收藏
- (void)dc_requestCollectStatusWithInfoId:(NSString *)infoId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"infoId":infoId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection/check" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 平台展会
- (void)dc_requestExhibitListWithID:(NSString *)iD
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"id":iD};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/info/expo" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBExhibitModel *model = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBExhibitModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 关注店铺列表
- (void)dc_requestCareListWithCurrentPage:(NSInteger)currentPage
                                  success:(DCListSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/collection/firm" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBCareModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 请求商品详情
- (void)dc_requestGoodsDetailWithGoodsId:(NSString *)goodsId
                                 batchId:(NSString *)batchId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    
    NSDictionary *params = @{@"goodsId":goodsId};
    if (batchId) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:batchId forKey:@"batchId"];
        params = [dictionary copy];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/detail" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBGoodsDetailModel *detaiModel = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                detaiModel = [GLBGoodsDetailModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(detaiModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 添加浏览记录
- (void)dc_requestAddSeeRecordWithFirmId:(NSString *)firmId
                                firmName:(NSString *)firmName
                                 goodsId:(NSString *)goodsId
                               goodsName:(NSString *)goodsName
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"firmName":firmName,
                             @"goodsId":goodsId,
                             @"goodsName":goodsName};
    
    [[DCHttpClient shareClient] requestWithPath:@"/product/detail/access/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(dict);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取店铺详情
- (void)dc_requestStoreDetailWithFirmId:(NSString *)firmId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/detail" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBStoreModel *storeModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                storeModel = [GLBStoreModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(storeModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取商家优惠券
- (void)dc_requestStoreTicketWithFirmId:(NSString *)firmId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/store/item" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBStoreTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 领取商家优惠券
- (void)dc_requestGetStoreTicketWithCouponId:(NSInteger)couponId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"couponId":@(couponId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/store/receive" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 获取商品专享优惠券
- (void)dc_requestGoodsTicketWithGoodsId:(NSString *)goodsId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    if (goodsId) {
        NSMutableArray *dictionary = [params mutableCopy];
        [dictionary setValue:goodsId forKeyPath:@"goodsId"];
        params = [dictionary copy];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/goods/item" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBGoodsTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 获取平台优惠券
- (void)dc_requestPlatformTicketWithSuccess:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/platform" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBGoodsTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 获取商铺详情里优惠券
- (void)dc_requestGoodsDetailTicketWithFirmId:(NSString *)firmId
                                      goodsId:(NSString *)goodsId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (firmId) {
        [dictionary setValue:@([firmId integerValue]) forKey:@"firmId"];
    }
    if (goodsId) {
        [dictionary setValue:goodsId forKey:@"goodsId"];
    }
    NSDictionary *params = [dictionary copy];
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/info" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBGoodsDetailTicketModel *model = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                model = [GLBGoodsDetailTicketModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 领取商品专享优惠券
- (void)dc_requestGetGoodsTicketWithCouponId:(NSInteger)couponId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"couponId":@(couponId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/goods/receive" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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




#pragma mark - 获取企业资质
- (void)dc_requestCompanyAptitudeWithFirmId:(NSString *)firmId
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/front/qc" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBAptitudeModel *model = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBAptitudeModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 获取药交会数据
- (void)dc_requestDrugExhibitSuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/info/yjh" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBExhibitModel *model = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBExhibitModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 采购记录
- (void)dc_requestGoodsRecordListWithCurrentPage:(NSInteger)currentPage
                                         goodsId:(NSString *)goodsId
                                         success:(DCListSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/detail/order" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBRecordModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 筛选商品列表
- (void)dc_requestSearchGoodsListWithCatIds:(NSString *)catIds
                                currentPage:(NSInteger)currentPage
                                   entrance:(NSString *)entrance
                                  goodsName:(NSString *)goodsName
                                   isCoupon:(NSString *)isCoupon
                                isPromotion:(NSString *)isPromotion
                                manufactory:(NSString *)manufactory
                                packingSpec:(NSString *)packingSpec
                                   prodType:(NSString *)prodType
                                       sort:(NSString *)sort
                              suppierFirmId:(NSString *)suppierFirmId
                                    success:(DCListSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    
    [[DCHttpClient shareClient] requestWithPath:@"/product" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

- (void)dc_requestB2BSearchGoodsListWithCatIds:(NSString *)catIds
                                   currentPage:(NSInteger)currentPage
                                      entrance:(NSString *)entrance
                                     goodsName:(NSString *)goodsName
                                      isCoupon:(NSString *)isCoupon
                                   isPromotion:(NSString *)isPromotion
                                   manufactory:(NSString *)manufactory
                                   packingSpec:(NSString *)packingSpec
                                      prodType:(NSString *)prodType
                                          sort:(NSString *)sort
                                 suppierFirmId:(NSString *)suppierFirmId
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 筛选厂家
- (void)dc_requestSearchCompanyListWithCurrentPage:(NSInteger)currentPage
                                            catIds:(NSString *)catIds
                                          entrance:(NSString *)entrance
                                         goodsName:(NSString *)goodsName
                                          isCoupon:(NSString *)isCoupon
                                       isPromotion:(NSString *)isPromotion
                                       manufactory:(NSString *)manufactory
                                       packingSpec:(NSString *)packingSpec
                                          prodType:(NSString *)prodType
                                              sort:(NSString *)sort
                                     suppierFirmId:(NSString *)suppierFirmId
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"sort":sort,
                             @"suppierFirmId":suppierFirmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/factory" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                
                [dataArray addObjectsFromArray:[GLBFactoryModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 筛选规格包装
- (void)dc_requestSearchPackageListWithCurrentPage:(NSInteger)currentPage
                                            catIds:(NSString *)catIds
                                          entrance:(NSString *)entrance
                                         goodsName:(NSString *)goodsName
                                          isCoupon:(NSString *)isCoupon
                                       isPromotion:(NSString *)isPromotion
                                       manufactory:(NSString *)manufactory
                                       packingSpec:(NSString *)packingSpec
                                          prodType:(NSString *)prodType
                                              sort:(NSString *)sort
                                     suppierFirmId:(NSString *)suppierFirmId
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"sort":sort,
                             @"suppierFirmId":suppierFirmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/specs" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBPackageModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 筛选商家列表
- (void)dc_requestSearchStoreListWithBrand:(NSString *)brand
                                  classify:(NSString *)classify
                                 goodsName:(NSString *)goodsName
                              goodsTagName:(NSString *)goodsTagName
                                     isHot:(NSString *)isHot
                               isPromotion:(NSString *)isPromotion
                               manufactory:(NSString *)manufactory
                               packingSpec:(NSString *)packingSpec
                                  saleCtrl:(NSString *)saleCtrl
                                      sort:(NSString *)sort
                             suppierFirmId:(NSString *)suppierFirmId
                           suppierFirmName:(NSString *)suppierFirmName
                                       zyc:(NSString *)zyc
                               currentPage:(NSInteger)currentPage
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"brand":brand,
                             @"catIds":classify,
                             @"goodsName":goodsName,
                             @"goodsTagName":goodsTagName,
                             @"isHot":isHot,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"saleCtrl":saleCtrl,
                             @"sort":sort,
                             @"suppierFirmId":suppierFirmId,
                             @"suppierFirmName":suppierFirmName,
                             @"zyc":zyc};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/firm" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBStoreFiltrateModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 企业个人中心
- (void)dc_requestUserInfoWithSuccess:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/info" params:nil httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBUserInfoModel *userInfoModel = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                userInfoModel = [GLBUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
                //更新当前用户信息
                [DCObjectManager dc_saveUserData:[userInfoModel mj_keyValues] forKey:DC_UserInfo_Key];
                [DCUpdateTool shareClient].currentUser = userInfoModel;
                /*Add_HX_标识
                 *更新环信
                 */
                
                NSString *headImg = @"";
                if ([DCObjectManager dc_readUserDataForKey:DC_UserImage_Key]) {
                    headImg = [DCObjectManager dc_readUserDataForKey:DC_UserImage_Key];
                }
                
                NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2b_%@",[DCObjectManager dc_readUserDataForKey:DC_UserID_Key]],@"nickname":[NSString stringWithFormat:@"%@",[DCUpdateTool shareClient].currentUser.userName],@"headImg":[NSString stringWithFormat:@"%@",headImg]};
                [[DCUpdateTool shareClient] updateEaseUser:userInfo];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(userInfoModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 保存个人信息
- (void)dc_requestSaveUserInfoWithCellphone:(NSString *)cellphone
                                      email:(NSString *)email
                                   landline:(NSString *)landline
                                         qq:(NSString *)qq
                                     wechat:(NSString *)wechat
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cellphone":cellphone,
                             @"email":email,
                             @"landline":landline,
                             @"qq":qq,
                             @"wechat":wechat};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/account/info/update" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 订购意向列表
- (void)dc_requestIntentionListWithCurrentPage:(NSInteger)currentPage
                                         state:(NSString *)state
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    if (state) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:@([state integerValue]) forKey:@"state"];
        params = [dictionary copy];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/plant/order" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBIntentionModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 订单列表
- (void)dc_requestOrderListWithCurrentPage:(NSInteger)currentPage
                                orderState:(NSString *)orderState
                                  firmName:(NSString *)firmName
                                   success:(DCListSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    if (orderState) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:orderState forKey:@"searchState"];
        params = [dictionary copy];
    }
    if (firmName) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:firmName forKey:@"firmName"];
        params = [dictionary copy];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/order" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBOrderModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购车商品列表
- (void)dc_requestShoppingCarListWithSuccess:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBShoppingCarModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 加入购物车
- (void)dc_requestAddShoppingCarWithBatchId:(NSString *)batchId
                                    goodsId:(NSString *)goodsId
                                   quantity:(NSInteger)quantity
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"quantity":@(quantity),
                             @"batchId":batchId,
                             @"goodsId":goodsId};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 修改购物车商品数量
- (void)dc_requestChangeGoodsCountWithBatchId:(NSString *)batchId
                                      goodsId:(NSString *)goodsId
                                       cartId:(NSString *)cartId
                                     quantity:(NSInteger)quantity
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"quantity":@(quantity),
                             @"batchId":batchId,
                             @"goodsId":goodsId,
                             @"cartId":cartId};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/changeNum" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 删除购物车商品
- (void)dc_requestDeleteShoppingCarWithCartIds:(NSString *)cartIds
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    
    NSDictionary *params = @{@"cartIds":cartIds};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/del" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 查询购物车商品总数
- (void)dc_requestShoppingCarGoodsCountWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/num" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSInteger cartNum = 0;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                cartNum = [dict[@"data"][@"cartNum"] integerValue];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(@(cartNum));
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车下单
- (void)dc_requestShoppingCarCommintWithCartIds:(NSString *)cartIds
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/info" params:@{@"cartIds":cartIds} httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBShoppingCarModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 购物车下单确认
- (void)dc_requestShoppingCarSubmitWithAddressId:(NSInteger)addressId
                                      couponsIds:(NSString *)couponsIds
                                         cartIds:(NSString *)cartIds
                                cartTradeInfoDTO:(NSArray *)cartTradeInfoDTO
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addressId":@(addressId),
                             @"couponsIds":couponsIds,
                             @"cartIds":cartIds,
                             @"cartTradeInfoDTO":cartTradeInfoDTO};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/submit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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



#pragma mark - 查询店铺列表
- (void)dc_requestSearchStoreListWithCurrentPage:(NSInteger)currentPage
                                          coupon:(NSString *)coupon
                                        firmName:(NSString *)firmName
                                     isShowGoods:(NSString *)isShowGoods
                                        maxMoney:(NSString *)maxMoney
                                        minMoney:(NSString *)minMoney
                                       promotion:(NSString *)promotion
                                           scope:(NSString *)scope
                                       sortField:(NSString *)sortField
                                        sortMode:(NSString *)sortMode
                                         success:(DCListSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"coupon":coupon,
                             @"firmName":firmName,
                             @"isShowGoods":isShowGoods,
                             @"promotion":promotion,
                             @"scope":scope,
                             @"sortField":sortField,
                             @"sortMode":sortMode};
    
    if (maxMoney) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:@([maxMoney integerValue]) forKey:@"maxMoney"];
        params = [dictionary copy];
    }
    if (minMoney) {
        NSMutableDictionary *dictionary = [params mutableCopy];
        [dictionary setValue:@([minMoney integerValue]) forKey:@"minMoney"];
        params = [dictionary copy];
    }
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBStoreListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 个人中心数量显示
- (void)dc_requestMineCountWithSuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/statistical" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict[@"data"]);
                }
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


#pragma mark - 获取批次列表
- (void)dc_requestBatchListWithGoodsId:(NSString *)goodsId
                               batchId:(NSString *)batchId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    NSMutableDictionary *dictionary = [params mutableCopy];
    if (goodsId) {
        [dictionary setValue:goodsId forKey:@"goodsId"];
    }
    if (batchId) {
        [dictionary setValue:batchId forKey:@"batchId"];
    }
    params = [dictionary copy];
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/detail/batchId" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBBatchModel *model = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                model = [GLBBatchModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 已领取券列表
- (void)dc_requestMineTicketListWithCurrentPage:(NSInteger)currentPage
                                          state:(NSString *)state
                                           type:(NSString *)type
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"state":state,
                             @"type":type};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/activity/coupons/mycoupon" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBMineTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 逾期还款记录
- (void)dc_requestRepayListListWithCurrentPage:(NSInteger)currentPage
                                     startDate:(NSString *)startDate
                                       endDate:(NSString *)endDate
                                       orderNo:(NSString *)orderNo
                                         state:(NSString *)state
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"state":state,
                             @"startDate":startDate,
                             @"endDate":endDate,
                             @"orderNo":orderNo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/period/repayment" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBRepayListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 账期还款
- (void)dc_requestRepayRepayWithAmount:(CGFloat)amount
                               orderNo:(NSInteger)orderNo
                             paymentId:(NSString *)paymentId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"amount":@(amount),
                             @"orderNo":@(orderNo),
                             @"paymentId":paymentId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/period/repayment/pay" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 申请逾期
- (void)dc_requestApplyOverdueWithOrderNo:(NSInteger)orderNo
                              delayReason:(NSString *)delayReason
                           paymentEndDate:(NSString *)paymentEndDate
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":@(orderNo),
                             @"delayReason":delayReason,
                             @"paymentEndDate":paymentEndDate};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/period/repayment/applyDelay" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
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


#pragma mark - 账期还款记录
- (void)dc_requestRepayRecordWithOrderNo:(NSInteger)orderNo
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":@(orderNo)};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/period/repayment/pay/list" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBRepayRecordModel *recordModel = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                recordModel = [GLBRepayRecordModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(recordModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 账期还款可申请日期
- (void)dc_requestRepayOverdunTimeWithOrderNo:(NSInteger)orderNo
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":@(orderNo)};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/period/repayment/applyDelay/date" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict[@"data"] );
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


#pragma mark - 店铺商品评价列表
- (void)dc_requestStoreEvaluateListWithCurrentPage:(NSInteger)currentPage
                                            firmId:(NSString *)firmId
                                              type:(NSString *)type
                                           success:(DCListSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"firmId":firmId,
                             @"type":type};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/evaluate" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBStoreEvaluateModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 店铺评价汇总
- (void)dc_requestStoreEvaluateAnalyzeWithFirmId:(NSString *)firmId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/evaluateCount" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                GLBEvaluateDetailModel *detailModel = [GLBEvaluateDetailModel mj_objectWithKeyValues:dict[@"data"]];
                if (success) {
                    success(detailModel);
                }
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


#pragma mark - 店铺商品列表
- (void)dc_requestStoreGoodsListWithCurrentPage:(NSInteger)currentPage
                                         firmId:(NSString *)firmId
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"firmId":firmId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/goods" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBStoreGoodsModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 查询企业名称是否重复
- (void)dc_requestIsRegisterWithFirmName:(NSString *)firmName
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmName":firmName};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/register/check/firmname" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBRegisterModel *model = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBRegisterModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 企业用户注册
- (void)dc_requestCompanyRegisterWithApplyType:(NSInteger)applyType
                                     cellphone:(NSInteger)cellphone
                                   firmAddress:(NSString *)firmAddress
                                      firmArea:(NSString *)firmArea
                                    firmAreaId:(NSInteger)firmAreaId
                                      firmCat1:(NSString *)firmCat1
                                  firmCat2List:(NSString *)firmCat2List
                                   firmContact:(NSString *)firmContact
                                  firmLoginPwd:(NSString *)firmLoginPwd
                                      firmName:(NSString *)firmName
                                     loginName:(NSString *)loginName
                                    tempUserId:(NSInteger)tempUserId
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"applyType":@(applyType),
                             @"cellphone":@(cellphone),
                             @"firmAddress":firmAddress,
                             @"firmArea":firmArea,
                             @"firmAreaId":@(firmAreaId),
                             @"firmCat1":firmCat1,
                             @"firmCat2List":firmCat2List,
                             @"firmContact":firmContact,
                             @"firmLoginPwd":firmLoginPwd,
                             @"firmName":firmName,
                             @"loginName":loginName,
                             @"tempUserId":@(tempUserId)};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/account/register" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (success) {
                    success(dict[@"data"]);
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


#pragma mark - 企业资质加载
- (void)dc_requestCompanyQualificateWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/getQcInfoForSub" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                GLBQualificateModel *model = [GLBQualificateModel mj_objectWithKeyValues:dict[@"data"]];
                if (success) {
                    success(model);
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


#pragma mark - 企业需要上传的资质
- (void)dc_requestRequireUploadQualificateWithfirmCat1:(NSString *)firmCat1
                                              firmCat2:(NSString *)firmCat2
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmCat1":firmCat1,
                             @"firmCat2":firmCat2};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/qc/list" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                
                [dataArray addObjectsFromArray:[GLBQualificateListModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(dataArray);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 企业资质提交
- (void)dc_requestCommintQualificateWithFirmAddress:(NSString *)firmAddress
                                           firmArea:(NSString *)firmArea
                                         firmAreaId:(NSInteger)firmAreaId
                                           firmCat1:(NSString *)firmCat1
                                       firmCat2List:(NSString *)firmCat2List
                                        firmContact:(NSString *)firmContact
                                             firmId:(NSInteger)firmId
                                           firmName:(NSString *)firmName
                                             qcList:(NSArray *)qcList
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmAddress":firmAddress,
                             @"firmArea":firmArea,
                             @"firmAreaId":@(firmAreaId),
                             @"firmCat1":firmCat1,
                             @"firmCat2List":firmCat2List,
                             @"firmContact":firmContact,
                             @"firmId":@(firmId),
                             @"firmName":firmName,
                             @"qcList":qcList};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/subFirmQcInfo" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                GLBQualificateModel *model = [GLBQualificateModel mj_objectWithKeyValues:dict[@"data"]];
                if (success) {
                    success(model);
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


#pragma mark - 商品药集采详情
- (void)dc_requestDrugjcInfoWithGoodsId:(NSString *)goodsId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/detail/yjc" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                GLBYcjModel *model = [GLBYcjModel mj_objectWithKeyValues:dict[@"data"]];
                if (success) {
                    success(model);
                }
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


#pragma mark - 修改手机号绑定
- (void)dc_requestChangePhoneWithCellphone:(NSString *)cellphone
                                  newPhone:(NSString *)newPhone
                                 validInfo:(NSString *)validInfo
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cellphone":cellphone,
                             @"newPhone":newPhone,
                             @"validInfo":validInfo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/login/phone/bind" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (success) {
                    success(dict[@"data"]);
                }
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

- (void)dc_promote:(NSString *)goodsId
               Stm:(NSString *)stm
         utmUserId:(NSString *)utmUserId
           success:(DCSuccessBlock)success
          failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"goodsId":goodsId?goodsId:@"" ,
                             @"stm":stm ? stm:@"",
                             @"utmUserId":utmUserId?utmUserId:@""
    };
    
    [DC_KeyWindow dc_disable];
    
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/promote" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (success) {
                    success(dict[@"data"]);
                }
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

#pragma mark -
- (void)dc_requestXiaohuWithCellphone:(NSString *)cellphone
                            validInfo:(NSString *)validInfo
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cellphone":cellphone,
                             @"validInfo":validInfo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/logoff" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (success) {
                    success(dict[@"data"]);
                }
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



#pragma mark - 企业已认证资质
- (void)dc_requestCertifiedQualificateWithSuccess:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/getAuthedQcInfo" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBQualificateModel *model = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBQualificateModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 企业未认证资质
- (void)dc_requestUnverifiedQualificateWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/getAuthingQcInfo" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBQualificateModel *model = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                model = [GLBQualificateModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(model);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 查询企业详细信息
- (void)dc_requestCompanyInfoWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/detail" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                if (success) {
                    success(dict[@"data"]);
                }
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


#pragma mark - 中药材商品列表
- (void)dc_requestTCMSearchGoodsListWithCatIds:(NSString *)catIds
                                   currentPage:(NSInteger)currentPage
                                      entrance:(NSString *)entrance
                                     goodsName:(NSString *)goodsName
                                      isCoupon:(NSString *)isCoupon
                                   isPromotion:(NSString *)isPromotion
                                   manufactory:(NSString *)manufactory
                                   packingSpec:(NSString *)packingSpec
                                      prodType:(NSString *)prodType
                                          sort:(NSString *)sort
                                 suppierFirmId:(NSString *)suppierFirmId
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/zyc" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}



#pragma mark - 中药材-最受欢迎商品列表
- (void)dc_requestTCMLickGoodsListWithCatIds:(NSString *)catIds
                                 currentPage:(NSInteger)currentPage
                                    entrance:(NSString *)entrance
                                   goodsName:(NSString *)goodsName
                                    isCoupon:(NSString *)isCoupon
                                 isPromotion:(NSString *)isPromotion
                                 manufactory:(NSString *)manufactory
                                 packingSpec:(NSString *)packingSpec
                                    prodType:(NSString *)prodType
                                        sort:(NSString *)sort
                               suppierFirmId:(NSString *)suppierFirmId
                                     success:(DCListSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/zyc/popular" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 中药材-精品推荐商品列表
- (void)dc_requestTCMRecommendGoodsListWithCatIds:(NSString *)catIds
                                      currentPage:(NSInteger)currentPage
                                         entrance:(NSString *)entrance
                                        goodsName:(NSString *)goodsName
                                         isCoupon:(NSString *)isCoupon
                                      isPromotion:(NSString *)isPromotion
                                      manufactory:(NSString *)manufactory
                                      packingSpec:(NSString *)packingSpec
                                         prodType:(NSString *)prodType
                                             sort:(NSString *)sort
                                    suppierFirmId:(NSString *)suppierFirmId
                                          success:(DCListSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/zyc/recommend" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 中药材-今日特惠商品列表
- (void)dc_requestTCMSpecialGoodsListWithCatIds:(NSString *)catIds
                                    currentPage:(NSInteger)currentPage
                                       entrance:(NSString *)entrance
                                      goodsName:(NSString *)goodsName
                                       isCoupon:(NSString *)isCoupon
                                    isPromotion:(NSString *)isPromotion
                                    manufactory:(NSString *)manufactory
                                    packingSpec:(NSString *)packingSpec
                                       prodType:(NSString *)prodType
                                           sort:(NSString *)sort
                                  suppierFirmId:(NSString *)suppierFirmId
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"catIds":catIds,
                             @"entrance":entrance,
                             @"goodsName":goodsName,
                             @"isCoupon":isCoupon,
                             @"isPromotion":isPromotion,
                             @"manufactory":manufactory,
                             @"packingSpec":packingSpec,
                             @"prodType":prodType,
                             @"suppierFirmId":suppierFirmId,
                             @"sort":sort};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/zyc/special" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBGoodsListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 系统消息
- (void)dc_requestSysMessageWithCurrentPage:(NSInteger)currentPage
                                    success:(DCListSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/sysmsg" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBMessageModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 订单消息
- (void)dc_requestOrderMessageWithCurrentPage:(NSInteger)currentPage
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/sysordermsg" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBMessageModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 未读消息数量
- (void)dc_requestNoReadMessageCountWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/sysmsgnum" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict[@"data"]);
                }
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


#pragma mark - 查询中药馆店铺列表
- (void)dc_requestTCMStoreListWithCurrentPage:(NSInteger)currentPage
                                       coupon:(NSString *)coupon
                                     firmName:(NSString *)firmName
                                  isShowGoods:(NSString *)isShowGoods
                                     maxMoney:(NSInteger)maxMoney
                                     minMoney:(NSInteger)minMoney
                                    promotion:(NSString *)promotion
                                        scope:(NSString *)scope
                                    sortField:(NSString *)sortField
                                     sortMode:(NSString *)sortMode
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":@(currentPage),
                             @"coupon":coupon,
                             @"firmName":firmName,
                             @"isShowGoods":isShowGoods,
                             @"maxMoney":@(maxMoney),
                             @"minMoney":@(minMoney),
                             @"promotion":promotion,
                             @"scope":scope,
                             @"sortField":sortField,
                             @"sortMode":sortMode};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/zyc" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        BOOL hasNextPage = NO;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (dict[@"data"][@"pageData"] && [dict[@"data"][@"pageData"] isKindOfClass:[NSArray class]]) {
                    
                    [dataArray addObjectsFromArray:[GLBStoreListModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"pageData"]]];
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
            success(dataArray,hasNextPage);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 重置密码
- (void)dc_requestResetPasswordWithNewPwd:(NSString *)newPwd
                                   oldPwd:(NSString *)oldPwd
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"newPwd":newPwd,
                             @"oldPwd":oldPwd};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/login/pwdreset" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 默认图片
- (void)dc_requestDefaultImageWithSuccess:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/appconfig/defultimg" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
            
        } else {
            
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            //failture(error);
        }
    }];
}


#pragma mark - 搜索商品 联想
- (void)dc_requestSearchGoodsKeywordWithKeyword:(NSString *)keyword
                                          isZyc:(NSString *)isZyc
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"searchName":keyword,
                             @"isZyc":@(0)};
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/product/keyword" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBSearchGoodsModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            //            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
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

#pragma mark - 搜索店铺 联想
- (void)dc_requestSearchStoreKeywordWithKeyword:(NSString *)keyword
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/firm/store/keyword" params:@{@"keyword":keyword} httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBSearchStoreModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
            }
            
        } else {
            
            //            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
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


#pragma mark - 查询采供商是否存在账期关系
- (void)dc_requestIsRepayInfoWithSuppierFirmId:(NSInteger)suppierFirmId
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"suppierFirmId":@(suppierFirmId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/period/apply/check" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        GLBRepayInfoModel *infoModel = nil;
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                infoModel = [GLBRepayInfoModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        if (success) {
            success(infoModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 申请账期支付
- (void)dc_requestApplyRepayWithSuppierFirmId:(NSInteger)suppierFirmId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"suppierFirmId":@(suppierFirmId)};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/period/apply" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark - 下单成功列表页展示
- (void)dc_requestApplyOrderSuccessWithOrders:(NSString *)orders
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orders":orders};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/trade/cart/submit/success" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBOrderSuccessModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 获取企业经营范围
- (void)dc_requestCompanyRangWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/common/scopes" params:nil httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBRangModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 检查更新
- (void)dc_requestCheckUpdateWithAppBusType:(NSString *)appBusType
                                    appType:(NSString *)appType
                                  versionNo:(NSString *)versionNo
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"appBusType":appBusType,
                             @"appType":appType,
                             @"versionNo":versionNo};
    
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/appconfig/version" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        GLBUpdateModel *updateModel = nil;
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                updateModel = [GLBUpdateModel mj_objectWithKeyValues:dict[@"data"]];
            }
            
        } else {
            
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(updateModel);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            //failture(error);
        }
    }];
}


#pragma mark - 注册协议
- (void)dc_requestRegisterProtocolWithSuccess:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/appconfig/agreement" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLBProtocolModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma mark - 已登录企业资质状态
- (void)dc_requestCompanyStatusWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/state" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        DCUserModel *userModel = [DCUserModel new];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            userModel.code = DC_Result_Success;
            userModel.msg = dict[@"msg"];
            
        } else {
            
            userModel.code = [dict[DC_ResultCode_Key] integerValue];
            userModel.msg = dict[@"msg"];
        }
        
        //        [DCObjectManager dc_saveUserData:userModel forKey:DC_UserModel_Key];
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}



#pragma mark - 退出登录
- (void)dc_requestLogoutWithSuccess:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/logout" params:nil httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
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


#pragma mark -获取默认地址
- (void)dc_requestDefautAddresssuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithPath:@"/account/address/default" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [DC_KeyWindow dc_enable];
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                GLBAddressModel *addressModel = [GLBAddressModel mj_objectWithKeyValues:dict[@"data"]];
                if (success) {
                    success(addressModel);
                }
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

#pragma mark - 验证码获取
- (void)dc_request_b2c_common_captcha_getWithDic:(NSDictionary *)dic
                                         Success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture{
    NSDictionary *params = dic;
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/captcha/get" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict[@"data"]);
                }
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

#pragma mark - 滑动验证码验证
- (void)dc_request_b2c_common_captcha_checkWithDic:(NSDictionary *)dic
                                           Success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture{
    NSDictionary *params = dic;
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/captcha/check" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(@{@"success":@"YES"});
                }
            }
        } else {
            success(@{@"success":@"NO"});
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

#pragma mark - 滑动验证码二次调用，发送短信验证码
- (void)dc_request_b2c_common_captcha_sendMessageWithDic:(NSDictionary *)dic
                                                 Success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture{
    NSDictionary *params = dic;
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/captcha/sendMessage" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSString class]]) {
                if (success) {
                    success(@{@"success":@"YES",@"code":@"200"});
                }
            }
        } else {
            success(@{@"success":@"NO",@"code":dict[DC_ResultCode_Key],DC_ResultMsg_Key:dict[DC_ResultMsg_Key]});
            //[SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        if (failture) {
            failture(error);
        }
    }];
}

@end
