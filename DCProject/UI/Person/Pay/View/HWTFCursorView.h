//
//  HWTFCursorView.h
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 基础版 - 下划线 - 有光标 - 方框
 */
@interface HWTFCursorView : UIView


// ----------------------------Data----------------------------
/// 当前输入的内容
@property (nonatomic, copy, readonly) NSString *code;


@property (nonatomic, copy)  void(^HWTFCursorView_InputComplete_block)(NSString *password);;
@property (nonatomic, assign) BOOL isResetView;

// ----------------------------Method----------------------------

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
//isAvailable
@end




// ------------------------------------------------------------------------
// -----------------------------HWCursorLabel------------------------------
// ------------------------------------------------------------------------

@interface HWCursorLabel : UITextField//UILabel

@property (nonatomic, weak, readonly) UIView *cursorView;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
