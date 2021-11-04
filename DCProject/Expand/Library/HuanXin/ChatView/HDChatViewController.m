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

#import "HDChatViewController.h"
#import "AppDelegate+HelpDesk.h"
#import "CSDemoAccountManager.h"
#import "HDLeaveMsgViewController.h"
#import "HFileViewController.h"
#import "HDMessageReadManager.h"

#import "DCChatGoodsTopView.h"
//#import "DCChatGoodsCell.h"
#import "GLPGoodsDetailsController.h"
#import "GLBGoodsDetailController.h"
#import "OrderAdvisoryView.h"
#import "DCExamineImageView.h"
#import <YBImageBrowser/YBImageBrowser.h>
#import "DCAPIManager+PioneerRequest.h"
#import "GLPOrderDetailsViewController.h"
@interface HDChatViewController ()<UIAlertViewDelegate,HDClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    
}

@property (nonatomic) NSMutableDictionary *emotionDic;

@property (nonatomic, strong) DCChatGoodsTopView *goodsTopView;
@property (nonatomic, assign) BOOL isHidde_top;
@property (nonatomic, copy) NSString *certificatePic;

@end

static CGFloat kGoodsTopViewH = 125;

@implementation HDChatViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CSDemoAccountManager shareLoginManager].curChat = self;
    [self dc_navBarLucency:NO];
}

#pragma mark - 设置导航栏是否透明
- (void)dc_navBarLucency:(BOOL)isLucency
{
    UIImage *image = isLucency ? [[UIImage alloc] init] : nil;
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CSDemoAccountManager shareLoginManager].curChat = nil;
    BOOL keyBoard = NO;
    for (UIView* view in self.view.window.subviews)
    {
        keyBoard = keyBoard ? keyBoard : [self dc_dismissAllKeyBoardInView:view];
    }
}

#pragma mark - 关闭window上所有view的键盘
-(BOOL)dc_dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dc_dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.frimId.length > 0) {
        self.title = @"在线药师";
    }
    
//    if (_sellerFirmName.length > 0) {
//        self.title = _sellerFirmName;
//    }

    self.tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#f5f7f7"];
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#f5f7f7"];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[HDClient sharedClient].chatManager bindChatWithConversationId:self.conversation.conversationId];
    [self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];

    [self tableViewDidTriggerHeaderRefresh];
    
    
    [HDClient.sharedClient.leaveMsgManager getWorkStatusWithToUser:self.conversation.conversationId
                                                        completion:^(BOOL isOn, NSError *aError)
    {
        
    }];
    
    if (self.goodsModel && self.goodsModel.orderNo.length == 0) {
        [self.view addSubview:self.goodsTopView];
        self.goodsTopView.goodsModel = self.goodsModel;
        
        [self.goodsTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(kGoodsTopViewH);
        }];
        
        CGFloat tableview_H = self.view.frame.size.height - self.chatToolbar.frame.size.height-LJ_TabbarSafeBottomMargin;
        self.tableView.frame = CGRectMake(0, kGoodsTopViewH, self.view.dc_width, tableview_H  - kGoodsTopViewH);
        self.isHidde_top = YES;
    }else{
        if (self.goodsModel != nil && self.goodsModel.orderNo.length > 0) {
            self.commodityInfo = [self.goodsModel mj_keyValues];
            [self sendCommodityMessageWithInfo:self.commodityInfo];
//            self.goodsModel = nil;
            self.commodityInfo = nil;
        }
    }
}

#pragma mark - HDChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        if (self.isHidde_top) {
            rect.origin.y = kGoodsTopViewH;
            rect.size.height = self.view.frame.size.height - toHeight - LJ_TabbarSafeBottomMargin - kGoodsTopViewH;
        }else{
            rect.origin.y = 0;
            rect.size.height = self.view.frame.size.height - toHeight - LJ_TabbarSafeBottomMargin;
        }
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}


#pragma mark - private helper

- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        if (self.isHidde_top) {
            offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + kGoodsTopViewH);
        }
        [self.tableView setContentOffset:offset animated:animated];
    }
}

