//
//  TRHistoryListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^DetailBlock)(NSInteger clickId);
@interface TRHistoryListCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)CouponsListModel*listModel;
@property(nonatomic,strong)CouponsListModel*currentModel;
@property(nonatomic,strong) NSMutableArray *couponArray;
@property(nonatomic,copy)DetailBlock detailblock;
@end

NS_ASSUME_NONNULL_END
