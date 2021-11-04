//
//  TRHomeCell1.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ClickBlock)(NSInteger clickId);
@interface TRHomeCell1 : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)ClickBlock clickblock;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
