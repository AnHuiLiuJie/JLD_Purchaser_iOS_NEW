//
//  GLBUserInfoCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBUserInfoCell : UITableViewCell


@property (nonatomic, strong) DCTextField *textField;

// 赋值
- (void)setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders contents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
