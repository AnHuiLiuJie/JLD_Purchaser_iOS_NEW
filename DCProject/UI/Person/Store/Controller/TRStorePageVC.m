//
//  TRStorePageVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRStorePageVC.h"
#import "TRStoreHomeVC.h"
#import "TRStoreActivityVC.h"
#import "TRStoreBulkVC.h"
#import "TRStoreRecommendVC.h"
#import "TRStoreGoodsVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YBPopupMenu.h"
#import "GLPMessageListVC.h"
#import "GLPTabBarController.h"
#import "TRClassGoodsVC.h"
#import "CSDemoAccountManager.h"//lj_will_change
#import "WMScrollView+DCPopGesture.h"

static CGFloat const kWMMenuViewHeight = 40;

@interface TRStorePageVC ()<YBPopupMenuDelegate,UITextFieldDelegate>
{
    UIView *headView1;
    UIView *headView2;
    UIView *searchView;
    UIImageView *headImageV;
    UILabel *nameLab;
    UILabel *numLab;
    UIImageView *levelImageV;
}

@property (nonatomic, strong) NSArray *names;
@property(nonatomic,strong) UIButton *likeBtn;
@property(nonatomic,assign) float moveHeight;
@property(nonatomic,strong) UIButton *gzBtn;
@property(nonatomic,strong) UIImageView *gzImageV;
@property(nonatomic,strong) UILabel *gzLab;
@property(nonatomic,strong) UILabel *msgLab;
@property(nonatomic,copy) NSString *collectId;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *headImage;
@property (nonatomic, copy) NSString *firmName; // 企业名称

@end

@implementation TRStorePageVC

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 18;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 5;
        self.progressWidth = 40;
        self.menuView.backgroundColor = RGB_COLOR(0, 148, 140);
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor whiteColor];
        self.progressColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 请求 获取未读消息数量
