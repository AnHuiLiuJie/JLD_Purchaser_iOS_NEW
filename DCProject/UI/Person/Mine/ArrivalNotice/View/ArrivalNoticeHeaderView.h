//
//  ArrivalNoticeHeaderView.h
//  DCProject
//
//  Created by LiuMac on 2021/7/6.
//

#import <UIKit/UIKit.h>
#import "ArrivalNoticeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArrivalNoticeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptView_H_LayoutConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgView_Y_LayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UILabel *timePre;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UISwitch *smsSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBgView_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (nonatomic, copy) void(^ArrivalNoticeHeaderView_block)(NSString *isSms);
@property (nonatomic, copy) void(^ArrivalNoticeHeaderView_block2)(NSString *expectTime);
@property (nonatomic, copy) void(^ArrivalNoticeHeaderView_block3)(NSString *buyerCellphone);

@property (nonatomic, strong) ArrivalNoticeModel *model;
@property (nonatomic, copy) NSArray *timeArr;

@end

NS_ASSUME_NONNULL_END
