//
//  GLPOldGoodsDetailsController.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPOldGoodsDetailsController.h"

#import "GLPGoodsDetailsTitleCell.h"
#import "GLPGoodsDetailsOldExpressCell.h"
#import "GLPGoodsDetailsOldTicketCell.h"
#import "GLPGoodsDetailsSimilarCell.h"
#import "GLPGoodsDetailsMatchCell.h"
#import "GLPGoodsDetailsEvaluateCell.h"
#import "GLPGoodsDetailsQuestionCell.h"
#import "GLPGoodsDetailsOldStoreCell.h"
#import "GLPGoodsDetailsRecommendCell.h"
#import "GLPGoodsDetailsInfoCell.h"
#import "GLPGoodsDetailsEvaluetaHeaderView.h"
#import "GLPGoodsDetailsEvaluetaFooterView.h"

#import "GLPGoodsDetailsHeadView.h"
#import "GLPGoodsDetailsNavigationBar.h"
#import "GLPGoodsDetailsBottomView.h"
#import "YBPopupMenu.h"

#import "GLPDetailEnsureController.h"
#import "GLPTabBarController.h"
#import "GLPAddShoppingCarController.h"
#import "TRStorePageVC.h"
#import "GLPMessageListVC.h"
#import "GLPShoppingCarModel.h"
#import "GLBCountTFView.h"
#import "GLPConfirmOrderViewController.h"
#import "GLPTicketSgnController.h"

#import "CSDemoAccountManager.h"//lj_will_change_end
#import "GLPGoodsDetailsWebCell.h"

#import "GLPShoppingCarController.h"
#import "GLPOldGoodsDetailsSpecificationsCell.h"
#import "GLPOldGoodsDetailsSpecificationsView.h"
#import "GLPGoodsDetailsSpecModel.h"

#import <WebKit/WebKit.h>
#import "DCUMShareTool.h"
#import "GLPGoodsShareVC.h"
#import "GLPEtpEntrepreneurPosterVC.h"
#import "GLPDetailActBeanController.h"
#import "ArrivalNoticeViewController.h"
#import "GLPGoodsAddressModel.h"

static NSString *const titleCellID = @"GLPGoodsDetailsTitleCell";
static NSString *const expressCellID = @"GLPGoodsDetailsOldExpressCell";
static NSString *const ticketCellID = @"GLPGoodsDetailsOldTicketCell";
static NSString *const similarCellID = @"GLPGoodsDetailsSimilarCell";
static NSString *const matchCellID = @"GLPGoodsDetailsMatchCell";
static NSString *const evaluateCellID = @"GLPGoodsDetailsEvaluateCell";
static NSString *const questionCellID = @"GLPGoodsDetailsQuestionCell";
static NSString *const storeCellID = @"GLPGoodsDetailsOldStoreCell";
static NSString *const recommendCellID = @"GLPGoodsDetailsRecommendCell";
static NSString *const infoCellID = @"GLPGoodsDetailsInfoCell";
static NSString *const GLPGoodsDetailsWebCellID = @"GLPGoodsDetailsWebCell";
static NSString *const evaluateHeaderID = @"GLPGoodsDetailsEvaluetaHeaderView";
static NSString *const evaluateFooterID = @"GLPGoodsDetailsEvaluetaFooterView";
static NSString *const specificationsID = @"GLPOldGoodsDetailsSpecificationsCell";


@interface GLPOldGoodsDetailsController ()<YBPopupMenuDelegate,GLPEditCountViewDelegate,WKNavigationDelegate>
{
    dispatch_group_t group;
}
@property (nonatomic, strong) GLPGoodsDetailsHeadView *headView;
@property (nonatomic, strong) GLPGoodsDetailsBottomView *bottomView;
@property (nonatomic, strong) GLPGoodsDetailsNavigationBar *navBar;
@property (nonatomic, strong) GLBCountTFView *countTFView;

//规格
@property (nonatomic, strong) GLPOldGoodsDetailsSpecificationsView *specView;
@property (nonatomic, strong) NSArray *specModels;
@property (nonatomic, strong) GLPGoodsDetailsSpecModel *specModelSelect;//当前选中的规格
@property (nonatomic, assign) NSInteger specType;

// 商品详情
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
// 默认地址与运费信息
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel;
// 相似产品
@property (nonatomic, strong) NSMutableArray<GLPGoodsSimilarModel *> *similarArray;
// 处方推荐
//@property (nonatomic, strong) NSMutableArray<GLPGoodsMatchModel *> *matchArray;
@property (nonatomic, strong) GLPGoodsMatchModel *matchModel;
// 评价模型
@property (nonatomic, strong) GLPGoodsEvaluateModel *evaluateModel;
// 问答专区
@property (nonatomic, strong) NSMutableArray<GLPGoodsQusetionModel *> *questionArray;
// 相似产品
@property (nonatomic, strong) GLPGoodsLickModel *lickModel;
// 商品收藏ID
@property (nonatomic, assign) NSInteger goodsCollectID;
// 店铺收藏ID
@property (nonatomic, copy) NSString *storeCollectID;
@property(nonatomic, assign) NSInteger selctIndexTag;

@property (nonatomic, assign) NSInteger buyCount;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webHeight;


@end

@implementation GLPOldGoodsDetailsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES animated:animated];
    [self requestNoReadMsgCount];
    if (_bottomView) {
        [_bottomView reshnum];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    GLPCustomXFView *xfView = [DC_KEYWINDOW viewWithTag:xfViewTag];
    CGPoint point = CGPointMake(kScreenW-xfView.dc_width, CGRectGetMaxY(self.headView.frame)-xfView.dc_height+10);
    CGRect originalFrame = xfView.frame;
    originalFrame.origin.x = point.x;
    originalFrame.origin.y = point.y;
    xfView.frame = originalFrame;
    
    xfView.hidden = NO;
    WEAKSELF;
    [xfView setTapBlock:^(NSDictionary *_Nonnull linkDic) {
        //点击事件
        [weakSelf yaoqingBtnMethod];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO animated:animated];
    GLPCustomXFView *xfView = [DC_KEYWINDOW viewWithTag:xfViewTag];
    xfView.hidden = YES;
}

#pragma mark - 邀请
- (void)yaoqingBtnMethod
{
    if (self.extendType == 0) {
        
        GLPEtpEntrepreneurPosterVC *vc = [GLPEtpEntrepreneurPosterVC new];//创业者申请
        vc.userInfoModel = nil;
        [self dc_pushNextController:vc];
    }else if (self.extendType == 1) {
        
        GLPGoodsShareVC *vc = [[GLPGoodsShareVC alloc] init];
        vc.goodsId = self.detailModel.goodsId;
        [self dc_pushNextController:vc];
    }else if (self.extendType == 2 ) {
        
        GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
        vc.statusType = EtpApprovalStatusReviewing;
        [self dc_pushNextController:vc];
    }else{
        GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
        vc.statusType = EtpApprovalStatusReviewFailure;
        [self dc_pushNextController:vc];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    self.buyCount = 1;
    NSString  *extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
    self.extendType = extendType.length > 0 ? [extendType integerValue] : 0;
    
    [self.view addSubview:self.webView];
    
    [self setUpTableView];
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.bottomView];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.view.top);
        make.right.equalTo(self.view.right);
        make.height.equalTo(kNavBarHeight);
    }];
    self.storeCollectID = @"";
    self.selctIndexTag = 600;
    [self requestGoodsInfo:YES];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 9) {
        if (self.lickModel && self.lickModel.goodsList && self.lickModel.goodsList.count > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    else if (section == 7) {
        if (self.questionArray.count > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    else if (section == 6) {
        if (self.evaluateModel && [self.evaluateModel.evalList count] > 0) {
            return self.evaluateModel.evalList.count > 2 ? 2 : self.evaluateModel.evalList.count;
        } else {
            return 0;
        }
    }
    else if (section==5)
    {
        if (self.matchModel.goodsList.count > 0) {
            return 1;
        }
        else{
            return 0;
        }
    }
    else if (section==4)
    {
        if (self.similarArray.count > 0) {
            return 1;
        }
        else{
            return 0;
        }
    }
    else if (section == 3)
    {
        if (self.detailModel && (self.detailModel.goodsCoupons.couponsId || self.detailModel.bossCoupons.couponsId || self.detailModel.storeCoupons.couponsId )) {
            return 1;
        } else {
            return 0;
        }
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0) {
        //商品详情等信息
        GLPGoodsDetailsTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellID forIndexPath:indexPath];
        titleCell.countView.delegate = self;
        titleCell.countView.countTF.text = [NSString stringWithFormat:@"%ld",self.buyCount];
        if (self.addressModel) {
            titleCell.addressModel = self.addressModel;
        }
        if (self.detailModel) {
            titleCell.detailModel = self.detailModel;
        }
        titleCell.titleCellBlock = ^(NSInteger tag) {
            [weakSelf dc_titleCellBtnClick:tag];
        };
        titleCell.detailType = self.detailType;
        cell = titleCell;
    }else if (indexPath.section == 1) {
        //规格
        GLPOldGoodsDetailsSpecificationsCell *specCell = [tableView dequeueReusableCellWithIdentifier:specificationsID forIndexPath:indexPath];
        specCell.specificationsStr = self.specModelSelect ? self.specModelSelect.attr : @"";
        cell = specCell;
    } else if (indexPath.section == 2) {
        //平台展示
        GLPGoodsDetailsOldExpressCell *expressCell = [tableView dequeueReusableCellWithIdentifier:expressCellID forIndexPath:indexPath];
        if (self.detailModel) {
            expressCell.detailModel = self.detailModel;
        }
        expressCell.moreBtnBlock = ^{
            [weakSelf dc_pushDetailEnsureController];
        };
        cell = expressCell;
    } else if (indexPath.section == 3) {
        //优惠卷
        GLPGoodsDetailsOldTicketCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:ticketCellID forIndexPath:indexPath];
        if (self.detailModel) {
            ticketCell.detailModel = self.detailModel;
        }
        ticketCell.ticketBlock = ^(NSInteger tag) {
            [weakSelf dc_pushDetailTicketController:tag];
        };
        cell = ticketCell;
    } else if (indexPath.section == 4) {
        //浏览过商品的用户还购买
        GLPGoodsDetailsSimilarCell *similarCell = [tableView dequeueReusableCellWithIdentifier:similarCellID forIndexPath:indexPath];
        if (self.similarArray.count > 0) {
            similarCell.similarArray = self.similarArray;
        }
        similarCell.similarCellBlock = ^(GLPGoodsSimilarModel *model) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:model.goodsId firmId:nil];
        };
        cell = similarCell;
    } else if (indexPath.section == 5) {//http://wzgk4us5du.52http.net/b2c/goods/prescript mall_LgQj55+ELHIpfjbth1o2yIRUUfY1oqtuzUnvWShc4cPv9lf6Kexogg== 3099 20210602170022008 d6964a7bcc6ced056a48a2c048f97c24
        //处方搭配
        GLPGoodsDetailsMatchCell *matchCell = [tableView dequeueReusableCellWithIdentifier:matchCellID forIndexPath:indexPath];
        if (self.matchModel.goodsList.count > 0) {
            matchCell.matchModel = self.matchModel;
        }
        matchCell.matchCellBlock = ^(GLPGoodsMatchGoodsModel *goodsModel) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:goodsModel.iD firmId:goodsModel.sellerFirmId];
        };
        cell = matchCell;
    } else if (indexPath.section == 6) {
        //评价体系
        GLPGoodsDetailsEvaluateCell *evaluateCell = [tableView dequeueReusableCellWithIdentifier:evaluateCellID forIndexPath:indexPath];
        if (self.evaluateModel && self.evaluateModel.evalList > 0) {
            evaluateCell.listModel = self.evaluateModel.evalList[indexPath.row];
        }
        cell = evaluateCell;
    } else if (indexPath.section == 7) {
        //问答专区
        GLPGoodsDetailsQuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:questionCellID forIndexPath:indexPath];
        if (self.questionArray.count > 0) {
            questionCell.questionArray = self.questionArray;
        }
        questionCell.questionCellBlock = ^{
            
            if (weakSelf.detailModel) {
                NSString *params = [NSString stringWithFormat:@"id=%@",weakSelf.detailModel.goodsId];
                [weakSelf dc_pushPersonWebController:@"/geren/quest_answer.html" params:params];
            }
            
        };
        cell = questionCell;
    } else if (indexPath.section == 8) {
        //店铺
        GLPGoodsDetailsOldStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:storeCellID forIndexPath:indexPath];
        if (self.detailModel) {
            storeCell.detailModel = self.detailModel;
        }
        storeCell.storeCellBlock = ^(NSInteger tag) {
            [weakSelf dc_storeCellBtnClick:tag indexPath:indexPath];
        };
        cell = storeCell;
    } else if (indexPath.section == 9) {
        //猜你喜欢
        GLPGoodsDetailsRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:recommendCellID forIndexPath:indexPath];
        if (self.lickModel) {
            recommendCell.lickModel = self.lickModel;
        }
        recommendCell.recommendCellBlock = ^(GLPGoodsLickGoodsModel *goodsModel) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:goodsModel.iD firmId:goodsModel.sellerFirmId];
        };
        cell = recommendCell;
        
    } else if (indexPath.section == 10) {
        //商品详情
        GLPGoodsDetailsInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID forIndexPath:indexPath];
        infoCell.infoblock = ^(NSInteger tag) {
            weakSelf.selctIndexTag = tag;
            
            NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
            [idxSet addIndex:9];
            [idxSet addIndex:10];
            [weakSelf.tableView reloadData];
            /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
             [UIView performWithoutAnimation:^{
             [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
             }];
             }];*/
            //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
        };
        infoCell.selctButton = [NSString stringWithFormat:@"%ld",self.selctIndexTag];
        infoCell.detailModel = self.detailModel;
        cell = infoCell;
    } else if (indexPath.section == 11) {
        //商品网页介绍
        GLPGoodsDetailsWebCell *webCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsWebCellID forIndexPath:indexPath];
        [webCell dc_setValueWithModel:self.detailModel selctButton:[NSString stringWithFormat:@"%ld",self.selctIndexTag] viewHeight:self.webHeight];
        webCell.reloadBlock = ^{
            [weakSelf.tableView reloadData];
            /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
             [UIView performWithoutAnimation:^{
             [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
             }];
             }];*/
            //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
        };
        cell = webCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 6 ? 40.0f : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 10 || section == 11) {
        return 0.01f;
    }
    if (section == 9) {
        if (self.lickModel && self.lickModel.goodsList && self.lickModel.goodsList.count > 0) {
            return 5.0f;
        } else {
            return 0.01f;
        }
    }
    else if (section == 7) {
        if (self.questionArray.count > 0) {
            return 5.0f;
        } else {
            return 0.01f;
        }
    }
    else if (section == 6) {
        return 80.0f;
    }
    else if (section==5)
    {
        if (self.matchModel.goodsList.count > 0) {
            return 5.0f;
        }
        else{
            return 0.01;
        }
    }
    else if (section==4)
    {
        if (self.similarArray.count > 0) {
            return 5.0f;
        }
        else{
            return 0.01;
        }
    }
    else if (section == 3)
    {
        if (self.detailModel && (self.detailModel.goodsCoupons.couponsId || self.detailModel.bossCoupons.couponsId || self.detailModel.storeCoupons.couponsId )) {
            return 5.0f;
        } else {
            return 0.01f;
        }
    }
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 6) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
    }
    WEAKSELF;
    GLPGoodsDetailsEvaluetaHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:evaluateHeaderID];
    if (self.evaluateModel) {
        header.evaluateModel = self.evaluateModel;
    }
    header.allEvaluateBlock = ^{
        [weakSelf dc_pushAllEvaluateVC];
    };
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 6) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
    }
    WEAKSELF;
    GLPGoodsDetailsEvaluetaFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:evaluateFooterID];
    footer.allEvaluateBlock = ^{
        [weakSelf dc_pushAllEvaluateVC];
    };
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 0;
            if (!weakSelf.specView.isShow) {
                [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //    NSLog(@"===willDisplayCell:%ld",(long)indexPath.section);
    //    if (indexPath.section > 8) {
    //        self.navBar.currentIndex = 4;
    //    } else if (indexPath.section > 7) {
    //        self.navBar.currentIndex = 3;
    //    } else if (indexPath.section > 4) {
    //        self.navBar.currentIndex = 2;
    //    } else {
    //        self.navBar.currentIndex = 1;
    //    }
}

- (void)resizeImageInWebView:(CGFloat)maxwidth
{
    NSString *jsString = [NSString stringWithFormat:
                          @"var script = document.createElement('script');"
                          "script.type = 'text/javascript';"
                          "script.text = \"function ResizeImages() { "
                          "var myimg,oldwidth,oldheight;"
                          "var maxwidth=%f;"// 图片宽度
                          "for(i=0;i <document.images.length;i++){"
                          "myimg = document.images[i];"
                          //                          "if(myimg.width > maxwidth){"
                          //                          "myimg.height = (maxwidth/myimg.width)*myimg.height;"
                          "myimg.width = maxwidth;"
                          //                          "}"
                          "}"
                          "}\";"
                          "document.getElementsByTagName('head')[0].appendChild(script);",maxwidth];
    
    [self.webView evaluateJavaScript:jsString completionHandler:nil];
    
    [self.webView evaluateJavaScript:@"ResizeImages();" completionHandler:nil];
}

#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"
              completionHandler:^(id _Nullable result, NSError *_Nullable error) {
        if (!error) {
        }
    }];
    dispatch_group_leave(group);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webview 加载失败 — %@",error);
    dispatch_group_leave(group);
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed
        UIScrollView *scrollView = self.webView.scrollView;
        self.webHeight = scrollView.contentSize.height;
    }
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < -20){
        self.navBar.hidden = YES;
    }else{
        self.navBar.hidden = NO;
        
        if (20 < y < kNavBarHeight) {
            self.navBar.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:(y - 20)/kNavBarHeight];
        }
        
        if (y > kNavBarHeight) {
            self.navBar.isTop = YES;
        }else{
            self.navBar.isTop = NO;
        }
    }
    
    if (self.tableView == scrollView) {
        CGFloat orgY5 = [self.tableView rectForSection:6].origin.y;
        CGFloat orgY9 = [self.tableView rectForSection:9].origin.y;
        CGFloat orgY10 = [self.tableView rectForSection:10].origin.y;
        if (y + 5 >= orgY10) {
            self.navBar.currentIndex = 4;
        }else if (y + 5 >= orgY9){
            self.navBar.currentIndex = 3;
        }else if (y + 5 >= orgY5){
            self.navBar.currentIndex = 2;
        }else if(y < 0){
            self.navBar.currentIndex = 1;
        }
    }
}


