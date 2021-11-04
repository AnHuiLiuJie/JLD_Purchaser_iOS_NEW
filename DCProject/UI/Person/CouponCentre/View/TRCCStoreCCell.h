//
//  TRCCStoreCCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCCStoreCCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *canuserLab;

@end

NS_ASSUME_NONNULL_END
