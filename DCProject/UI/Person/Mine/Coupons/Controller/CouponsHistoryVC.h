//
//  CouponsHistoryVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponsHistoryVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)userClick:(id)sender;
- (IBAction)timeClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
