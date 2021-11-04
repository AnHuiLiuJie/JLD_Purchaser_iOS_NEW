//
//  ShowOneBigPicVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/10/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowOneBigPicVC : DCBasicViewController
- (IBAction)disClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageHeight;

@end

NS_ASSUME_NONNULL_END
