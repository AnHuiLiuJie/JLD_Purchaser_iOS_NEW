//
//  GLBZizhiExchangeItemCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBZizhiExchangeItemCell : UICollectionViewCell

// 赋值
- (void)setValueWithArray:(NSArray *)imgurlArray indexPath:(NSIndexPath *)indexPath;


@property (nonatomic, copy) dispatch_block_t deleteBlock;

@property (nonatomic, copy) dispatch_block_t exchangeBlock;

@property (nonatomic, copy) dispatch_block_t iconBlock;

@end

NS_ASSUME_NONNULL_END
