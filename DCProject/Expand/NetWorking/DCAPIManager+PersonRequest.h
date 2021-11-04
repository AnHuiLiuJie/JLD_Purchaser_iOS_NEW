//
//  DCAPIManager+PersonRequest.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCAPIManager (PersonRequest)
#pragma mark - 登录
/*!
 *@brief   账户密码登录
 *
 *@param  loginName 手机号码,
 *@param  loginPwd 密码,
 *@param  userType 用户类型1.个人 ,2.供应商
 *
 */
- (void)person_requestPsdLoginWithLoginName:(NSString *)loginName
                                   loginPwd:(NSString *)loginPwd
                                   userType:(NSString *)userType
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;
#pragma mark - 登录
/*!
 *@brief   短信验证码登录
 *
 *@param  captcha 短信验证码
 *@param  phoneNumber 手机号码,
 *@param  token token,
 *@param  userId userid
 *@param  userType 用户类型1.个人 ,2.供应商,
 */
- (void)person_requestSmsCodeLoginWithcaptcha:(NSString *)captcha
                                  phoneNumber:(NSString *)phoneNumber
                                        token:(NSString *)token
                                       userId:(NSString *)userId
                                     userType:(NSString *)userType
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;
#pragma mark - 获取图片验证码
- (void)person_requestImageCodeWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark - 获取短信验证码
/*!
 *@brief   获取短信验证码
 *
 *@param  captcha  图形验证码
 *@param  phoneNumber 手机号
 *@param  token  token
 *@param  userId  userId
 */
- (void)person_requestSendSMSCodeWithCaptcha:(NSString *)captcha
                                 phoneNumber:(NSString *)phoneNumber
                                       token:(NSString *)token
                                      userId:(NSString *)userId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;
#pragma mark - 注册
/*!
 *@brief   注册
 *
 *@param  cellphone  手机号
 *@param  loginName 登录名
 *@param  loginPwd  密码
 *@param  tempUserId  userId
 *@param  validInfo  短信验证码
 */
- (void)person_requestResginWithcellphone:(NSString *)cellphone
                                loginName:(NSString *)loginName
                                 loginPwd:(NSString *)loginPwd
                               tempUserId:(NSString *)tempUserId
                                validInfo:(NSString *)validInfo
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;
#pragma mark - 忘记密码
/*!
 *@brief   忘记密码
 *@param  token  token
 *@param  phoneNumber  手机号
 *@param  loginName 登录名
 *@param  newPwd  新密码
 *@param  userId  userId
 *@param  captcha  短信验证码
 */
- (void)person_requestForgetWithphoneNumber:(NSString *)phoneNumber
                                  loginName:(NSString *)loginName
                                     newPwd:(NSString *)newPwd
                                     userId:(NSString *)userId
                                      token:(NSString *)token
                                    captcha:(NSString *)captcha
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;
#pragma mark - 个人信息
- (void)person_requestPersonDataWithisShowHUD:(BOOL)isShow
                                      Success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;
#pragma mark - 获取个人界面数量
- (void)person_requestPersonNumWithSuccess:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark - 保存个人信息
/*!
 *@param  userImg        头像
 *@param  sex      性别
 *@param  qq            QQ
 *@param  wechat        微信号
 *@param  nickName       昵称
 *@param  modifyTimeParam        修改时间
 */
- (void)person_requestSaveUserInfoWithuserImg:(NSString *)userImg
                                     nickName:(NSString *)nickName
                                          sex:(NSString *)sex
                                           qq:(NSString *)qq
                                       wechat:(NSString *)wechat
                              modifyTimeParam:(NSString *)modifyTimeParam
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;
#pragma mark -修改绑定手机
/*!
 *@brief   修改绑定手机
 *
 *@param  loginPwd  登录密码
 *@param  newPhone  新手机号
 *@param  validInfo  短信验证码
 */
- (void)person_changePhoneWithloginPwd:(NSString *)loginPwd
                              newPhone:(NSString *)newPhone
                             validInfo:(NSString *)validInfo
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;
#pragma mark -修改登录密码
/*!
 *@brief   修改登录密码
 *
 *@param  oldPwd  老密码
 *@param  newPwd  新密码
 */
