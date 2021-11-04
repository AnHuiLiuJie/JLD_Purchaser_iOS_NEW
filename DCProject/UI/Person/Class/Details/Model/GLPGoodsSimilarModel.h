//
//  GLPGoodsSimilarModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/12.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsSimilarModel : NSObject

@property (nonatomic, assign) NSInteger applyState; // 申请状态：1-买家申请退款；2-卖家同意退款；3-卖家不同意退款（等待运营商仲裁）；4-运营商已受理，处理中；5-运营商处理完成
@property (nonatomic, copy) NSString *brandName; // 品牌名称
@property (nonatomic, copy) NSString *goodsImg; // 商品图片
@property (nonatomic, copy) NSString *goodsTitle; // 商品标题
@property (nonatomic, copy) NSString *packingSpec; // 包装规格
@property (nonatomic, assign) NSInteger quantity; // 数量
@property (nonatomic, assign) NSInteger returnType; // 退货退款类别：1-退货退款；2-仅退款
@property (nonatomic, assign) CGFloat sellPrice; // 商城销售单价：单位元
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *batchId; // 商品批号

@end

NS_ASSUME_NONNULL_END
