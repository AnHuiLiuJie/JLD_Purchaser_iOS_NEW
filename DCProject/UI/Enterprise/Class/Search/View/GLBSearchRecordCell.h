//
//  GLBSearchRecordCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBSearchRecordCell : UICollectionViewCell


@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) dispatch_block_t deleteBlock;

@end

NS_ASSUME_NONNULL_END
