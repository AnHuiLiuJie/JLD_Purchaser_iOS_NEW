//
//  DCAPIManager+PersonRequest.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAPIManager+PersonRequest.h"
#import "GLBProvinceModel.h"
#import "GLBProtocolModel.h"
#import "GLPUserInfoModel.h"
#import "GLPNewTicketModel.h"
#import "CocoaSecurity.h"
#import "DH_EncryptAndDecrypt.h"


@implementation DCAPIManager (PersonRequest)
#pragma mark - 登录
- (void)person_requestPsdLoginWithLoginName:(NSString *)loginName
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
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                // 储存token userId
                NSString *token = dict[@"data"][@"token"];
                NSString *userId = dict[@"data"][@"userId"];
                [DCObjectManager dc_saveUserData:token forKey:P_Token_Key];
                [DCObjectManager dc_saveUserData:userId forKey:P_UserID_Key];
                
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

#pragma mark -验证码 登录
- (void)person_requestSmsCodeLoginWithcaptcha:(NSString *)captcha
                                  phoneNumber:(NSString *)phoneNumber
                                        token:(NSString *)token
                                       userId:(NSString *)userId
                                     userType:(NSString *)userType
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"captcha":captcha,
                             @"phoneNumber":phoneNumber,
                             @"token":token,
                             @"userId":userId,
                             @"userType":userType};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login/phone" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                // 储存token userId
                NSString *token = dict[@"data"][@"token"];
                NSString *userId = dict[@"data"][@"userId"];
                [DCObjectManager dc_saveUserData:token forKey:P_Token_Key];
                [DCObjectManager dc_saveUserData:userId forKey:P_UserID_Key];
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
- (void)person_requestImageCodeWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"version":APP_VERSION};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/vcode/img" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[responseObject mj_JSONObject]];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSString *imgCode= dict[@"data"][@"imgCode"];
                NSString *decryptString = [DH_EncryptAndDecrypt decryptWithContent:imgCode key:DC_Encrypt_Key];
                NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
                [data setValue:decryptString forKey:@"imgCode"];
                [dict setObject:data forKey:@"data"];
                
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


