//
//  PatientInfoFooterView.h
//  DCProject
//
//  Created by LiuMac on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientInfoFooterView : UIView

@property (nonatomic, strong) MedicalPersListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nowIllnessLab;
@property (weak, nonatomic) IBOutlet UILabel *historyAllergicLab;
@property (weak, nonatomic) IBOutlet UILabel *historyIllnessLab;
@property (weak, nonatomic) IBOutlet UILabel *liverUnusualLab;
@property (weak, nonatomic) IBOutlet UILabel *renalUnusualLab;
@property (weak, nonatomic) IBOutlet UILabel *lactationFlagLab;

@end

NS_ASSUME_NONNULL_END
