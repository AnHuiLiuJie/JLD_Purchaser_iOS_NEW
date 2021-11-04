//
//  CustomTitleView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CustomTitleViewDelegate <NSObject>

- (void)TitileButtonClickButtonAction:(NSInteger )btnTag;

@end

@interface CustomTitleView : UIView

@property (nonatomic, weak) id<CustomTitleViewDelegate> delegate;

/** 标题 */
@property (nonatomic, copy) void(^TitileButtonClickBlock)(NSInteger btnTag);

@property (nonatomic, copy) NSArray *accountArray;

@property (nonatomic, assign) NSInteger selectedIndex;//默认第一个

@end

NS_ASSUME_NONNULL_END
