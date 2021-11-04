//
//  GLPGroupBuyBottomTabView.h
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPGroupBuyBottomTabView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) void(^GLPGroupBuyBottomTabView_btnBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
