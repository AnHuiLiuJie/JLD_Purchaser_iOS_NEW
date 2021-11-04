//
//  PrescriptionConfirmCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrescriptionConfirmCell : UITableViewCell

@property (nonatomic, strong) UIButton *statusBtn;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy)  dispatch_block_t PrescriptionConfirmCell_block;

@end

NS_ASSUME_NONNULL_END
