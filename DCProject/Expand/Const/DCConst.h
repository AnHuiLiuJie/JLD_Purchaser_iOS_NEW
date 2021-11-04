//
//  DCConst.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 常量数 10
UIKIT_EXTERN CGFloat const DCMargin;

/// 背景色 #00BEB3 常用按钮的颜色
extern NSString *const DC_BtnColor;
/// 背景色 #eeeeee 238, 238, 238 灰
extern NSString *const DC_BGColor;
/// 颜色 #1a1b1c 26, 27, 28 黑
extern NSString *const DC_1a1b1c;
/// 颜色 #333333 51, 51, 51
extern NSString *const DC_333333;
/// 颜色 #3683FF 54, 131, 255 蓝
extern NSString *const DC_3683FF;
/// 颜色 #444444 68, 68, 68
extern NSString *const DC_444444;
/// 颜色 #4BA8FF 75, 168, 255 淡蓝
extern NSString *const DC_4BA8FF;
/// 颜色 #666666 102, 102, 102
extern NSString *const DC_666666;
/// 颜色 #999999 153, 153, 153
extern NSString *const DC_999999;
/// 颜色 #cccccc 204, 204, 204
extern NSString *const DC_cccccc;
/// 颜色 #E44450 228, 68, 80 红
extern NSString *const DC_E44450;
/// 线条 #F5F7F7 245, 247, 247
extern NSString *const DC_LineColor;

/// 成功 #00C957   1DA9A2
extern NSString *const DC_SuccessStatusColor;
/// 失败 #FF3B30
extern NSString *const DC_FailureStatusColor;
/// 其他 #35A4FF
extern NSString *const DC_OtherStatusColor;
/// 主题色 #35A4FF
extern NSString *const DC_AppThemeColor;

/// 七牛token 本地存储的key名
extern NSString *const DC_QiniuToken_Key;
/// 七牛imageurl 本地存储的key名
extern NSString *const DC_QiniuImgUrl_Key;
/// Token 本地存储的key名
extern NSString *const DC_Token_Key;
/// Userid 本地存储的key名
extern NSString *const DC_UserID_Key;
/// 地区 本地存储的key名
extern NSString *const DC_AreaData_Key;
/// 公司类型 本地存储的key名
extern NSString *const DC_CompanyType_Key;
/// 商品搜索记录 本地存储的key名
extern NSString *const DC_GoodsSearchRecord_Key;
/// 店铺搜索记录 本地存储的key名
extern NSString *const DC_StoreSearchRecord_Key;
/// 个人版商品搜索记录 本地存储的key名
extern NSString *const DC_Person_GoodsSearchRecord_Key ;
/// 开屏广告 本地存储的key名
extern NSString *const DC_OpenAdv_Key;
/// 占位图 本地存储的key名
extern NSString *const DC_Placeholder_Key;
/// 可变请求地址 本地存储的key名
//extern NSString *const DC_IP_Key;
/// 可变h5地址 本地存储的key名
//extern NSString *const DC_H5_Key;
/// 可变请求地址 本地存储的key名 - 个人
//extern NSString *const DC_PersonIP_Key;
/// 可变h5地址 本地存储的key名 - 个人
//extern NSString *const DC_PersonH5_Key;
/// 当前登录的用户类型 本地存储的key名
extern NSString *const DC_UserType_Key;
/// userinfo 本地存储的key名
extern NSString *const DC_UserInfo_Key;

/// 当前登录的用户资质等状态 本地存储的key名
extern NSString *const DC_UserModel_Key;

///版本判断 本地存储当前时间
extern NSString *const DC_CurrentDate_key;
///商品列表展示样式 横向列表 或纵向列表
extern NSString *const DC_GoodsListType_key;


/// 用户头像 本地存储的key名
extern NSString *const DC_UserImage_Key;
/// 用户名 本地存储的key名
extern NSString *const DC_UserName_Key;


#pragma mark - 响应
/// 请求 响应状态 key值
extern NSString *const DC_ResultCode_Key;
/// 请求 响应message key值
extern NSString *const DC_ResultMsg_Key;
/// 请求 响应状态 成功 200
UIKIT_EXTERN NSInteger const DC_Result_Success;
/// 请求 响应状态 token无效 900001
UIKIT_EXTERN NSInteger const DC_Result_TokenOut;
/// 请求 响应状态 未登录 900002
UIKIT_EXTERN NSInteger const DC_Result_UnLogin;
/// 请求 响应状态 账户不存在 900002
UIKIT_EXTERN NSInteger const DC_Result_Unexist;
/// 请求 响应状态 无权限 900005
UIKIT_EXTERN NSInteger const DC_Result_Unallow;
UIKIT_EXTERN NSInteger const DC_Result_Eegistered;
/// 请求 响应状态 用户不存在 500003 如果当前是登录业务：客户提示：手机号码未注册，是否现在去注册？  【取消】=关闭提示  【确定】=去注册页面
UIKIT_EXTERN NSInteger const DC_Result_NotExist;


#pragma mark - 通知
/// 用户注册成功，去登录通知
extern NSString *const DC_RegisterLogin_Notification;
/// 用户登录成功，同志商品详情刷新
extern NSString *const DC_LoginSucess_Notification;
/// 支付宝支付完成
extern NSString *const DC_AlipayResulkt_NotificationName;
/// 微信支付完成
extern NSString *const DC_WxPayResulkt_NotificationName;


/// 点击环信订单查询
extern NSString *const DC_HXOrderCheck_NotificationName;
/// 点击环信推送消息
extern NSString *const DC_HXMessageCheck_NotificationName;
extern NSString *const DC_HXMessageCheck_NotificationName1;
extern NSString *const DC_HXMessageCheck_NotificationName2;

#pragma mark - 个人版
/// Token 本地存储的key名
extern NSString *const P_Token_Key;
/// Userid 本地存储的key名
extern NSString *const P_UserID_Key;
/// User 本地存储的key名
extern NSString *const P_UserInfo_Key;
/// 地区本地存储的key名
extern NSString *const P_AreaData_Key;
/// 人用户名名账号
extern NSString *const DC_Person_loginName_Key;
/// 公司登录名账号
extern NSString *const DC_Company_loginName_Key;
/// 个人本地常用存储
extern NSString *const DC_LocalCommonSetModel_Key;
/// 临时Token 本地存储的key名
extern NSString *const P_TemporaryToken_Key;
/// 临时Userid 本地存储的key名
extern NSString *const P_TemporaryUserID_Key;

#pragma mark - 环信登录信息
/*Add_HX_标识
 *存储登录信息
 */
extern NSString *const DC_UserInfo_EaseMobile_Key;
/// 环信APNs 通知
extern NSString *const DC_HX_Notification_Key;


#pragma mark - 用户自定义环信消息
extern NSString *const DC_Custom_Message_Key;
//两次提示的默认间隔
extern CGFloat const DC_kDefaultPlaySoundInterval;
extern NSString *const DC_kMessageType;
extern NSString *const DC_kConversationChatter;
extern NSString *const DC_kGroupName;

#pragma mark - 客服类型
extern NSString *const DC_Message_preSale_Key;
extern NSString *const DC_Message_afterSale_Key;

extern NSString *const DC_IsFirstOpen_Key;
