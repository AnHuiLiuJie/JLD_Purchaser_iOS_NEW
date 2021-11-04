//
//  GLBAddInfoTVCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBTextViewBlock)(NSString *text);

@interface GLBAddInfoTVCell : UITableViewCell


@property (nonatomic, strong) DCTextView *textView;

// 
@property (nonatomic, copy) GLBTextViewBlock textViewBlock;

@end

NS_ASSUME_NONNULL_END
