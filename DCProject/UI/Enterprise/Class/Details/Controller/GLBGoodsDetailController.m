//
//  GLBGoodsDetailController.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsDetailController.h"
#import "GLBGoodsDetailHeadView.h"
#import "GLBGoodsTitleCell.h"
#import "GLBGoodsTicketCell.h"
#import "GLBGoodsInfoCell.h"
#import "GLBGoodsShopCell.h"
#import "GLBGoodsSendCell.h"
#import "GLBGoodsRecordCell.h"
#import "GLBGoodsRecommendCell.h"

#import "GLBGoodsDetailBottomView.h"
#import "GLBGoodsDetailNavigationBar.h"
#import "GLBFuncView.h"

#import "GLBTicketSelectController.h"
#import "GLBRecordListController.h"
#import "GLBAddShoppingCarController.h"
#import "GLBStorePageController.h"
#import "GLBSearchPageController.h"
#import "GLBShoppingCarController.h"
#import "DCTabbarController.h"
#import "DCLoginController.h"
#import "DCNavigationController.h"
#import "CSDemoAccountManager.h"//lj_will_change

static NSString *titleCellID = @"GLBGoodsTitleCell";
static NSString *ticketCellID = @"GLBGoodsTicketCell";
static NSString *infoCellID = @"GLBGoodsInfoCell";
static NSString *shopCellID = @"GLBGoodsShopCell";
static NSString *sendCellID = @"GLBGoodsSendCell";
static NSString *recordCellID = @"GLBGoodsRecordCell";
static NSString *recommendCellID = @"GLBGoodsRecommendCell";

@interface GLBGoodsDetailController ()

@property (nonatomic, strong) GLBGoodsDetailNavigationBar *navBar;
@property (nonatomic, strong) GLBGoodsDetailHeadView *headView;
@property (nonatomic, strong) GLBGoodsDetailBottomView *bottomView;
@property (nonatomic, strong) GLBFuncView *funcView;

@property (nonatomic, strong) GLBGoodsDetailModel *detailModel; // 商品详情
@property (nonatomic, strong) GLBYcjModel *ycjModel; // 药采集模型
@property (nonatomic, strong) NSMutableArray<GLBGoodsDetailGoodsModel *> *similarArray; // 购买此商品的用户还购买
@property (nonatomic, strong) NSMutableArray<GLBGoodsDetailGoodsModel *> *recommendArray; // 推荐商品

// 券模型
@property (nonatomic, strong) GLBGoodsDetailTicketModel *ticketModel;

@end

@implementation GLBGoodsDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
    
    [self requestShoppingCarGoodsCount];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.goodsId = @"CM21190826102542611007";
    
    [self setUpTableView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.navBar];

    [self dc_requestValue];
}


#pragma mark - 请求数据
- (void)dc_requestValue
{
    if (_goodsId) {
        [self requestDetail];
        
        if (_detailType == GLBGoodsDetailTypeYjc) {
            [self requestDrugcjInfo];
        }
    }
    
    [self requestShoppingCarGoodsCount];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 4;
    if (self.detailModel && self.detailModel.deliveryExplain.length > 0) {
        count ++;
    }
    if (self.detailModel && self.detailModel.orderList && [self.detailModel.orderList count] > 0) {
        count ++;
    }
    if (self.similarArray.count > 0) {
        count ++;
    }
    if (self.recommendArray.count > 0) {
        count ++;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        GLBGoodsTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellID forIndexPath:indexPath];
        titleCell.detailType = self.detailType;
        titleCell.loginBlock = ^{
            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
                [weakSelf dc_requestValue];
                [weakSelf dc_postNotification];
            }];
