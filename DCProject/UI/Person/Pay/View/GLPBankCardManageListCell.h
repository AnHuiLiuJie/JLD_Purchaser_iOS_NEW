//
//  GLPBankCardManageListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import <UIKit/UIKit.h>
#import "GLPBankCardListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPBankCardManageListCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t GLPBankCardManageListCell_block;

@property (nonatomic, strong) GLPBankCardListModel *model;

@end

NS_ASSUME_NONNULL_END
