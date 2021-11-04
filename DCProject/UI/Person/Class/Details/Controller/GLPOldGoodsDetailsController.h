//
//  GLPOldGoodsDetailsController.h
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLPGoodsDetailsTitleCell.h"
#import "GLPCustomXFView.h"

NS_ASSUME_NONNULL_BEGIN

static CGFloat const xfViewTag = 5021;

@interface GLPOldGoodsDetailsController : DCTabViewController

// 商品id
@property (nonatomic, copy) NSString *goodsId;

// 企业id
@property (nonatomic, copy) NSString *firmId;


//0-普通用户【进入申请界面】，1-创业者【正常推广】，2-创业者【待审核】，3-创业者【审核不通过】，4-创业者【禁用】，5-服务商员工【不可推广】
@property (nonatomic,assign) NSInteger extendType;

// 类型
@property (nonatomic, assign) GLPGoodsDetailType detailType;


@end

NS_ASSUME_NONNULL_END
