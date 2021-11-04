//
//  RequestRefundListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestRefundListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