#pragma mark - <GLPEditCountViewDelegate>
// 加
- (void)dc_personCountAddWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text intValue];
    count ++;
    
    if (self.detailModel && self.detailModel.totalStock > 0) {
        if (count > self.detailModel.totalStock) { // 大于库存
            [SVProgressHUD showInfoWithStatus:@"超过库存啦～"];
            return;
        }
        self.buyCount = count;
        
    } else {
        self.buyCount = count;
    }
    [self.tableView reloadData];
    /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
     [UIView performWithoutAnimation:^{
     [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
     }];
     }];*/
    //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
}

// 减
- (void)dc_personCountSubWithCountView:(GLPEditCountView *)countView
{
    NSInteger count = [countView.countTF.text intValue];
    count --;
    self.buyCount = count;
    [self.tableView reloadData];
    /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
     [UIView performWithoutAnimation:^{
     [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
     }];
     }];*/
    //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
}

// 改变
- (void)dc_personCountChangeWithCountView:(GLPEditCountView *)countView
{
    if (![DC_KeyWindow.subviews containsObject:self.countTFView]) {
        [DC_KeyWindow addSubview:self.countTFView];
        self.countTFView.textField.text = countView.countTF.text;
        WEAKSELF;
        self.countTFView.successBlock = ^{
            NSInteger count = [weakSelf.countTFView.textField.text integerValue];
            if (count < 1) {
                [SVProgressHUD showInfoWithStatus:@"不能小于1件"];
                return;
            }
            
            if (weakSelf.detailModel && weakSelf.detailModel.totalStock > 0) {
                if (count > weakSelf.detailModel.totalStock) { // 大于库存
                    [SVProgressHUD showInfoWithStatus:@"超过库存啦～"];
                    return;
                }
                weakSelf.buyCount = count;
                
            } else {
                weakSelf.buyCount = count;
            }
            
            [weakSelf requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
                [weakSelf.tableView reloadData];
                /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
                 [UIView performWithoutAnimation:^{
                 [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                 }];
                 }];*/
                //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
            }];
        };
        
        [self.countTFView.textField becomeFirstResponder];
        [self.countTFView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}


