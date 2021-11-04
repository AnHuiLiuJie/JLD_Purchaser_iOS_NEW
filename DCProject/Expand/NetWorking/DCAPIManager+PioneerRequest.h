//
//  DCAPIManager+PioneerRequest.h
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import "DCAPIManager.h"
#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager (PioneerRequest)

#pragma mark - 申请成为创业者
/*!
 *@param  areaId   地区id
 *@param  cellphone   手机号
 *@param  idCard  身份证号
 *@param  userName  用户名
 *@param  wechat   微信
 */
- (void)pioneerRequest_b2c_pioneer_applyWithAreaId:(NSString *)areaId
                                         cellphone:(NSString *)cellphone
                                            idCard:(NSString *)idCard
                                          userName:(NSString *)userName
                                            wechat:(NSString *)wechat
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;


#pragma mark - POST创业者信息详情
- (void)pioneerRequest_b2c_pioneer_viewWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark - POST服务费记录
- (void)pioneerRequest_b2c_pioneer_service_feeWithSuccess:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma mark - POST获取可提现金额，个税，实际到账金额
- (void)pioneerRequest_b2c_pioneer_withdraw_amountWithSuccess:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture;

#pragma mark - POST银行卡列表
- (void)pioneerRequest_b2c_pioneer_withdraw_bank_listWithSuccess:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture;

#pragma mark - POST银行卡添加
- (void)pioneerRequest_b2c_pioneer_withdraw_bank_addWithBankAccount:(NSString *)bankAccount
                                                    bankAccountName:(NSString *)bankAccountName
                                                     bankBranchName:(NSString *)bankBranchName
                                                           bankName:(NSString *)bankName
                                                          isDefault:(NSString *)isDefault
                                                            success:(DCSuccessBlock)success
                                                           failture:(DCFailtureBlock)failture;

#pragma mark - POST银行卡编辑
- (void)pioneerRequest_b2c_pioneer_withdraw_bank_editWithBankAccount:(NSString *)bankAccount
                                                     bankAccountName:(NSString *)bankAccountName
                                                      bankBranchName:(NSString *)bankBranchName
                                                            bankName:(NSString *)bankName
                                                              cardId:(NSString *)cardId
                                                           isDefault:(NSString *)isDefault
                                                             success:(DCSuccessBlock)success
                                                            failture:(DCFailtureBlock)failture;

#pragma mark - POST银行卡删除
- (void)pioneerRequest_b2c_pioneer_withdraw_bank_deleteWithCardId:(NSString *)cardId
                                                          Success:(DCSuccessBlock)success
                                                         failture:(DCFailtureBlock)failture;

#pragma mark - POST提现申请
- (void)pioneerRequest_b2c_pioneer_withdraw_bank_applyWithCardId:(NSString *)cardId
                                                         Success:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture;

#pragma mark - POST提现列表
- (void)pioneerRequest_b2c_pioneer_withdraw_listWithCurrentPage:(NSString *)currentPage
                                                        endTime:(NSString *)endTime
                                                      startTime:(NSString *)startTime
                                                          state:(NSString *)state
                                                        success:(DCSuccessBlock)success
                                                       failture:(DCFailtureBlock)failture;

#pragma mark - POST提现详情
- (void)pioneerRequest_b2c_pioneer_withdraw_viewWithWithdrawId:(NSString *)withdrawId
                                                       Success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;

#pragma mark - POST提现规则
- (void)pioneerRequest_b2c_pioneer_rule_withdrawWithSuccess:(DCSuccessBlock)success
                                                   failture:(DCFailtureBlock)failture;

#pragma mark - POST等级规则
- (void)pioneerRequest_b2c_pioneer_rule_gradeWithSuccess:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture;

#pragma mark - POST用户协议
- (void)pioneerRequest_b2c_pioneer_rule_agreementWithSuccess:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;

