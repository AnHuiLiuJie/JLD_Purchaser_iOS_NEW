//
//  GLPShoppingCarGoodsSectionView.h
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPShoppingCarGoodsSectionView : UITableViewHeaderFooterView

@property (nonatomic, strong) ActInfoListModel *acticityModel;
@property (nonatomic, copy) NSArray *actInfoList;

@end

NS_ASSUME_NONNULL_END