//        [self gotologin];
        };
        if (self.detailModel) {
            titleCell.detailModel = self.detailModel;
        }
        if (self.ycjModel) {
            titleCell.ycjModel = self.ycjModel;
        }
        if (self.promoteModel) {
            titleCell.promoteModel = self.promoteModel;
        }
        cell = titleCell;
        
    } else if (indexPath.section == 1) {
        
        GLBGoodsTicketCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:ticketCellID forIndexPath:indexPath];
        if (self.detailModel) {
            ticketCell.detailModel = self.detailModel;
        }
        ticketCell.ticketCellBlock = ^(NSInteger tag) {
            [weakSelf presentTicketSelectController:tag];
        };
        cell = ticketCell;
        
    } else if (indexPath.section == 2) {
        
        GLBGoodsInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID forIndexPath:indexPath];
        infoCell.detailBtnClick = ^{
            NSString *params = [NSString stringWithFormat:@"id=%@",weakSelf.detailModel.goodsId];
            [weakSelf dc_pushWebController:@"/qiye/goods_detail.html" params:params];
        };
        if (self.detailModel) {
            infoCell.detailModel = self.detailModel;
        }
        cell = infoCell;
        
    } else if (indexPath.section == 3) {
        
        GLBGoodsShopCell *shopCell = [tableView dequeueReusableCellWithIdentifier:shopCellID forIndexPath:indexPath];
        if (self.detailModel) {
            shopCell.detailModel = self.detailModel;
        }
        shopCell.openStoreBlock = ^{
            [weakSelf pushStorePageController];
        };
        cell = shopCell;
        
    } else if (self.detailModel && self.detailModel.deliveryExplain.length > 0 && indexPath.section == 4) {
        
        GLBGoodsSendCell *sendCell = [tableView dequeueReusableCellWithIdentifier:sendCellID forIndexPath:indexPath];
        if (self.detailModel) {
            sendCell.detailModel = self.detailModel;
        }
        cell = sendCell;
        
    } else if (self.detailModel && [self.detailModel.orderList count] > 0 && ((self.detailModel.deliveryExplain.length > 0 && indexPath.section == 5) || ((self.detailModel.deliveryExplain.length == 0 && indexPath.section == 4)))) {
        
        GLBGoodsRecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:recordCellID forIndexPath:indexPath];
        if (self.detailModel) {
            recordCell.detailModel = self.detailModel;
        }
        recordCell.recordCellBlock = ^{
            [weakSelf pushRecordListController];
        };
        cell = recordCell;
        
    } else if (self.similarArray.count > 0 && ((!self.detailModel && indexPath.section == 4) || (self.detailModel && ((self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count == 0 && indexPath.section == 4) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count == 0 && indexPath.section == 5) || ((self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count > 0 && indexPath.section == 5) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count > 0 && indexPath.section == 6)))))) {
        
        GLBGoodsRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendCellID forIndexPath:indexPath];
        recommendCell.similarArray = self.similarArray;
        recommendCell.recommendCellBlock = ^(GLBGoodsDetailGoodsModel *goodsModel) {
            [weakSelf pushGoodsDetailController:goodsModel.goodsId];
        };
        cell = recommendCell;
        
    } else if (self.recommendArray.count > 0 && ((!self.detailModel && self.similarArray.count == 0 && indexPath.section == 4) || (!self.detailModel && self.similarArray.count > 0 && indexPath.section == 5) || (self.detailModel && ((self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count == 0 && self.similarArray.count == 0 && indexPath.section == 4) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count == 0 && self.similarArray.count == 0 && indexPath.section == 5) || (self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count > 0 && self.similarArray.count == 0 && indexPath.section == 5) || (self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count == 0 && self.similarArray.count > 0 && indexPath.section == 5) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count > 0 && self.similarArray.count == 0 && indexPath.section == 6) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count == 0 && self.similarArray.count > 0 && indexPath.section == 6) || (self.detailModel.deliveryExplain.length == 0 && self.detailModel.orderList.count > 0 && self.similarArray.count > 0 && indexPath.section == 6) || (self.detailModel.deliveryExplain.length > 0 && self.detailModel.orderList.count > 0 && self.similarArray.count > 0 && indexPath.section == 7)) ) )) {
        
        GLBGoodsRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendCellID forIndexPath:indexPath];
        recommendCell.recommendArray = self.recommendArray;
        recommendCell.recommendCellBlock = ^(GLBGoodsDetailGoodsModel *goodsModel) {
            [weakSelf pushGoodsDetailController:goodsModel.goodsId];
        };
        cell = recommendCell;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 && self.detailModel && [self.detailModel.goodsTicketArray count] == 0 && [self.detailModel.storeTicketArray count] == 0) {
        return 0.1f;
    }
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 页面跳转
- (void)pushRecordListController
{
    if (self.detailModel == nil) {
        return;
    }
    
    GLBRecordListController *vc = [GLBRecordListController new];
    vc.detailModel = self.detailModel;
    [self dc_pushNextController:vc];
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < -20){
        self.navBar.hidden = YES;
    }else{
        self.navBar.hidden = NO;
        
        if (20 < y < kNavBarHeight) {
            self.navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:(y - 20)/kNavBarHeight];
        }
    }
}



