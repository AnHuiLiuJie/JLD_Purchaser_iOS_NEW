//
//  DrugUsersCell.h
//  DCProject
//
//  Created by Apple on 2021/3/17.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

typedef void(^DrugUsersCellBlock)(NSIndexPath *idx,NSInteger type);

@interface DrugUsersCell : UITableViewCell

@property (nonatomic,copy) DrugUsersCellBlock block;

@property (nonatomic,strong) NSIndexPath *idx;

@property (nonatomic,strong) UILabel *nameLB;
@property (nonatomic,strong) UILabel *sexLB;
@property (nonatomic,strong) UILabel *ageLB;
@property (nonatomic,strong) UILabel *phoneLB;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton *editBtn;
@end

NS_ASSUME_NONNULL_END