// 订单列表
- (void)moreViewOrderListAction:(HDChatBarMoreView *)moreView{
    
    OrderAdvisoryView *view = [[OrderAdvisoryView alloc] initWithFrame:DC_KEYWINDOW.bounds filterModel:self.goodsModel];
    WEAKSELF;
    view.OrderAdvisoryViewBlock = ^(NSDictionary *_Nonnull commodityInfo) {
        weakSelf.commodityInfo = commodityInfo;
        [weakSelf sendCommodityMessageWithInfo:weakSelf.commodityInfo];
        //weakSelf.goodsModel = nil;
        weakSelf.commodityInfo = nil;
    };
    [DC_KEYWINDOW addSubview:view];
}


#pragma mark - set model
- (DCChatGoodsTopView *)goodsTopView{
    if (!_goodsTopView) {
        _goodsTopView = [[DCChatGoodsTopView alloc] init];
        WEAKSELF;
        _goodsTopView.sendBtnBlock = ^{
            if (weakSelf.goodsModel != nil) {
                weakSelf.commodityInfo = [weakSelf.goodsModel mj_keyValues];
                [weakSelf sendCommodityMessageWithInfo:weakSelf.commodityInfo];
                //weakSelf.goodsModel = nil;
                weakSelf.commodityInfo = nil;
            }
        };
        _goodsTopView.cancelBtnBlock = ^{
            weakSelf.isHidde_top = NO;
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.view.dc_width, weakSelf.view.frame.size.height - weakSelf.chatToolbar.frame.size.height-LJ_TabbarSafeBottomMargin);
        };
    }
    return _goodsTopView;
}

- (BOOL)isOrder {
    if (_commodityInfo == nil) {
        return NO;
    }
    NSString *type = [_commodityInfo objectForKey:@"orderNo"];
    BOOL isBool = type.length > 0 ? YES : NO;
    return isBool;
}

- (id)trackOrOrder {
    if (_commodityInfo == nil) {
        return nil;
    }
    NSDictionary *info = _commodityInfo;
    NSString *title = [info objectForKey:@"goodsName"];//title
    NSString *orderTitle = [info objectForKey:@"order_title"];//order_title
    NSString *price = [info objectForKey:@"price"];//price
    NSString *desc = [info objectForKey:@"desc"];//desc
    desc = desc.length == 0 ? title : desc;
    NSString *imageUrl = [info objectForKey:@"goodsImage"];//img_url
    NSString *itemUrl = [info objectForKey:@"item_url"];//[info objectForKey:@"item_url"];//item_url
    if ([self isOrder]) { //发送订单消息
        HDOrderInfo *ord = [HDOrderInfo new];
        ord.title = title;
        ord.orderTitle = orderTitle;
        ord.price = price;
        ord.desc = desc;
        ord.imageUrl = imageUrl;
        ord.itemUrl = itemUrl;
        return ord;
    } else {
        HDVisitorTrack *vst = [HDVisitorTrack new];
        vst.title = title;
        vst.price = price;
        vst.desc = desc;
        vst.imageUrl = imageUrl;
        vst.itemUrl = itemUrl;
        return vst;
    }
    
    return nil;
}


- (void)sendCommodityMessageWithInfo:(NSDictionary *)info
{
    HDMessage *message = [HDSDKHelper textHMessageFormatWithText:@"" to:self.conversation.conversationId];
    if ([self isOrder]) {
        HDOrderInfo *od = (HDOrderInfo *)[self trackOrOrder];
        [message addContent:od];
        
        [message addContent:self.visitorInfo];
        NSString *imageName = [info objectForKey:@"imageName"];
        NSMutableDictionary *ext = [message.ext mutableCopy];
        [ext setValue:imageName forKey:@"imageName"];
        message.ext = [ext copy];
        [self _sendMessage:message];
        
    } else {
        HDVisitorTrack *vt = (HDVisitorTrack *)[self trackOrOrder];
        [message addContent:vt];
        
        [message addContent:self.visitorInfo];
        NSString *imageName = [info objectForKey:@"imageName"];
        NSMutableDictionary *ext = [message.ext mutableCopy];
        [ext setValue:imageName forKey:@"imageName"];
        message.ext = [ext copy];
        [self _insertTrackMessage:message];
    }
}


