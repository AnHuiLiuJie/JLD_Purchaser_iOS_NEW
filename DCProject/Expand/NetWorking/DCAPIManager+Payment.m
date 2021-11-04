//
//  DCAPIManager+Payment.m
//  DCProject
//
//  Created by LiuMac on 2021/8/16.
//

#import "DCAPIManager+Payment.h"

@implementation DCAPIManager (Payment)

#pragma mark -银行卡列表
- (void)payment_b2c_account_pay_bankCardListWithSuccess:(DCSuccessBlock)success
                                               failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/bankCardList" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -银行卡绑定，点击绑定时调用
/*!
 *@brief  立即提交需求清单
 *@param  cardNo 银行卡号
 *@param  cardType 卡类型：D-借记卡；C-贷记卡
 *@param  certNo 证件号
 *@param  certType 证件类型
 *@param  name 用户名称
 *@param  originalSerialNo 支付序列号
 *@param  phone 手机号
 *@param  sendMsg 验证码
 */
- (void)payment_b2c_account_pay_cardBlindWithCardNo:(NSString *)cardNo
                                           cardType:(NSString *)cardType
                                             certNo:(NSString *)certNo
                                           certType:(NSString *)certType
                                               name:(NSString *)name
                                   originalSerialNo:(NSString *)originalSerialNo
                                              phone:(NSString *)phone
                                            sendMsg:(NSString *)sendMsg
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"cardNo":cardNo,
                             @"cardType":cardType,
                             @"certNo":certNo,
                             @"certType":certType,
                             @"name":name,
                             @"originalSerialNo":originalSerialNo,
                             @"phone":phone,
                             @"sendMsg":sendMsg};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/cardBlind" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -银行卡绑定，点击接收手机验证码时调用
/*!
 *@param  cardNo 银行卡号
 *@param  cardType 卡类型：D-借记卡；C-贷记卡
 *@param  certNo 证件号
 *@param  certType 证件类型
 *@param  name 用户名称
 *@param  originalSerialNo 支付序列号
 *@param  phone 手机号
 *@param  sendMsg 验证码
 */
- (void)payment_b2c_account_pay_cardBlindSendMsmWithCardNo:(NSString *)cardNo
                                                  cardType:(NSString *)cardType
                                                    certNo:(NSString *)certNo
                                                  certType:(NSString *)certType
                                                      name:(NSString *)name
                                          originalSerialNo:(NSString *)originalSerialNo
                                                     phone:(NSString *)phone
                                                   sendMsg:(NSString *)sendMsg
                                                   success:(DCSuccessBlock)success
                                                  failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"cardNo":cardNo,
                             @"cardType":cardType,
                             @"certNo":certNo,
                             @"certType":certType,
                             @"name":name,
                             @"originalSerialNo":originalSerialNo,
                             @"phone":phone,
                             @"sendMsg":sendMsg};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/cardBlindSendMsm" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -获取支付密码错误信息，包含错误时间、错误次数
- (void)payment_b2c_account_pay_getPayPwdErrorInfoWithSuccess:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/getPayPwdErrorInfo" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -是否设置了支付密码，0-未设置，1-已设置
- (void)payment_b2c_account_pay_isSetPayPwdWithSuccess:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/isSetPayPwd" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -设置支付密码
/*!
 *@param  password 支付密码
 */
- (void)payment_b2c_account_pay_setPayPwdWithPassword:(NSString *)password
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"password":password};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/setPayPwd" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -验证支付密码，0-错误，1-正确
/*!
 *@param  password 支付密码
 */
- (void)payment_b2c_account_pay_verifyPayPwdWithPassword:(NSString *)password
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"password":password};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/verifyPayPwd" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark -验证短信验证码，0-验证码错误，1-验证码正确，2-验证码过期
/*!
 *@param  cellphone 手机号
 *@param  code 验证码
 */
- (void)payment_b2c_account_pay_verifySmsWithCellphone:(NSString *)cellphone
                                                  code:(NSString *)code
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"cellphone":cellphone,@"code":code};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/verifySms" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 支付界面数据获取-
- (void)paymentRequest_b2c_order_manage_orderForPayWithOrderNo:(NSString *)orderNo
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":orderNo};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/order/manage/orderForPay" params:params httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 支付宝支付
- (void)paymentRequest_b2c_trade_pay_alipayWithOrderNo:(NSString *)orderNo
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"orderNo":orderNo};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/pay/alipay" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 微信App支付
- (void)paymentRequest_b2c_trade_pay_apppayWithOrderNo:(NSString *)orderNo
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":orderNo};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/pay/apppay" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - App快捷支付
- (void)paymentRequest_b2c_trade_pay_quickpayWithOrderNo:(NSString *)orderNo
                                                   idStr:(NSString *)idStr
                                                  payPwd:(NSString *)payPwd
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture
{
    NSDictionary *params = @{@"orderNo":orderNo,@"id":idStr,@"payPwd":payPwd};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/pay/quickpay" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 银行卡解绑
- (void)paymentRequest_b2c_account_pay_unbindWithIdStr:(NSString *)idStr
                                              payPwd:(NSString *)payPwd
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"id":idStr,@"payPwd":payPwd};
    
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/account/pay/unbind" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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

#pragma mark - 获取企业支持的支付方式，03支付宝 04微信 05光大快捷支付
- (void)paymentRequest_b2c_trade_pay_paymodeWithFirmId:(NSString *)firmId
                                             success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture{
    NSDictionary *params = @{@"firmId":firmId};
    [SVProgressHUD show];
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/pay/paymode" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
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