#pragma mark - 获取短信验证码
- (void)person_requestSendSMSCodeWithCaptcha:(NSString *)captcha
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
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/vcode/sms" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            [SVProgressHUD showSuccessWithStatus:dict[@"data"]];
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
#pragma 注册
- (void)person_requestResginWithcellphone:(NSString *)cellphone
                                loginName:(NSString *)loginName
                                 loginPwd:(NSString *)loginPwd
                               tempUserId:(NSString *)tempUserId
                                validInfo:(NSString *)validInfo
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSString *goods = [DCObjectManager dc_readUserDataForKey:@"goodsId"];
    NSString *stm = [DCObjectManager dc_readUserDataForKey:@"stm"];
    NSString *utmUserId = [DCObjectManager dc_readUserDataForKey:@"utmUserId"];
    NSString *pioneerUserId = [DCObjectManager dc_readUserDataForKey:@"pioneerUserId"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"cellphone":cellphone,
                                                                                  @"loginName":loginName,
                                                                                  @"loginPwd":loginPwd,
                                                                                  @"tempUserId":tempUserId,
                                                                                  @"validInfo":validInfo
    }];
    
    if (goods.length >1) {
        [params setValue:goods?goods:@"" forKey:@"goodsId"];
        [params setValue:stm?stm:@"" forKey:@"stm"];
        [params setValue:utmUserId?utmUserId:@"" forKey:@"utmUserId"];
    }
    if (pioneerUserId.length >1) {
        [params setValue:pioneerUserId forKey:@"pioneerUserId"];
    }
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/regPerson" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(dict);
                    [DCObjectManager dc_removeUserDataForkey:pioneerUserId];
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
#pragma 忘记密码
- (void)person_requestForgetWithphoneNumber:(NSString *)phoneNumber
                                  loginName:(NSString *)loginName
                                     newPwd:(NSString *)newPwd
                                     userId:(NSString *)userId
                                      token:(NSString *)token
                                    captcha:(NSString *)captcha
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"phoneNumber":phoneNumber,
                             @"loginName":loginName,
                             @"newPwd":newPwd,
                             @"userId":userId,
                             @"token":token,
                             @"captcha":captcha
    };
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login/retrievepwd" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 个人信息
- (void)person_requestPersonDataWithisShowHUD:(BOOL)isShow
                                      Success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    isShow ? ([SVProgressHUD show]) : 1;
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/per/detail" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *userDic = dict[@"data"];
                GLPUserInfoModel *userInfoModel = [GLPUserInfoModel mj_objectWithKeyValues:userDic];
                //更新当前用户信息
                [DCObjectManager dc_saveUserData:[userInfoModel mj_keyValues] forKey:P_UserInfo_Key];
                [DCUpdateTool shareClient].currentUserB2C = userInfoModel;
                /*Add_HX_标识
                 *更新环信
                 */
                NSDictionary *userInfo = @{@"userId":[NSString stringWithFormat:@"b2c_%@",[DCObjectManager dc_readUserDataForKey:P_UserID_Key]],@"nickname":[NSString stringWithFormat:@"%@",[DCUpdateTool shareClient].currentUserB2C.nickName],@"headImg":[NSString stringWithFormat:@"%@",[DCUpdateTool shareClient].currentUserB2C.userImg]};
                [[DCUpdateTool shareClient] updateEaseUser:userInfo];
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
#pragma mark - 获取个人界面数量
- (void)person_requestPersonNumWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/statistical" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma 修改个人信息
- (void)person_requestSaveUserInfoWithuserImg:(NSString *)userImg
                                     nickName:(NSString *)nickName
                                          sex:(NSString *)sex
                                           qq:(NSString *)qq
                                       wechat:(NSString *)wechat
                              modifyTimeParam:(NSString *)modifyTimeParam
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"userImg":userImg,
                             @"sex":sex,
                             @"qq":qq,
                             @"wechat":wechat,
                             @"modifyTimeParam":modifyTimeParam,
                             @"nickName":nickName
    };
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/per/edit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma 修改绑定手机号
- (void)person_changePhoneWithloginPwd:(NSString *)loginPwd
                              newPhone:(NSString *)newPhone
                             validInfo:(NSString *)validInfo
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"loginPwd":loginPwd,
                             @"newPhone":newPhone,
                             @"validInfo":validInfo
    };
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login/phone/bind" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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



- (void)person_xiaohuWithNewPhone:(NSString *)newPhone
                        validInfo:(NSString *)validInfo
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cellphone":newPhone,
                             @"validInfo":validInfo
    };
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/logoff" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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


#pragma 修改密码
- (void)person_changePwdWitholdPwd:(NSString *)oldPwd
                            newPwd:(NSString *)newPwd
                           success:(DCSuccessBlock)success
                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"oldPwd":oldPwd,
                             @"newPwd":newPwd
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/login/pwdreset" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma 实名认证
- (void)person_AuthenWithuserName:(NSString *)userName
                           idCard:(NSString *)idCard
                  modifyTimeParam:(NSString *)modifyTimeParam
                   idCardFrontPic:(NSString *)idCardFrontPic
                         frontPic:(NSString *)frontPic
                    idCardFacePic:(NSString *)idCardFacePic
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"userName":userName,
                             @"idCard":idCard,
                             @"modifyTimeParam":modifyTimeParam,
                             @"idCardFrontPic":idCardFrontPic,
                             @"frontPic":frontPic,
                             @"idCardFacePic":idCardFacePic
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/card/edit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -获取实名认证信息

- (void)person_GetAuthenInfosuccess:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{ };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/card/detail" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -获取收货地址列表

