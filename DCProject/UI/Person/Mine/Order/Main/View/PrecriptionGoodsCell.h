//
//  PrecriptionGoodsCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PrecriptionGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *wayLab;
@property (weak, nonatomic) IBOutlet UILabel *returnInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *mixTipLab;

@property (nonatomic, strong) OredrGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