#pragma mark - POST活动规则
- (void)pioneerRequest_b2c_pioneer_rule_activityWithSuccess:(DCSuccessBlock)success
                                                   failture:(DCFailtureBlock)failture;

#pragma mark - POST推广用户数统计
- (void)pioneerRequest_b2c_pioneer_extend_user_statistWithSuccess:(DCSuccessBlock)success
                                                         failture:(DCFailtureBlock)failture;

#pragma mark - POST服务费统计
- (void)pioneerRequest_b2c_pioneer_fee_statistWithSuccess:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma 获取推广订单列表
- (void)pioneerRequest_b2c_pioneer_extend_order_listWithCurrentPage:(NSString *)currentPage
                                                          startTime:(NSString *)startTime
                                                            endTime:(NSString *)endTime
                                                          goodsName:(NSString *)goodsName
                                                            orderNo:(NSString *)orderNo
                                                              state:(NSString *)state
                                                              level:(NSString *)level
                                                            success:(DCSuccessBlock)success
                                                           failture:(DCFailtureBlock)failture;

#pragma 获取推广用户列表
- (void)pioneerRequest_b2c_pioneer_extend_user_listWithCurrentPage:(NSString *)currentPage
                                                             level:(NSString *)level
                                                           feeSort:(NSString *)feeSort
                                                           success:(DCSuccessBlock)success
                                                          failture:(DCFailtureBlock)failture;

#pragma 获取资讯列表//是否热门：取热门资讯时传1 是否推荐：取推荐资讯是传1
- (void)pioneerRequest_b2c_news_listWithCurrentPage:(NSString *)currentPage
                                              catId:(NSString *)catId
                                              isHot:(NSString *)isHot
                                        isRecommend:(NSString *)isRecommend
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture;


#pragma 获取资讯详情
- (void)pioneerRequest_b2c_news_contentWithCurrentNewsID:(NSString *)newsId
                                                 success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture;

#pragma 获取Tab页
- (void)pioneerRequest_b2c_news_tabWithSsuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;

#pragma 获取赚钱说明
- (void)pioneerRequest_b2c_pioneer_rule_moneyWithSsuccess:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma app首页推广【新】
- (void)pioneerRequest_b2c_pioneer_extend_app_newWithSsuccess:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture;

#pragma 商品页推广【新】
- (void)pioneerRequest_b2c_pioneer_extend_goods_newWithGoodsId:(NSString *)goodsId
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;

#pragma 按日统计推广金额
- (void)pioneerRequest_b2c_pioneer_reportWithDays:(NSString *)days
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;

#pragma 添加客服评论
- (void)pioneerRequest_b2c_common_customer_evalAddWithCustomerId:(NSString *)customerId
                                              dissatisfiedReason:(NSString *)dissatisfiedReason
                                                         isSolve:(NSString *)isSolve
                                                            star:(NSString *)star
                                                         success:(DCSuccessBlock)success
                                                        failture:(DCFailtureBlock)failture;

#pragma 获取药师信息
- (void)pioneerRequest_b2c_common_customer_pharmacistWithFrimId:(NSString *)frimId
                                                        success:(DCSuccessBlock)success
                                                       failture:(DCFailtureBlock)failture;

#pragma 个性化推送开关
- (void)pioneerRequest_b2c_common_specificWithFlag:(NSString *)flag
                                          Ssuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma 月份账单列表
- (void)pioneerRequest_b2c_pioneer_bill_listWithYear:(NSString *)year
                                             success:(DCSuccessBlock)success
                                            failture:(DCFailtureBlock)failture;

#pragma 月份账单详情
- (void)pioneerRequest_b2c_pioneer_bill_detailWithCurrentPage:(NSString *)currentPage
                                                       billId:(NSString *)billId
                                                      success:(DCSuccessBlock)success
                                                     failture:(DCFailtureBlock)failture;

