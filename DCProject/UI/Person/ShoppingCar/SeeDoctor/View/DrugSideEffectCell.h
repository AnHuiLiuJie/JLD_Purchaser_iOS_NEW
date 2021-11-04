//
//  DrugSideEffectCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "MedicalInfomationModel.h"
NS_ASSUME_NONNULL_BEGIN

//药品相关病例至少选择一个



@interface DrugSideEffectCell : UITableViewCell

@property (nonatomic,strong) MedicalSymptomListModel *model;

@property (nonatomic,strong) NSMutableArray *selctedSymptom;

@property (nonatomic,strong) NSMutableArray *diseaseArr;

@property (nonatomic, copy) dispatch_block_t DrugSideEffectCell_block;

//@property (nonatomic, copy) void(^DrugSideEffectCell_backBlock)(NSDictionary *dic) ;
@property (nonatomic, copy) void(^DrugSideEffectCell_backBlock)(NSString *symptoms) ;



@end

NS_ASSUME_NONNULL_END
