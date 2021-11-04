//
//  CouponGoodsCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsCouponLab;
@property (weak, nonatomic) IBOutlet UIButton *goodsUserBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cellBgImageView;

@end

NS_ASSUME_NONNULL_END