- (void)person_GetAddressListsuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark - 获取地区
- (void)person_requestAllAreaWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/common/areas" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}
#pragma mark -新增收货地址
- (void)person_addAddressWithareaId:(NSString *)areaId
                          cellphone:(NSString *)cellphone
                          isDefault:(NSString *)isDefault
                           recevier:(NSString *)recevier
                         streetInfo:(NSString *)streetInfo
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"areaId":areaId,
                             @"cellphone":cellphone,
                             @"isDefault":isDefault,
                             @"recevier":recevier,
                             @"streetInfo":streetInfo
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -编辑收货地址
- (void)person_editAddressWithaddrId:(NSString *)addrId
                              areaId:(NSString *)areaId
                           cellphone:(NSString *)cellphone
                           isDefault:(NSString *)isDefault
                            recevier:(NSString *)recevier
                          streetInfo:(NSString *)streetInfo
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":addrId,
                             @"areaId":areaId,
                             @"cellphone":cellphone,
                             @"isDefault":isDefault,
                             @"recevier":recevier,
                             @"streetInfo":streetInfo
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address/edit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -删除收货地址
- (void)person_deleAddressWithaddrId:(NSString *)addrId
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":addrId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address/del" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -优惠券列表
- (void)person_getCouponsListWithcouponsClass:(NSString *)couponsClass
                                    isConsume:(NSString *)isConsume
                                  currentPage:(NSString *)currentPage
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"couponsClass":couponsClass,
                             @"isConsume":isConsume,
                             @"currentPage":currentPage
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/user" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            //            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            //            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        
        if (success) {
            success(dict);
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - 确认下单页面优惠券列表
- (void)person_getMineCouponsListWithCartIds:(NSString *)cartIds
                                       entry:(NSString *)entry
                                    GoodsIds:(NSString *)goodsIds
                                    quantity:(NSString *)quantity
                                 salerFirmId:(NSInteger)salerFirmId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    if ([entry isEqualToString:@"1"]) {
        params = @{@"cartIds":cartIds,@"goodsIds":goodsIds,@"entry":entry,@"salerFirmId":@(salerFirmId)};
    }else{
        params = @{@"goodsIds":goodsIds,@"entry":entry,@"quantity":quantity,@"salerFirmId":@(salerFirmId)};
    }
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/getCoupons" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSArray class]]) {
                [dataArray addObjectsFromArray:[GLPNewTicketModel mj_objectArrayWithKeyValuesArray:dict[@"data"]]];
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


#pragma 获取订单列表
- (void)person_getOrderListWithbuyerDelState:(NSString *)buyerDelState
                                 currentPage:(NSString *)currentPage
                                     endDate:(NSString *)endDate
                                   evalState:(NSString *)evalState
                                     orderNo:(NSString *)orderNo
                                  orderState:(NSString *)orderState
                                 refundState:(NSString *)refundState
                              sellerFirmName:(NSString *)sellerFirmName
                                   startDate:(NSString *)startDate
                                  searchName:(NSString *)searchName
                                   goodsName:(NSString *)goodsName
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"buyerDelState":buyerDelState,
                             @"currentPage":currentPage,
                             @"endDate":endDate,
                             @"evalState":evalState,
                             @"orderNo":orderNo,
                             @"orderState":orderState,
                             @"refundState":refundState,
                             @"sellerFirmName":sellerFirmName,
                             @"startDate":startDate,
                             @"searchName":searchName,
                             @"goodsName":goodsName};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/order/manage/orderList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

//退款订单列表
- (void)person_b2c_order_manage_returnListWithCurrentPage:(NSString *)currentPage
                                              refundState:(NSString *)refundState
                                                  orderNo:(NSString *)orderNo
                                               searchName:(NSString *)searchName
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture
{
    
    NSDictionary *params = @{@"searchName":searchName,
                             @"refundState":refundState,
                             @"currentPage":currentPage};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/order/manage/returnList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -获取消息第一条数据

- (void)person_getmessageFirstsuccess:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/info/infomessage/statistical" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -关注店铺列表

- (void)person_getFocusLisFirstwithcurrentPage:(NSString *)currentPage
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":currentPage
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/firm" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -删除收藏（店铺，商品共用）

- (void)person_deleFocusFirstwithcollectionIds:(NSString *)collectionIds
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"collectionIds":collectionIds
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/remove" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -删除收藏（店铺，商品共用） 新接口

- (void)person_deleNewFocusFirstwithcollectionIds:(NSString *)collectionIds
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"id":collectionIds};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/remove" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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


#pragma mark -店铺基本信息
- (void)person_getStoreInfowithfirmId:(NSString *)firmId
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/index" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -是否已被收藏

- (void)person_judgeIsCollectionwithobjectId:(NSString *)objectId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"objectId":objectId
    };
    [DC_KeyWindow dc_disable];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/iscollection" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -添加收藏（店铺，商品共用）

