//
//  GLBMessageListCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBMessageListCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *image;

- (void)setCountDictValue:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
