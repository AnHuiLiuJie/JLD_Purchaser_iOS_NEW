//
//  EntrepreneurInfoModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrepreneurInfoModel : DCBaseModel


@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *loginName;//登录名
@property (nonatomic, copy) NSString *userName;//用户姓名
@property (nonatomic, copy) NSString *cellphone;//手机号
@property (nonatomic, copy) NSString *idCard;//身份证号
@property (nonatomic, copy) NSString *wechat;//微信号
@property (nonatomic, copy) NSString *areaId;//所属地区ID
@property (nonatomic, copy) NSString *pioneerLevel;//级别
@property (nonatomic, copy) NSString *pioneerLevelIcon;//级别图标
@property (nonatomic, copy) NSString *areaName;//所属地区名称
@property (nonatomic, copy) NSString *applyTime;//申请时间
@property (nonatomic, copy) NSString *state;//状态值：1-审核通过，2-待审核，3-审核不通过，4-禁用
@property (nonatomic, copy) NSString *stateStr;//状态字符串，页面显示使用：1-审核通过，2-待审核，3-审核不通过，4-禁用
@property (nonatomic, copy) NSString *auditUser;//审核人
@property (nonatomic, copy) NSString *auditTime;//审核时间
@property (nonatomic, copy) NSString *auditRemark;//审核备注
@property (nonatomic, copy) NSString *totalServiceFee;//累计服务费
@property (nonatomic, copy) NSString *withdrawServiceFee;//可提现服务费

@end


#pragma mark -
@interface EntrepreneurReportModel : DCBaseModel

@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *amounts;
@property (nonatomic, copy) NSString *counts;

@end



NS_ASSUME_NONNULL_END
