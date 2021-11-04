//
//  GLPSearchGoodsPromptCell.h
//  DCProject
//
//  Created by Apple on 2021/3/17.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPSearchKeyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLPSearchGoodsPromptCellBlock)(NSString *searchStr);

@interface GLPSearchGoodsPromptCell : UITableViewCell

@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIView *btnView;

- (void)reloadUI;

@property (nonatomic,strong) GLPSearchKeyModel *model;
@property (nonatomic,copy) GLPSearchGoodsPromptCellBlock block;

@end

NS_ASSUME_NONNULL_END
