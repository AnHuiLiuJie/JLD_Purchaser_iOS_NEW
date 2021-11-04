//
//  PatientRelationshipCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientRelationshipCell : UITableViewCell

@property (nonatomic, strong) MedicalPersListModel *model;

@property (nonatomic,assign) NSInteger specIdx;//选中第几个

@property (nonatomic, copy) void(^PatientRelationshipCell_block)(MedicalPersListModel *model);
@property (nonatomic, copy) dispatch_block_t PatientRelationshipCell_Block;

@end

NS_ASSUME_NONNULL_END
