//
//  DCConst.m
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 常量数
CGFloat const DCMargin = 10;


/// 背景色#00BEB3  常用按钮的颜色
NSString *const DC_BtnColor = @"#00BEB3";
/// 背景色 #F5F7F7
NSString *const DC_BGColor = @"#F5F7F7";
/// 颜色 #1a1b1c
NSString *const DC_1a1b1c = @"#1a1b1c";
/// 颜色 #333333
NSString *const DC_333333 = @"#333333";
/// 颜色 #3683FF
NSString *const DC_3683FF = @"#3683FF";
/// 颜色 #444444
NSString *const DC_444444 = @"#444444";
/// 颜色 #4BA8FF
NSString *const DC_4BA8FF = @"#4BA8FF";
/// 颜色 #666666
NSString *const DC_666666 = @"#666666";
/// 颜色 #999999
NSString *const DC_999999 = @"#999999";
/// 颜色 #cccccc
NSString *const DC_cccccc = @"#cccccc";
/// 颜色 #E44450
NSString *const DC_E44450 = @"#E44450";
/// 线条 #F5F7F7
NSString *const DC_LineColor = @"#EEEEEE";
/// 成功 #00C957   1DA9A2
NSString *const DC_SuccessStatusColor = @"#00C957";
/// 失败 #FF3B30
NSString *const DC_FailureStatusColor = @"#FF3B30";
/// 其他 #35A4FF
NSString *const DC_OtherStatusColor = @"#35A4FF";;
/// 主题色 #35A4FF
NSString *const DC_AppThemeColor = @"#35A4FF";;


/// 七牛token 本地存储的key名
NSString *const DC_QiniuToken_Key = @"DC_QiniuTokenKey";
/// 七牛imageurl 本地存储的key名
NSString *const DC_QiniuImgUrl_Key = @"DC_QiniuImgUrlKey";
/// Token 本地存储的key名
NSString *const DC_Token_Key = @"DC_Token_Key";
/// Userid 本地存储的key名
NSString *const DC_UserID_Key = @"DC_UserID_Key";

/// 地区 本地存储的key名
NSString *const DC_AreaData_Key = @"DC_AreaData_Key";
/// 公司类型 本地存储的key名
NSString *const DC_CompanyType_Key = @"DC_CompanyType_Key";
/// 商品搜索记录 本地存储的key名
NSString *const DC_GoodsSearchRecord_Key = @"DC_GoodsSearchRecord_Key";
/// 店铺搜索记录 本地存储的key名
NSString *const DC_StoreSearchRecord_Key = @"DC_StoreSearchRecord_Key";
/// 个人版商品搜索记录 本地存储的key名
NSString *const DC_Person_GoodsSearchRecord_Key = @"DC_Person_GoodsSearchRecord_Key";
/// 开屏广告 本地存储的key名
NSString *const DC_OpenAdv_Key = @"DC_OpenAdv_Key";
/// 占位图 本地存储的key名
NSString *const DC_Placeholder_Key = @"DC_Placeholder_Key";
/// 可变请求地址 本地存储的key名
//NSString *const DC_IP_Key = @"DC_IP_Key";
/// 可变h5地址 本地存储的key名
//NSString *const DC_H5_Key = @"DC_H5_Key";
/// 可变请求地址 本地存储的key名 - 个人
//NSString *const DC_PersonIP_Key = @"DC_PersonIP_Key";
/// 可变h5地址 本地存储的key名 - 个人
//NSString *const DC_PersonH5_Key = @"DC_PersonH5_Key";
/// 当前登录的用户类型 本地存储的key名
NSString *const DC_UserType_Key = @"DC_UserType_Key";
/// userinfo 本地存储的key名
NSString *const DC_UserInfo_Key = @"DC_UserInfo_Key";
/// 当前登录的用户资质等状态 本地存储的key名
NSString *const DC_UserModel_Key = @"DC_UserModel_Key";

///版本判断 本地存储当前时间
NSString *const DC_CurrentDate_key = @"DC_CurrentDate_key";

///商品列表展示样式 横向列表 或纵向列表
NSString *const DC_GoodsListType_key = @"DC_GoodsListType_key";

/// 用户头像 本地存储的key名
NSString *const DC_UserImage_Key = @"DC_UserImage_Key";
/// 用户名 本地存储的key名
NSString *const DC_UserName_Key = @"DC_UserName_Key";

