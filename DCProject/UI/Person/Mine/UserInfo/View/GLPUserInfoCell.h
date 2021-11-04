//
//  GLPUserInfoCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPUserInfoCell : UITableViewCell

@property (nonatomic, strong) DCTextField *textField;


- (void)dc_setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders contents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