- (void)person_changePwdWitholdPwd:(NSString *)oldPwd
                            newPwd:(NSString *)newPwd
                           success:(DCSuccessBlock)success
                          failture:(DCFailtureBlock)failture;
#pragma mark -实名认证
/*!
 *@brief   实名认证
 *
 *@param  userName  真实姓名
 *@param  idCard  身份证号码
 *@param  modifyTimeParam  修改时间
 *@param  idCardFrontPic  身份证正面
 *@param  frontPic  身份证反面
 *@param  idCardFacePic  手持身份证
 */
- (void)person_AuthenWithuserName:(NSString *)userName
                           idCard:(NSString *)idCard
                  modifyTimeParam:(NSString *)modifyTimeParam
                   idCardFrontPic:(NSString *)idCardFrontPic
                         frontPic:(NSString *)frontPic
                    idCardFacePic:(NSString *)idCardFacePic
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;
#pragma mark -获取实名认证信息

- (void)person_GetAuthenInfosuccess:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;
#pragma mark -获取收货地址列表

- (void)person_GetAddressListsuccess:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;
#pragma mark - 获取地区
- (void)person_requestAllAreaWithSuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;
#pragma mark -新增收货地址
/*!
 *@brief  新增收货地址
 *
 *@param  areaId  区域ID
 *@param  cellphone  手机号码
 *@param  isDefault  是否为默认收货地址。0-否；1-是
 *@param  recevier  收货人姓名
 *@param  streetInfo  收货地址详细地址
 */
- (void)person_addAddressWithareaId:(NSString *)areaId
                          cellphone:(NSString *)cellphone
                          isDefault:(NSString *)isDefault
                           recevier:(NSString *)recevier
                         streetInfo:(NSString *)streetInfo
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;
#pragma mark -编辑收货地址
/*!
 *@brief  编辑收货地址
 *@param  addrId  收货地址编码
 *@param  areaId  区域ID
 *@param  cellphone  手机号码
 *@param  isDefault  是否为默认收货地址。0-否；1-是
 *@param  recevier  收货人姓名
 *@param  streetInfo  收货地址详细地址
 */
- (void)person_editAddressWithaddrId:(NSString *)addrId
                              areaId:(NSString *)areaId
                           cellphone:(NSString *)cellphone
                           isDefault:(NSString *)isDefault
                            recevier:(NSString *)recevier
                          streetInfo:(NSString *)streetInfo
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;
#pragma mark -删除收货地址
/*!
 *@brief  编辑收货地址
 *@param  addrId  收货地址编码
 */
- (void)person_deleAddressWithaddrId:(NSString *)addrId
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;
#pragma mark -优惠券列表
/*!
 *@brief  优惠券列表
 *@param  couponsClass  优惠券类型1：平台通用券 2：店铺通用券 3：商品通用券
 *@param  isConsume  是否已消费，0：已过期，1：未消费，2：已消费
 *@param  currentPage  当前分页页码（默认为1)
 */
- (void)person_getCouponsListWithcouponsClass:(NSString *)couponsClass
                                    isConsume:(NSString *)isConsume
                                  currentPage:(NSString *)currentPage
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;


#pragma mark - 确认下单页面优惠券列表
/*!
 *  @param  goodsIds  所有商品ID，用英文“,”隔开
 *  @param  salerFirmId  卖家Id
 */
//- (void)person_getMineCouponsListWithGoodsIds:(NSString *)goodsIds
//                                  salerFirmId:(NSInteger)salerFirmId
//                                      success:(DCSuccessBlock)success
//                                     failture:(DCFailtureBlock)failture;

- (void)person_getMineCouponsListWithCartIds:(NSString *)cartIds
                                       entry:(NSString *)entry
                                    GoodsIds:(NSString *)goodsIds
                                    quantity:(NSString *)quantity
                                 salerFirmId:(NSInteger)salerFirmId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;


