//
//  GLPHomeDataModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCActivityBaseModel.h"

@class GLPHomeDataActivityModel;
@class GLPHomeDataGoodsModel;
@class GLPHomeDataGroupModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPHomeDataModel : NSObject

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, copy) NSString *spaceCode; // 推荐位编码
@property (nonatomic, copy) NSString *spaceName; // 推荐位名称
@property (nonatomic, copy) NSString *spacePic; // 推荐位营销图

@end

#pragma mark -

@interface GLPHomeNewDataModel : NSObject

@property (nonatomic, copy)  NSArray *collageList; // 拼团列表//DCCollageListModel
@property (nonatomic, copy)  NSArray *seckillList; // 秒杀列表 //DCSeckillListModel

@property (nonatomic, strong) GLPHomeDataModel *midAd; // 中间广告位
@property (nonatomic, strong) GLPHomeDataModel *season; // 季节用药
@property (nonatomic, strong) GLPHomeDataModel *hotSales; // 热销数据
@property (nonatomic, strong) GLPHomeDataModel *hotRec; // 底部热点推荐数据
@property (nonatomic, copy) NSArray *floorData;//楼层数据

@end


#pragma mark -
@interface GLPHomeDataListModel : NSObject

@property (nonatomic, strong) GLPHomeDataActivityModel *actVo; // 活动VO
@property (nonatomic, strong) GLPHomeDataGoodsModel *goodsVo; // 商品信息VO
@property (nonatomic, strong) GLPHomeDataGroupModel *groupVo; // 团购VO
@property (nonatomic, copy) NSString *imgUrl; // 推荐信息营销图片
@property (nonatomic, copy) NSString *infoId; // 推荐信息ID
@property (nonatomic, copy) NSString *infoTitle; // 推荐信息标题
@property (nonatomic, assign) NSInteger infoType; // 信息类型：1-企业；2-商品；3-促销；4-团购
@property (nonatomic, copy) NSString *subTitle; // 推荐信息营销副标题，有则优先显示此项，舍弃信息标题

@end


#pragma mark - 活动信息
@interface GLPHomeDataActivityModel : NSObject

@property (nonatomic, copy) NSString *actDesc; // 促销活动规则
@property (nonatomic, copy) NSString *actEndDate; // 促销活动结束时间
@property (nonatomic, copy) NSString *joinNum; // 参与人数

@end


#pragma mark - 商品信息
@interface GLPHomeDataGoodsModel : NSObject

@property (nonatomic, copy) NSString *certifiNum; // 批准文号
@property (nonatomic, copy) NSString *chargeUnit; // 计价单位
@property (nonatomic, copy) NSString *goodsPrice; // 商品价格
@property (nonatomic, copy) NSString *isGroup; // 是否团购：1-是；2-否
@property (nonatomic, copy) NSString *isImport; // 是否进口：1-是；2-否
@property (nonatomic, copy) NSString *isOtc; // 是否OTC：1-是；2-否  非OTC是处方药
@property (nonatomic, copy) NSString *isPromotion; // 是否促销：1-是；2-否
@property (nonatomic, copy) NSString *marketPrice; // 市场价
@property (nonatomic, copy) NSString *packingSpec; // 规格

@end


#pragma mark - 团购信息
@interface GLPHomeDataGroupModel : NSObject

@property (nonatomic, copy) NSString *actEndDate; // 活动结束时间
@property (nonatomic, copy) NSString *goodsId; // 团购商品ID
@property (nonatomic, copy) NSString *goodsPrice; // 商品原价格
@property (nonatomic, copy) NSString *groupPrice; // 团购价格
@property (nonatomic, copy) NSString *joinNum; // 参与人数

@end

NS_ASSUME_NONNULL_END
