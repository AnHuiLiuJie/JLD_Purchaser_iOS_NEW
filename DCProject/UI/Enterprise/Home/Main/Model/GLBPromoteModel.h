//
//  GLBGoodsModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBPromoteModel : NSObject

@property (nonatomic, assign) NSInteger goodsPromotionId;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) NSInteger batchId;
@property (nonatomic, copy) NSString *batchNum;
@property (nonatomic, assign) CGFloat wholeNotaxPrice;
@property (nonatomic, assign) CGFloat zeroNotaxPrice;
@property (nonatomic, assign) CGFloat oldWholeNotaxPrice;
@property (nonatomic, assign) CGFloat oldZeroNotaxPrice;
@property (nonatomic, assign) double suppierFirmId;
@property (nonatomic, copy) NSString *suppierFirmName;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *promotionTitle;
@property (nonatomic, copy) NSString *promotionDesc;
@property (nonatomic, copy) NSString *promotionBtime;
@property (nonatomic, copy) NSString *promotionEtime;
@property (nonatomic, assign) NSInteger promotionStock;
@property (nonatomic, assign) NSInteger activitySales;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *packingSpec;
@property (nonatomic, copy) NSString *manufactory;
@property (nonatomic, copy) NSString *certifiNum;
@property (nonatomic, copy) NSString *goodsImg;


@property (nonatomic, copy) NSString *iD;


//"goodsPromotionId": 44,
//"infoTitle": "小儿热速清颗粒大促销1",
//"subTitle": "小儿热速清颗粒大促销1",
//"imgUrl": "http://img.ypw.com/1/00-00-52/wKgAC11CfCSAJPw7AABqBdMKVh8397.png",
//"batchId": 995127,
//"batchNum": "有效期内",
//"wholeNotaxPrice": 12,
//"zeroNotaxPrice": 13,
//"suppierFirmId": 100000000113369,
//"suppierFirmName": "江西立达云医药有限公司",
//"goodsId": "CM21170508161357306087",
//"promotionTitle": "大促销啦",
//"promotionDesc": "",
//"promotionBtime": "2019-07-25 00:00:00",
//"promotionEtime": "2020-07-24 00:00:00",
//"promotionStock": 2000,
//"activitySales": 0,
//"goodsName": "小儿热速清颗粒",
//"packingSpec": "2g*10袋*",
//"manufactory": "哈尔滨圣泰生物制药有限公司",
//"certifiNum": "国药准字Z10980101",
//"goodsImg": "https://img.123ypw.com/1/00-02-0C/wKgUM1hvSUGAQb2VABVWcZvmENM460.

@end

NS_ASSUME_NONNULL_END
