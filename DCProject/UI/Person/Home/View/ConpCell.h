//
//  ConpCell.h
//  DCProject
//
//  Created by 刘德山 on 2020/9/25.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConpCell : UITableViewCell
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *type;
@property (nonatomic,strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