#pragma 推广订单详情
- (void)pioneerRequest_b2c_pioneer_extend_order_detailWithOrderNo:(NSString *)orderNo
                                                          success:(DCSuccessBlock)success
                                                         failture:(DCFailtureBlock)failture;
#pragma mark - POST个税规则
- (void)pioneerRequest_b2c_pioneer_rule_tax_ruleWithSuccess:(DCSuccessBlock)success
                                                   failture:(DCFailtureBlock)failture;

#pragma mark - POST订单详情
- (void)pioneerRequest_b2c_order_manage_detailWithOrderNo:(NSString *)orderNo
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;

#pragma mark - POST获取处方状态
- (void)pioneerRequest_b2c_order_manage_onlineDetailWithOrderNo:(NSString *)orderNo
                                                        success:(DCSuccessBlock)success
                                                       failture:(DCFailtureBlock)failture;

#pragma mark - 申请延期收货
- (void)pioneerRequest_b2c_order_manage_aplyDlayRecvGoodsWithOrderNo:(NSString *)orderNo
                                                     modifyTimeParam:(NSString *)modifyTimeParam
                                                             success:(DCSuccessBlock)success
                                                            failture:(DCFailtureBlock)failture;

#pragma mark - 买家售后申请
- (void)pioneerRequest_b2c_order_manage_buyerAfterSalesApplyWithOrderNo:(NSString *)orderNo
                                                       afterSalesImages:(NSString *)afterSalesImages
                                                       afterSalesReason:(NSString *)afterSalesReason
                                                         afterSalesType:(NSString *)afterSalesType
                                                                success:(DCSuccessBlock)success
                                                               failture:(DCFailtureBlock)failture;
#pragma mark - 买家退款申请
- (void)pioneerRequest_b2c_order_manage_buyerReturnApplyWithOrderNo:(NSString *)orderNo
                                                         reasonDesc:(NSString *)reasonDesc
                                                         reasonText:(NSString *)reasonText
                                                            success:(DCSuccessBlock)success
                                                           failture:(DCFailtureBlock)failture;
#pragma mark - 取消售后申请-
- (void)pioneerRequest_b2c_order_manage_cancelAfterSalesApplyWithOrderNo:(NSString *)orderNo
                                                                 success:(DCSuccessBlock)success
                                                                failture:(DCFailtureBlock)failture;
#pragma mark - 取消订单
- (void)pioneerRequest_b2c_order_manage_cancelOrderWithOrderNo:(NSString *)orderNo
                                                    closedDesc:(NSString *)closedDesc
                                               modifyTimeParam:(NSString *)modifyTimeParam
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;

#pragma mark - 取消退款申请-
- (void)pioneerRequest_b2c_order_manage_cancelReturnApplyWithOrderNo:(NSString *)orderNo
                                                             success:(DCSuccessBlock)success
                                                            failture:(DCFailtureBlock)failture;
#pragma mark - 删除订单（入订单回收站）
- (void)pioneerRequest_b2c_order_manage_deleteOrderWithOrderNo:(NSString *)orderNo
                                               modifyTimeParam:(NSString *)modifyTimeParam
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;
#pragma mark - 售后申请详情-
- (void)pioneerRequest_b2c_order_manage_detailAfterSalesApplyWithOrderNo:(NSString *)orderNo
                                                                 success:(DCSuccessBlock)success
                                                                failture:(DCFailtureBlock)failture;
#pragma mark - 订单商品退款详情-
- (void)pioneerRequest_b2c_order_manage_detailOrderGoodsReturnWithOrderNo:(NSString *)orderNo
                                                             orderGoodsId:(NSString *)orderGoodsId
                                                                  success:(DCSuccessBlock)success
                                                                 failture:(DCFailtureBlock)failture;
#pragma mark -订单退款详情，type：1-接单时退款，2-用户申请时退款-
- (void)pioneerRequest_b2c_order_manage_detailOrderReturnWithOrderNo:(NSString *)orderNo
                                                             success:(DCSuccessBlock)success
                                                            failture:(DCFailtureBlock)failture;
