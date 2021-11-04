//
//  TRMessageListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRMessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageV;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UILabel *redLab;

@end

NS_ASSUME_NONNULL_END