#pragma mark -订单列表
/*!
 *@brief  订单列表
 *@param  buyerDelState  买家删除标识：1-正常；2-删除；3-彻底删除
 *@param  currentPage 当前分页页码（默认为1）
 *@param  endDate  查询交易日期，结束日期
 *@param  evalState  评价状态：11-买家未评价、卖家未评价；12-买家未评价、卖家已评价；21-买家已评价、卖家未评价；22-买家已评价、卖家已评价
 *@param  orderNo 订单编号
 *@param  orderState  订单状态：1-已下单，等待买家付款；2-买家已付款，等待（职业药师）审核；3-（职业药师）审核通过，等待卖家发货； 4-买家申请退款中(未发货前整笔订单退款)；5-卖家已发货，等待买家确认；6-买家确认收货，交易成功；7-交易关闭
 *@param  sellerFirmName  卖家企业名称
 *@param  startDate 查询交易日期，开始日期
 */
- (void)person_getOrderListWithbuyerDelState:(NSString *)buyerDelState
                                 currentPage:(NSString *)currentPage
                                     endDate:(NSString *)endDate
                                   evalState:(NSString *)evalState
                                     orderNo:(NSString *)orderNo
                                  orderState:(NSString *)orderState
                                 refundState:(NSString *)refundState
                              sellerFirmName:(NSString *)sellerFirmName
                                   startDate:(NSString *)startDate
                                  searchName:(NSString *)searchName
                                   goodsName:(NSString *)goodsName
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;

//退款订单列表
- (void)person_b2c_order_manage_returnListWithCurrentPage:(NSString *)currentPage
                                              refundState:(NSString *)refundState
                                                  orderNo:(NSString *)orderNo
                                               searchName:(NSString *)searchName
                                                  success:(DCSuccessBlock)success
                                                 failture:(DCFailtureBlock)failture;
#pragma mark -获取消息第一条数据
/*!
 *@brief  获取消息第一条数据
 */
- (void)person_getmessageFirstsuccess:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;

#pragma mark -关注店铺列表
/*!
 *@brief  关注店铺列表
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_getFocusLisFirstwithcurrentPage:(NSString *)currentPage
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;
#pragma mark -删除收藏（店铺，商品共用）
/*!
 *@brief  -删除收藏（店铺，商品共用）
 *@param  collectionIds 收藏ID
 */
- (void)person_deleFocusFirstwithcollectionIds:(NSString *)collectionIds
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;

#pragma mark -删除收藏（店铺，商品共用） 新接口

- (void)person_deleNewFocusFirstwithcollectionIds:(NSString *)collectionIds
                                          success:(DCSuccessBlock)success
                                         failture:(DCFailtureBlock)failture;
#pragma mark -店铺基本信息
/*!
 *@brief  店铺基本信息
 *@param  firmId 店铺ID
 */
- (void)person_getStoreInfowithfirmId:(NSString *)firmId
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;
#pragma mark -是否已被收藏
/*!
 *@brief  是否已被收藏
 *@param  objectId 店铺ID/商品ID
 */
- (void)person_judgeIsCollectionwithobjectId:(NSString *)objectId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;
#pragma mark -添加收藏（店铺，商品共用）
/*!
 *@brief  -添加收藏（店铺，商品共用）
 *@param  collectionType 收藏类型：1-产品收藏；2-关注企业
 *@param  goodsPrice 收藏商品价格：收藏时商品的价格
 *@param  objectId 添加收藏，若收藏产品传入产品ID；若收藏企业传入企业ID
 */
- (void)person_addCollectionwithcollectionType:(NSString *)collectionType
                                    goodsPrice:(NSString *)goodsPrice
                                      objectId:(NSString *)objectId
                                      isPrompt:(BOOL)isPrompt
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;
#pragma mark -店铺优惠券接口
/*!
 *@brief  店铺优惠券接口
 *@param  firmId 店铺ID
 */
- (void)person_getStoreCouponswithfirmId:(NSString *)firmId
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;
#pragma mark -领取优惠券接口
/*!
 *@brief  领取优惠券接口
 *@param  couponsId 优惠券ID
 */
- (void)person_receiveCouponswithcouponsId:(NSString *)couponsId
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark -店铺中间按钮分类
/*!
 *@brief  店铺中间按钮分类
 *@param  firmId 店铺ID
 */
