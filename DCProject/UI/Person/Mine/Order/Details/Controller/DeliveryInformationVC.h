//
//  DeliveryInformationVC.h
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import "DCBasicViewController.h"
#import "DeliveryInformationCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryInformationVC : DCBasicViewController


@property (nonatomic, strong) DeliveryListModel *listModel;//如果有值不需要请求
@property (nonatomic, copy) NSString *orderNoStr;
@end

NS_ASSUME_NONNULL_END
