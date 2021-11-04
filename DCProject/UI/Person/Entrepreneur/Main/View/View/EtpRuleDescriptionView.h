//
//  EtpRuleDescriptionView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, EtpRuleDescriptionViewType) {
    EtpRuleDescriptionViewTypeWithdraw    = 0,//提现规则
    EtpRuleDescriptionViewTypeGrade   = 1,//等级规则
    EtpRuleDescriptionViewTypeAgreement   = 2,//用户协议
    EtpRuleDescriptionViewTypeActivity   = 3,//活动规则
    EtpRuleDescriptionViewTypeTaxAmount   = 4,//代缴个税

};

NS_ASSUME_NONNULL_BEGIN

@interface EtpRuleDescriptionView : UIView

@property (nonatomic, copy) NSString *titile_str;

@property (nonatomic, assign) EtpRuleDescriptionViewType showType;

@property (nonatomic, copy) NSString *content_str;


@end

NS_ASSUME_NONNULL_END
