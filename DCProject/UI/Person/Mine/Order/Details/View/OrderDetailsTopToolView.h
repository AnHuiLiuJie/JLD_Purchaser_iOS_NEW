//
//  OrderDetailsTopToolView.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsTopToolView : UIView

/*  左侧标题 */
@property (strong , nonatomic)UILabel *titleLabel;

/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;


- (void)wr_setBackgroundAlpha:(CGFloat)alpha;

// 未读消息数量
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
