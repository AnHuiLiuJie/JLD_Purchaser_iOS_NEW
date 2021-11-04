//
//  OrderAdvisoryView.h
//  DCProject
//
//  Created by LiuMac on 2021/5/7.
//

#import <UIKit/UIKit.h>
#import "GLPOrderAdvisoryPageVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderAdvisoryView : UIView

+ (void)lj_showSildBarViewControllerModel:(nullable DCChatGoodsModel *)filterModel;
- (instancetype)initWithFrame:(CGRect)frame filterModel:(nullable DCChatGoodsModel *)filterModel;

/** 点击已选回调 */
@property (nonatomic , copy) void(^OrderAdvisoryViewBlock)(NSDictionary *commodityInfo);

@end

NS_ASSUME_NONNULL_END
