//
//  TRHomeTableCell1.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRHomeTableCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

NS_ASSUME_NONNULL_END
