//
//  ArrivalNoticeViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/7/6.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArrivalNoticeViewController : DCBasicViewController

@property (nonatomic, copy) NSString *goodsId;//商品ID
@property (nonatomic, copy) NSString *serialId;//货号流水ID，非医药商品使用此字段
@property (nonatomic, copy) NSString *price;//商品价格

@end

NS_ASSUME_NONNULL_END
