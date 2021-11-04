//
//  TRClassGoodsVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRHotCommdityVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
- (IBAction)backClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mrBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priceImageV;
@property (weak, nonatomic) IBOutlet UIImageView *choseImageV;
@property (weak, nonatomic) IBOutlet UIImageView *mor_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
- (IBAction)searchClick:(id)sender;
- (IBAction)mrClick:(id)sender;
- (IBAction)priceClick:(id)sender;
- (IBAction)choseClick:(id)sender;
- (IBAction)moreClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
