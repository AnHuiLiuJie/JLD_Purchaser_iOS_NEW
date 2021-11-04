//
//  PhotoCollectionViewCell.h
//  MSIApp
//
//  Created by ZhihanCui on 2018/6/20.
//  Copyright © 2018年 ZhihanCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageV;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