- (void)requestNoReadMsgCount
{
    [[DCAPIManager shareManager] person_requestNoReadMsgCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"]) {
                NSInteger count = [response[@"data"] integerValue];
                if (count>0){
                    self.msgLab.hidden = NO;
                    self.msgLab.text = [NSString stringWithFormat:@"%ld",(long)count];
                }else{
                     self.msgLab.hidden = YES;
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

- (void)viewDidLoad {
    [self headView];
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.moveHeight = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveClick:) name:@"move" object:nil];
    self.collectId = @"";
    self.userId = @"";
    [self getstoreinfo];
    [self judgeIsCollect];
}

//获取店铺基本资料
- (void)getstoreinfo
{
    WEAKSELF;
    [[DCAPIManager shareManager]person_getStoreInfowithfirmId:[NSString stringWithFormat:@"%@",self.firmId] success:^(id response) {
        NSDictionary *dic = response[@"data"];
        [self->headImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"logoImg"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
        self.headImage = [NSString stringWithFormat:@"%@",dic[@"logoImg"]];
        self->nameLab.text = [NSString stringWithFormat:@"%@",dic[@"shopName"]];
        NSString *levelIconUrl = [NSString stringWithFormat:@"%@",dic[@"levelIconUrl"]];
        self.userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        self->numLab.text = [NSString stringWithFormat:@"%@人关注",dic[@"collectionCount"]];
        [self->levelImageV sd_setImageWithURL:[NSURL URLWithString:levelIconUrl] placeholderImage:[UIImage imageNamed:@"xx"]];
        
        weakSelf.firmName = dic[@"firmName"];
        
    } failture:^(NSError *error) {
        
    }];
}

//判断是否被收藏
- (void)judgeIsCollect
{
    [[DCAPIManager shareManager]person_judgeIsCollectionwithobjectId:[NSString stringWithFormat:@"%@",self.firmId] success:^(id response) {
        NSString *type = [NSString stringWithFormat:@"%@",response[@"data"]];
        if ([type isEqualToString:@"0"])
        {
            self.likeBtn.selected = NO;
            self.gzBtn.selected = NO;
            self.gzImageV.image = [UIImage imageNamed:@"gz"];
            self.gzLab.text = @"关注";
            self.likeBtn.backgroundColor = RGB_COLOR(252, 94, 9);
            [self.likeBtn setImage:[UIImage imageNamed:@"gz"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"关注" forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor clearColor].CGColor;
            self.likeBtn.layer.borderWidth = 0;
        }
        else{
            self.collectId = type;
            self.likeBtn.selected = YES;
            self.gzBtn.selected = YES;
            self.gzImageV.image = [UIImage imageNamed:@"yiguanzhu_bai"];
            self.gzLab.text = @"已关注";
            self.likeBtn.backgroundColor = [UIColor clearColor];
            [self.likeBtn setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"已关注" forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            self.likeBtn.layer.borderWidth = 1;
        }
    } failture:^(NSError *error) {
    }];
}

- (void)moveClick:(NSNotification*)no
{
    NSString *y = no.userInfo[@"move"];
    if ([y floatValue]>=0 && [y floatValue]<=70) {
        headView1.frame = CGRectMake(0, 60+kStatusBarHeight-[y floatValue], kScreenW, 110);
        headView2.frame = CGRectMake(0, 130+kStatusBarHeight-[y floatValue], kScreenW, 40);
        if ([y floatValue]>50) {
            searchView.frame = CGRectMake(56, kStatusBarHeight+21, kScreenW-163, 30);
        }
        else{
             searchView.frame = CGRectMake(56, kStatusBarHeight+21, kScreenW-113-self.moveHeight, 30);
        }
       
        for (UIView *allview in headView1.subviews) {
            allview.alpha = (70-[y floatValue])/70;
        }
        if ([y floatValue]==0)
        {
            self.gzBtn.hidden = YES;
        }
        else{
            self.gzBtn.hidden = NO;
        }
        self.gzBtn.alpha = [y floatValue]/70;
        self.moveHeight = [y floatValue];
        [self forceLayoutSubviews];
    }
}

- (void)headView
{
    headView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60+kStatusBarHeight, kScreenW, 70)];
    headView1.backgroundColor = RGB_COLOR(0, 148, 140);
    [self.view addSubview:headView1];
    
    headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(16, 8, 40, 40)];
    headImageV.layer.masksToBounds = YES;
    headImageV.layer.cornerRadius = 20;
    headImageV.userInteractionEnabled = YES;
    [headView1 addSubview:headImageV];
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [headImageV addGestureRecognizer:tap1];
    
    nameLab = [[UILabel alloc]initWithFrame:CGRectMake(59,  8, kScreenW-225, 25)];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.text = @"";
    nameLab.userInteractionEnabled = YES;
    [headView1 addSubview:nameLab];
    UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [nameLab addGestureRecognizer:tap2];
   
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(kScreenW-74, 17, 58, 22);
    [likeBtn setTitle:@"关注" forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"gz"] forState:UIControlStateNormal];
    likeBtn.layer.cornerRadius = 11;
    likeBtn.layer.masksToBounds = YES;
    likeBtn.backgroundColor = RGB_COLOR(252, 94, 9);
    [likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [headView1 addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    levelImageV = [[UIImageView alloc] init];
    levelImageV.frame = CGRectMake(59, 38, 13, 13);
    [headView1 addSubview:levelImageV];
    
    numLab = [[UILabel alloc]initWithFrame:CGRectMake(75, 38, kScreenW-210,14)];
    numLab.textColor = [UIColor whiteColor];
    numLab.font = [UIFont systemFontOfSize:10];
    [headView1 addSubview:numLab];
    
    UIButton *kefubtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kefubtn.frame = CGRectMake(kScreenW-140, 17, 58, 22);
    [kefubtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [kefubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kefubtn.layer.masksToBounds = YES;
    kefubtn.layer.cornerRadius = 11;
    kefubtn.layer.borderColor = [UIColor whiteColor].CGColor;
    kefubtn.layer.borderWidth = 1;
    kefubtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [kefubtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [headView1 addSubview:kefubtn];
    headView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 130+kStatusBarHeight, kScreenW, 40)];
    headView2.backgroundColor = RGB_COLOR(0, 148, 140);
    [self.view addSubview:headView2];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenW , 60+kStatusBarHeight)];
    headView.backgroundColor = RGB_COLOR(0, 148, 140);
    [self.view addSubview:headView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"dc_arrow_left_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(18, kStatusBarHeight+24, 20, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    searchView = [[UIView alloc]initWithFrame:CGRectMake(56, kStatusBarHeight+21, kScreenW-113, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 15;
    [headView addSubview:searchView];
    UIImageView *searchImageV = [[UIImageView alloc] init];
    searchImageV.center = CGPointMake(22, 15);
    searchImageV.bounds = CGRectMake(0, 0, 14, 14);
    searchImageV.image = [UIImage imageNamed:@"dc_ss_hei"];
    [searchView addSubview:searchImageV];
    UITextField *searchTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, searchView.frame.size.width-45 , 20)];
    searchTF.placeholder = @"搜索此店铺商品";
    searchTF.font = [UIFont systemFontOfSize:12];
    searchTF.borderStyle=UITextBorderStyleNone;
    searchTF.returnKeyType=UIReturnKeySearch;
    searchTF.delegate = self;
    [searchView addSubview:searchTF];
    
    self.gzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gzBtn.frame = CGRectMake(kScreenW-90, kStatusBarHeight+21, 40, 30);
    self.gzBtn.hidden = YES;
    self.gzBtn.alpha=0;
    [self.gzBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.gzBtn];
    self.gzImageV = [[UIImageView alloc] init];
    self.gzImageV.image = [UIImage imageNamed:@"gz"];
    self.gzImageV.center = CGPointMake(self.gzBtn.frame.size.width/2, 8);
    self.gzImageV.bounds = CGRectMake(0, 0, 16, 16);
    [self.gzBtn addSubview:self.gzImageV];
    self.gzLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 40, 13)];
    self.gzLab.text = @"关注";
    self.gzLab.textColor = [UIColor whiteColor];
    self.gzLab.font = [UIFont systemFontOfSize:11];
    self.gzLab.textAlignment = NSTextAlignmentCenter;
    [self.gzBtn addSubview:self.gzLab];
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn setImage:[UIImage imageNamed:@"dianpuxiangqzhankai"] forState:UIControlStateNormal];
    msgBtn.frame = CGRectMake(kScreenW-42, kStatusBarHeight+21, 30, 30);
    [msgBtn addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:msgBtn];
    
    self.msgLab = [[UILabel alloc]initWithFrame:CGRectMake(msgBtn.frame.size.width/2+msgBtn.frame.origin.x, msgBtn.frame.origin.y-17, 17, 17)];
    self.msgLab.backgroundColor = [UIColor redColor];
    self.msgLab.layer.masksToBounds = YES;
    self.msgLab.layer.cornerRadius = 8.5;
    self.msgLab.textColor = [UIColor whiteColor];
    self.msgLab.textAlignment = NSTextAlignmentCenter;
    self.msgLab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.msgLab.layer.borderWidth = 1;
    self.msgLab.hidden = YES;;
    self.msgLab.font = [UIFont systemFontOfSize:11];
    [headView addSubview: self.msgLab];
    
}