#pragma mark - 展示弹框  选中的cell样式可自定义  待优化
- (void)showPopupMenu {
    YBPopupMenu *popupMenu = [YBPopupMenu showAtPoint:CGPointMake(kScreenW - 30, kNavBarHeight - 10) titles:@[@"消息",@"首页",@"商品分类",@"购物车",@"我的"] icons:@[@"xiangqxiaoxi",@"xiangqshouye",@"xiangqingspfenlei",@"xiangqigouwuc",@"xiangqwode"] menuWidth:138 delegate:self];
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
    } else if(index == 5){
        [self yaoqingBtnMethod];
    }else { // 首页 商品分类 购物车 我的
        GLPTabBarController *vc = [[GLPTabBarController alloc] init];
        vc.selectedIndex = index - 1;
        DC_KeyWindow.rootViewController = vc;
    }
}

- (void)ybPopupMenuDidDismiss{
    
}


#pragma mark - action
- (void)dc_navBarBtnClick:(NSInteger)tag
{
    if (tag == 700) {
        if (self.presentingViewController) {
            GLPTabBarController*vc = [[GLPTabBarController alloc] init];
            vc.selectedIndex=0;
            DC_KeyWindow.rootViewController = vc;
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (tag == 701) { // 消息
        [self showPopupMenu];
    }
    if (tag == 702) { // 商品
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }
    if (tag == 703) { // 评价
        
        CGFloat orgY5 = [self.tableView rectForSection:6].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY5) animated:NO];
        return;
        
        //        NSInteger evlIdx = 0;
        //        if (self.matchModel.goodsList.count > 0) {
        //            evlIdx = 4;
        //        }else if (self.similarArray.count > 0) {
        //            evlIdx = 3;
        //        }else if (self.detailModel && (self.detailModel.goodsCoupons.couponsId || self.detailModel.bossCoupons.couponsId || self.detailModel.storeCoupons.couponsId )) {
        //            evlIdx = 2;
        //        }
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:evlIdx] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        //        return;
        //       if (self.evaluateModel && [self.evaluateModel.evalList count] > 0) {
        //           [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        //       }
        //       else{
        //
        //           if (self.questionArray.count > 0) {
        //               [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        //           } else {
        //               [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:7] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        //           }
        //
        //       }
        
    }
    if (tag == 704) { // 详情
        CGFloat orgY9 = [self.tableView rectForSection:9].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY9) animated:NO];
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if (tag == 705) { // 详情
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:9] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        CGFloat orgY10 = [self.tableView rectForSection:11].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY10) animated:NO];
    }
}

- (void)dc_bottomViewBtnClick:(NSInteger)tag
{
    if (tag == 800) { // 客服
        
        if (!self.detailModel) {
            return;
        }
        
        NSString *userID = @"";
        NSString *title = @"客服";
        NSString *headImg = @"";
        if (self.detailModel.shopInfo) {
            title = self.detailModel.shopInfo.shopName;
            userID = [NSString stringWithFormat:@"b2c_%@",self.detailModel.shopInfo.userId];
            headImg = self.detailModel.shopInfo.logoImg;
            
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [userDic setValue:userID forKey:@"userId"];
            [userDic setValue:title forKey:@"nickname"];
            [userDic setValue:headImg forKey:@"headImg"];
            
            DCChatGoodsModel *model = [DCChatGoodsModel new];
            model.goodsName = self.detailModel.goodsName;
            model.goodsId = self.detailModel.goodsId;
            model.manufactory = self.detailModel.manufactory;
            model.item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/goods/%@.html",self.detailModel.goodsId];
            model.type = @"1";
            model.price = [NSString stringWithFormat:@"%.2f",self.detailModel.sellPrice];
            model.sendType = @"1";
            
            NSString *imageUrl = self.detailModel.goodsImgs;
            if ([imageUrl containsString:@","]) {
                imageUrl = [imageUrl componentsSeparatedByString:@","][0];
            }
            model.goodsImage = imageUrl;
            
            //lj_will_change_end
            WEAKSELF;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
                if ([lgM loginKefuSDK]) {
                    NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
                    NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
                    NSString *chatTitle = title;
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
                        chat.goodsModel = model;
                        chat.title = title;
                        chat.sellerFirmName = weakSelf.detailModel.shopInfo.firmName;
                        [self.navigationController pushViewController:chat animated:YES];
                    });
                    
                } else {
                    hd_dispatch_main_async_safe(^(){
                        [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
                    });
                    NSLog(@"登录失败");
                }
            });//完整
            
        }
    }
    if (tag == 801) { // 药师
        
        if (!self.detailModel) {
            return;
        }
        
        NSString *userID = @"";
        NSString *title = @"客服";
        NSString *headImg = @"";
        if (self.detailModel.shopInfo) {
            title = self.detailModel.shopInfo.shopName;
            userID = [NSString stringWithFormat:@"b2c_%@",self.detailModel.shopInfo.userId];
            headImg = self.detailModel.shopInfo.logoImg;
            NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [userDic setValue:userID forKey:@"userId"];
            [userDic setValue:title forKey:@"nickname"];
            [userDic setValue:headImg forKey:@"headImg"];
            
            DCChatGoodsModel *model = [DCChatGoodsModel new];
            model.goodsName = self.detailModel.goodsName;
            model.goodsId = self.detailModel.goodsId;
            model.manufactory = self.detailModel.manufactory;
            model.item_url = [NSString stringWithFormat:@"http://mall.123ypw.com/goods/%@.html",self.detailModel.goodsId];
            model.type = @"1";
            model.price = [NSString stringWithFormat:@"%.2f",self.detailModel.sellPrice];
            model.sendType = @"1";
            NSString *imageUrl = self.detailModel.goodsImgs;
            if ([imageUrl containsString:@","]) {
                imageUrl = [imageUrl componentsSeparatedByString:@","][0];
            }
            model.goodsImage = imageUrl;
            
            //lj_will_change_end
            WEAKSELF;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
                if ([lgM loginKefuSDK]) {
                    NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
                    NSString *agent = @"ys@123ypw.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
                    NSString *chatTitle = title;
                    HDQueueIdentityInfo *queueIdentityInfo = nil;
                    HDAgentIdentityInfo *agentIdentityInfo = nil;
                    queue ? (queueIdentityInfo = [[HDQueueIdentityInfo alloc] initWithValue:queue]) : nil;
                    agent ? (agentIdentityInfo = [[HDAgentIdentityInfo alloc] initWithValue:queue]) : nil;
                    chatTitle.length == 0 ? (chatTitle = [CSDemoAccountManager shareLoginManager].cname) : nil;
                    hd_dispatch_main_async_safe((^(){
                        [weakSelf hideHud];
                        HDChatViewController *chat = [[HDChatViewController alloc] initWithConversationChatter:lgM.cname];
                        queue ? (chat.queueInfo = queueIdentityInfo) : nil;
                        agent ? (chat.agent = agentIdentityInfo) : nil;
                        chat.visitorInfo = CSDemoAccountManager.shareLoginManager.visitorInfo;
                        chat.goodsModel = model;
                        chat.frimId = [NSString stringWithFormat:@"%ld",weakSelf.detailModel.sellerFirmId];
                        chat.sellerFirmName = weakSelf.detailModel.shopInfo.firmName;
                        [self.navigationController pushViewController:chat animated:YES];
                    }));
                    
                } else {
                    hd_dispatch_main_async_safe(^(){
                        [weakSelf showHint:NSLocalizedString(@"loginFail", @"login fail") duration:1];
                    });
                    NSLog(@"登录失败");
                }
            });//完整
            
        }
        
    }
    if (tag == 802) {
        GLPShoppingCarController *shopCarVC = [[GLPShoppingCarController alloc] init];
        [self.navigationController pushViewController:shopCarVC animated:YES];
    }
    if (tag == 803) {
        // 加入购物车
        // 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 1;
            [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
        }];
    }
    if (tag == 804) {
        // 立即购买
        // 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 2;
            [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
        }];
        
    }
    
    if (tag == 805) {
        WEAKSELF;
        if ([self.detailModel.isMedical integerValue] == 2) {
            [self requestGetNewSpecList:^{
                //到货通知
                [weakSelf redirectToArrivalNotice];
            }];
        }else
            [weakSelf redirectToArrivalNotice];
        
    }
}

