//
//  GLBSetCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBSetCell : UITableViewCell


// 点击回调
@property (nonatomic, copy) dispatch_block_t switchBlock;


// 赋值
- (void)setValueWithTitles:(NSArray *)titles icons:(NSArray *)icons indexPath:(NSIndexPath *)indexPath cellPhone:(NSString *) cellPhone;

@end

NS_ASSUME_NONNULL_END