#pragma mark - action
- (void)dc_funcViewBtnClick:(NSInteger)tag
{
    if (tag == 600) {  // 首页
        DC_KeyWindow.rootViewController = [[DCTabbarController alloc] init];
    } else if (tag == 601) {  // 搜索
        [self dc_pushNextController:[GLBSearchPageController new]];
    }
}


- (void)dc_bottomViewBtnClick:(NSInteger)tag
{
    WEAKSELF;
    
    if (tag == 500) { //客服
        
//        if (![[DCLoginTool shareTool] dc_isLogin]) {
//            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
//                [weakSelf dc_requestValue];
//                [weakSelf dc_postNotification];
//            }];
//            return;
//        }
//        
//        if (!self.detailModel) {
//            return;
//        }
//
//        NSString *userID = @"";
//        NSString *title = @"客服";
//        NSString *headImg = @"";
//        if (self.detailModel) {
//            title = self.detailModel.suppierFirmName;
//            userID = [NSString stringWithFormat:@"b2b_%@",self.detailModel.suppierUserId];
//            headImg = self.detailModel.storeInfo.logoImg;
//            
//            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [userDic setValue:userID forKey:@"userId"];
//            [userDic setValue:title forKey:@"nickname"];
//            [userDic setValue:headImg forKey:@"headImg"];
//            [[DCUpdateTool shareClient]updateEaseUser:userDic];
//            
//            DCChatGoodsModel *model = [DCChatGoodsModel new];
//            model.goodsName = self.detailModel.goodsName;
//            model.goodsId = self.detailModel.goodsId;
//            model.type = @"1";
//            if (self.detailModel.sellType == 2) { // 整件销售
//                model.price = [NSString stringWithFormat:@"%@",self.detailModel.wholePrice];
//            } else {
//                model.price = [NSString stringWithFormat:@"%@",self.detailModel.zeroPrice];
//            }
//            model.sendType = @"2";
//            if (self.detailModel.picUrl && [self.detailModel.picUrl count] > 0) {
//                model.goodsImage = self.detailModel.picUrl[0];
//            }
//            
//            //lj_will_change_end
//            WEAKSELF;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
//                if ([lgM loginKefuSDK]) {
//                    NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
//                    NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
//                    NSString *chatTitle = @"";
//                    HDQueueIdentityInfo *queueIdentityInfo = nil;
//                    HDAgentIdentityInfo *agentIdentityInfo = nil;
//                    queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
//                    agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
//                    chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
//                    hd_dispatch_main_async_safe(^(){
//                        [weakSelf hideHud];
//                        HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
//                        queue ? (chat.queueInfo = queueIdentityInfo) : nil;
//                        agent ? (chat.agent = agentIdentityInfo) : nil;
//                        chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
//                        [self.navigationController pushViewController:chat animated:YES];
//                    });
//                   
//                } else {
//                    hd_dispatch_main_async_safe(^(){
//                        [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
//                    });
//                    NSLog(@"登录失败");
//                }
//            });//完整
//            
//            
//            //lj_will_change
////            HDChatViewController *chatController = [[HDChatViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
////            chatController.title = title;
////            chatController.goodsModel = model;
////            chatController.sellerFirmName = self.detailModel.suppierFirmName;
////            [self.navigationController pushViewController:chatController animated:YES];
//        }
    } else if (tag == 501) { // 收藏
        
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
                [weakSelf dc_requestValue];
                [weakSelf dc_postNotification];
            }];
