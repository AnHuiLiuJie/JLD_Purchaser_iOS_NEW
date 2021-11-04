//
//  PrescriptionCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrescriptionCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *couponArray;
@property(nonatomic,strong) UIButton * lookBtn;
@property(nonatomic,strong) UILabel *timeLab;
@end

NS_ASSUME_NONNULL_END