- (void)person_addCollectionwithcollectionType:(NSString *)collectionType
                                    goodsPrice:(NSString *)goodsPrice
                                      objectId:(NSString *)objectId
                                      isPrompt:(BOOL)isPrompt
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"collectionType":collectionType,
                             @"goodsPrice":goodsPrice,
                             @"objectId":objectId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (success) {
                success(dict);
            }
        } else {
            isPrompt ? : [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
        if (failture) {
            isPrompt ? :  failture(error);
        }
    }];
}
#pragma mark -店铺优惠券接口

- (void)person_getStoreCouponswithfirmId:(NSString *)firmId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/store/item" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -领取优惠券接口
- (void)person_receiveCouponswithcouponsId:(NSString *)couponsId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"couponsId":couponsId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/user/add" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺中间按钮分类
/*!
 *@brief  店铺中间按钮分类
 *@param  firmId 店铺ID
 */
- (void)person_getStoreCategorywithfirmId:(NSString *)firmId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/index/cat" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺商品列表

- (void)person_getStoreGoodsListywithfirmId:(NSString *)firmId
                                    brandId:(NSString *)brandId
                                  brandName:(NSString *)brandName
                                currentPage:(NSString *)currentPage
                                   descFlag:(NSString *)descFlag
                                 dosageForm:(NSString *)dosageForm
                                   goodsIds:(NSString *)goodsIds
                                 goodsTitle:(NSString *)goodsTitle
                                manufactory:(NSString *)manufactory
                                  orderFlag:(NSString *)orderFlag
                                 searchName:(NSString *)searchName
                                    symptom:(NSString *)symptom
                                  useMethod:(NSString *)useMethod
                                  usePerson:(NSString *)usePerson
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"brandId":brandId,
                             @"brandName":brandName,
                             @"currentPage":currentPage,
                             @"descFlag":descFlag,
                             @"dosageForm":dosageForm,
                             @"goodsIds":goodsIds,
                             @"goodsTitle":goodsTitle,
                             @"manufactoryStr":manufactory,
                             @"orderFlag":orderFlag,
                             @"searchName":searchName,
                             @"symptom":symptom,
                             @"useMethod":useMethod,
                             @"usePerson":usePerson
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/goods/goodsList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺推荐位(店铺首页的团购和促销)

- (void)person_getStoreRecommendwithfirmId:(NSString *)firmId
                                 spaceCode:(NSString *)spaceCode
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"spaceCode":spaceCode
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/index/rec" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺楼层（店铺首页最下面的）

- (void)person_getStoreFloorwithfirmId:(NSString *)firmId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/index/floor" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺活动

- (void)person_getStoreActivitywithfirmId:(NSString *)firmId
                              currentPage:(NSString *)currentPage
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"currentPage":currentPage
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/act/act" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺推荐商品

- (void)person_getStoreCommoditieswithfirmId:(NSString *)firmId
                                 currentPage:(NSString *)currentPage
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"currentPage":currentPage
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/goods/recgoods" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -店铺团购

- (void)person_getStoreBulkwithfirmId:(NSString *)firmId
                          currentPage:(NSString *)currentPage
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"firmId":firmId,
                             @"currentPage":currentPage
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/act/group" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -需求清单

- (void)person_getRequirementsLissuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/getNoOtcCart" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -我的处方单
- (void)person_getPrescriptionsWithorderNo:(NSString *)orderNo
                               currentPage:(NSString *)currentPage
                                   endDate:(NSString *)endDate
                                orderState:(NSString *)orderState
                            sellerFirmName:(NSString *)sellerFirmName
                                 startDate:(NSString *)startDate
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"orderNo":orderNo,
                             @"currentPage":currentPage,
                             @"endDate":endDate,
                             @"orderState":orderState,
                             @"sellerFirmName":sellerFirmName,
                             @"startDate":startDate
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/order/manage/onlineList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -商品数量修改

- (void)person_goodsNumwithcartId:(NSString *)cartId
                         quantity:(NSString *)quantity
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartId":cartId,
                             @"quantity":quantity
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/addQuantity" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -购物车(需求清单)商品,单个,多个删除

- (void)person_DeleRequestGoodswithcartIds:(NSString *)cartIds
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartIds":cartIds,
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/batchdel" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark 用户通过购物车确认订单
- (void)person_CommitRequestGoodswithcartIds:(NSString *)cartIds
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cartIds":cartIds,
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/cartNotarize" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -批量添加商品收藏

