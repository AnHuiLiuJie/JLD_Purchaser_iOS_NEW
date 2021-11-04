//
//  GLPSearchTitleItemCell.h
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPSearchTitleItemCell : UICollectionViewCell

@property (nonatomic, copy) dispatch_block_t deleteBlock;


@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
