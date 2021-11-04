//
//  CouponListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/4.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^UserBlock)(NSInteger clickId);
@interface CouponListCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *couponArray;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,copy) UserBlock userkblock;
@property(nonatomic,copy) NSString *classType;//2店铺 3商品券
@property(nonatomic,copy) NSString *couponsClass;
@end

NS_ASSUME_NONNULL_END
