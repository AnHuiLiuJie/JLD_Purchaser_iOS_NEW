//
//  DCAPIManager.h
//  DCProject
//
//  Created by bigbing on 2019/4/22.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHttpClient.h"
#import "DCBaseModel.h"

typedef void(^DCSuccessBlock)( _Nullable  id response);
typedef void(^DCMoreListSuccessBlock)(NSArray *_Nonnull array,BOOL hasNextPage,CommonListModel *_Nullable baseModel);
typedef void(^DCListSuccessBlock)(NSArray *_Nullable array,BOOL hasNextPage);
typedef void(^DCFailtureBlock)(NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager : NSObject

+ (DCAPIManager *)shareManager;



- (void)dc_requestPsdLoginWithLoginName:(NSString *)loginName
                               loginPwd:(NSString *)loginPwd
                               userType:(NSString *)userType
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;



- (void)dc_requestImageCodeWithToken:(NSString *)token
                              userId:(NSString *)userId
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;



- (void)dc_requestSendSMSCodeWithCaptcha:(NSString *)captcha
                             phoneNumber:(NSString *)phoneNumber
                                   token:(NSString *)token
                                  userId:(NSString *)userId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestCheckSMSCodeWithCaptcha:(NSString *)captcha
                              phoneNumber:(NSString *)phoneNumber
                                    token:(NSString *)token
                                   userId:(NSString *)userId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;


- (void)dc_requestResetPswWithCaptcha:(NSString *)captcha
                          phoneNumber:(NSString *)phoneNumber
                                token:(NSString *)token
                               userId:(NSString *)userId
                            loginName:(NSString *)loginName
                               newPwd:(NSString *)newPwd
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;



- (void)dc_requestAllAreaWithSuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;



- (void)dc_requestAdvWithCode:(NSString *)code
                      success:(DCSuccessBlock)success
                     failture:(DCFailtureBlock)failture;



- (void)dc_requestHomePromoteWithDataKey:(NSString *)dataKey
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestHomeCompanyWithDataKey:(NSString *)dataKey
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestHomeGoodsWithDataKey:(NSString *)dataKey
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;


- (void)dc_requestHomeNewsWithDataKey:(NSString *)dataKey
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;



- (void)dc_requestDrugTypeWithCatIds:(NSString *)catIds
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;



- (void)dc_requestCompanyTypeWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestDrugCollectWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestPlantPeopleListWithGrowerName:(NSString *)growerName
                                    currentPage:(NSInteger)currentPage
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;


- (void)dc_requestPlantDrugListWithVarietyName:(NSString *)varietyName
                                   currentPage:(NSInteger)currentPage
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


- (void)dc_requestNewsListWithCatId:(NSString *)catId
                         searchName:(NSString *)searchName
                        currentPage:(NSInteger)currentPage
                            success:(DCListSuccessBlock)success
                           failture:(DCFailtureBlock)failture;



- (void)dc_requestAddressListWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestAddAddressWithAreaId:(NSInteger)areaId
                              recevier:(NSString *)recevier
                             cellphone:(NSString *)cellphone
                             isDefault:(NSInteger)isDefault
                            streetInfo:(NSString *)streetInfo
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;


- (void)dc_requestEditAddressWithAddrId:(NSInteger)addrId
                                 areaId:(NSInteger)areaId
                               recevier:(NSString *)recevier
                              cellphone:(NSString *)cellphone
                              isDefault:(NSInteger)isDefault
                             streetInfo:(NSString *)streetInfo
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;


- (void)dc_requestDeleteAddressWithAddrId:(NSInteger)addrId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;


- (void)dc_requestBrowseRecordWithCurrentPage:(NSInteger)currentPage
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;


- (void)dc_requestDeleteBrowseWithAccessId:(NSInteger)accessId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;


- (void)dc_requestAddCollectWithInfoId:(NSString *)infoId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;


- (void)dc_requestCollectListWithCurrentPage:(NSInteger)currentPage
                                   goodsName:(NSString *)goodsName
                                     success:(DCListSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)dc_requestDeleteCollectWithCollectionId:(NSArray *)collectionId
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestCancelCollectWithInfoId:(NSString *)infoId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;



- (void)dc_requestCollectStatusWithInfoId:(NSString *)infoId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;



- (void)dc_requestExhibitListWithID:(NSString *)iD
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;


- (void)dc_requestCareListWithCurrentPage:(NSInteger)currentPage
                                  success:(DCListSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;


- (void)dc_requestGoodsDetailWithGoodsId:(NSString *)goodsId
                                 batchId:(NSString *)batchId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestAddSeeRecordWithFirmId:(NSString *)firmId
                                firmName:(NSString *)firmName
                                 goodsId:(NSString *)goodsId
                               goodsName:(NSString *)goodsName
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture  ;

- (void)dc_requestStoreDetailWithFirmId:(NSString *)firmId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;



- (void)dc_requestStoreTicketWithFirmId:(NSString *)firmId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;



- (void)dc_requestGetStoreTicketWithCouponId:(NSInteger)couponId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)dc_requestGoodsTicketWithGoodsId:(NSString *)goodsId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestGetGoodsTicketWithCouponId:(NSInteger)couponId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)dc_requestGoodsDetailTicketWithFirmId:(NSString *)firmId
                                      goodsId:(NSString *)goodsId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestCompanyAptitudeWithFirmId:(NSString *)firmId
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;


