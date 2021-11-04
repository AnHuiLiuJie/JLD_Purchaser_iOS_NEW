//
//  TRRequestCommodityCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRRequestCommodityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sepacLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *marketLab;
@property (weak, nonatomic) IBOutlet UILabel *sellLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;

@end

NS_ASSUME_NONNULL_END
