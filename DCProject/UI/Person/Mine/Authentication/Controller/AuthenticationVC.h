//
//  AuthenticationVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
- (IBAction)comfireClick:(id)sender;
@property(nonatomic,copy) NSString *statuStr;
@property(nonatomic,copy) NSString *modifyTimeParam;
@end

NS_ASSUME_NONNULL_END
