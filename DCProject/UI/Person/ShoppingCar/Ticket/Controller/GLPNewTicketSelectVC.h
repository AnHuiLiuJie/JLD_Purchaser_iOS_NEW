//
//  GLPNewTicketSelectVC.h
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "DCBasicViewController.h"
#import "GLPMainTicketCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPNewTicketSelectVC : DCBasicViewController

// 已选中的券
@property (nonatomic, strong) NSMutableArray *selectTicketArray;

// 模型
@property (nonatomic, strong) GLPFirmListModel *firmModel;

@property(nonatomic,copy) NSString *ispay;//1:直接购买 其他：购物车
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *quanlity;

// 券点击
@property (nonatomic, copy) void(^GLPNewTicketSelectVC_block)(NSArray *ticketArray);

@end

NS_ASSUME_NONNULL_END
