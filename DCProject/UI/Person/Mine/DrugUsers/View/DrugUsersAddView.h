//
//  DrugUsersAddView.h
//  DCProject
//
//  Created by Apple on 2021/3/18.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DrugUsersAddViewItem;

@interface DrugUsersAddView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) DrugUsersAddViewItem *gwbs;
@property (nonatomic,strong) DrugUsersAddViewItem *gms;
@property (nonatomic,strong) DrugUsersAddViewItem *jzbs;
@property (nonatomic,strong) DrugUsersAddViewItem *ggn;
@property (nonatomic,strong) DrugUsersAddViewItem *sgn;
@property (nonatomic,strong) DrugUsersAddViewItem *rcbr;

- (void)show;

@end

@interface DrugUsersAddViewItem : UIView

@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;

@end

NS_ASSUME_NONNULL_END
