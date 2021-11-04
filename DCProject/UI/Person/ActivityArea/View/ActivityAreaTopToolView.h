//
//  ActivityAreaTopToolView.h
//  DCProject
//
//  Created by LiuMac on 2021/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityAreaTopToolView : UIView

/*  中间标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;

- (void)wr_setBackgroundAlpha:(CGFloat)alpha;


@end

NS_ASSUME_NONNULL_END
