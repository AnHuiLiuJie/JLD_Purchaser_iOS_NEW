//
//  GLPConfirmOrderViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/7/12.
//

#import "DCTabViewController.h"
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPConfirmOrderViewController : DCTabViewController

@property(nonatomic,copy) NSDictionary *actDic;

@property (nonatomic, strong) GLPNewShoppingCarModel *mainModel;
@property(nonatomic,copy) NSString *ispay;//1:直接购买 其他：购物车

@property (nonatomic, strong) NSMutableArray<GLPNewShopCarGoodsModel *> *shoppingCarArray;

@end

NS_ASSUME_NONNULL_END
