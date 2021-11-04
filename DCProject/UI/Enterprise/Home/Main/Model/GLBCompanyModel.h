//
//  GLBCompanyModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBCompanyModel : NSObject

@property (nonatomic, copy) NSString *iD;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *firmName;
@property (nonatomic, copy) NSString *firmArea;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *logoImg;
@property (nonatomic, copy) NSString *transScore;
@property (nonatomic, copy) NSString *supplierLevel;
@property (nonatomic, copy) NSString *firstFirmCat;
@property (nonatomic, copy) NSString *isCoupon;
@property (nonatomic, copy) NSString *isPromotion;

//"id" : "110000000013509",
//"firmName" : "西藏藏药(集团)利众院生物科技有限公司",
//"isPromotion" : "1",
//"infoTitle" : "西藏藏药(集团)利众院生物科技有限公司",
//"subTitle" : "西藏藏药(集团)利众院生物科技有限公司",
//"imgUrl" : "",
//"logoImg" : "",
//"firmArea" : "西藏自治区-拉萨市-城关区",
//"firstFirmCat" : "1",
//"supplierLevel" : "35",
//"createTime" : "Fri Jun 22 00:00:00 CST 2018",
//"transScore" : "5.0",
//"shopName" : "西藏藏药(集团)利众院生物科技有限公司",
//"isCoupon" : "1"

@end

NS_ASSUME_NONNULL_END