- (void)person_getStoreCategorywithfirmId:(NSString *)firmId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;
#pragma mark -店铺商品列表
/*!
 *@brief  店铺中间按钮分类
 *@param  firmId 店铺ID
 *@param  brandId 品牌ID
 *@param  brandName 品牌名字
 *@param  currentPage 当前分页页码（默认为1
 *@param  descFlag 价格排序 排序方式:1.由高到低；2.由低到高。（默认由高到低）
 *@param  dosageForm 剂型
 *@param  goodsIds 刷选的goodsIDs
 *@param  goodsTitle 商品名
 *@param  manufactory 生产单位
 *@param  orderFlag 排序类型：sellPrice.价格排序；totalSales.销量排序；evalNum.评价数排序（默认是销量排序，由高到低）
 *@param  searchName 输入框输入的字符:通用名，商品名，症状
 *@param  symptom 症状
 *@param  useMethod 使用方法
 *@param  usePerson 使用人群
 */
- (void)person_getStoreGoodsListywithfirmId:(NSString *)firmId
                                    brandId:(NSString *)brandId
                                  brandName:(NSString *)brandName
                                currentPage:(NSString *)currentPage
                                   descFlag:(NSString *)descFlag
                                 dosageForm:(NSString *)dosageForm
                                   goodsIds:(NSString *)goodsIds
                                 goodsTitle:(NSString *)goodsTitle
                                manufactory:(NSString *)manufactory
                                  orderFlag:(NSString *)orderFlag
                                 searchName:(NSString *)searchName
                                    symptom:(NSString *)symptom
                                  useMethod:(NSString *)useMethod
                                  usePerson:(NSString *)usePerson
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;
#pragma mark -店铺推荐位(店铺首页的团购和促销)
//【首页团购推荐位：DEFAULT_APP_INDEX_01，首页促销推荐位1：DEFAULT_APP_INDEX_02，首页促销推荐位2：DEFAULT_APP_INDEX_03】
/*!
 *@brief  店铺推荐位
 *@param  firmId 店铺ID
 *  @param  spaceCode spaceCode
 */
- (void)person_getStoreRecommendwithfirmId:(NSString *)firmId
                                 spaceCode:(NSString *)spaceCode
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark -店铺楼层（店铺首页最下面的）
/*!
 *@brief  店铺楼层（店铺首页最下面的）
 *@param  firmId 店铺ID
 */
- (void)person_getStoreFloorwithfirmId:(NSString *)firmId
                               success:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;
#pragma mark -店铺活动
/*!
 *@brief  店铺活动
 *@param  firmId 店铺ID
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_getStoreActivitywithfirmId:(NSString *)firmId
                              currentPage:(NSString *)currentPage
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;
#pragma mark -店铺推荐商品
/*!
 *@brief  店铺推荐商品
 *@param  firmId 店铺ID
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_getStoreCommoditieswithfirmId:(NSString *)firmId
                                 currentPage:(NSString *)currentPage
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;
#pragma mark -店铺团购
/*!
 *@brief 店铺团购
 *@param  firmId 店铺ID
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_getStoreBulkwithfirmId:(NSString *)firmId
                          currentPage:(NSString *)currentPage
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;
#pragma mark -需求清单

- (void)person_getRequirementsLissuccess:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;
#pragma mark -我的处方单
/*!
 *@brief 店铺团购
 *@param  orderNo 订单编号
 *@param  currentPage 当前分页页码（默认为1）
 *@param  endDate 查询交易日期，结束日期
 *@param  orderState 订单状态：1-已下单，等待买家付款；2-买家已付款，等待（职业药师）审核；3-（职业药师）审核通过，等待卖家发货； 4-买家申请退款中(未发货前整笔订单退款)；5-卖家已发货，等待买家确认；6-买家确认收货，交易成功；7-交易关闭
 *@param  sellerFirmName 卖家企业名称
 *@param  startDate 查询交易日期，开始日期
 */
