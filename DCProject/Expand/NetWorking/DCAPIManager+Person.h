//
//  DCAPIManager+Person.h
//  DCProject
//
//  Created by bigbing on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager (Person)


#pragma mark - 广告位
/*!
 *@param  adCode  APP_AD_HOME : 首页广告
 */
- (void)person_requestAdvWithAdCode:(NSString *)adCode
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;


#pragma mark - 首页推荐位
/*!
 *@param  zoneCode  推荐区域编码
 *
 1.首页活动推荐位:ACT_ZONE_INDEX
 2.首页【季节用药】推荐位：SEASON_ZONE_INDEX
 3.首页【热销榜】推荐位:HOTSALES_ZONE_INDEX
 4.首页【楼层1】推荐位：FLOOR1_ZONE_INDEX
 5.首页【楼层2】推荐位:FLOOR2_ZONE_INDEX
 6.首页【楼层3】推荐位：FLOOR3_ZONE_INDEX
 7.首页【楼层4】推荐位:FLOOR4_ZONE_INDEX
 8.首页【热点推荐】推荐位：HOT_REC_ZONE_INDEX
 type 1:首页推荐位 2:推荐位更多接口
 */
- (void)person_requestHomeRecommendWithZoneCode:(NSString *)zoneCode
                                           type:(NSString *)type
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;

#pragma mark - 首页主页面几个(中间广告位,季节数据,热销数据 4个楼层 热点推荐)合集
- (void)person_requestHomeMainAllListWithsuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;

#pragma mark - 获取未读消息数量
- (void)person_requestNoReadMsgCountWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情 统一新接口
- (void)person_requestNewGoodsDetailsWithGoodsId:(NSString *)goodsId
                                         batchId:(NSString *)batchId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情:运费与默认收货地址
/*!
 *@param  areaId    区域ID
 *@param  goodsId   商品ID
 *@param  logisticsTplId  运费模板ID
 *@param  quantity   购买数量
 */
- (void)person_requestGoodsDetailsDefaultAddressWithAreaId:(NSString *)areaId
                                                   goodsId:(NSString *)goodsId
                                            logisticsTplId:(NSInteger)logisticsTplId
                                                  quantity:(NSInteger)quantity
                                                   success:(DCSuccessBlock)success
                                                  failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情：购买了此商品的用户还购买了
/*!
 *@param  goodsId   商品ID
 */
- (void)person_requestGoodsDetailsSimliarGoodsWithGoodsId:(NSString *)goodsId
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情：处方搭配
/*!
 *@param  goodsCode   商品code
 *@param  type   查询类型:1.查询一条数据，2.所有数据
 */
- (void)person_requestGoodsDetailsMatchWithGoodsCode:(NSString *)goodsCode
                                                type:(NSInteger)type
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情：商品评论
/*!
 *@param  goodsId   商品ID
 *@param  currentPage   页码
 *@param  isHaveEvalContent  有无评论内容：0.全部，1.有内容，2.无内容
 *@param  sellerFirmId   卖家企业ID
 *@param  star   星级：1-1星；2-2星；3-3星；4-4星；5-5星
 */
- (void)person_requestGoodsDetailEvaluetaWithGoodsId:(NSString *)goodsId
                                         currentPage:(NSInteger)currentPage
                                   isHaveEvalContent:(NSInteger)isHaveEvalContent
                                        sellerFirmId:(NSString *)sellerFirmId
                                                star:(NSInteger)star
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情：问答专区
/*!
 *@param  goodsId   商品ID
 *@param  type      查询类型:1.查询一条数据，2.所有数据
 */
- (void)person_requestGoodsDetailQuestionWithGoodsId:(NSString *)goodsId
                                                type:(NSInteger)type
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture;


#pragma mark - 商品详情：猜你喜欢
/*!
 *@param  catId     分类
 *@param  descFlag  排序方式:1.由高到低；2.由低到高。（默认由高到低）
 *@param  orderFlag   排序类型：sellPrice.价格排序；totalSales.销量排序；evalNum.评价数排序
 *@param  symptom    症状
 */
- (void)person_requestGoodsDetailLickWithGoodsId:(NSString *)goodsId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;


#pragma mark - 商品优惠券
/*!
 *@param  goodsId  商品id
 */
