//
//  CouponCenterGoodsCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponCenterGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageV;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *requestLab;
@property (weak, nonatomic) IBOutlet UIImageView *haveImageV;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end

NS_ASSUME_NONNULL_END