/// 人用户名名账号
NSString *const DC_Person_loginName_Key = @"person_loginName";
/// 公司登录名账号
NSString *const DC_Company_loginName_Key = @"company_loginName";

NSString *const DC_IsFirstOpen_Key = @"DC_IsFirstOpen_Key";


#pragma mark - 响应
/// 请求 响应状态 key值
NSString *const DC_ResultCode_Key = @"code";
/// 请求 响应message key值
NSString *const DC_ResultMsg_Key = @"msg";
/// 请求 响应状态 成功 200
NSInteger const DC_Result_Success = 200;
/// 请求 响应状态 token无效 900001
NSInteger const DC_Result_TokenOut = 900001;
/// 请求 响应状态 未登录 900002
NSInteger const DC_Result_UnLogin = 900002;
/// 请求 响应状态 账户不存在 900003
NSInteger const DC_Result_Unexist = 900003;
/// 请求 响应状态 无权限 900005
NSInteger const DC_Result_Unallow = 900005;
/// 请求 响应状态 无权限 500020 客户提示：手机号码已经注册，是否现在去登录？  【取消】=关闭提示  【确定】=去登录页面
NSInteger const DC_Result_Eegistered = 500020;
/// 请求 响应状态 用户不存在 500003 如果当前是登录业务：客户提示：手机号码未注册，是否现在去注册？  【取消】=关闭提示  【确定】=去注册页面
NSInteger const DC_Result_NotExist = 500003;

#pragma mark - 通知
/// 用户注册成功，去登录通知
NSString *const DC_RegisterLogin_Notification = @"DC_RegisterLogin_Notification";
/// 用户登录成功，同志商品详情刷新
NSString *const DC_LoginSucess_Notification = @"DC_LoginSucess_Notification";
/// 支付宝支付完成
NSString *const DC_AlipayResulkt_NotificationName = @"DC_AlipayResulkt_NotificationName";
/// 微信支付完成
NSString *const DC_WxPayResulkt_NotificationName = @"DC_WxPayResulkt_NotificationName";


/// 点击环信订单查询
NSString *const DC_HXOrderCheck_NotificationName = @"DC_HXOrderCheck_NotificationName";
/// 点击环信推送消息
NSString *const DC_HXMessageCheck_NotificationName = @"DC_HXMessageCheck_NotificationName";
NSString *const DC_HXMessageCheck_NotificationName1 = @"DC_HXMessageCheck_NotificationName1";
NSString *const DC_HXMessageCheck_NotificationName2 = @"DC_HXMessageCheck_NotificationName2";

#pragma mark - 个人版
// Token 本地存储的key名
NSString *const P_Token_Key = @"P_Token_Key";
// Userid 本地存储的key名
NSString *const P_UserID_Key = @"P_UserID_Key";
// User 本地存储的key名
NSString *const P_UserInfo_Key = @"P_UserInfo_Key";
// 地区 本地存储的key名
NSString *const P_AreaData_Key = @"P_AreaData_Key";
/// 个人本地常用存储
NSString *const DC_LocalCommonSetModel_Key = @"DC_LocalCommonSetModel_Key";

// 临时Token 本地存储的key名
NSString *const P_TemporaryToken_Key = @"P_TemporaryToken_Key";
// 临时Userid 本地存储的key名
NSString *const P_TemporaryUserID_Key = @"P_TemporaryUserID_Key";

#pragma mark - 环信登录信息
NSString *const DC_UserInfo_EaseMobile_Key = @"DC_UserInfo_EaseMobile_Key";
/// 环信APNs 通知
NSString *const DC_HX_Notification_Key = @"DC_HX_Notification_Key";

#pragma mark - 用户自定义环信消息
NSString *const DC_Custom_Message_Key = @"user_custom_message_Key";
//两次提示的默认间隔
CGFloat const DC_kDefaultPlaySoundInterval = 3.0;
NSString *const DC_kMessageType = @"MessageType";
NSString *const DC_kConversationChatter = @"ConversationChatter";
NSString *const DC_kGroupName = @"GroupName";

#pragma mark - 客服类型
NSString *const DC_Message_preSale_Key = @"shangpingkefu";//卖商品的客服
NSString *const DC_Message_afterSale_Key = @"yaoshikefu";//药师客服
