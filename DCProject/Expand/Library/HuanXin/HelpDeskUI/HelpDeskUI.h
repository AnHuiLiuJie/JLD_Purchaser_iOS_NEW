/************************************************************
 * *Hyphenate CONFIDENTIAL
 *__________________
 *Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 *NOTICE: All information contained herein is, and remains
 *the property of Hyphenate Inc.
 *Dissemination of this information or reproduction of this material
 *is strictly forbidden unless prior written permission is obtained
 *from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

//#define MAS_SHORTHAND  // 只要添加了这个宏，就不用带mas_前缀https://blog.csdn.net/allanGold/article/details/79387705?utm_medium=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-1.nonecase&dist_request_id=1619658154138_98235&depth_1-utm_source=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-1.nonecas
//#define MAS_SHORTHAND_GLOBALS // 只要添加了这个宏，equalTo就等价于mas_equalTo
//#import "Masonry.h"

#import "HDMessageViewController.h"
#import "HDViewController.h"

#import "HDIModelCell.h"
#import "HDIModelChatCell.h"
#import "HDMessageCell.h"
#import "HDBaseMessageCell.h"
#import "HDBubbleView.h"
#import "CustomButton.h"

#import "HDChineseToPinyin.h"
#import "HDEmoji.h"
#import "HDEmotionEscape.h"
#import "HDEmotionManager.h"
#import "HDSDKHelper.h"
#import "HDCDDeviceManager.h"
#import "HDConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"
#import "UIView+FLExtension.h"
#import "NSString+HDValid.h"
//#import "UIImageView+HDWebCache.h"//lj_SDk_change
#import "UIViewController+HDHUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIResponder+HRouter.h"
#import "HDLocalDefine.h"




//Ext keyWord
#define kMessageExtWeChat @"weichat"
#define kMessageExtWeChat_ctrlType @"ctrlType"
#define kMessageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMessageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMessageExtWeChat_ctrlType_transferToKf_HasTransfer @"hasTransfer"
#define kMessageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMessageExtWeChat_ctrlArgs_evaluationDegree @"evaluationDegree"
#define kMessageExtWeChat_ctrlType_transferToKfHint  @"TransferToKfHint"
#define kMessageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMessageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMessageExtWeChat_ctrlArgs_detail @"detail"
#define kMessageExtWeChat_ctrlArgs_summary @"summary"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define kWeakSelf __weak __typeof__(self) weakSelf = self;
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kHDScreenWidth [UIScreen mainScreen].bounds.size.width
#define kHDScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define fHDUserDefaults [NSUserDefaults standardUserDefaults]

#define fKeyWindow [UIApplication sharedApplication].keyWindow
#define fUserDefaults [NSUserDefaults standardUserDefaults]

@interface HelpDeskUI : NSObject

@end