#pragma mark - 到货通知
- (void)redirectToArrivalNotice{
    ArrivalNoticeViewController *vc = [[ArrivalNoticeViewController alloc] init];
    vc.goodsId = self.detailModel.goodsId;
    NSString *price = [NSString stringWithFormat:@"%.2f",self.detailModel.sellPrice];
    vc.price = price;
    if ([self.detailModel.isMedical integerValue] == 2) {
        vc.serialId = self.specModelSelect.serialId;
    }else{
        vc.serialId = @"";
        vc.goodsId = self.specModelSelect.goodsId;
    }
    [self dc_pushNextController:vc];
}

- (void)dc_titleCellBtnClick:(NSInteger)tag
{
    if (!self.detailModel) {
        return;
    }
    
    if (tag == 100) { // 收藏
        if (self.detailModel.isCollection > 0) {
            [self requestCancelCollectGoods];
        } else {
            [self requestCollectGoods];
        }
    }
    
    if (tag == 101) { // 分享
        

        NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
        NSArray *imagearr = [self.detailModel.goodsImgs componentsSeparatedByString:@","];
        [[DCUMShareTool shareClient]shareInfoWithImage:[imagearr firstObject] WithTitle:self.detailModel.goodsTitle orderNo:@"" joinId:@"" goodsId:self.goodsId content:@"金利达" url:[NSString stringWithFormat:@"%@/geren/app_code.html?type=2&id=%@&userId=%@",Person_H5BaseUrl,self.goodsId,userId] completion:^(id result, NSError *error) {
        }];
    }
    
    if (tag == 102) { // 活动介绍
        GLPDetailActBeanController *vc = [GLPDetailActBeanController new];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.detailModel = self.detailModel;
        
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
    }
}

