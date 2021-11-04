//
//  TRGoodsCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPMineCollectModel.h"
#import "GLPMineSeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bqImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *storeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icn_stau;
@property (weak, nonatomic) IBOutlet UILabel *mjLab;
@property (weak, nonatomic) IBOutlet UILabel *xsLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *gwcBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *line;


// 收藏模型
@property (nonatomic, strong) GLPMineCollectModel *collectModel;
// 浏览记录模型
@property (nonatomic, strong) GLPMineSeeGoodsModel *seeModel;


@end

NS_ASSUME_NONNULL_END
