//
//  TRChoseRandVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^DosageFormBlock)(NSArray *choseArr);
@interface TRChoseDosageFormVC : DCBasicViewController
@property(nonatomic,copy)DosageFormBlock dosageFormblock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
- (IBAction)resetClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
- (IBAction)comfireClick:(id)sender;
- (IBAction)dissClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *choseArray;
@property(nonatomic,strong)NSArray *dataArray;
@end

NS_ASSUME_NONNULL_END
