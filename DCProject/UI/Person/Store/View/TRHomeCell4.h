//
//  TRHomeCell4.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ClickIdBlock)(NSString *idStr);
@interface TRHomeCell4 : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)ClickIdBlock clickidblock;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
