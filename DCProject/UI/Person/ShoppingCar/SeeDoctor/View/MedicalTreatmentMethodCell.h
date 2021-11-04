//
//  MedicalTreatmentMethodCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface MedicalTreatmentMethodCell : UITableViewCell

@property (nonatomic, copy) NSString *onlineStatus;

@property (nonatomic, copy)  void(^MedicalTreatmentMethodCell_block)(NSString *onlineStatus);

@end

NS_ASSUME_NONNULL_END
