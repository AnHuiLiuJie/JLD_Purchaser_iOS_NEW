//
//  TRHomeCollectionCell1.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRHomeCollectionCell1 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end

NS_ASSUME_NONNULL_END
