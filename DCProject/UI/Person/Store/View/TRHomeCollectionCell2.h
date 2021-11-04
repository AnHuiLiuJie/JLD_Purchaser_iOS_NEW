//
//  TRHomeCollectionCell2.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRHomeCollectionCell2 : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (strong, nonatomic) GLPHomeDataListModel *model;


@end

NS_ASSUME_NONNULL_END
