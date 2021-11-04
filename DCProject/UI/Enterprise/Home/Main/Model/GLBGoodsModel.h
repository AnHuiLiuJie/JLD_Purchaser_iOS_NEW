//
//  GLBGoodsModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBGoodsModel : NSObject

@property (nonatomic, copy) NSString *iD;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *batchNum;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *goodsCode;
@property (nonatomic, copy) NSString *batchProduceTime;
@property (nonatomic, copy) NSString *batchTotalSale;
@property (nonatomic, copy) NSString *wholePrice;
@property (nonatomic, copy) NSString *zeroPrice;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *packingSpec;
@property (nonatomic, copy) NSString *manufactory;
@property (nonatomic, copy) NSString *manufactoryAbbr;
@property (nonatomic, copy) NSString *certifiNum;
@property (nonatomic, copy) NSString *suppierFirmId;
@property (nonatomic, copy) NSString *suppierFirmName;
//@property (nonatomic, copy) NSString *isWholeSell; // 是否整件销售 1是。2否
@property (nonatomic, assign) NSInteger sellType; // 2整售 4零售 3整+零
@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *isPromotion; // 是否促销 1是 2否
@property (nonatomic, copy) NSString *isCoupon; // 是否有优惠券 1是 2否
@property (nonatomic, copy) NSString *saleCtrl; // 销售控制 0无 1控销 2招标
@property (nonatomic, copy) NSString *actTitle; // 满多少减多少券


@end

NS_ASSUME_NONNULL_END
