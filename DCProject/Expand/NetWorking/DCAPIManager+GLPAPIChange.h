//
//  DCAPIManager+GLPAPIChange.h
//  DCProject
//
//  Created by LiuMac on 2021/7/12.
//



#import "DCAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager (GLPAPIChange)

#pragma mark - x
/*!
 *@param x
 *@param x
 */
- (void)glpRequest_b2c_XWithParam:(NSString *)param
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;

#pragma mark - 添加购物车 或者 立即购买校验
/*!
 *@param batchId 批次ID（非医药加入购物车、立即购买必传）
 *@param cart 购物车编码（购物车提交必填）
 *@param goodsId 商品id（加入购物车、立即购买必传）
 *@param quantity 购买数量，必传
 *@param sellerFirmId 商品归属企业ID，必传
 *@param tradeType 交易类型：1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
 */
- (void)glpRequest_b2c_tradeInfo_confirmOrder_newWith:(NSDictionary *)paramDic
                                              success:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture;

- (void)glpRequest_b2c_tradeInfoWithGoodsId:(NSString *)goodsId
                                    batchId:(NSString *)batchId
                                       cart:(NSArray *)cart
                                   quantity:(NSString *)quantity
                               sellerFirmId:(NSString *)sellerFirmId
                                  tradeType:(NSString *)tradeType
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;

- (void)glpRequest_b2c_new_tradeInfoWithDic:(NSDictionary *)paramDic
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;

#pragma mark - 我的购物车
- (void)glpRequest_b2c_tradeInfo_cartWithSuccess:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;

#pragma mark - 修改购物车
/*!
 *@param act 操作类型：change-修改购物车数量；remove-从购物车中删除
 *@param cart 购物车编码
 *@param value 修改购物车数量，act-change必传
 */
- (void)glpRequest_b2c_tradeInfo_cart_editWithAct:(NSString *)act
                                             cart:(NSArray *)cart
                                            value:(NSString *)value
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;

#pragma mark - 我的购物车数量
- (void)glpRequest_b2c_tradeInfo_cart_sizeWithSuccess:(DCSuccessBlock)success
                                             failture:(DCFailtureBlock)failture;

#pragma mark - 订单确认页面
/*!
 *@param batchId 批次ID（非医药加入购物车、立即购买必传）
 *@param cart 购物车编码（购物车提交必填）
 *@param goodsId 商品id（加入购物车、立即购买必传）
 *@param quantity 购买数量，必传
 *@param sellerFirmId 商品归属企业ID，必传
 *@param tradeType 交易类型：1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
 */
- (void)glpRequest_b2c_tradeInfo_confirmOrderWithBatchId:(NSString *)batchId
                                                    cart:(NSArray *)cart
                                                 goodsId:(NSString *)goodsId
                                                quantity:(NSString *)quantity
                                            sellerFirmId:(NSString *)sellerFirmId
                                               tradeType:(NSString *)tradeType
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture;

#pragma mark - 运费计算接口
/*!
 *@param areaId 收货地址地区编码，空或者0表示选择默认
 *@param goodsList 需要参与计算的产品列表
 **@param goodsId 商品id
 **@param goodsWeight 商品单位重量（KG）
 **@param logisticsTplId 运费模板Id
 **@param quantity 购买数量
 **@param sellerFirmId 商品归属企业ID
 */
- (void)glpRequest_b2c_tradeInfo_freightWithAreaId:(NSString *)areaId
                                         goodsList:(NSArray *)goodsList
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark - 订单提交
/*!
 *@param addrId 收货地址id传）
 *@param batchId 批次ID（非医药加入购物车、立即购买必传）
 *@param billDesc 疾病症状描述
 *@param cart 购物车编码（购物车提交必填）
 *@param drugId 用药人Id
 *@param goodsId 商品id（加入购物车、立即购买必传）
 *@param prescriptionImg 处方单图片
 *@param quantity 购买数量，必传
 *@param sellerFirmId 商品归属企业ID，必传
 *@param shopList 订单对应的店铺列表，多店铺情况下，一个店铺一个订单
 * *@param couponsId 用户选择的优惠券
 * *@param firmId 企业Id
 * *@param leaveMsg 订单备注
 *@param supUrl 补充图片URL(线上开单)
 *@param tradeType 交易类型：1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
 */