- (void)person_getPrescriptionsWithorderNo:(NSString *)orderNo
                               currentPage:(NSString *)currentPage
                                   endDate:(NSString *)endDate
                                orderState:(NSString *)orderState
                            sellerFirmName:(NSString *)sellerFirmName
                                 startDate:(NSString *)startDate
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark -商品数量修改
/*!
 *@brief 店铺团购
 *@param  cartId 购物车ID
 *@param  quantity 数量
 */
- (void)person_goodsNumwithcartId:(NSString *)cartId
                         quantity:(NSString *)quantity
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;
#pragma mark -购物车(需求清单)商品,单个,多个删除
/*!
 *@brief 购物车(需求清单)商品,单个,多个删除
 *@param  cartIds 购物车ID逗号隔开
 */
- (void)person_DeleRequestGoodswithcartIds:(NSString *)cartIds
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark 用户通过购物车确认订单
/*!
 *@brief 用户通过购物车确认订单
 *@param  cartIds 购物车ID逗号隔开
 */
- (void)person_CommitRequestGoodswithcartIds:(NSString *)cartIds
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;
#pragma mark -批量添加商品收藏
/*!
 *@brief  批量添加商品收藏
 *@param  objectIds 添加收藏，逗号隔开
 */
- (void)person_CollectionGoodswithobjectIds:(NSString *)objectIds
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;
#pragma mark -获取默认地址
- (void)person_GetDefautAddresssuccess:(DCSuccessBlock)success
                              failture:(DCFailtureBlock)failture;
#pragma mark -分类商品列表
/*!
 *@brief  分类商品列表
 *@param  catId 分类ID
 *@param  brandId 品牌ID
 *@param  brandName 品牌名字
 *@param  currentPage 当前分页页码（默认为1
 *@param  descFlag 价格排序 排序方式:1.由高到低；2.由低到高。（默认由高到低）
 *@param  dosageForm 剂型
 *@param  goodsIds 刷选的goodsIDs
 *@param  goodsTitle 商品名
 *@param  manufactory 生产单位
 *@param  orderFlag 排序类型：sellPrice.价格排序；totalSales.销量排序；evalNum.评价数排序（默认是销量排序，由高到低）
 *@param  searchName 输入框输入的字符:通用名，商品名，症状
 *@param  symptom 症状
 *@param  useMethod 使用方法
 *@param  usePerson 使用人群
 *  *@param  goodsTagNameList 分类名称
 */
- (void)person_getClassGoodsListywithcatId:(NSString *)catId
                                   brandId:(NSString *)brandId
                          goodsTagNameList:(NSString *)goodsTagNameList
                                 brandName:(NSString *)brandName
                               currentPage:(NSString *)currentPage
                                  descFlag:(NSString *)descFlag
                                dosageForm:(NSString *)dosageForm
                                  goodsIds:(NSString *)goodsIds
                                goodsTitle:(NSString *)goodsTitle
                               manufactory:(NSString *)manufactory
                                 orderFlag:(NSString *)orderFlag
                                searchName:(NSString *)searchName
                                   symptom:(NSString *)symptom
                                 useMethod:(NSString *)useMethod
                                 usePerson:(NSString *)usePerson
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;
#pragma mark -确认需求清单（从购物车进入）
/*!
 *@brief  确认需求清单
 *@param  entrance 下单页面入口:2-需求清单；4-处方药立即购买(暂定)
 *@param  addrId 收货地址id，必填
 *@param  cartIds 购物车进入时的购物车id(逗号隔开)
 *@param  leaveMsg 订单备注
 *@param  prescriptionImg 处方单图片地址(逗号隔开)
 */
- (void)person_comfirRequestwithentrance:(NSString *)entrance
                                  addrId:(NSString *)addrId
                                 cartIds:(NSString *)cartIds
                                leaveMsg:(NSString *)leaveMsg
                         prescriptionImg:(NSString *)prescriptionImg
                                 success:(DCSuccessBlock)success
                                failture:(DCFailtureBlock)failture;
