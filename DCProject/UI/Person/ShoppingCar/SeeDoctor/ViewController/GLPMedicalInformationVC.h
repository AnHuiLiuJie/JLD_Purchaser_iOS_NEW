//
//  GLPMedicalInformationVC.h
//  DCProject
//
//  Created by LiuMac on 2021/6/7.
//

#import "DCBasicViewController.h"
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPMedicalInformationVC : DCBasicViewController

@property (nonatomic, assign) BOOL isOtc; //药品中是否包含otc药品，otc需要选择用药人
@property (nonatomic, copy) NSString *goodsIds;//产品id 多个用，


@property (nonatomic, copy) void(^GLPMedicalInformationVC_block)(PatientDisplayInformationModel *infoModel,MedicalPersListModel *userModel);

@property (nonatomic, strong) PatientDisplayInformationModel *infoModel;

@end

NS_ASSUME_NONNULL_END