//             [self gotologin];
            return;
        }
        
        if (self.detailModel && self.detailModel.isCollected) {
            [self requestCancelCollectGoods];
        } else {
            [self requestAddCollectGoods];
        }
        
    } else if (tag == 502) { // 购物车
        
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
                [weakSelf dc_requestValue];
                [weakSelf dc_postNotification];
            }];
//             [self gotologin];
            return;
        }
        [self dc_pushNextController:[GLBShoppingCarController new]];
        
    } else if (tag == 503) { //加入购物车
        
        if (![[DCLoginTool shareTool] dc_isLogin]) {
            [[DCLoginTool shareTool] dc_pushLoginControllerSuccessBlock:^{
                [weakSelf dc_requestValue];
                [weakSelf dc_postNotification];
            }];
//            [self gotologin];
            return;
        }
        [self presentAddShoppingCarController];
    }
}

- (void)gotologin
{
    // 清除本地字段
           [[DCLoginTool shareTool] dc_removeLoginDataWithCompany];

           DCLoginController *vc = [DCLoginController new];
                            vc.isPresent = YES;
                            vc.modalPresentationStyle =UIModalPresentationFullScreen;
                            DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
           [self presentViewController:nav animated:YES completion:^{
                    [self dc_requestValue];
                   [self dc_postNotification];
                         }];
}

