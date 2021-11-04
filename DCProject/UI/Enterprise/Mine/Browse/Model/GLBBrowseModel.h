//
//  GLBBrowseModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/8.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBBrowseModel : NSObject

@property (nonatomic, copy) NSString *packingSpec;
@property (nonatomic, copy) NSString *zeroPrice;
@property (nonatomic, assign) NSInteger accessId;
@property (nonatomic, copy) NSString *totalSales;
@property (nonatomic, copy) NSString *manufactory;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *certifiNum;
@property (nonatomic, copy) NSString *wholePrice;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *accessDate;
@property (nonatomic, copy) NSString *frimName;

//"packingSpec" : "0.2g*6s",
//"zeroPrice" : 37.140000000000001,
//"accessId" : 48176,
//"totalSales" : 0,
//"manufactory" : "",
//"goodsName" : "塞来昔布胶囊",
//"certifiNum" : "",
//"wholePrice" : 37.140000000000001,
//"goodsImg" : "",
//"goodsId" : "IM21170401110606515086",
//"accessDate" : "2019-08-08",
//"frimName" : "广西柳州百草堂药业有限公司"

@end

NS_ASSUME_NONNULL_END
