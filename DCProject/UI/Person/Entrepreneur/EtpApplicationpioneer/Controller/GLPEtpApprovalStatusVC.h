//
//  GLPEtpApprovalStatusVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import "DCBasicViewController.h"
#import "EntrepreneurInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, EtpApprovalStatus) {
    EtpApprovalStatusReviewing    = 0,//审核中
    EtpApprovalStatusReviewFailure   = 1,//审核失败
};

@interface GLPEtpApprovalStatusVC : DCBasicViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *status_img;
@property (weak, nonatomic) IBOutlet UILabel *status_lab;
//@property (weak, nonatomic) IBOutlet UILabel *tishi_lab;
@property (weak, nonatomic) IBOutlet UILabel *noPass_lab1;
@property (weak, nonatomic) IBOutlet UILabel *noPass_lab2;

@property (weak, nonatomic) IBOutlet UILabel *tell_lab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tell_Y_LayoutConstraint;

@property (weak, nonatomic) IBOutlet UIButton *submit_btn;

@property (nonatomic, assign) EtpApprovalStatus statusType;
@property (strong , nonatomic) EntrepreneurInfoModel *userInfoModel;


@property (weak, nonatomic) IBOutlet UILabel *tishi_lab;

@end

NS_ASSUME_NONNULL_END
