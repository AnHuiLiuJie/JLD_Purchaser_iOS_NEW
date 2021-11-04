//
//  TRHomeCell2.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ClickBlock)(NSInteger clickId);
@interface TRHomeCell2 : UITableViewCell
@property(nonatomic,copy)ClickBlock clickblock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
