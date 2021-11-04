//
//  AppDelegate.h
//  DCProject
//
//  Created by bigbing on 2019/3/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer API_AVAILABLE(ios(10.0))
;

- (void)saveContext;

@property (nonatomic,assign ) NSInteger index_num;

// 时间器
@property (nonatomic, strong) NSTimer *timer;
// 时间
@property (nonatomic, assign) NSInteger index;

@end

