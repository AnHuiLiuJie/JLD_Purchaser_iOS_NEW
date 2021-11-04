//
//  TRHistoryCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImageV;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *LookBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statuImageV;

@end

NS_ASSUME_NONNULL_END