#pragma mark - 退款申请详情-
- (void)pioneerRequest_b2c_order_manage_detailReturnApplyWithOrderNo:(NSString *)orderNo
                                                             success:(DCSuccessBlock)success
                                                            failture:(DCFailtureBlock)failture;
#pragma mark - 买家申请商品退款退货（订单已发货）
- (void)pioneerRequest_b2c_order_manage_goodsRefundWithApplyAmount:(NSString *)applyAmount
                                                              img1:(NSString *)img1
                                                              img2:(NSString *)img2
                                                              img3:(NSString *)img3
                                                      orderGoodsId:(NSString *)orderGoodsId
                                                        reasonDesc:(NSString *)reasonDesc
                                                          reasonId:(NSString *)reasonId
                                                        reasonText:(NSString *)reasonText
                                                        returnType:(NSString *)returnType
                                                           success:(DCSuccessBlock)success
                                                          failture:(DCFailtureBlock)failture;
#pragma mark - 退款申请详情
- (void)pioneerRequest_b2c_order_manage_goodsRefundListApplyWithCurrentPage:(NSString *)currentPage
                                                                    success:(DCSuccessBlock)success
                                                                   failture:(DCFailtureBlock)failture;

#pragma mark - 获取物流公司列表
- (void)pioneerRequest_b2c_order_manage_logisticsWithSuccess:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;


#pragma mark - 买家申请整笔订单退款
- (void)pioneerRequest_b2c_order_manage_orderRefundWithOrderNo:(NSString *)orderNo
                                               modifyTimeParam:(NSString *)modifyTimeParam
                                             orderRefundReason:(NSString *)orderRefundReason
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;

#pragma mark - 获取退款原因列表，type：1-取消订单原因，2-退款原因
- (void)pioneerRequest_b2c_order_manage_refundReasonWithType:(NSString *)type
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;

#pragma mark - 确认收货
- (void)pioneerRequest_b2c_order_manage_recvGoodsWithOrderNo:(NSString *)orderNo
                                             modifyTimeParam:(NSString *)modifyTimeParam
                                                     success:(DCSuccessBlock)success
                                                    failture:(DCFailtureBlock)failture;
#pragma mark - 催单-
- (void)pioneerRequest_b2c_order_manage_remindWithOrderNo:(NSString *)orderNo
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;
#pragma mark - 买家订单汇总信息
- (void)pioneerRequest_b2c_order_manage_userorderCountWithSuccess:(DCSuccessBlock)success
                                                         failture:(DCFailtureBlock)failture;
#pragma mark - 买家查看退款退货（查看异议订单）-
- (void)pioneerRequest_b2c_order_manage_viewGoodsRefundWithOrderNo:(NSString *)orderNo
                                                           success:(DCSuccessBlock)success
                                                          failture:(DCFailtureBlock)failture;

#pragma mark - 物流列表 -
- (void)pioneerRequest_b2c_order_manage_deliverListWithOrderNo:(NSString *)orderNo
                                                       success:(DCSuccessBlock)success
                                                      failture:(DCFailtureBlock)failture;

#pragma mark - 获取消息列表
- (void)pioneerRequest_b2c_info_infomessage_publishsWithCurrentPage:(NSString *)currentPage
                                                          beginTime:(NSString *)beginTime
                                                            endTime:(NSString *)endTime
                                                            hasRead:(NSString *)hasRead
                                                         msgContent:(NSString *)msgContent
                                                            msgType:(NSString *)msgType
                                                       recvNameList:(NSString *)recvNameList
                                                       sendRecvFlag:(NSString *)sendRecvFlag
                                                     senderUserName:(NSString *)senderUserName
                                                            success:(DCSuccessBlock)success
                                                           failture:(DCFailtureBlock)failture;


@end

NS_ASSUME_NONNULL_END
