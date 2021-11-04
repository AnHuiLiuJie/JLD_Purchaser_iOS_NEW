//
//  GLPPaymentManageListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPPaymentManageListCell : UITableViewCell

@property (nonatomic, copy) void(^GLPPaymentManageListCell_block)(NSInteger type);

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
