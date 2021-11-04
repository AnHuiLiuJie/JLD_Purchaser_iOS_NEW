//
//  GLPDetailActBeanController.h
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "DCBasicViewController.h"
#import "GLPGoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPDetailActBeanController : DCBasicViewController

@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
@property (nonatomic, copy) NSString *content;


@end

NS_ASSUME_NONNULL_END
