/************************************************************
 * *Hyphenate CONFIDENTIAL
 *__________________
 *Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 *NOTICE: All information contained herein is, and remains
 *the property of Hyphenate Inc.
 *Dissemination of this information or reproduction of this material
 *is strictly forbidden unless prior written permission is obtained
 *from Hyphenate Inc.
 */

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"
#import "HDMessageViewController.h"

@interface HDChatViewController : HDMessageViewController <HDMessageViewControllerDelegate, HDMessageViewControllerDataSource>

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;


//- (void)reloadDingCellWithAckMessageId:(NSString *)aMessageId;


#pragma mark -
@property (nonatomic, strong) DCChatGoodsModel *goodsModel; // 模型
@property (strong, nonatomic) NSDictionary *commodityInfo; //商品信息

@property (nonatomic, copy) NSString *sellerFirmName; // 店铺名称

@property (nonatomic, copy) NSString *frimId; //企业ID 判断药师用的


@end
