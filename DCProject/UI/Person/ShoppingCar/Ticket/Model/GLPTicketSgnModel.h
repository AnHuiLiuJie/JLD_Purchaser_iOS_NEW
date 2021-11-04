//
//  GLPTicketSgnModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPTicketSgnModel : NSObject

@property (nonatomic, strong) NSArray *coupGoodsvo; // 商品优惠券列表
@property (nonatomic, strong) NSArray *coupfirmvo; // 店铺优惠券

@end



#pragma mark - 券
@interface GLPTicketSgnTicketModel : NSObject

@property (nonatomic, copy) NSString *couponsId;
@property (nonatomic, copy) NSString *discountAmount;
@property (nonatomic, copy) NSString *firmId;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsImg1;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *isReceive;
@property (nonatomic, copy) NSString *isconsume;
@property (nonatomic, copy) NSString *requireAmount;
@property (nonatomic, copy) NSString *useEndDate;
@property (nonatomic, copy) NSString *useStartDate;
@property (nonatomic, strong) NSArray *goodsList;

@end


#pragma mark - 商品
@interface GLPTicketSgnGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsImg1;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsTagList;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString *sellPrice;

@end

NS_ASSUME_NONNULL_END
