//
//  TRRecommCollectionCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRRecommCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *bqImageV1;
@property (weak, nonatomic) IBOutlet UIImageView *bqImageV2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVheight;

@end

NS_ASSUME_NONNULL_END
