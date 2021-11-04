//
//  GLPEtpCenterHeaderView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpCenterHeaderView : UIView

/* 头像点击回调 */
@property (nonatomic, copy) dispatch_block_t headClickBlock;

@property (nonatomic, copy) void(^headerViewClickBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView_Y_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImg;
@property (weak, nonatomic) IBOutlet UILabel *allServiceLab;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UILabel *availableLab;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;

@end

NS_ASSUME_NONNULL_END
