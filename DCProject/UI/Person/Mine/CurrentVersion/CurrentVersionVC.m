//
//  CurrentVersionVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/10/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "CurrentVersionVC.h"

@interface CurrentVersionVC ()

@end

@implementation CurrentVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"当前版本";
    self.view.backgroundColor = [UIColor whiteColor];
    self.versionLab.text = [NSString stringWithFormat:@"当前版本：V%@",APP_VERSION];
    
    [[DCUpdateTool shareClient] requestIsUpdate];
}

@end
