//
//  GLBAddressTFCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBAddressTFCell : UITableViewCell



@property (nonatomic, strong) DCTextField *textFiled;


#pragma mark - 赋值
- (void)setValueWithTitles:(NSArray *)titles placeholders:(NSArray *)placeholders indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
