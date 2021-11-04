//
//  PatientInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (nonatomic, strong) MedicalPersListModel *model;

@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UITextField *idCar_tf;
@property (weak, nonatomic) IBOutlet UITextField *weight_tf;
@property (weak, nonatomic) IBOutlet UITextField *tel_tf;
@property (weak, nonatomic) IBOutlet UILabel *tapBgView;

@property (copy, nonatomic) void(^PatientInfoCell_block)(NSString *text,NSInteger type);
@property (copy, nonatomic) void(^PatientInfoCell_Block)(MedicalPersListModel *model);


@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet UIView *promptLine;

@end

NS_ASSUME_NONNULL_END