- (void)glpRequest_b2c_tradeInfo_submitWithAddrId:(NSString *)addrId
                                          batchId:(NSString *)batchId
                                         billDesc:(NSString *)billDesc
                                             cart:(NSArray *)cart
                                           drugId:(NSString *)drugId
                                          goodsId:(NSString *)goodsId
                                  prescriptionImg:(NSString *)prescriptionImg
                                         quantity:(NSString *)quantity
                                     sellerFirmId:(NSString *)sellerFirmId
                                         shopList:(NSArray *)shopList
                                           supUrl:(NSString *)supUrl
                                      symptomList:(NSArray *)symptomList
                                        tradeType:(NSString *)tradeType
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;

- (void)glpRequest_b2c_tradeInfo_submit_newWithPrameDic:(NSDictionary *)prameDic
                                                success:(DCSuccessBlock)success
                                               failture:(DCFailtureBlock)failture;


#pragma mark - 添加买家评论
/*!
 *@param firmEval 订单企业评价信息 EvalFirmItemDTO
 **@param sellerFirmId 卖家企业ID
 **@param sellerFirmName 企业名称
 **@param serviceAttitude 服务态度星级：1-1星；2-2星；3-3星；4-4星；5-5星
 **@param speedStar 发货速度星级：1-1星；2-2星；3-3星；4-4星；5-5星
 *@param goodsEvalList 订单商品评价信息 array
 **@param batchId 批次ID：货号ID
 **@param evalContent 企评论内容
 **@param evalImg1 评论图片1 evalImg2 evalImg3 evalImg4 evalImg5
 **@param goodsId 商品ID
 **@param goodsTitle 商品标题
 **@param orderGoodsId 订单商品ID
 **@param star星级：1-1星；2-2星；3-3星；4-4星；5-5星
 *@param modifyTimeParam 修改时间
 *@param orderNo 订单号
 */
- (void)glpRequest_b2c_account_eval_account_collection_addWithPrameDic:(NSDictionary *)prameDic
                                                                success:(DCSuccessBlock)success
                                                               failture:(DCFailtureBlock)failture;

#pragma mark - 获取评论列表
/*!
 *@param currentPage 当前分页页码（默认为1）
 *@param goodsId 商品ID
 *@param isHaveEvalContent 有无评论内容：0.全部，1.有内容，2.无内容
 *@param isHaveEvalImgs 有无图片：0.全部，1.有图，2.无图
 *@param sellerFirmId 卖家企业ID
 *@param star 星级：1-1星；2-2星；3-3星；4-4星；5-5星
 */
- (void)glpRequest_b2c_account_eval_evalListWithPrameDic:(NSDictionary *)prameDic
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma mark - 评价页面入口
/*!
 *@param currentPage 当前分页页码（默认为1）
 *@param goodsId 商品ID
 *@param isHaveEvalContent 有无评论内容：0.全部，1.有内容，2.无内容
 *@param isHaveEvalImgs 有无图片：0.全部，1.有图，2.无图
 *@param sellerFirmId 卖家企业ID
 *@param star 星级：1-1星；2-2星；3-3星；4-4星；5-5星
 */
- (void)glpRequest_b2c_account_eval_orderEvalWithOrderNo:(NSString *)orderNo
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma mark - 我的评价列表
/*!
 *@param currentPage 当前分页页码（默认为1）
 */
- (void)glpRequest_b2c_account_eval_myEvalListWithCurrentPage:(NSString *)currentPage
                                                      success:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture;

@end

NS_ASSUME_NONNULL_END