- (void)dc_requestDrugExhibitSuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;



- (void)dc_requestGoodsRecordListWithCurrentPage:(NSInteger)currentPage
                                         goodsId:(NSString *)goodsId
                                         success:(DCListSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchGoodsListWithCatIds:(NSString *)catIds
                                currentPage:(NSInteger)currentPage
                                   entrance:(NSString *)entrance
                                  goodsName:(NSString *)goodsName
                                   isCoupon:(NSString *)isCoupon
                                isPromotion:(NSString *)isPromotion
                                manufactory:(NSString *)manufactory
                                packingSpec:(NSString *)packingSpec
                                   prodType:(NSString *)prodType
                                       sort:(NSString *)sort
                              suppierFirmId:(NSString *)suppierFirmId
                                    success:(DCListSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;

- (void)dc_requestB2BSearchGoodsListWithCatIds:(NSString *)catIds
                                   currentPage:(NSInteger)currentPage
                                      entrance:(NSString *)entrance
                                     goodsName:(NSString *)goodsName
                                      isCoupon:(NSString *)isCoupon
                                   isPromotion:(NSString *)isPromotion
                                   manufactory:(NSString *)manufactory
                                   packingSpec:(NSString *)packingSpec
                                      prodType:(NSString *)prodType
                                          sort:(NSString *)sort
                                 suppierFirmId:(NSString *)suppierFirmId
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


- (void)dc_requestSearchCompanyListWithCurrentPage:(NSInteger)currentPage
                                            catIds:(NSString *)catIds
                                          entrance:(NSString *)entrance
                                         goodsName:(NSString *)goodsName
                                          isCoupon:(NSString *)isCoupon
                                       isPromotion:(NSString *)isPromotion
                                       manufactory:(NSString *)manufactory
                                       packingSpec:(NSString *)packingSpec
                                          prodType:(NSString *)prodType
                                              sort:(NSString *)sort
                                     suppierFirmId:(NSString *)suppierFirmId
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchPackageListWithCurrentPage:(NSInteger)currentPage
                                            catIds:(NSString *)catIds
                                          entrance:(NSString *)entrance
                                         goodsName:(NSString *)goodsName
                                          isCoupon:(NSString *)isCoupon
                                       isPromotion:(NSString *)isPromotion
                                       manufactory:(NSString *)manufactory
                                       packingSpec:(NSString *)packingSpec
                                          prodType:(NSString *)prodType
                                              sort:(NSString *)sort
                                     suppierFirmId:(NSString *)suppierFirmId
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchStoreListWithBrand:(NSString *)brand
                                  classify:(NSString *)classify
                                 goodsName:(NSString *)goodsName
                              goodsTagName:(NSString *)goodsTagName
                                     isHot:(NSString *)isHot
                               isPromotion:(NSString *)isPromotion
                               manufactory:(NSString *)manufactory
                               packingSpec:(NSString *)packingSpec
                                  saleCtrl:(NSString *)saleCtrl
                                      sort:(NSString *)sort
                             suppierFirmId:(NSString *)suppierFirmId
                           suppierFirmName:(NSString *)suppierFirmName
                                       zyc:(NSString *)zyc
                               currentPage:(NSInteger)currentPage
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;



- (void)dc_requestUserInfoWithSuccess:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;



- (void)dc_requestSaveUserInfoWithCellphone:(NSString *)cellphone
                                      email:(NSString *)email
                                   landline:(NSString *)landline
                                         qq:(NSString *)qq
                                     wechat:(NSString *)wechat
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;



- (void)dc_requestIntentionListWithCurrentPage:(NSInteger)currentPage
                                         state:(NSString *)state
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


- (void)dc_requestOrderListWithCurrentPage:(NSInteger)currentPage
                                orderState:(NSString *)orderState
                                  firmName:(NSString *)firmName
                                   success:(DCListSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;


- (void)dc_requestShoppingCarListWithSuccess:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)dc_requestAddShoppingCarWithBatchId:(NSString *)batchId
                                    goodsId:(NSString *)goodsId
                                   quantity:(NSInteger)quantity
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;



- (void)dc_requestChangeGoodsCountWithBatchId:(NSString *)batchId
                                      goodsId:(NSString *)goodsId
                                       cartId:(NSString *)cartId
                                     quantity:(NSInteger)quantity
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestDeleteShoppingCarWithCartIds:(NSString *)cartIds
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;

- (void)dc_requestShoppingCarGoodsCountWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;


- (void)dc_requestShoppingCarCommintWithCartIds:(NSString *)cartIds
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestShoppingCarSubmitWithAddressId:(NSInteger)addressId
                                      couponsIds:(NSString *)couponsIds
                                         cartIds:(NSString *)cartIds
                                cartTradeInfoDTO:(NSArray *)cartTradeInfoDTO
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchStoreListWithCurrentPage:(NSInteger)currentPage
                                          coupon:(NSString *)coupon
                                        firmName:(NSString *)firmName
                                     isShowGoods:(NSString *)isShowGoods
                                        maxMoney:(NSString *)maxMoney
                                        minMoney:(NSString *)minMoney
                                       promotion:(NSString *)promotion
                                           scope:(NSString *)scope
                                       sortField:(NSString *)sortField
                                        sortMode:(NSString *)sortMode
                                         success:(DCListSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;


- (void)dc_requestMineCountWithSuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;




- (void)dc_requestBatchListWithGoodsId:(NSString *)goodsId
                               batchId:(NSString *)batchId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;



- (void)dc_requestMineTicketListWithCurrentPage:(NSInteger)currentPage
                                          state:(NSString *)state
                                           type:(NSString *)type
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestRepayListListWithCurrentPage:(NSInteger)currentPage
                                     startDate:(NSString *)startDate
                                       endDate:(NSString *)endDate
                                       orderNo:(NSString *)orderNo
                                         state:(NSString *)state
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


- (void)dc_requestRepayRepayWithAmount:(CGFloat)amount
                               orderNo:(NSInteger)orderNo
                             paymentId:(NSString *)paymentId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;


- (void)dc_requestApplyOverdueWithOrderNo:(NSInteger)orderNo
                              delayReason:(NSString *)delayReason
                           paymentEndDate:(NSString *)paymentEndDate
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;



- (void)dc_requestRepayRecordWithOrderNo:(NSInteger)orderNo
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;


- (void)dc_requestRepayOverdunTimeWithOrderNo:(NSInteger)orderNo
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestStoreEvaluateListWithCurrentPage:(NSInteger)currentPage
                                            firmId:(NSString *)firmId
                                              type:(NSString *)type
                                           success:(DCListSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;



- (void)dc_requestStoreEvaluateAnalyzeWithFirmId:(NSString *)firmId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;



- (void)dc_requestStoreGoodsListWithCurrentPage:(NSInteger)currentPage
                                         firmId:(NSString *)firmId
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestIsRegisterWithFirmName:(NSString *)firmName
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;


- (void)dc_requestCompanyRegisterWithApplyType:(NSInteger)applyType
                                     cellphone:(NSInteger)cellphone
                                   firmAddress:(NSString *)firmAddress
                                      firmArea:(NSString *)firmArea
                                    firmAreaId:(NSInteger)firmAreaId
                                      firmCat1:(NSString *)firmCat1
                                  firmCat2List:(NSString *)firmCat2List
                                   firmContact:(NSString *)firmContact
                                  firmLoginPwd:(NSString *)firmLoginPwd
                                      firmName:(NSString *)firmName
                                     loginName:(NSString *)loginName
                                    tempUserId:(NSInteger)tempUserId
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;


- (void)dc_requestCompanyQualificateWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestRequireUploadQualificateWithfirmCat1:(NSString *)firmCat1
                                              firmCat2:(NSString *)firmCat2
                                               success:(DCSuccessBlock)success
                                              failture:(DCFailtureBlock)failture;



- (void)dc_requestCommintQualificateWithFirmAddress:(NSString *)firmAddress
                                           firmArea:(NSString *)firmArea
                                         firmAreaId:(NSInteger)firmAreaId
                                           firmCat1:(NSString *)firmCat1
                                       firmCat2List:(NSString *)firmCat2List
                                        firmContact:(NSString *)firmContact
                                             firmId:(NSInteger)firmId
                                           firmName:(NSString *)firmName
                                             qcList:(NSArray *)qcList
                                            success:(DCSuccessBlock)success
                                           failture:(DCFailtureBlock)failture;



- (void)dc_requestDrugjcInfoWithGoodsId:(NSString *)goodsId
                                success:(DCSuccessBlock)success
                               failture:(DCFailtureBlock)failture;



- (void)dc_requestChangePhoneWithCellphone:(NSString *)cellphone
                                  newPhone:(NSString *)newPhone
                                 validInfo:(NSString *)validInfo
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;



- (void)dc_requestCertifiedQualificateWithSuccess:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;



- (void)dc_requestUnverifiedQualificateWithSuccess:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;



- (void)dc_requestCompanyInfoWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestTCMSearchGoodsListWithCatIds:(NSString *)catIds
                                   currentPage:(NSInteger)currentPage
                                      entrance:(NSString *)entrance
                                     goodsName:(NSString *)goodsName
                                      isCoupon:(NSString *)isCoupon
                                   isPromotion:(NSString *)isPromotion
                                   manufactory:(NSString *)manufactory
                                   packingSpec:(NSString *)packingSpec
                                      prodType:(NSString *)prodType
                                          sort:(NSString *)sort
                                 suppierFirmId:(NSString *)suppierFirmId
                                       success:(DCListSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;



- (void)dc_requestTCMLickGoodsListWithCatIds:(NSString *)catIds
                                 currentPage:(NSInteger)currentPage
                                    entrance:(NSString *)entrance
                                   goodsName:(NSString *)goodsName
                                    isCoupon:(NSString *)isCoupon
                                 isPromotion:(NSString *)isPromotion
                                 manufactory:(NSString *)manufactory
                                 packingSpec:(NSString *)packingSpec
                                    prodType:(NSString *)prodType
                                        sort:(NSString *)sort
                               suppierFirmId:(NSString *)suppierFirmId
                                     success:(DCListSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)dc_requestTCMRecommendGoodsListWithCatIds:(NSString *)catIds
                                      currentPage:(NSInteger)currentPage
                                         entrance:(NSString *)entrance
                                        goodsName:(NSString *)goodsName
                                         isCoupon:(NSString *)isCoupon
                                      isPromotion:(NSString *)isPromotion
                                      manufactory:(NSString *)manufactory
                                      packingSpec:(NSString *)packingSpec
                                         prodType:(NSString *)prodType
                                             sort:(NSString *)sort
                                    suppierFirmId:(NSString *)suppierFirmId
                                          success:(DCListSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;



- (void)dc_requestTCMSpecialGoodsListWithCatIds:(NSString *)catIds
                                    currentPage:(NSInteger)currentPage
                                       entrance:(NSString *)entrance
                                      goodsName:(NSString *)goodsName
                                       isCoupon:(NSString *)isCoupon
                                    isPromotion:(NSString *)isPromotion
                                    manufactory:(NSString *)manufactory
                                    packingSpec:(NSString *)packingSpec
                                       prodType:(NSString *)prodType
                                           sort:(NSString *)sort
                                  suppierFirmId:(NSString *)suppierFirmId
                                        success:(DCListSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestSysMessageWithCurrentPage:(NSInteger)currentPage
                                    success:(DCListSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;



- (void)dc_requestOrderMessageWithCurrentPage:(NSInteger)currentPage
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestNoReadMessageCountWithSuccess:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;


- (void)dc_requestTCMStoreListWithCurrentPage:(NSInteger)currentPage
                                       coupon:(NSString *)coupon
                                     firmName:(NSString *)firmName
                                  isShowGoods:(NSString *)isShowGoods
                                     maxMoney:(NSInteger)maxMoney
                                     minMoney:(NSInteger)minMoney
                                    promotion:(NSString *)promotion
                                        scope:(NSString *)scope
                                    sortField:(NSString *)sortField
                                     sortMode:(NSString *)sortMode
                                      success:(DCListSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestResetPasswordWithNewPwd:(NSString *)newPwd
                                   oldPwd:(NSString *)oldPwd
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;



- (void)dc_requestDefaultImageWithSuccess:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchGoodsKeywordWithKeyword:(NSString *)keyword
                                          isZyc:(NSString *)isZyc
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestSearchStoreKeywordWithKeyword:(NSString *)keyword
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;



- (void)dc_requestIsRepayInfoWithSuppierFirmId:(NSInteger)suppierFirmId
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;



- (void)dc_requestApplyRepayWithSuppierFirmId:(NSInteger)suppierFirmId
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestApplyOrderSuccessWithOrders:(NSString *)orders
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestCompanyRangWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;



- (void)dc_requestCheckUpdateWithAppBusType:(NSString *)appBusType
                                    appType:(NSString *)appType
                                  versionNo:(NSString *)versionNo
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;



- (void)dc_requestRegisterProtocolWithSuccess:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;



- (void)dc_requestCompanyStatusWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;



- (void)dc_requestLogoutWithSuccess:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;



- (void)dc_requestDefautAddresssuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;

#pragma mark -
- (void)dc_requestXiaohuWithCellphone:(NSString *)cellphone
                            validInfo:(NSString *)validInfo
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;

- (void)dc_promote:(NSString *)goodsId
               Stm:(NSString *)stm
         utmUserId:(NSString *)utmUserId
           success:(DCSuccessBlock)success
          failture:(DCFailtureBlock)failture;

#pragma mark - 验证码获取
- (void)dc_request_b2c_common_captcha_getWithDic:(NSDictionary *)dic
                                         Success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;

#pragma mark - 滑动验证码验证
- (void)dc_request_b2c_common_captcha_checkWithDic:(NSDictionary *)dic
                                           Success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;

#pragma mark - 滑动验证码二次调用，发送短信验证码
- (void)dc_request_b2c_common_captcha_sendMessageWithDic:(NSDictionary *)dic
                                                 Success:(DCSuccessBlock)success
                                                failture:(DCFailtureBlock)failture;

@end

NS_ASSUME_NONNULL_END
