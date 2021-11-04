//
//  CouponsListVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponsListVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *storebtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsbtn;
@property (weak, nonatomic) IBOutlet UIButton *platformbtn;
@property (weak, nonatomic) IBOutlet UIButton *historybtn;
@property (weak, nonatomic) IBOutlet UIButton *getbtn;
- (IBAction)getCouponsClick:(id)sender;
- (IBAction)couponsHistoryClick:(id)sender;
- (IBAction)storeClick:(id)sender;
- (IBAction)goodsClick:(id)sender;
- (IBAction)platformClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
