//
//  GLPEtpCenterTopToolView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpCenterTopToolView : UIView

/*  中间标题 */
@property (strong , nonatomic)UILabel *titleLabel;

/** 左边Item点击 */
@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
/** 右边Item点击 */
@property (nonatomic, copy) dispatch_block_t rightItemClickBlock;


- (void)wr_setBackgroundAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
