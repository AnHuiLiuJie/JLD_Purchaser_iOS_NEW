//
//  HomeHotListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeHotListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) GLPHomeDataListModel *model;

@property (assign, nonatomic) NSInteger radiusType;
@end

NS_ASSUME_NONNULL_END