- (void)person_CollectionGoodswithobjectIds:(NSString *)objectIds
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"objectIds":objectIds
    };
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/collection/account/collection/addAll" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -获取默认地址
- (void)person_GetDefautAddresssuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address/defaultAddr" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -分类商品列表
- (void)person_getClassGoodsListywithcatId:(NSString *)catId
                                   brandId:(NSString *)brandId
                          goodsTagNameList:(NSString *)goodsTagNameList
                                 brandName:(NSString *)brandName
                               currentPage:(NSString *)currentPage
                                  descFlag:(NSString *)descFlag
                                dosageForm:(NSString *)dosageForm
                                  goodsIds:(NSString *)goodsIds
                                goodsTitle:(NSString *)goodsTitle
                               manufactory:(NSString *)manufactory
                                 orderFlag:(NSString *)orderFlag
                                searchName:(NSString *)searchName
                                   symptom:(NSString *)symptom
                                 useMethod:(NSString *)useMethod
                                 usePerson:(NSString *)usePerson
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"catId":catId,
                             @"navId":catId,
                             @"brandId":brandId,
                             @"brandName":brandName,
                             @"currentPage":currentPage,
                             @"descFlag":descFlag,
                             @"dosageForm":dosageForm,
                             @"goodsIds":goodsIds,
                             @"goodsTitle":goodsTitle,
                             @"manufactoryStr":manufactory,
                             @"orderFlag":orderFlag,
                             @"searchName":searchName,
                             @"symptom":symptom,
                             @"useMethod":useMethod,
                             @"usePerson":usePerson,
                             @"goodsTagNameList":goodsTagNameList
    };
    [SVProgressHUD show];
    if (searchName.length > 0) {//UM统计 自定义搜索关键词事件
        NSDictionary *dict = @{@"type":@"个人版",@"searchName":searchName};
        [MobClick event:UMEventCollection_1 attributes:dict];
    }
    
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -确认需求清单

- (void)person_comfirRequestwithentrance:(NSString *)entrance
                                  addrId:(NSString *)addrId
                                 cartIds:(NSString *)cartIds
                                leaveMsg:(NSString *)leaveMsg
                         prescriptionImg:(NSString *)prescriptionImg
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"addrId":addrId,
                             @"cartIds":cartIds,
                             @"leaveMsg":leaveMsg,
                             @"prescriptionImg":prescriptionImg};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/appApplySubmit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark 领券中心-店铺券
- (void)person_CouponCenterStorewithcurrentPage:(NSString *)currentPage
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/center/store" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark 领券中心-平台券

- (void)person_CouponCenterPlatformwithcurrentPage:(NSString *)currentPage
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":currentPage};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/center/plat" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark 领券中心-商品券

- (void)person_CouponCenterGoodswithcurrentPage:(NSString *)currentPage
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"currentPage":currentPage};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/center/goods" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark 帮助中心
- (void)person_HelpCenterwithhelpId:(NSString *)helpId
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"helpId":helpId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/help" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark 注册协议
- (void)person_RegisterProtocolsuccess:(DCSuccessBlock)success failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/help/agreement" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
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
        [SVProgressHUD dismiss];
        if (failture) {
            failture(error);
        }
    }];
}
#pragma mark -意见反馈

- (void)person_feedbackwithcellPhone:(NSString *)cellPhone
                             content:(NSString *)content
                                imgs:(NSString *)imgs
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"cellPhone":cellPhone,@"content":content,@"imgs":imgs};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/feedback" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark 意见反馈基础信息

- (void)person_getFeedBackInfosuccess:(DCSuccessBlock)success failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/percen/getFeedback" params:params httpMethod:DCHttpRequestGet sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -直接购买
- (void)person_buywithgoodsId:(NSString *)goodsId
                      batchId:(NSString *)batchId
                     quantity:(NSString *)quantity
                      success:(DCSuccessBlock)success
                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"batchId":batchId,@"quantity":quantity};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/buyNow" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -根据收货地址和运费

- (void)person_getAddressMoenywithgoodsId:(NSString *)goodsId
                                 quantity:(NSString *)quantity
                                   areaId:(NSString *)areaId
                           logisticsTplId:(NSString *)logisticsTplId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"quantity":quantity,@"areaId":areaId,@"logisticsTplId":logisticsTplId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/address/default" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -加入需求清单
