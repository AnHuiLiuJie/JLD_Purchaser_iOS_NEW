//
//  OrderListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *bottomArr;


@property (weak, nonatomic) IBOutlet UIImageView *storeImageV;
@property (weak, nonatomic) IBOutlet UIButton *storeNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *statuLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn1;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn2;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn3;
@property (weak, nonatomic) IBOutlet UILabel *storeNmaeLab;
@property (nonatomic,copy) NSString *sellerFirmId;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *couponArray;

@property (weak, nonatomic) IBOutlet UIImageView *rpStateImg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (void)changeBottomView:(NSArray *)array;

@property (nonatomic, strong) OrderListModel *model;
@property (nonatomic, strong) ReturnOrderListModel *returnModel;

@property (nonatomic, copy) void(^OrderListCell_block)(NSString *title,OrderListModel *clickModel);
@property (nonatomic, copy) void(^OrderListCell_Block)(NSString *title,ReturnOrderListModel *clickModel);

@property (nonatomic, assign) BOOL isRefund;//YES 退款/售后  NO我的订单

@end

NS_ASSUME_NONNULL_END