#pragma mark 领券中心-店铺券
/*!
 *@brief  领券中心-店铺券
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_CouponCenterStorewithcurrentPage:(NSString *)currentPage
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;
#pragma mark 领券中心-平台券
/*!
 *@brief  领券中心-平台券
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_CouponCenterPlatformwithcurrentPage:(NSString *)currentPage
                                           success:(DCSuccessBlock)success
                                          failture:(DCFailtureBlock)failture;
#pragma mark 领券中心-商品券
/*!
 *@brief  领券中心-商品券
 *@param  currentPage 当前分页页码（默认为1）
 */
- (void)person_CouponCenterGoodswithcurrentPage:(NSString *)currentPage
                                        success:(DCSuccessBlock)success
                                       failture:(DCFailtureBlock)failture;
#pragma mark 帮助中心
/*!
 *@brief  帮助中心
 *@param  helpId 帮助IdhelpId=87：服务条款；helpId=90：订单状态说明（商品验收说明）；helpId=74：商品退换货政策；
 */
- (void)person_HelpCenterwithhelpId:(NSString *)helpId
                            success:(DCSuccessBlock)success
                           failture:(DCFailtureBlock)failture;
#pragma mark 注册协议
/*!
 *@brief  注册协议
 */
- (void)person_RegisterProtocolsuccess:(DCSuccessBlock)success failture:(DCFailtureBlock)failture;
#pragma mark -意见反馈
/*!
 *@brief  意见反馈
 *@param  cellPhone 手机号
 *@param  content 内容
 *@param  imgs 图片列表，多图片用逗号隔开
 */
- (void)person_feedbackwithcellPhone:(NSString *)cellPhone
                             content:(NSString *)content
                                imgs:(NSString *)imgs
                             success:(DCSuccessBlock)success
                            failture:(DCFailtureBlock)failture;
#pragma mark 意见反馈基础信息
/*!
 *@brief  意见反馈基础信息
 */
- (void)person_getFeedBackInfosuccess:(DCSuccessBlock)success failture:(DCFailtureBlock)failture;
#pragma mark -直接购买
/*!
 *@brief  直接购买
 *@param  goodsId 商品ID
 *@param  quantity 数量
 */
- (void)person_buywithgoodsId:(NSString *)goodsId
                      batchId:(NSString *)batchId
                     quantity:(NSString *)quantity
                      success:(DCSuccessBlock)success
                     failture:(DCFailtureBlock)failture;
#pragma mark -根据收货地址和运费
/*!
 *@brief  根据收货地址和运费
 *@param  goodsId 商品ID
 *@param  quantity 数量
 *  *@param  areaId 区域id
 *    *@param  logisticsTplId 运费模板ID
 */
- (void)person_getAddressMoenywithgoodsId:(NSString *)goodsId
                                 quantity:(NSString *)quantity
                                   areaId:(NSString *)areaId
                           logisticsTplId:(NSString *)logisticsTplId
                                  success:(DCSuccessBlock)success
                                 failture:(DCFailtureBlock)failture;
#pragma mark -加入需求清单
/*!
 *@brief  加入需求清单
 *@param  goodsId 商品ID
 *@param  quantity 数量
 */
- (void)person_jionRequestwithgoodsId:(NSString *)goodsId
                             quantity:(NSString *)quantity
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;
#pragma mark -立即提交需求清单
/*!
 *@brief  立即提交需求清单
 *@param  goodsId 商品ID
 *@param  quantity 数量
 */
- (void)person_detailCommitRequestwithgoodsId:(NSString *)goodsId
                                     quantity:(NSString *)quantity
                                      success:(DCSuccessBlock)success
                                     failture:(DCFailtureBlock)failture;
#pragma mark -获取当前店铺的楼层商品列表
/*!
 *@brief  获取当前店铺的楼层商品列表
 *@param  catId 分类ID
 *@param  currentPage 页数
 *  *@param  firmId 企业ID
 */
- (void)person_getFoolsGoodswithcatId:(NSString *)catId
                          currentPage:(NSString *)currentPage
                               firmId:(NSString *)firmId
                              success:(DCSuccessBlock)success
                             failture:(DCFailtureBlock)failture;
#pragma mark -获取订单数
/*!
 *@brief  获取订单数
 */
