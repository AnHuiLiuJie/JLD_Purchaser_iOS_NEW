//
//  GLPEtpCenterBannerCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpCenterBannerCell : UITableViewCell

/** 升级会员 */
@property (nonatomic, copy) dispatch_block_t upDataClassroomClickBlock;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bannerImg;

@end

NS_ASSUME_NONNULL_END