#pragma mark -
- (void)presentTicketSelectController:(NSInteger)tag
{
    GLBTicketSelectController *vc = [GLBTicketSelectController new];
    if (tag == 400) {
        
        vc.ticketType = GLBTicketTypeGoods;
        vc.goodsId = self.detailModel.goodsId;
        
    } else if (tag == 401) {
        
        vc.ticketType = GLBTicketTypeStore;
        vc.storeId = self.detailModel.suppierFirmId;
        
    } else if (tag == 402) {
        
        vc.ticketType = GLBTicketTypeComment;

    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [DC_KeyWindow.rootViewController addChildViewController:vc];
    [DC_KeyWindow.rootViewController.view addSubview:vc.view];
    
//    [DC_KeyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 跳转 弹框
- (void)presentAddShoppingCarController
{
    if (self.detailModel) {
        WEAKSELF;
        GLBAddShoppingCarController *vc = [GLBAddShoppingCarController new];
        vc.detailModel = self.detailModel;
        vc.successBlock = ^{
            [weakSelf requestShoppingCarGoodsCount];
        };
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [DC_KeyWindow.rootViewController addChildViewController:vc];
        [DC_KeyWindow.rootViewController.view addSubview:vc.view];
        
//        [DC_KeyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}


- (void)pushGoodsDetailController:(NSString *)goodsId
{
    GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
    vc.goodsId = goodsId;
    vc.detailType = GLBGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


- (void)pushStorePageController
{
    if (self.detailModel && self.detailModel.storeInfo) {
        GLBStorePageController *vc = [GLBStorePageController new];
        vc.firmId = self.detailModel.storeInfo.firmId;
        [self dc_pushNextController:vc];
    }
}


#pragma mark - 发送登录成功通知
- (void)dc_postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DC_LoginSucess_Notification object:nil];
}


#pragma mark - 请求 商品详情
- (void)requestDetail
{
    self.detailModel = nil;
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGoodsDetailWithGoodsId:_goodsId batchId:_batchId success:^(id response) {
        if (response && [response isKindOfClass:[GLBGoodsDetailModel class]]) {
            weakSelf.detailModel = response;
            weakSelf.detailModel.goodsId = weakSelf.goodsId;
            
            weakSelf.headView.detailModel = weakSelf.detailModel;
            [weakSelf.recommendArray removeAllObjects];
            [weakSelf.recommendArray addObjectsFromArray:weakSelf.detailModel.recommendGoods];
            
            [weakSelf.similarArray removeAllObjects];
            [weakSelf.similarArray addObjectsFromArray:weakSelf.detailModel.similarGoods];
            
//            [weakSelf requestGoodsTicket];
//            [weakSelf requestStoreTicket];
            [weakSelf requestTicketInfo];
            [weakSelf requestGoodsCollectStatus];
            [weakSelf.tableView reloadData];
            
        } else {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 请求 各种类型券
- (void)requestTicketInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestGoodsDetailTicketWithFirmId:self.detailModel.suppierFirmId goodsId:self.detailModel.goodsId success:^(id response) {
        if (response && [response isKindOfClass:[GLBGoodsDetailTicketModel class]]) {
            weakSelf.ticketModel = response;
            
            if (weakSelf.ticketModel.goods && weakSelf.ticketModel.goods.cashCouponId > 0) {
                 weakSelf.detailModel.goodsTicketArray = @[weakSelf.ticketModel.goods];
            }
            if (weakSelf.ticketModel.store && weakSelf.ticketModel.store.cashCouponId > 0) {
                weakSelf.detailModel.storeTicketArray = @[weakSelf.ticketModel.store];
            }
            if (weakSelf.ticketModel.platform) {
                weakSelf.detailModel.commonTicketArray = @[weakSelf.ticketModel.platform];
            }
            [weakSelf.tableView reloadData];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


//#pragma mark - 请求 商品专享券
//- (void)requestGoodsTicket
//{
//    if (!self.detailModel) {
//        return;
//    }
//    WEAKSELF;
//    [[DCAPIManager shareManager] dc_requestGoodsTicketWithGoodsId:self.detailModel.goodsId success:^(id response) {
//        if (response && [response count] > 0) {
//            weakSelf.detailModel.goodsTicketArray = response;
//            [weakSelf.tableView reloadData];
//        }
//    } failture:^(NSError *_Nullable error) {
//    }];
//}
//
//#pragma mark - 请求 店铺券
//- (void)requestStoreTicket
//{
//    if (!self.detailModel) {
//        return;
//    }
//    WEAKSELF;
//    [[DCAPIManager shareManager] dc_requestStoreTicketWithFirmId:self.detailModel.suppierFirmId success:^(id response) {
//        if (response && [response count] > 0) {
//            weakSelf.detailModel.storeTicketArray = response;
//            [weakSelf.tableView reloadData];
//        }
//    } failture:^(NSError *_Nullable error) {
//    }];
//}
//
//#pragma mark - 请求 平台券
//- (void)requestParmformTicket
//{
//    if (!self.detailModel) {
//        return;
//    }
////    WEAKSELF;
////    [[DCAPIManager shareManager] dc_requestStoreTicketWithFirmId:self.detailModel.suppierFirmId success:^(id response) {
////        if (response && [response count] > 0) {
////            weakSelf.detailModel.storeTicketArray = response;
////            [weakSelf.tableView reloadData];
////        }
////    } failture:^(NSError *_Nullable error) {
//    }];
//}



#pragma mark - 请求 商品收藏状态
- (void)requestGoodsCollectStatus
{
    if (!self.detailModel) {
        return;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCollectStatusWithInfoId:self.detailModel.goodsId success:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"] && [response[@"data"] isKindOfClass:[NSString class]] && [response[@"data"] isEqualToString:@"2"]) { // 已收藏
                weakSelf.detailModel.isCollected = YES;
                weakSelf.bottomView.detailModel = weakSelf.detailModel;
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 添加收藏
- (void)requestAddCollectGoods
{
    if (!self.detailModel) {
        return;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddCollectWithInfoId:self.detailModel.goodsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            weakSelf.detailModel.isCollected = YES;
            weakSelf.bottomView.detailModel = weakSelf.detailModel;
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 删除收藏
- (void)requestCancelCollectGoods
{
    if (!self.detailModel) {
        return;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCancelCollectWithInfoId:self.detailModel.goodsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            weakSelf.detailModel.isCollected = NO;
            weakSelf.bottomView.detailModel = weakSelf.detailModel;
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 要采集信息
- (void)requestDrugcjInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestDrugjcInfoWithGoodsId:_goodsId success:^(id response) {
        if (response && [response isKindOfClass:[GLBYcjModel class]]) {
            weakSelf.ycjModel = response;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 购物车商品数量
- (void)requestShoppingCarGoodsCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestShoppingCarGoodsCountWithSuccess:^(id response) {
        if (response) {
            weakSelf.bottomView.count = [response integerValue];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - UI
- (void)setUpTableView
{
    CGFloat height = kStatusBarHeight > 20 ? 75 : 45;
    
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH - height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 1.0f;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.sectionFooterHeight = 5.00f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView registerClass:NSClassFromString(titleCellID) forCellReuseIdentifier:titleCellID];
    [self.tableView registerClass:NSClassFromString(ticketCellID) forCellReuseIdentifier:ticketCellID];
    [self.tableView registerClass:NSClassFromString(infoCellID) forCellReuseIdentifier:infoCellID];
    [self.tableView registerClass:NSClassFromString(shopCellID) forCellReuseIdentifier:shopCellID];
    [self.tableView registerClass:NSClassFromString(sendCellID) forCellReuseIdentifier:sendCellID];
    [self.tableView registerClass:NSClassFromString(recordCellID) forCellReuseIdentifier:recordCellID];
    [self.tableView registerClass:NSClassFromString(recommendCellID) forCellReuseIdentifier:recommendCellID];
}


#pragma mark - lazy load
- (GLBGoodsDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[GLBGoodsDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.6*kScreenW)];
    }
    return _headView;
}

- (GLBGoodsDetailBottomView *)bottomView{
    if (!_bottomView) {
        
        CGFloat height = kStatusBarHeight > 20 ? 75 : 45;
        
        _bottomView = [[GLBGoodsDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - height, kScreenW, height)];
        WEAKSELF;
        _bottomView.bottomViewBlock = ^(NSInteger tag) {
            [weakSelf dc_bottomViewBtnClick:tag];
        };
    }
    return _bottomView;
}

- (GLBGoodsDetailNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBGoodsDetailNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _navBar.backBtnBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navBar.moreBtnBlock = ^{
            if (![DC_KeyWindow.subviews containsObject:weakSelf.funcView]) {
                [DC_KeyWindow addSubview:weakSelf.funcView];
                
                [weakSelf.funcView startAnimation];
                [weakSelf dc_statusBarStyle:UIStatusBarStyleLightContent];
                
                [weakSelf.funcView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(DC_KeyWindow);
                }];
            }
        };
    }
    return _navBar;
}

- (GLBFuncView *)funcView{
    if (!_funcView) {
        _funcView = [[GLBFuncView alloc] init];
        WEAKSELF;
        _funcView.funcViewBlock = ^(NSInteger tag) {
            [weakSelf dc_funcViewBtnClick:tag];
        };
        _funcView.cancelBlock = ^{
            if (@available(iOS 13.0, *)) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
            } else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
        };
    }
    return _funcView;
}


- (NSMutableArray<GLBGoodsDetailGoodsModel *> *)similarArray{
    if (!_similarArray) {
        _similarArray = [NSMutableArray array];
    }
    return _similarArray;
}

- (NSMutableArray<GLBGoodsDetailGoodsModel *> *)recommendArray{
    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

@end