- (void)_insertTrackMessage:(HDMessage *)message
{
    message.status = HDMessageStatusSuccessed;
    [self addMessageToDataSource:message progress:nil];
    [self.conversation addMessage:message error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"第二通道已经关闭");
    [[HDClient sharedClient].chatManager unbind];
}

#pragma mark - setup subviews start
- (void)_setupBarButtonItem
{
    if (self.frimId.length > 0) {
        //两个按钮的父类view
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 50)];
        //查看证件按钮
        UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 70, 26)];
        [rightButtonView addSubview:historyBtn];
        historyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [historyBtn setTitle:@"查看证件" forState:UIControlStateNormal];
        [historyBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [DCSpeedy dc_changeControlCircularWith:historyBtn AndSetCornerRadius:historyBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#999999"] canMasksToBounds:YES];
        [historyBtn addTarget:self action:@selector(historyBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        #pragma mark >>>>>主页搜索按钮
        //清空按钮
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 44, 44)];
        [rightButtonView addSubview:clearButton];
        clearButton.accessibilityIdentifier = @"clear_message";
        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        //把右侧的两个按钮添加到rightBarButtonItem
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;

    }else{
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        clearButton.accessibilityIdentifier = @"clear_message";
        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    
    if (self.navigationItem.leftBarButtonItems && self.navigationItem.leftBarButtonItems.count > 0) {
        UIBarButtonItem *lefbar = self.navigationItem.leftBarButtonItems.firstObject;
        lefbar.action = @selector(backAction);
        lefbar.target = self;
        NSMutableArray *item = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
        item[0]= lefbar;
        self.navigationItem.leftBarButtonItems = item;
    }
}

#pragma mark - action

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setup subviews end

- (void)didPressedLeaveMsgButton {
    HDLeaveMsgViewController *leaveMsgVC = [[HDLeaveMsgViewController alloc] init];
    [self.navigationController pushViewController:leaveMsgVC animated:YES];
}

//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.cancelButtonIndex != buttonIndex) {
//        self.messageTimeIntervalTag = -1;
//        [self.conversation deleteAllMessages:nil];
//        [self.dataArray removeAllObjects];
//        [self.messsagesSource removeAllObjects];
//        [self.tableView reloadData];
//    }
//}

#pragma mark - HDMessageViewControllerDelegate

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController fileMessageCellSelected:(id<HDIMessageModel>)model {
    HFileViewController *fileVC = [[HFileViewController alloc] init];
    fileVC.model = (HDMessageModel *)model;
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        HDMessageCell *cell = (HDMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id<HDIMessageModel> model = [self.dataArray objectAtIndex:indexPath.row];
//    if (model.isSender) {
//        if (model.bodyType == EMMessageBodyTypeText) {
//            HDExtMsgType extMsgType = [HDMessageHelper getMessageExtType:model.message];
//
//            if (extMsgType == HDExtOrderMsg) {
//                [self _orderMessageCellSelected:model];
//
//            }else if(extMsgType == HDExtTrackMsg){
//                [self _trackMessageCellSelected:model];
//
//            }
//        }
//    }

}

- (void)_orderMessageCellSelected:(id<HDIMessageModel>)model
{
    [DC_KEYWINDOW endEditing:YES];//关闭键盘
    HDMessage *message = model.message;
    NSDictionary *ext = message.ext;
    NSDictionary *msgtype = [ext objectForKey:@"msgtype"];
    NSDictionary *order = [msgtype objectForKey:@"order"];
    NSString *order_title = [order objectForKey:@"order_title"];
    NSString *orderNo = @"";
    NSArray *array = [order_title componentsSeparatedByString:@"订单号:"];
    if (array.count >1) {
        orderNo = array[1];
    }
    
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) {
        //企业
        NSString *params = [NSString stringWithFormat:@"id=%@",orderNo];
        [self dc_pushWebController:@"/qiye/order_detail.html" params:params];
    }else{
        //个人
        GLPOrderDetailsViewController *vc = [[GLPOrderDetailsViewController alloc] init];
        vc.orderNo_Str = orderNo;
        [self.navigationController pushViewController:vc animated:YES];
        //[self dc_pushPersonWebController:@"/geren/detail.html" params:params];
    }
}

- (void)_trackMessageCellSelected:(id<HDIMessageModel>)model
{
    [DC_KEYWINDOW endEditing:YES];//关闭键盘
    HDMessage *message = model.message;
    NSDictionary *ext = message.ext;
    NSDictionary *msgtype = [ext objectForKey:@"msgtype"];
    NSDictionary *track = [msgtype objectForKey:@"track"];
    NSString *item_url = [track objectForKey:@"item_url"];
    NSArray *array = [item_url componentsSeparatedByString:@"goods/"];
    NSString *goodsId = @"";
    if (array.count >1) {
        NSArray *array1 = [array[1] componentsSeparatedByString:@".html"];
        goodsId = array1[0];
    }
    if (goodsId.length == 0) {
        return;;
    }
    
    NSInteger userType = [[DCObjectManager dc_readUserDataForKey:DC_UserType_Key] integerValue];
    if (userType == DCUserTypeWithCompany) {
        GLBGoodsDetailController *vc = [GLBGoodsDetailController new];
        vc.goodsId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //个人
        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
        vc.goodsId = goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 界面跳转h5界面 - 个人
- (void)dc_pushPersonWebController:(NSString *)path params:(NSString *)params
{
    NSString *url = Person_H5BaseUrl;
    if (path && [path length] > 0) {
        url = [url stringByAppendingString:path];
    }
    
    if (params && [params length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    GLPH5ViewController *vc = [GLPH5ViewController new];
    vc.path = url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 界面跳转h5界面
- (void)dc_pushWebController:(NSString *)path params:(NSString *)params
{
    NSString *url = DC_H5BaseUrl;
    if (path && [path length] > 0) {
        url = [url stringByAppendingString:path];
    }

    if (params && [params length] > 0) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }

    DCH5ViewController *vc = [DCH5ViewController new];
    vc.path = url;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - HDMessageViewControllerDataSource
// 设置消息页面右侧显示的昵称和头像
- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController
                           modelForMessage:(HDMessage *)message
{
    id<HDIMessageModel> model = nil;
    model = [[HDMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
    model.avatarURLPath = [CSDemoAccountManager shareLoginManager].avatarStr;
    model.nickname = [CSDemoAccountManager shareLoginManager].nickname;
    return model;
}

- (NSArray *)emotionFormessageViewController:(HDMessageViewController *)viewController
{
    NSMutableArray *rst = [NSMutableArray arrayWithCapacity:0];
    //添加表情数据源
#pragma mark smallpngface
    NSMutableArray *customEmotions = [NSMutableArray array];
    NSMutableArray *customNameArr = [NSMutableArray arrayWithCapacity:0];
    NSString *customName = nil;
    for (int i=1; i<=35; i++) {
        // 把自定义表情图片加到数组中
        customName = [@"HelpDeskUIResource.bundle/e_e_" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        [customNameArr addObject:customName];
    }
    int i = 0;
    // 取出表情字符
    for (NSString *name in [HDConvertToCommonEmoticonsHelper emotionsArray]) {
        //initWithName是表情底部的显示名，可以传空， emotionId传表情名称  emotionThumbnail和emotionOriginal  是传表情字符对应的图片 在UI上显示
        HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:customNameArr[i] emotionOriginal:customNameArr[i] emotionOriginalURL:@"" emotionType:HDEmotionPng];
        [customEmotions addObject:emotion];
        i++;
    }
    HDEmotion *customTemp = [customEmotions objectAtIndex:0];
    HDEmotionManager *customManagerDefault = [[HDEmotionManager alloc] initWithType:HDEmotionPng emotionRow:4 emotionCol:9 emotions:customEmotions tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
    customManagerDefault.emotionName = NSLocalizedString(@"default", @"default");
    [rst addObject:customManagerDefault];
    
    NSArray *emojiPackagesDics = [self emojiValueForKey:@"emojiPackages"];
    for (NSDictionary *dic in emojiPackagesDics) {
        HEmojiPackage *package = [[HEmojiPackage alloc] initWithDictionary:dic];
        if (![[CSDemoAccountManager shareLoginManager].tenantId isEqualToString:package.tenantId]) {
            continue;
        }
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
        NSArray *emojis = [self emojiValueForKey:[NSString stringWithFormat:@"emojis%@",package.packageId]];
        for (NSDictionary *emojiDic in emojis) {
            HEmoji *hemoji = [[HEmoji alloc] initWithDictionary:emojiDic];
            HDEmotion *emotion = [[HDEmotion alloc] initWithName:hemoji.emojiName emotionId:@"123" emotionThumbnail:hemoji.thumbnailUrl emotionOriginal:hemoji.originUrl emotionOriginalURL:hemoji.originUrl emotionType:hemoji.emotionType];
            [marr addObject:emotion];
        }
        if (marr.count > 0) {
            HDEmotion *customTemp = [marr objectAtIndex:0];
            HDEmotionManager *manager = [[HDEmotionManager alloc] initWithType:HDEmotionGif emotionRow:2 emotionCol:4 emotions:marr tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
            manager.emotionName = package.packageName;
            [rst addObject:manager];
        }
        
    }
    return rst;
}

- (id)emojiValueForKey:(NSString *)key {
    NSString *path=NSTemporaryDirectory();
    NSString *emojiPath = [path stringByAppendingPathComponent:@"emoji.plist"];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithContentsOfFile:emojiPath];
    return [mDic valueForKey:key];
}

- (BOOL)isEmotionMessageFormessageViewController:(HDMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (HDEmotion*)emotionURLFormessageViewController:(HDMessageViewController *)viewController
                                      messageModel:(id<HDIMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    HDEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[HDEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:HDEmotionGif];
    }
    return emotion;
}

#pragma mark - action

/**
 继承于父类，点击左上箭头离开聊天界面时执行。本方法禁止执行可能引起父类方法不能释放的代码。
 */
- (void)backItemDidClicked
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
    NSLog(@"返回会话列表");
}

/**产看药师*/
- (void)historyBtnEvent
{
    
    [self requestFrimeInfo];

//    DCExamineImageView *view = [[DCExamineImageView alloc] init];
//    view.frame = DC_KEYWINDOW.bounds;
//    view.frimId = self.frimId;
//    [DC_KEYWINDOW addSubview:view];
}

#pragma mark - 请求 查看药师资格
- (void)requestFrimeInfo
{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_common_customer_pharmacistWithFrimId:self.frimId success:^(id response) {
        NSDictionary *userDic = response[@"data"];
        weakSelf.certificatePic = [userDic objectForKey:@"certificatePic"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        YBIBImageData *data0 = [YBIBImageData new];
        data0.imageURL = [NSURL URLWithString:self.certificatePic];
        [arr addObject:data0];
        
        YBImageBrowser *brow = [YBImageBrowser new];
        brow.autoHideProjectiveView = NO;
        brow.dataSourceArray = arr;
        brow.currentPage = 0;
        // 只有一个保存操作的时候，可以直接右上角显示保存按钮
        brow.defaultToolViewHandler.topView.hidden = YES;
        [brow show];

    } failture:^(NSError *error) {
        
    }];
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *chattingID = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [chattingID isEqualToString:self.conversation.conversationId];
        if (isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.dataArray removeAllObjects];
            [self.messsagesSource removeAllObjects];
            [self.tableView reloadData];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cancela", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancela", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//        [alertView show];
    }
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessageWithMessageId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    self.menuIndexPath = nil;
}

#pragma mark - private
- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[HDCDDeviceManager sharedInstance] stopPlaying];
    [[HDCDDeviceManager sharedInstance] disableProximitySensor];
    [HDCDDeviceManager sharedInstance].delegate = self;
    
    HDMessageModel *playingModel = [[HDMessageReadManager defaultManager] stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        hd_dispatch_main_async_safe(^(){
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}


@end
