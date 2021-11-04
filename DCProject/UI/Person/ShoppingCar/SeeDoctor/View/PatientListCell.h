//
//  PatientListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PatientListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) MedicalPersListModel *model;
@property (weak, nonatomic) IBOutlet UIView *typeBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic, copy) dispatch_block_t PatientListCellDel_block;
@property (nonatomic, copy) dispatch_block_t PatientListCellEid_block;
@property (weak, nonatomic) IBOutlet UILabel *relationLab;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultLab;
@property (weak, nonatomic) IBOutlet UILabel *authenticateLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isDefault_X_LayoutConstraint;

@end

NS_ASSUME_NONNULL_END
