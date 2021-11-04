//
//  RequestListVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestListVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBen;
@property (weak, nonatomic) IBOutlet UIButton *CDBtn;
- (IBAction)choseClick:(id)sender;
- (IBAction)collectClick:(id)sender;
- (IBAction)commitOrDeleClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
