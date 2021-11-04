//
//  GLPSpikeHomeTopToolView.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPSpikeHomeTopToolView : UIView

/*  中间标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;

/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;

- (void)wr_setBackgroundAlpha:(CGFloat)alpha;


@end

NS_ASSUME_NONNULL_END
