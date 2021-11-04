//
//  TRHomeCell5.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/27.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^MoreBlock)(NSString *idStr);
typedef void (^ClickFoolBlock)(NSString *infoId);
@interface TRHomeCell5 : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)ClickFoolBlock foolblock;
@property(nonatomic,copy)MoreBlock moreblock;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;
@property(nonatomic,strong) UILabel *bgLab;
@property(nonatomic,copy) NSString *foolId;
@property(nonatomic,copy) NSString *foolsId;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
