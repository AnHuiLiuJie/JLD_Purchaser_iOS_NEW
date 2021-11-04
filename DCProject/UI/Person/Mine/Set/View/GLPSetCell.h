//
//  GLPSetCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPSetCell : UITableViewCell

// 点击回调
@property (nonatomic, copy) dispatch_block_t switchBlock;
@property (nonatomic, copy) void(^switchBlock_two)(BOOL isOn);


// 赋值
- (void)setValueWithTitles:(NSArray *)titles indexPath:(NSIndexPath *)indexPath withPhone:(NSString *)phone isOn:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
