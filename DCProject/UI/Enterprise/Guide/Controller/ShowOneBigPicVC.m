//
//  ShowOneBigPicVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/10/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "ShowOneBigPicVC.h"

@interface ShowOneBigPicVC ()

@end

@implementation ShowOneBigPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigImageV.image = [UIImage imageNamed:@"zhengzhao"];
    self.bigImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(distap)];
    [self.bigImageV addGestureRecognizer:tap];
    self.ImageHeight.constant = 1182*kScreenW/810;
}

- (IBAction)disClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)distap
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
