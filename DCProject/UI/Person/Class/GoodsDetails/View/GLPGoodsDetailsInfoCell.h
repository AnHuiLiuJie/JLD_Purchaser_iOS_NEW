//
//  GLPGoodsDetailsInfoCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^InfoBlock)(NSInteger tag);

@interface GLPGoodsDetailsInfoCell : UITableViewCell


@property(nonatomic,copy)InfoBlock infoblock;
@property(nonatomic,copy) NSString *selctButton;

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;



@end

NS_ASSUME_NONNULL_END
