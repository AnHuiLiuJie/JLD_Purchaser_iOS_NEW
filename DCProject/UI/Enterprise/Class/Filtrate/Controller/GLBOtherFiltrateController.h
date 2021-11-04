//
//  GLBOtherFiltrateController.h
//  DCProject
//
//  Created by bigbing on 2019/8/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "GLBTypeModel.h"
#import "GLBStoreFiltrateModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBOtherFiltrateBlock)(NSArray *typeArray,NSArray *companyArray,NSArray *packageArray);


@interface GLBOtherFiltrateController : DCTabViewController

// 搜索名称
@property (nonatomic, copy) NSString *searchName;
// 选中的分类id
@property (nonatomic, copy) NSString *catIds;
// 入口标识
@property (nonatomic, copy) NSString *entrance;
// 是否是中药材
@property (nonatomic, copy) NSString *prodType;
// 是否促销
@property (nonatomic, copy) NSString *isPromotion;

// 选中的类型数据
@property (nonatomic, strong) NSArray *userTypeArray;
// 选中的厂家数据
@property (nonatomic, strong) NSArray *userCompanyArray;
// 选中的规格数据
@property (nonatomic, strong) NSArray *userPackageArray;
// 选中的店铺数据
@property (nonatomic, strong) NSArray *userStoreArray;
// 商品分类 - 重要参数
@property (nonatomic, strong) GLBTypeModel *typeModel;


@property (nonatomic, copy) dispatch_block_t cancelBlock;

@property (nonatomic, copy) GLBOtherFiltrateBlock successBlock;


@property(nonatomic,copy) NSString *frameType;//1:GLBStoreGoodsController页面需要上移

@end

NS_ASSUME_NONNULL_END