- (void)person_requestGoodsTicketWithGoodsId:(NSString *)goodsId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;


#pragma mark - 企业店铺优惠券
/*!
 *@param  firmId  店铺id
 */
- (void)person_requestStoreTicketWithFirmId:(NSString *)firmId
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;


#pragma mark - 加入购物车
/*!
 *@param  goodsId   商品id
 *@param  quantity  数量
 */
- (void)person_requestAddShoppingCarWithGoodsId:(NSString *)goodsId
                                        batchId:(NSString *)batchId
                                       quantity:(NSString *)quantity
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock _Nullable)failture;


#pragma mark - 购物车列表
- (void)person_requestShoppingCarListWithSuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;


#pragma mark - 修改购物车商品数量
/*!
 *@param  cartId     购物车id
 *@param  quantity   商品id
 */
- (void)person_requestChangeShoppingCarCountWithCartId:(NSString *)cartId
                                              quantity:(NSString *)quantity
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture;


#pragma mark - 获取商品分类
/*!
 *@param  catIds   分类id
 */
- (void)person_requestGoodsClassWithCatIds:(NSString *)catIds
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;


#pragma mark - 搜索热销商品
/*!
 *@param  currentPage   没什么吊用的参数
 */
- (void)person_requestSearchHotGoodsWithCurrentPage:(NSInteger)currentPage
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture;


#pragma mark - 搜索商品联想
/*!
 *@param  searchName   搜索商品
 */
- (void)person_requestSearchWordWithSearchName:(NSString *)searchName
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;

#pragma mark - 搜索商品联想
- (void)person_requestSearchWordKeyWithKey:(NSString *)keyStr
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;


#pragma mark - 收藏的商品列表
/*!
 *@param  goodsName      搜索商品名称
 *@param  currentPage    页码
 */
- (void)person_requestCollectGoodsListWithCurrentPage:(NSInteger)currentPage
                                            goodsName:(NSString *)goodsName
                                              success:(DCMoreListSuccessBlock)success
                                             failture:(DCFailtureBlock)failture;


#pragma mark - 浏览记录列表
/*!
 *@param  currentPage    页码
 */
