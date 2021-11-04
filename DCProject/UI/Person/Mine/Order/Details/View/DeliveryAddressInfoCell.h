//
//  DeliveryAddressInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>
#import "GLPOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeliveryAddressInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (nonatomic, strong) GLPOrderDetailModel *model;

@end

NS_ASSUME_NONNULL_END
