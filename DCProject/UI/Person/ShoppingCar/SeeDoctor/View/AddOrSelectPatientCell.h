//
//  AddOrSelectPatientCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddOrSelectPatientCell : UITableViewCell

@property (nonatomic, copy) NSString *drugId;

@property (nonatomic, copy) NSArray *persList;

@property (nonatomic, copy) dispatch_block_t AddOrSelectPatientCell_AddBlock;

@property (nonatomic, copy) void(^AddOrSelectPatientCell_editBlock)(MedicalPersListModel *model);
@property (nonatomic, copy) void(^AddOrSelectPatientCell_selectedBlock)(MedicalPersListModel *model);

@end


#pragma mark - 用药人
@interface MedicalPersListView : UIView

@property (nonatomic, copy) void(^MedicalPersListView_block)(NSInteger index);

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) MedicalPersListModel *model;
@property (nonatomic, strong) UIButton *statusBtn;


@end

NS_ASSUME_NONNULL_END