- (void)dc_storeCellBtnClick:(NSInteger)tag indexPath:(NSIndexPath *)indexPath
{
    if (!self.detailModel) {
        return;
    }
    
    if (tag == 500) { // 关注
        if (self.detailModel.shopInfo.isCollection > 0) {
            [self requestCancelCollectStore:indexPath];
        } else
            [self requestCollectStore:indexPath];
    }
    
    if (tag == 501) { // 进去店铺
        TRStorePageVC *vc = [[TRStorePageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.firmId = [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - 页面跳转
- (void)dc_pushDetailEnsureController
{
    if (!self.detailModel) {
        return;
    }
    GLPDetailEnsureController *vc = [GLPDetailEnsureController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.detailModel = self.detailModel;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)dc_pushDetailTicketController:(NSInteger)tag
{
    if (!self.detailModel) {
        return;
    }
    
    if (tag == 3) { // 平台券 无
        return;
    }
    
    GLPTicketSgnController *vc = [GLPTicketSgnController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.storeId = [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId];
    vc.goodsId = self.detailModel.goodsId;
    vc.dissmissBlock = ^{
        //weakSelf.isNoReload = YES;
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    //    GLPDetailTicketController *vc = [GLPDetailTicketController new];
    //    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    vc.detailModel = self.detailModel;
    //    vc.ticketType = tag == 1 ? GLPTicketTypeWithGoods : GLPTicketTypeWithStore;
    //
    //    [self addChildViewController:vc];
    //    [self.view addSubview:vc.view];
    
    //    [self presentViewController:vc animated:YES completion:nil];
}


- (void)dc_pushGoodsDetailsControllerWithGoodsId:(NSString *)goodsId firmId:(NSString *)firmId
{
    GLPOldGoodsDetailsController *vc = [GLPOldGoodsDetailsController new];
    vc.goodsId = goodsId;
    vc.firmId = firmId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dc_pushAddShoppingCarController
{
    if (!self.detailModel) {
        return;
    }
    
    WEAKSELF;
    GLPAddShoppingCarController *vc = [GLPAddShoppingCarController new];
    vc.detailModel = self.detailModel;
    vc.buyCount = self.buyCount;
    vc.carCellBlock = ^(NSString *countStr) {
        [weakSelf.bottomView reshnum];
        if ([countStr intValue] != weakSelf.buyCount) {
            weakSelf.buyCount = [countStr intValue];
            
            [weakSelf requestGoodsDetailAddress:weakSelf.buyCount block:^(BOOL isSuccess) {
                [weakSelf.tableView reloadData];
                /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
                 [UIView performWithoutAnimation:^{
                 [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                 }];
                 }];*/
                //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
                
            }];
        }
    };
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
}

- (void)dc_pushAllEvaluateVC
{
    if (!self.detailModel) {
        return;
    }
    NSString *params = [NSString stringWithFormat:@"id=%@&sellerFirmId=%ld",self.detailModel.goodsId,(long)self.detailModel.sellerFirmId];
    [self dc_pushPersonWebController:@"/geren/all_evaluate.html" params:params];
}


#pragma mark - 请求 商品信息
- (void)requestGoodsInfo:(BOOL)needRequest
{
    if (!_goodsId) {
        return;
    }
    
    WEAKSELF;
    group = dispatch_group_create();
    
    [SVProgressHUD show];
    
    // 商品详情
    dispatch_group_enter(group);
    [self requestNewGoodsDetail:^{
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        
        dispatch_group_leave(self->group);
        
        if (weakSelf.detailModel && weakSelf.detailModel.goodsDesc) {
            if ([weakSelf.detailModel.goodsDesc dc_isNull]) {
                weakSelf.detailModel.goodsDesc = @"";
            }
            NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                               "<head> \n"
                               "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                               "<meta name=\"format-detection\" content=\"telephone=no\" /> \n"
                               "<style type=\"text/css\"> \n"
                               "body {font-size:14px;}\n"
                               "</style> \n"
                               "</head> \n"
                               "<body>%@"
                               "<script type='text/javascript'>"
                               "window.onload = function(){\n"
                               "var $img = document.getElementsByTagName('img');\n"
                               "for(var p in  $img){\n"
                               " $img[p].style.width = '100%%';\n"
                               "$img[p].style.height ='auto'\n"
                               "}\n"
                               "}"
                               "</script>"
                               "</body>"
                               "</html>",weakSelf.detailModel.goodsDesc];
            //NSLog(@"webview html - %@",weakSelf.detailModel.goodsDesc);
            //            NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%fpx !important;height:auto}</style></head>%@",self.view.dc_width,weakSelf.detailModel.goodsDesc];
            dispatch_group_enter(self->group);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadHTMLString:htmls baseURL:nil];
            });
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (self.detailModel) {
            // 默认收货地址与运费
            dispatch_group_enter(self->group);
            [self requestGoodsDetailAddress:1 block:^(BOOL isSuccess) {
                dispatch_group_leave(self->group);
            }];
            
            // 问答、评价、浏览此商品的用户还购买了
            dispatch_group_enter(self->group);
            [self requestGoodsDetail_Question_Evaluate_Similar:^{
                dispatch_group_leave(self->group);
            }];
            
        }
        
        dispatch_group_notify(self->group, dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    });
}

#pragma mark - 请求 商品详情
- (void)requestNewGoodsDetail:(dispatch_block_t)block
{
    NSString *goodsId = _goodsId ? _goodsId : @"";
    WEAKSELF;//有促销11200513113926363094 有团购11200629172233489015
    [[DCAPIManager shareManager] person_requestNewGoodsDetailsWithGoodsId:goodsId batchId:@"" success:^(id  _Nullable response) {
        if (response && [response isKindOfClass:[GLPGoodsDetailModel class]]) {
            weakSelf.detailModel = response;
        }
        
        if (weakSelf.detailModel) {
            weakSelf.headView.detailModel = weakSelf.detailModel;
            weakSelf.bottomView.detailModel = weakSelf.detailModel;
            GLPGoodsDetailsSpecModel *specModel = [[GLPGoodsDetailsSpecModel alloc] init];
            specModel.goodsId = weakSelf.detailModel.goodsId;
            //非医药商品，isMedical=2；；；packingSpec规格可能没有, 可以不区分
            specModel.attr = weakSelf.detailModel.packingSpec.length != 0 ? weakSelf.detailModel.packingSpec : weakSelf.detailModel.goodsTitle;
            
            weakSelf.specModelSelect = specModel;
            weakSelf.lickModel.goodsList = weakSelf.detailModel.shopHotGoods;
        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}

#pragma mark - 请求 获取未读消息数量
- (void)requestNoReadMsgCount
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestNoReadMsgCountWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response[@"data"]) {
                NSInteger count = [response[@"data"] integerValue];
                weakSelf.navBar.count = count;
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 商品默认收货地址与运费信息
- (void)requestGoodsDetailAddress:(NSInteger)quantity block:(void(^)(BOOL isSuccess))block
{
//    NSString *areaId = @"";
    NSInteger logisticsTplId = 0;
    if (self.detailModel.logisticsTplId > 0) {
        logisticsTplId = self.detailModel.logisticsTplId;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] person_GetDefautAddresssuccess:^(id response) {
        GLPGoodsAddressModel *addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.addressModel = addressModel;
        [weakSelf requestTradeInfoFreightBlock:^(BOOL isSuccess) {
            block(YES);
        }];
    } failture:^(NSError *_Nullable error) {
        block(NO);
    }];
}

- (void)requestTradeInfoFreightBlock:(void(^)(BOOL isSuccess))block{
    NSString *areaId = self.addressModel.areaId ? self.addressModel.areaId : @"";
    
    NSString *goodsId = self.detailModel.goodsId ? self.detailModel.goodsId : @"";
    NSInteger logisticsTplId = self.detailModel.logisticsTplId > 0 ? self.detailModel.logisticsTplId : 0;
    NSString *goodsWeight = self.detailModel.goodsWeight ? self.detailModel.goodsWeight : @"";
    NSInteger quantity = self.buyCount>0 ? self.buyCount : 1;
    NSInteger sellerFirmId = self.detailModel.sellerFirmId>0 ? self.detailModel.sellerFirmId : 0;

    NSArray *listArr = @[@{@"goodsId":goodsId,@"logisticsTplId":@(logisticsTplId),@"goodsWeight":goodsWeight,@"quantity":@(quantity),@"sellerFirmId":@(sellerFirmId)}];
    WEAKSELF;//因为详情页只有一种商品所以
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_freightWithAreaId:areaId goodsList:listArr success:^(id  _Nullable response) {
        NSArray *listArr = [GLPGoodsAddressExpressModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        weakSelf.addressModel.expressList = listArr;
        block(YES);
    } failture:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 请求 问答、评价、浏览此商品的用户还购买了
- (void)requestGoodsDetail_Question_Evaluate_Similar:(dispatch_block_t)block
{
    NSString *goodsId = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.goodsId] : _goodsId ? _goodsId : @"";
    NSString *sellerFirmId = self.detailModel ? [NSString stringWithFormat:@"%ld",self.detailModel.sellerFirmId] : _firmId ? _firmId : @"";
    NSString *certifiNum = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.certifiNum] : @"";
    NSString *packingSpec = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.packingSpec] :  @"";
    NSString *goodsCode  = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.goodsCode ] :  @"";
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_request_goodsInfo_detail_otherInfoWithGoodsId:goodsId certifiNum:certifiNum packingSpec:packingSpec sellerFirmId:sellerFirmId goodsCode:goodsCode goodsTagNameList:@"" success:^(id  _Nullable response) {
        NSArray *questionArr = response[@"question"];
        for (NSString *str in questionArr) {
            GLPGoodsQusetionModel *model = [[GLPGoodsQusetionModel alloc] init];
            model.questionContent = str;
            [weakSelf.questionArray addObject:model];
        }
        weakSelf.evaluateModel = [GLPGoodsEvaluateModel mj_objectWithKeyValues:response[@"eval"]];
        [weakSelf.similarArray addObjectsFromArray:[GLPGoodsSimilarModel mj_objectArrayWithKeyValuesArray:response[@"orderGoods"]]];
        self.matchModel = [GLPGoodsMatchModel mj_objectWithKeyValues:response[@"prescript"]];
        block();
    } failture:^(NSError * _Nullable error) {
        block();
    }];
}

#pragma mark - 收藏 商品
- (void)requestCollectGoods
{
    NSString *price = [NSString stringWithFormat:@"%.2f",self.detailModel.sellPrice];
    WEAKSELF;
    [[DCAPIManager shareManager] person_addCollectionwithcollectionType:@"1" goodsPrice:price objectId:self.detailModel.goodsId isPrompt:NO success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            if (response && response[@"data"]) {
                weakSelf.detailModel.isCollection = [response[@"data"] integerValue];
                [weakSelf.tableView reloadData];
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 取消收藏 商品
- (void)requestCancelCollectGoods
{
    NSString *goodsId = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.goodsId] : _goodsId ? _goodsId : @"";
    WEAKSELF;
    [[DCAPIManager shareManager] person_deleNewFocusFirstwithcollectionIds:goodsId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            weakSelf.detailModel.isCollection = 0;
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
        
    }];
}

#pragma mark - 收藏 店铺
- (void)requestCollectStore:(NSIndexPath *)indexPath
{
    NSString *storeId = [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId];
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_addCollectionwithcollectionType:@"2" goodsPrice:@"" objectId:storeId isPrompt:NO success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            if (response && response[@"data"]) {
                weakSelf.detailModel.shopInfo.isCollection = [response[@"data"] integerValue];
                weakSelf.storeCollectID = [NSString stringWithFormat:@"%@",response[@"data"]];
                [weakSelf.tableView reloadData];
                /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
                 [UIView performWithoutAnimation:^{
                 [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                 }];
                 }];*/
                //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 取消收藏 店铺
- (void)requestCancelCollectStore:(NSIndexPath *)indexPath
{
    NSString *shopId = self.detailModel ? [NSString stringWithFormat:@"%ld",self.detailModel.sellerFirmId] : @"";
    WEAKSELF;
    [[DCAPIManager shareManager] person_deleNewFocusFirstwithcollectionIds:shopId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"取消关注"];
            weakSelf.detailModel.shopInfo.isCollection = 0;
            [weakSelf.tableView reloadData];
            /*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
             [UIView performWithoutAnimation:^{
             [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
             }];
             }];*/
            //而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 查询商品规格 新接口
- (void)requestGetNewSpecList:(dispatch_block_t)block
{
    if (self.specModels.count != 0) {
        block();
        return;
    }
    NSString *goodsId = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.goodsId] : _goodsId ? _goodsId : @"";
    NSString *sellerFirmId = self.detailModel ? [NSString stringWithFormat:@"%ld",self.detailModel.sellerFirmId] : _firmId ? _firmId : @"";
    NSString *certifiNum = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.certifiNum] : @"";
    
    [SVProgressHUD show];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestGetNewGoodSpecByGoodsId:goodsId certifiNum:certifiNum sellerFirmId:sellerFirmId success:^(id  _Nullable response) {
        [SVProgressHUD dismiss];
        if (response) {
            weakSelf.specModels = [GLPGoodsDetailsSpecModel mj_objectArrayWithKeyValuesArray:response];
            if ([weakSelf.detailModel.isMedical integerValue] == 2) {//非医药商品，规格默认第一个
                weakSelf.specModelSelect = [weakSelf.specModels firstObject];
                
                if (weakSelf.specModelSelect.img.length == 0) {//因为非医药商品的img goodsName 没有所以用详情里面的
                    NSMutableArray *imgurlArray = [NSMutableArray array];
                    if (weakSelf.detailModel.goodsImgs) {
                        if ([weakSelf.detailModel.goodsImgs containsString:@","]) {
                            [imgurlArray addObjectsFromArray:[weakSelf.detailModel.goodsImgs componentsSeparatedByString:@","]];
                        } else {
                            [imgurlArray addObject:weakSelf.detailModel.goodsImgs];
                        }
                    }
                    for (GLPGoodsDetailsSpecModel *model in weakSelf.specModels) {
                        model.img = [imgurlArray firstObject];
                        model.goodsTitle = weakSelf.detailModel.goodsName;
                        //model.deliveryTime = weakSelf.detailModel.deliveryTime;
                    }
                }
            }else{//医药商品根据goodsid 判断对应哪个规格
                [weakSelf.specModels enumerateObjectsUsingBlock:^(GLPGoodsDetailsSpecModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj.goodsId isEqualToString:weakSelf.detailModel.goodsId]) {
                        //obj.deliveryTime = weakSelf.detailModel.deliveryTime;
                        weakSelf.specModelSelect = obj;
                        return;
                    }
                }];
            }
            //weakSelf.specModelSelect = weakSelf.specModels;//
        }
        weakSelf.specView.sendTimeLabel.text = weakSelf.detailModel.deliveryTime;
        weakSelf.specView.specModels = weakSelf.specModels;//放在前面来标记作用
        weakSelf.specView.specModel = weakSelf.specModelSelect;
        block();
    } failture:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        block();
    }];
}

#pragma mark - 请求 获取默认收货地址
- (void)requestDefaultAddress
{
    WEAKSELF;
    [[DCAPIManager shareManager] person_GetDefautAddresssuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = response;
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                GLPGoodsAddressModel *addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:dict[@"data"]];
                if (addressModel) {
                    weakSelf.addressModel = addressModel;
                    [weakSelf.tableView reloadData];
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - UI
- (void)setUpTableView
{
    CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
    
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - 56 - height - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.f;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.clipsToBounds = NO;
    
    [self.tableView registerClass:NSClassFromString(titleCellID) forCellReuseIdentifier:titleCellID];
    [self.tableView registerClass:NSClassFromString(expressCellID) forCellReuseIdentifier:expressCellID];
    [self.tableView registerClass:NSClassFromString(ticketCellID) forCellReuseIdentifier:ticketCellID];
    [self.tableView registerClass:NSClassFromString(similarCellID) forCellReuseIdentifier:similarCellID];
    [self.tableView registerClass:NSClassFromString(matchCellID) forCellReuseIdentifier:matchCellID];
    [self.tableView registerClass:NSClassFromString(evaluateCellID) forCellReuseIdentifier:evaluateCellID];
    [self.tableView registerClass:NSClassFromString(questionCellID) forCellReuseIdentifier:questionCellID];
    [self.tableView registerClass:NSClassFromString(storeCellID) forCellReuseIdentifier:storeCellID];
    [self.tableView registerClass:NSClassFromString(recommendCellID) forCellReuseIdentifier:recommendCellID];
    [self.tableView registerClass:NSClassFromString(infoCellID) forCellReuseIdentifier:infoCellID];
    [self.tableView registerClass:NSClassFromString(GLPGoodsDetailsWebCellID) forCellReuseIdentifier:GLPGoodsDetailsWebCellID];
    [self.tableView registerClass:NSClassFromString(evaluateHeaderID) forHeaderFooterViewReuseIdentifier:evaluateHeaderID];
    [self.tableView registerClass:NSClassFromString(evaluateFooterID) forHeaderFooterViewReuseIdentifier:evaluateFooterID];
    [self.tableView registerClass:NSClassFromString(specificationsID) forCellReuseIdentifier:specificationsID];
}

#pragma mark - lazy load
- (GLPGoodsDetailsHeadView *)headView{
    if (!_headView) {
        _headView = [[GLPGoodsDetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW-kNavBarHeight)];
    }
    return _headView;
}

- (GLPGoodsDetailsBottomView *)bottomView{
    if (!_bottomView) {
        
        CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
        _bottomView = [[GLPGoodsDetailsBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - 56 - height, kScreenW, 56 + height)];
        WEAKSELF;
        _bottomView.GLPNewGoodsDetailsBottomView_block = ^(NSInteger tag) {
            [weakSelf dc_bottomViewBtnClick:tag];
        };
    }
    return _bottomView;
}

- (GLPGoodsDetailsNavigationBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLPGoodsDetailsNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _navBar.navbarBlock = ^(NSInteger tag) {
            [weakSelf dc_navBarBtnClick:tag];
        };
    }
    return _navBar;
}


- (GLBCountTFView *)countTFView{
    if (!_countTFView) {
        _countTFView = [[GLBCountTFView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _countTFView;
}


- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, 0.01) configuration:configuration];
        _webView.userInteractionEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.navigationDelegate = self;
        _webView.hidden = YES;
        
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}


- (NSMutableArray<GLPGoodsSimilarModel *> *)similarArray{
    if (!_similarArray) {
        _similarArray = [NSMutableArray array];
    }
    return _similarArray;
}

- (NSMutableArray<GLPGoodsQusetionModel *> *)questionArray{
    if (!_questionArray) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}

- (GLPGoodsMatchModel *)matchModel{
    if (!_matchModel) {
        _matchModel = [[GLPGoodsMatchModel alloc] init];
    }
    return _matchModel;
}

- (GLPOldGoodsDetailsSpecificationsView *)specView{
    if (!_specView) {
        _specView = [[GLPOldGoodsDetailsSpecificationsView alloc] init];
        WEAKSELF;
        _specView.goodsDetailsSpecificationsView_Block = ^(GLPGoodsDetailsSpecModel * _Nonnull specModel, NSInteger payCount, NSInteger defineType) {
            BOOL isNeed = NO;
            weakSelf.buyCount = payCount;
            weakSelf.specType = defineType;
            if (![weakSelf.specModelSelect isEqual:specModel]) {
                isNeed = YES;
            }
            weakSelf.specModelSelect = specModel;
            [weakSelf changeShowGoodsView:isNeed];
            [weakSelf specViewBlock];
            
        };
        _specView.GLPOldGoodsDetailsSpecificationsView_block = ^{
            //到货通知
            [weakSelf redirectToArrivalNotice];
        };
    }
    return _specView;
}

/* 改变展示的商品详情*/
- (void)changeShowGoodsView:(BOOL)needChange
{
    if ([self.detailModel.isMedical integerValue] == 2) {
        //非医药上改变gooIInfo里的主图 市场价 商城价
        //self.detailModel.goodsTitle = self.specModelSelect.goodsTitle;//不需要传回来了
        self.detailModel.marketPrice = self.specModelSelect.marketPrice;
        self.detailModel.sellPrice = self.specModelSelect.sellPrice;
        self.detailModel.totalStock = self.specModelSelect.stock;
        CGFloat spreadAmount = self.detailModel.sellPrice * self.detailModel.spreadRate;
        self.detailModel.spreadAmount = [NSString stringWithFormat:@"%.2f",spreadAmount];
        self.headView.imageArray = [self getGoodsImages:self.detailModel.goodsImgs replace:self.specModelSelect.img];
        self.bottomView.detailModel = self.detailModel;//到货通知刷新
        [self.tableView reloadData];
    }else{
        self.goodsId = self.specModelSelect.goodsId;
        if (needChange) {
            [SVProgressHUD show];
            [self requestGoodsInfo:NO];
        }
    }
}

- (NSMutableArray *)getGoodsImages:(NSString *)images replace:(NSString *)firstImg
{
    NSMutableArray *imgurlArray = [[NSMutableArray alloc] init];
    if (_detailModel.goodsImgs) {
        if ([_detailModel.goodsImgs containsString:@","]) {
            [imgurlArray addObjectsFromArray:[_detailModel.goodsImgs componentsSeparatedByString:@","]];
        } else {
            [imgurlArray addObject:_detailModel.goodsImgs];
        }
    }
    if (firstImg.length > 0) {
        [imgurlArray replaceObjectAtIndex:0 withObject:firstImg];
    }
    return imgurlArray;
}

- (void)specViewBlock{
    if (self.specType == 0) {
        //单独选规格
        //        [UIView performWithoutAnimation:^{
        //             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //        }];
    }else if(self.specType == 1){
        //加入购物车
        NSString *batchId = self.specModelSelect.batchId ? self.specModelSelect.batchId : @"";
        NSArray *cart = @[];
        NSString *goodsId = self.specModelSelect.goodsId ? self.specModelSelect.goodsId : @"";
        NSString *quantity = [NSString stringWithFormat:@"%ld",(long)self.buyCount];
        NSString *sellerFirmId = self.detailModel.sellerFirmId>0 ? [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId] : @"0";
        NSString *tradeType = @"1";
        WEAKSELF;
        [[DCAPIManager shareManager] glpRequest_b2c_tradeInfoWithGoodsId:goodsId batchId:batchId cart:cart quantity:quantity sellerFirmId:sellerFirmId tradeType:tradeType success:^(id  _Nullable response) {
            if (response) {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
                [weakSelf.bottomView reshnum];
            }
        } failture:^(NSError *_Nullable error) {
        }];
    }else if (self.specType == 2){
        //立即购买
        NSString *batchId = self.specModelSelect.batchId ? self.specModelSelect.batchId : @"";
        NSArray *cart = @[];
        NSString *goodsId = self.specModelSelect.goodsId ? self.specModelSelect.goodsId : @"";
        NSString *quantity = [NSString stringWithFormat:@"%ld",(long)self.buyCount];
        NSString *sellerFirmId = self.detailModel.sellerFirmId>0 ? [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId] : @"0";
        NSString *tradeType = @"4";
        WEAKSELF;
        [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_confirmOrderWithBatchId:batchId cart:cart goodsId:goodsId quantity:quantity sellerFirmId:sellerFirmId tradeType:tradeType success:^(id  _Nullable response) {
            GLPNewShoppingCarModel *model = [GLPNewShoppingCarModel mj_objectWithKeyValues:response[@"data"]];
            NSArray *firmList = [GLPFirmListModel mj_objectArrayWithKeyValuesArray:model.firmList];
            for (GLPFirmListModel *firmModel in firmList) {
                NSArray *actInfoList = [ActInfoListModel mj_objectArrayWithKeyValuesArray:firmModel.actInfoList];
                NSArray *cartGoodsList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:firmModel.cartGoodsList];
                NSArray *couponList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.couponList];
                NSArray *defaultCoupon = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:firmModel.defaultCoupon];
                for (ActInfoListModel *actModel in actInfoList) {
                    NSArray *actInfoList = [GLPNewShopCarGoodsModel mj_objectArrayWithKeyValuesArray:actModel.actGoodsList];
                    actModel.actGoodsList = [actInfoList mutableCopy];
                }
                firmModel.actInfoList = [actInfoList mutableCopy];
                firmModel.cartGoodsList = [cartGoodsList mutableCopy];
                firmModel.couponList = couponList;
                firmModel.defaultCoupon = defaultCoupon;
            }
            model.firmList = firmList;
            GLPConfirmOrderViewController *vc = [GLPConfirmOrderViewController new];
            vc.ispay = @"1";
            vc.mainModel = model;
            NSDictionary *dict = @{@"type":@"创建订单详情页"};//UM统计 自定义搜索关键词事件
            [MobClick event:UMEventCollection_31 attributes:dict];
            
//            vc.shoppingcarArray = array;
//            vc.ispay = @"1";
//            vc.goodsId = self.goodsId;
//            vc.quanlity = [NSString stringWithFormat:@"%ld",self.buyCount];
            
            [weakSelf dc_pushNextController:vc];
            
        } failture:^(NSError * _Nullable error) {
        }];
    }
}

- (NSArray *)specModels{
    if (!_specModels) {
        _specModels = @[];
    }
    return _specModels;
}

- (GLPGoodsLickModel *)lickModel{
    if (!_lickModel) {
        _lickModel = [[GLPGoodsLickModel alloc] init];
    }
    return _lickModel;
}


- (void)dealloc {
    [self.webView stopLoading];
    self.webView.navigationDelegate = nil;
    
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}


@end
