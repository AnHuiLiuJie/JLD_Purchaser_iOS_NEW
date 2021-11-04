//
//  CouponStoreCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;

@end

NS_ASSUME_NONNULL_END
