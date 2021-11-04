//
//  EtpInviteTopToolView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EtpInviteTopToolView : UIView

@property (nonatomic, copy) dispatch_block_t leftItemClickBlock;
- (void)wr_setBackgroundAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
