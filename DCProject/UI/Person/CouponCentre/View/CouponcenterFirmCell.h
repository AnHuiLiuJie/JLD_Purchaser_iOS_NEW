//
//  CouponcenterFirmCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^couponBlock)(NSInteger selectId);
typedef void(^couponUserBlock)(NSInteger selectId);
@interface CouponcenterFirmCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,copy)couponBlock couponblock;
@property(nonatomic,copy)couponUserBlock couponuserblock;
@end

NS_ASSUME_NONNULL_END
