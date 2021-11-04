//
//  GLPEvaluationModel.h
//  DCProject
//
//  Created by LiuMac on 2021/10/22.
//

#import "DCBaseModel.h"
@class GLPGoodsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLPEvaluationModel : DCBaseModel


@end


#pragma mark - 评价页面入口
@interface GLPOrderEvalModel : DCBaseModel


@property (nonatomic, copy) NSString *modifyTime;//修改时间
@property (nonatomic, strong) GLPGoodsListModel *orderGoodsList;//订单商品列表
@property (nonatomic, copy) NSString *orderNo;//订单编号
@property (nonatomic, copy) NSString *sellerFirmId;//卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmImg;//卖家企业Logo
@property (nonatomic, copy) NSString *sellerFirmName;//卖家企业名称


@end

#pragma mark - 订单商品列表
@interface GLPGoodsListModel : DCBaseModel


@property (nonatomic, copy) NSString *applyState;//申请状态：1-买家申请退款；2-卖家同意退款；3-卖家不同意退款（等待运营商仲裁）；4-运营商已受理，处理中；5-运营商处理完成
@property (nonatomic, copy) NSString *batchId;//批次ID：货号ID
@property (nonatomic, copy) NSString *brandName;//品牌名称
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *orderGoodsId;//订单商品ID
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *quantity;//数量
@property (nonatomic, copy) NSString *returnType;//退货退款类别：1-退货退款；2-仅退款
@property (nonatomic, copy) NSString *sellPrice;//商城销售单价：单位元

@end


#pragma mark - 我的评价列表
@interface GLPMyEvalListModel : DCBaseModel


@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *evalContent;//评论内容
@property (nonatomic, copy) NSString *evalId;//评价ID
@property (nonatomic, copy) NSString *evalImgs;//评论图片
@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *goodsImg;//商品图片
@property (nonatomic, copy) NSString *goodsTitle;//商品标题
@property (nonatomic, copy) NSString *packingSpec;//包装规格
@property (nonatomic, copy) NSString *quantity;//数量
@property (nonatomic, copy) NSString *sellPrice;//商城销售单价：单位元
@property (nonatomic, copy) NSString *sellerFirmId;//卖家企业ID
@property (nonatomic, copy) NSString *sellerFirmImg;//卖家企业Logo
@property (nonatomic, copy) NSString *sellerFirmName;//卖家企业名称
@property (nonatomic, copy) NSString *star;//星级：1-1星；2-2星；3-3星；4-4星；5-5星


@end

#pragma mark - 获取评论列表
@interface GLPEvalListModel : DCBaseModel


@property (nonatomic, copy) NSString *buyerId;//买家ID
@property (nonatomic, copy) NSString *buyerLoginName;//买家登录名称
@property (nonatomic, copy) NSString *buyerNickname;//买家昵称：匿名评价时，昵称中用*号
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *evalContent;//评论内容
@property (nonatomic, copy) NSString *evalId;//评价ID
@property (nonatomic, copy) NSString *evalImgs;//评论图片
@property (nonatomic, copy) NSString *userImg;//买家头像
@property (nonatomic, copy) NSString *star;//星级：1-1星；2-2星；3-3星；4-4星；5-5星


@end

NS_ASSUME_NONNULL_END
