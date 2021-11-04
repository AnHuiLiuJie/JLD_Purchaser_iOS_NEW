//
//  GLPOldShoppingCarCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRequestListModel.h"
#import "TRRequestGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TRRequestListCell : UITableViewCell
typedef void (^ListNumBlock)(TRRequestGoodsModel *model);
typedef void (^SectionChoseBlock)(NSString *select);
typedef void (^RowChoseBlock)(TRRequestGoodsModel *model);
@property(nonatomic,strong)TRRequestListModel*requestListModel;
@property(nonatomic,copy)ListNumBlock listnumblock;
@property(nonatomic,copy)SectionChoseBlock choseblock;
@property(nonatomic,copy)RowChoseBlock rowblock;
@end

NS_ASSUME_NONNULL_END