- (void)person_getorderNumsuccess:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;
#pragma mark -确认需求清单（从商品详情进入）
/*!
 *@brief  立即提交需求清单
 *@param  goodsId 商品ID
 *@param  quantity 数量
 *@param  addrId 地址ID
 *@param  leaveMsg 备注
 *@param  prescriptionImg 图片
 */
- (void)person_detailComfireRequestwithgoodsId:(NSString *)goodsId
                                      quantity:(NSString *)quantity
                                        addrId:(NSString *)addrId
                                      leaveMsg:(NSString *)leaveMsg
                               prescriptionImg:(NSString *)prescriptionImg
                                       success:(DCSuccessBlock)success
                                      failture:(DCFailtureBlock)failture;
#pragma mark -确认订单单（从商品详情进入）
/*!
 *@brief  立即提交需求清单
 *@param  goodsId 商品ID
 *@param  quantity 数量
 *@param  addrId 地址ID
 *@param  leaveMsg 优惠券
 *@param  coupons 图片
 *  *@param  logisticsAmount 物流金额
 *  *@param  transId 配送方式：1-快递；2-EMS；3-平邮
 */
- (void)person_detailComfireOrderwithgoodsId:(NSString *)goodsId
                                    quantity:(NSString *)quantity
                                      addrId:(NSString *)addrId
                                    leaveMsg:(NSString *)leaveMsg
                             logisticsAmount:(NSString *)logisticsAmount
                                     transId:(NSString *)transId
                                     coupons:(NSDictionary *)coupons
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;



- (void)person_xiaohuWithNewPhone:(NSString *)newPhone
                        validInfo:(NSString *)validInfo
                          success:(DCSuccessBlock)success
                         failture:(DCFailtureBlock)failture;

#pragma mark -获取用药人以及产品对应的疾病症状
/*!
 *@param  传入产品id同时获取用药人列表以及对应产品的疾病症状列表，
 注：传入的产品Id用英文逗号隔开
 */
- (void)person_b2c_trade_userSymptomsWithGoodsId:(NSString *)goodsId
                                         success:(DCSuccessBlock)success
                                        failture:(DCFailtureBlock)failture;

#pragma mark -新增用药人
/*!
 *@param  birthTime 患者出生时间；chiefComplaint 病情描述（主诉）；drugId 患者ID；historyAllergic 过敏史；historyIllness 既往史（家族病史）；idCard 患者身份证号；isDefault 是否默认用药人：1.是，2.否；isHistoryAllergic 是否有过敏史：1.是，2.否；isHistoryIllness 是否有既往史（家族病史）：1.是，2.否；isNowIllness 是否有现病史（过往病史)：1.是，2.否；lactationFlag 是否是备孕/怀孕/哺乳期：1.是，2.否；liverUnusual  肝功能是否异常：1.是，2.否；nowIllness 现病史（过往病史）；patientAge 患者年龄；patientGender 患者性别：1-男， 2-女 ；patientName 患者姓名；patientTel 患者手机号；relation 1.本人，2.家属，3.亲戚，4.朋友；renalUnusual  肾功能是否异常：1.是，2.否；
 */
- (void)person_b2c_druguser_addWithParamDic:(NSDictionary *)paramDic
                                    success:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;

#pragma mark -用药人明细
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_detailWithDrugId:(NSString *)drugId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;

#pragma mark -修改用药人
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_editWithParamDic:(NSDictionary *)paramDic
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;

#pragma mark -用药人列表
- (void)person_b2c_druguser_listWithSuccess:(DCSuccessBlock)success
                                   failture:(DCFailtureBlock)failture;

#pragma mark -用药人列表
/*!
 *@param  用药人ID
 */
- (void)person_b2c_druguser_removeWithDrugId:(NSString *)drugId
                                     success:(DCSuccessBlock)success
                                    failture:(DCFailtureBlock)failture;

#pragma mark -【活动专区（促销）】
- (void)person_b2c_activityWithCurrentPage:(NSString *)currentPage
                                   success:(DCSuccessBlock)success
                                  failture:(DCFailtureBlock)failture;


@end

NS_ASSUME_NONNULL_END