- (void)person_jionRequestwithgoodsId:(NSString *)goodsId
                             quantity:(NSString *)quantity
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"quantity":quantity};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/addNeedCart" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -获取当前店铺的楼层商品列表
- (void)person_getFoolsGoodswithcatId:(NSString *)catId
                          currentPage:(NSString *)currentPage
                               firmId:(NSString *)firmId
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"catId":catId,@"currentPage":currentPage,@"firmId":firmId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/firm/shop/index/floorGoods" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -立即提交需求清单

- (void)person_detailCommitRequestwithgoodsId:(NSString *)goodsId
                                     quantity:(NSString *)quantity
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"quantity":quantity};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/buyNoOtcNow" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -获取订单数

- (void)person_getorderNumsuccess:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{};
    //[SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/order/manage/userorderCount" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -确认需求清单（从商品详情进入）
- (void)person_detailComfireRequestwithgoodsId:(NSString *)goodsId
                                      quantity:(NSString *)quantity
                                        addrId:(NSString *)addrId
                                      leaveMsg:(NSString *)leaveMsg
                               prescriptionImg:(NSString *)prescriptionImg
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"quantity":quantity,@"addrId":addrId,@"leaveMsg":leaveMsg,@"prescriptionImg":prescriptionImg};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/buyNowAppApplySubmit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
#pragma mark -确认订单单（从商品详情进入）

- (void)person_detailComfireOrderwithgoodsId:(NSString *)goodsId
                                    quantity:(NSString *)quantity
                                      addrId:(NSString *)addrId
                                    leaveMsg:(NSString *)leaveMsg
                             logisticsAmount:(NSString *)logisticsAmount
                                     transId:(NSString *)transId
                                     coupons:(NSDictionary *)coupons
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"goodsId":goodsId,@"quantity":quantity,@"addrId":addrId,@"leaveMsg":leaveMsg,@"logisticsAmount":logisticsAmount,@"transId":transId,@"coupons":coupons};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/buyNowSubmit" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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



#pragma mark -获取用药人以及产品对应的疾病症状
/*!
 *@param  传入产品id同时获取用药人列表以及对应产品的疾病症状列表，
 注：传入的产品Id用英文逗号隔开
 */
- (void)person_b2c_trade_userSymptomsWithGoodsId:(NSString *)goodsId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"goodsId":goodsId};
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/userSymptoms" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -新增用药人
/*!
 *@param  birthTime 患者出生时间；chiefComplaint 病情描述（主诉）；drugId 患者ID；historyAllergic 过敏史；historyIllness 既往史（家族病史）；idCard 患者身份证号；isDefault 是否默认用药人：1.是，2.否；isHistoryAllergic 是否有过敏史：1.是，2.否；isHistoryIllness 是否有既往史（家族病史）：1.是，2.否；isNowIllness 是否有现病史（过往病史)：1.是，2.否；lactationFlag 是否是备孕/怀孕/哺乳期：1.是，2.否；liverUnusual  肝功能是否异常：1.是，2.否；nowIllness 现病史（过往病史）；patientAge 患者年龄；patientGender 患者性别：1-男， 2-女 ；patientName 患者姓名；patientTel 患者手机号；relation 1.本人，2.家属，3.亲戚，4.朋友；renalUnusual  肾功能是否异常：1.是，2.否；
 */
- (void)person_b2c_druguser_addWithParamDic:(NSDictionary *)paramDic
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/add" params:paramDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -用药人明细
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_detailWithDrugId:(NSString *)drugId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"drugId":drugId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/detail" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -修改用药人
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_editWithParamDic:(NSDictionary *)paramDic
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture{
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/edit" params:paramDic httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -用药人列表
- (void)person_b2c_druguser_listWithSuccess:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/list" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && ([dict[@"data"] isKindOfClass:[NSArray class]] || [dict[@"data"] isKindOfClass:[NSDictionary class]])) {
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

#pragma mark -用药人列表
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_removeWithDrugId:(NSString *)drugId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"drugId":drugId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/druguser/remove" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -【活动专区（促销）】
- (void)person_b2c_activityWithCurrentPage:(NSString *)currentPage
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"currentPage":currentPage};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