- (void)tapClick
{
    [self dc_pushPersonWebController:@"/geren/store_detail.html" params:[NSString stringWithFormat:@"linkFrom=app&id=%@",self.firmId]];
}

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

//返回
- (void)backClick
{
   if (self.presentingViewController) {
       GLPTabBarController*vc = [[GLPTabBarController alloc] init];
       vc.selectedIndex = 0;
       DC_KeyWindow.rootViewController = vc;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//消息
- (void)msgClick
{
    [self showPopupMenu];
}

#pragma mark - 展示弹框  选中的cell样式可自定义  待优化
- (void)showPopupMenu {
    YBPopupMenu *popupMenu = [YBPopupMenu showAtPoint:CGPointMake(kScreenW - 30, kNavBarHeight - 10) titles:@[@"消息",@"首页",@"商品分类",@"购物车",@"我的"] icons:@[@"xiangqxiaoxi",@"xiangqshouye",@"xiangqingspfenlei",@"xiangqigouwuc",@"xiangqwode"] menuWidth:145 delegate:self];
    popupMenu.dismissOnSelected = YES;
    popupMenu.isShowShadow = YES;
    popupMenu.delegate = self;
    popupMenu.offset = 10;
    popupMenu.type = YBPopupMenuTypeDark;
    popupMenu.fontSize = 16;
    popupMenu.textColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    popupMenu.borderWidth = 0;
    popupMenu.cornerRadius = 5;
    popupMenu.minSpace = 10;
    popupMenu.arrowPosition = YBPopupMenuPriorityDirectionRight;
    popupMenu.backColor = [UIColor dc_colorWithHexString:@"666666" alpha:0.9];
    popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight|UIRectCornerTopLeft|UIRectCornerTopRight;
}

#pragma mark - <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) { // 消息
        GLPMessageListVC *vc = [[GLPMessageListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else { // 首页 商品分类 购物车 我的
        
        GLPTabBarController *vc = [[GLPTabBarController alloc] init];
        vc.selectedIndex = index - 1;
        DC_KeyWindow.rootViewController = vc;
    }
}

//关注
- (void)likeClick
{
    self.likeBtn.selected = !self.likeBtn.selected;
    self.gzBtn.selected = !self.gzBtn.selected;
    if (self.likeBtn.selected==YES)
    {
        [[DCAPIManager shareManager]person_addCollectionwithcollectionType:@"2" goodsPrice:@"" objectId:[NSString stringWithFormat:@"%@",self.firmId] isPrompt:NO success:^(id response) {
            self.collectId = [NSString stringWithFormat:@"%@",response[@"data"]];
            [SVProgressHUD showSuccessWithStatus:@"关注店铺成功"];
            self.likeBtn.backgroundColor = [UIColor clearColor];
            [self.likeBtn setImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"已关注" forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            self.likeBtn.layer.borderWidth = 1;
            self.gzLab.text = @"已关注";
            self.gzImageV.image = [UIImage imageNamed:@"yiguanzhu_bai"];
            [self getstoreinfo];
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        [[DCAPIManager shareManager]person_deleNewFocusFirstwithcollectionIds:self.firmId success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注店铺成功"];
            self.likeBtn.backgroundColor = RGB_COLOR(252, 94, 9);
            [self.likeBtn setImage:[UIImage imageNamed:@"gz"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"关注" forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor clearColor].CGColor;
            self.likeBtn.layer.borderWidth = 0;
            self.gzLab.text = @"关注";
            self.gzImageV.image = [UIImage imageNamed:@"gz"];
            [self getstoreinfo];
        } failture:^(NSError *error) {
            
        }];
       
    }
}

- (void)kefuClick
{
    //lj_will_change_end
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
        if ([lgM loginKefuSDK]) {
            NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
            NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
            NSString *chatTitle = @"";
            HDQueueIdentityInfo *queueIdentityInfo = nil;
            HDAgentIdentityInfo *agentIdentityInfo = nil;
            queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
            agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
            chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
            hd_dispatch_main_async_safe(^(){
                [weakSelf hideHud];
                HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                queue ? (chat.queueInfo = queueIdentityInfo) : nil;
                agent ? (chat.agent = agentIdentityInfo) : nil;
                chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
                [self.navigationController pushViewController:chat animated:YES];
            });
           
        } else {
            hd_dispatch_main_async_safe(^(){
                [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
            });
            NSLog(@"登录失败");
        }
    });//完整
    
    //lj_will_change
//    HDChatViewController *chatController = [[HDChatViewController alloc] initWithConversationChatter:userID conversationType:EMConversationTypeChat];
//    chatController.title = title;
//    chatController.sellerFirmName = self.firmName;
//    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self requestNoReadMsgCount];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
//     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
   
    if (index == 0) {
        TRStoreHomeVC *vc = [[TRStoreHomeVC alloc] init];
        vc.firmId = self.firmId;
        return vc;
        
    } else if (index == 1) {
        
        TRStoreGoodsVC *vc = [TRStoreGoodsVC new];
        vc.firmId = self.firmId;
        return vc;
        
    } else if (index == 2) {
        
        TRStoreActivityVC *vc = [TRStoreActivityVC new];
        vc.firmId = self.firmId;
        return vc;
        
    } else if (index == 3) {
        
        TRStoreBulkVC *vc = [TRStoreBulkVC new];
        vc.firmId = self.firmId;
        return vc;
    }
    else if (index == 4) {
        
        TRStoreRecommendVC *vc = [TRStoreRecommendVC new];
        vc.firmId = self.firmId;
        return vc;
        
    }
    return [UIViewController new];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, kStatusBarHeight+170-self.moveHeight, kScreenW, kScreenH - 170+kNavBarHeight+kTabBarHeight+self.moveHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kStatusBarHeight+125-self.moveHeight, kScreenW, kWMMenuViewHeight);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    int index = [info[@"index"] intValue];
    if (index == 3) {
    } else {
    }
    
}

- (NSArray *)names{
    if (!_names) {
        _names = @[@"首页",@"商品",@"活动",@"团购",@"推荐"];
    }
    return _names;
}

#pragma delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     if (textField.text.length>0)
       {
           TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
           vc.searchStr = textField.text;
           vc.firmId = self.firmId;
           [self.navigationController pushViewController:vc animated:YES];
       }
    return YES;
}

@end
