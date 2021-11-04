//
//  GLPAddPatientViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "DCBasicViewController.h"
#import "PatientInfoCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface GLPAddPatientViewController : DCBasicViewController

@property (nonatomic, strong) MedicalPersListModel *model;
@property (nonatomic, copy) NSString *drugId;

@property (nonatomic, copy) dispatch_block_t GLPAddPatientViewController_block;
@end

NS_ASSUME_NONNULL_END