- (void)person_requestSeeGoodsListWithCurrentPage:(NSInteger)currentPage
                                          success:(DCMoreListSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;


#pragma mark - 添加浏览记录
/*!
 *@param  goodsId       商品ID
 *@param  goodsName     商品名称（通用名）
 *@param  goodsTitle    商品标题 .
 *@param  linkUrl       链接地址
 *@param  sellerFirmId     卖家企业ID
 *@param  sellerFirmName    卖家企业名
 */
- (void)person_requestAddSeeCountWithGoodsId:(NSString *)goodsId
                                   goodsName:(NSString *)goodsName
                                  goodsTitle:(NSString *)goodsTitle
                                     linkUrl:(NSString *)linkUrl
                                sellerFirmId:(NSInteger)sellerFirmId
                              sellerFirmName:(NSString *)sellerFirmName
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;

#pragma mark - 查看商品规格 新接口
- (void)person_requestGetNewGoodSpecByGoodsId:(NSString *)goodsId
                                   certifiNum:(NSString *)certifiNum
                                 sellerFirmId:(NSString *)sellerFirmId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;
#pragma mark - 查看商品规格
- (void)person_requestGetGoodSpecByGoodsId:(NSString *)goodsId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;

#pragma mark - 商品详情：问答、评价、浏览此商品的用户还购买了 三合一接口
- (void)person_request_goodsInfo_detail_otherInfoWithGoodsId:(NSString *)goodsId
                                                  certifiNum:(NSString *)certifiNum
                                                 packingSpec:(NSString *)packingSpec
                                                sellerFirmId:(NSString *)sellerFirmId
                                                   goodsCode:(NSString *)goodsCode
                                            goodsTagNameList:(NSString *)goodsTagNameList
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;

#pragma mark - 删除浏览记录
/*!
 *@param  accessIds  浏览记录id
 */
- (void)person_requestDeleteSeeRecordWithAccessIds:(NSString *)accessIds
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;


#pragma mark - 购物车券列表
/*!
 *@param  firmId    企业id
 *@param  goodsIds  商品Id
 */
- (void)person_requestShoppingCarTicketWithFirmId:(NSString *)firmId
                                         goodsIds:(NSString *)goodsIds
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;


#pragma mark - 购物车确认提交页获取运费
/*!
 *@param  areaId   收货地址ID
 *@param  cartIds  购物车Ids
 *@param  sellerFirmId  卖家企业ID
 */
- (void)person_requestShoppingCarYunfeiWithAreaId:(NSString *)areaId
                                          cartIds:(NSString *)cartIds
                                     sellerFirmId:(NSString *)sellerFirmId
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;


#pragma mark - 提交订单
/*!
 *@param  entrance   下单页面入口:1-立即购买;2-购物车;3-活动页面；4-购买申请(支持线下购买商品的购买)
 *@param  addrId  收货地址id，
 *@param  cartIds  购物车进入时的购物车id
 *@param  sellerFirmList  卖家列表
 */
- (void)person_requestOrderCommintWithEntrance:(NSString *)entrance
                                        addrId:(NSString *)addrId
                                       cartIds:(NSString *)cartIds
                                sellerFirmList:(NSArray *)sellerFirmList
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


#pragma mark - 请求 用户通过购物车确认订单（需求清单）
- (void)person_requestCartNotarizeWithCartIds:(NSString *)cartIds
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;


#pragma mark - 购物车提交订单接口(新)
- (void)person_requestShoppingCarCommintWithAaddrId:(NSString *)addrId
                                            cartIds:(NSString *)cartIds
                                     sellerFirmList:(NSArray *)sellerFirmList
                                             drugId:(NSString *)drugId
                                    prescriptionImg:(NSString *)prescriptionImg
                                           billDesc:(NSString *)billDesc
                                             supUrl:(NSString *)supUrl
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture;

#pragma mark - (立即购买)提交订单接口(新)
- (void)person_buyNowWidthGoodsId:(NSString *)goodsId
                         quantity:(NSString *)quantity
                           addrId:(NSString *)addrId
                         leaveMsg:(NSString *)leaveMsg
                         couponId:(NSString *)couponId
                          buytype:(nonnull NSString *)type
                           drugId:(NSString *)drugId
                          symptom:(NSString *)symptom
                  prescriptionImg:(NSString *)prescriptionImg
                         billDesc:(NSString *)billDesc
                           supUrl:(NSString *)supUrl
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;


#pragma mark - 退出登录
- (void)person_requestLogoutWithSuccess:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;


#pragma mark - 第三方用户授权登录
- (void)person_requestThirdLogoutWithBlindId:(NSString *)blindId
                                     channel:(NSInteger)channel
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;


#pragma mark - 第三方会员注册
- (void)person_requestThirdRegisterWithCellphone:(NSString *)cellphone
                                      tempUserId:(NSString *)tempUserId
                                    thirdLoginId:(NSString *)thirdLoginId
                                       thirdType:(NSInteger)thirdType
                                       validInfo:(NSString *)validInfo
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;


#pragma mark - 获取用户推广类型
- (void)person_requestHomeRecommendTypeSuccess:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;

#pragma mark - 到货通知明细，如果明细为空则返回用户默认手机号 -
- (void)personRequest_b2c_goodsInfo_detail_arrival_noticeWithGoodsId:(NSString *)goodsId
                                                             serialId:(NSString *)serialId
                                                              success:(DCSuccessBlock)success
                                                             failture:(DCFailtureBlock)failture;

#pragma mark -期望通知时间列表
- (void)personRequest_b2c_goodsInfo_expect_time_listWithSuccess:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture;

#pragma mark - 订阅到货通知
- (void)personRequest_b2c_goodsInfo_subscribe_noticeWithGoodsId:(NSString *)goodsId
                                                  buyerCellphone:(NSString *)buyerCellphone
                                                      expectTime:(NSString *)expectTime
                                                           isSms:(NSString *)isSms
                                                        serialId:(NSString *)serialId
                                                         success:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture;

#pragma mark - 商品无库存情况下，查询推荐产品
- (void)personRequest_b2c_goodsInfo_detail_noStockRecommendWithGoodsId:(NSString *)goodsId
                                                              goodsName:(NSString *)goodsName
                                                                success:(DCSuccessBlock)success
                                                               failture:(DCFailtureBlock)failture;

@end

NS_ASSUME_NONNULL_END
