//
//  GLPMineHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLPMineHeadViewBlock)(NSInteger tag);
typedef void(^GLPMineAuthenBlock)(void);
typedef void(^GLPMineCouponBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface GLPMineHeadView : UIView
@property(nonatomic,strong)NSDictionary *numDic;
@property(nonatomic,strong)NSDictionary *personDic;
@property (nonatomic, copy) GLPMineHeadViewBlock headViewBlock;
@property (nonatomic, copy) GLPMineAuthenBlock authenBlock;
@property (nonatomic, copy) GLPMineCouponBlock couponBlock;
// 未读消息数量
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
