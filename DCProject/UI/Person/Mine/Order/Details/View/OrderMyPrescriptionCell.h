//
//  OrderMyPrescriptionCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"
#import <YBImageBrowser/YBImageBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderMyPrescriptionCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) PrescriptionDetailsModel *model;
@property (weak, nonatomic) IBOutlet UIView *jiantouView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *auditReasonLab;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supUrl_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *billDescLab;
@property (weak, nonatomic) IBOutlet UIView *supBgView;

@property (nonatomic, copy) void(^OrderMyPrescriptionCell_block)(NSString *imageUrl);
@property (nonatomic,strong) YBImageBrowser *brow;


///////
@property (nonatomic, assign) NSInteger showType;//0,我的处方 1疾病描述 2补充信息
@property (nonatomic, strong) NSMutableArray *imgArr;

@end

NS_ASSUME_NONNULL_END
