//
//  GLBRepayListSectionView.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBRepayListModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBRepaySectionViewBlock)(NSString *title);

@interface GLBRepayListSectionView : UITableViewHeaderFooterView


@property (nonatomic, copy) GLBRepaySectionViewBlock successBlock;


// 账期
@property (nonatomic, strong) GLBRepayListModel *repayListModel;

@end

NS_ASSUME_NONNULL_END
