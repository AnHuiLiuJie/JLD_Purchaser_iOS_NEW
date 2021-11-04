//
//  GLPGoodsDetailsController.m
//  DCProject
//
//  Created by LiuMac on 2021/7/20.
//

#import "GLPGoodsDetailsController.h"
/*cell*/
//#import "GLPGoodsDetailsActivityCell.h"
#import "GLPGoodsDetailsDiscountCell.h"
#import "GLPGoodsDetailsTopCell.h"//顶部价格信息
#import "GLPGoodsDetailsAllActivityCell.h"//活动信息
#import "GLPGoodsDetailsAllDiscountCell.h"//优惠信息
#import "GLPNewGoodsDetailsTitleCell.h"//商品标题等
#import "GLPGoodsDetailsSpecificationsCell.h"//规格 运费 配送
#import "GLPGoodsDetailsExpressCell.h"//平台介绍
#import "GLPGoodsDetailsEvaluateCell.h"//评价信息
#import "GLPGoodsDetailsQuestionCell.h"//问答信息
#import "GLPGoodsDetailsTicketCell.h"//优惠券（多种）
#import "GLPGoodsDetailsSimilarCell.h"//浏览该商品还购买过
#import "GLPGoodsDetailsMatchCell.h"//处方搭配
#import "GLPGoodsDetailsStoreCell.h"//店铺
#import "GLPGoodsDetailsRecommendCell.h"//为你推荐
#import "GLPGoodsDetailsInfoCell.h"//商品详情
#import "GLPGoodsDetailsWebCell.h"//商品网页介绍
#import "GLPGoodsDetailsManualCell.h"
#import "GLPGoodsDetailsFreightCell.h"

/*view*/
#import "GLPGoodsDetailsHeadView.h"
#import "GLPGoodsDetailsBottomView.h"
#import "GLPGoodsDetailsSpecificationsView.h"
#import "GLBCountTFView.h"
#import "EtpRuleDescriptionView.h"
#import "GLPGoodsDetailsEvaluetaHeaderView.h"//商品评价
#import "GLPGoodsDetailsEvaluetaFooterView.h"//查看全部评价

/*tool*/
#import "GLPGoodsDetailsNavigationBar.h"
#import "YBPopupMenu.h"
#import "CSDemoAccountManager.h"
#import <WebKit/WebKit.h>

/*vc*/
#import "GLPShoppingCarController.h"
#import "ArrivalNoticeViewController.h"
#import "GLPEtpEntrepreneurPosterVC.h"
#import "GLPTabBarController.h"
#import "GLPMessageListVC.h"
#import "GLPGoodsShareVC.h"
#import "GLPConfirmOrderViewController.h"
#import "GLPTicketSgnController.h"
#import "GLPDetailActBeanController.h"
#import "GLPDetailEnsureController.h"
#import "TRStorePageVC.h"
#import "DCNoStockRecommendVC.h"
#import "GLPDetailRuleController.h"
#import "GLPDetailTicketController.h"
/*model*/
#import "GLPGoodsDetailsSpecModel.h"
#import "GLPGoodsSimilarModel.h"
#import "GLPGoodsQusetionModel.h"
#import "GLPNewShoppingCarModel.h"
#import "GLPGoodsAddressModel.h"

@interface GLPGoodsDetailsController ()<YBPopupMenuDelegate,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
{
    dispatch_group_t group;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GLPGoodsDetailsHeadView *headView;
@property (nonatomic, strong) GLPGoodsDetailsBottomView *bottomView;
@property (nonatomic, strong) GLPGoodsDetailsNavigationBar *navBar;
@property (nonatomic, strong) GLBCountTFView *countTFView;

/*商品详情*/
@property (nonatomic, strong) GLPGoodsDetailModel *detailModel;
/*默认地址与运费信息*/
@property (nonatomic, strong) GLPGoodsAddressModel *addressModel;
/*购买数量*/
@property (nonatomic, assign) NSInteger buyCount;
/*店铺收藏ID*/
@property (nonatomic, copy) NSString *storeCollectID;
/*用于记录点击底部功能区域 商品介绍 规格参数 售后保障*/
@property(nonatomic, assign) NSInteger selctIndexTag;
// 处方推荐
//@property (nonatomic, strong) NSMutableArray<GLPGoodsMatchModel *> *matchArray;
@property (nonatomic, strong) GLPGoodsMatchModel *matchModel;
// 猜你喜欢 推荐的
@property (nonatomic, strong) GLPGoodsLickModel *lickModel;
// 相似产品
@property (nonatomic, strong) NSMutableArray<GLPGoodsSimilarModel *> *similarArray;
// 评价模型
@property (nonatomic, strong) GLPGoodsEvaluateModel *evaluateModel;
// 问答专区
@property (nonatomic, strong) NSMutableArray<GLPGoodsQusetionModel *> *questionArray;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webHeight;

//规格
@property (nonatomic, strong) GLPGoodsDetailsSpecificationsView *specView;
@property (nonatomic, strong) NSArray *specList;
@property (nonatomic, strong) GLPGoodsDetailsSpecModel *specModelSelect;//当前选中的规格
@property (nonatomic, assign) NSInteger specType;//0 无操作 803加入购物车 8033原价购买 804立即购买 8044立即拼团

//无货时候推荐
@property (nonatomic, strong) UIView *noStockView;
// 无货时候推荐 商品列表
@property (nonatomic, strong) NSArray *noStockList;
@end

static NSString *const GLPGoodsDetailsTopCellID = @"GLPGoodsDetailsTopCell";
static NSString *const GLPGoodsDetailsAllActivityCellID = @"GLPGoodsDetailsAllActivityCell";
static NSString *const GLPGoodsDetailsAllDiscountCellID = @"GLPGoodsDetailsAllDiscountCell";
static NSString *const GLPGoodsDetailsSpecificationsCellID = @"GLPGoodsDetailsSpecificationsCell";
static NSString *const GLPNewGoodsDetailsTitleCellID = @"GLPNewGoodsDetailsTitleCell";
static NSString *const GLPGoodsDetailsDiscountCellID = @"GLPGoodsDetailsDiscountCell";
static NSString *const GLPGoodsDetailsTicketCellID = @"GLPGoodsDetailsTicketCell";
static NSString *const GLPGoodsDetailsManualCellID = @"GLPGoodsDetailsManualCell";
static NSString *const GLPGoodsDetailsFreightCellID = @"GLPGoodsDetailsFreightCell";
static NSString *const GLPGoodsDetailsExpressCellID = @"GLPGoodsDetailsExpressCell";
static NSString *const GLPGoodsDetailsEvaluateCellID = @"GLPGoodsDetailsEvaluateCell";
static NSString *const GLPGoodsDetailsQuestionCellID = @"GLPGoodsDetailsQuestionCell";
static NSString *const GLPGoodsDetailsEvaluetaFooterViewID = @"GLPGoodsDetailsEvaluetaFooterView";
static NSString *const GLPGoodsDetailsSimilarCellID = @"GLPGoodsDetailsSimilarCell";
static NSString *const GLPGoodsDetailsMatchCellID = @"GLPGoodsDetailsMatchCell";
static NSString *const GLPGoodsDetailsRecommendCellID = @"GLPGoodsDetailsRecommendCell";
static NSString *const GLPGoodsDetailsStoreCellID = @"GLPGoodsDetailsStoreCell";
static NSString *const GLPGoodsDetailsInfoCellID = @"GLPGoodsDetailsInfoCell";
static NSString *const GLPGoodsDetailsWebCellID = @"GLPGoodsDetailsWebCell";




static NSString *const GLPGoodsDetailsEvaluetaHeaderViewID = @"GLPGoodsDetailsEvaluetaHeaderView";


@implementation GLPGoodsDetailsController

#pragma mark - VIEW Load

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES animated:animated];
    [self requestNoReadMsgCount];
    if (_bottomView) {
        [_bottomView reshnum];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO animated:animated];
    GLPCustomXFView *xfView = [DC_KEYWINDOW viewWithTag:xfViewTag];
    xfView.hidden = YES;
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
//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailType = GLPGoodsDetailTypeNormal;
    
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    
    self.buyCount = 1;
    NSString  *extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
    self.extendType = extendType.length > 0 ? [extendType integerValue] : 0;
    
    [self.view addSubview:self.webView];
    
    self.tableView.hidden = NO;
    
    [self.tableView setTableHeaderView:self.headView];
    
    //    self.tableView.tableHeaderView = self.headView;
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
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        //活动信息
        if (self.specModelSelect.liaoIdx > 0) {
            return 0;//优先级 互斥
        }
        if (self.detailType == GLPGoodsDetailTypeGroup || self.detailType == GLPGoodsDetailTypeSeckill || self.detailType == GLPGoodsDetailTypeCollage) {
            return 1;
        }else
            return 0;
    }else if (section == 2) {
        //优惠信息
        NSInteger row = 0;
        if (self.detailModel.mixTips.length > 0) {
            row++;
        }
        if (self.detailModel.fullMinusTips.length > 0) {
            row++;
        }
        if (self.detailModel.couponTips.length > 0) {
            row++;
        }
        return row;
    }else if (section == 6){
        // 店铺优惠卷
        if (self.detailModel.storeCoupons.couponsId.length != 0 || self.detailModel.bossCoupons.couponsId.length != 0 || self.detailModel.goodsCoupons.couponsId.length != 0) {
            return 1;
        }else
            return 0;
    }else if (section == 7){
        //浏览过商品的用户还购买
        if (self.similarArray.count > 0) {
            return 1;
        }
        else{
            return 0;
        }
    }else if (section == 8){
        //处方搭配
        if (self.matchModel.goodsList.count > 0) {
            return 1;
        }
        else{
            return 0;
        }
    }else if (section == 9) {
        //评价体系
        if (self.evaluateModel && [self.evaluateModel.evalList count] > 0) {
            return self.evaluateModel.evalList.count > 2 ? 2 : self.evaluateModel.evalList.count;
        } else {
            return 0;
        }
    }else if (section == 10) {
        //问答专区
        if (self.questionArray.count > 0) {
            return 1;
        } else {
            return 1;
        }
    }else if (section == 12) {
        //猜你喜欢 为你推荐 店铺热销
        if (self.lickModel && self.lickModel.goodsList && self.lickModel.goodsList.count > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        //商品价格
        GLPGoodsDetailsTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsTopCellID forIndexPath:indexPath];
        if (_detailModel) {
            topCell.detailType = self.detailType;
            topCell.detailModel = self.detailModel;
        }
        topCell.GLPGoodsDetailsTopCell_block = ^(NSString * _Nonnull title) {
            if ([title isEqualToString:@"收藏"]) {
                if (weakSelf.detailModel.isCollection > 0) {
                    [weakSelf requestCancelCollectGoods];
                } else {
                    [weakSelf requestCollectGoods];
                }
            }else if([title isEqualToString:@"分享"]){
                NSString *userId = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
                NSArray *imagearr = [weakSelf.detailModel.goodsImgs componentsSeparatedByString:@","];
                [[DCUMShareTool shareClient]shareInfoWithImage:[imagearr firstObject] WithTitle:weakSelf.detailModel.goodsTitle orderNo:@"" joinId:@"" goodsId:weakSelf.goodsId content:@"金利达" url:[NSString stringWithFormat:@"%@/geren/app_code.html?type=2&id=%@&userId=%@",Person_H5BaseUrl,weakSelf.goodsId,userId] completion:^(id result, NSError *error) {
                }];
            }
        };
        cell = topCell;
    }else if(indexPath.section == 1){
        //活动信息
        GLPGoodsDetailsAllActivityCell *activityCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsAllActivityCellID forIndexPath:indexPath];
        if (_detailModel) {
            activityCell.detailType = self.detailType;
            activityCell.detailModel = self.detailModel;
        }
        activityCell.GLPGoodsDetailsAllActivityCell_block = ^(NSString * _Nonnull title) {
            if ([title isEqualToString:@"活动结束"]) {
                
            }else if([title isEqualToString:@"规则详情"]){
                
                [weakSelf dc_pushDetailRuleeController];
            }
        };
        cell = activityCell;
    }else if(indexPath.section == 2){
        //优惠信息
        GLPGoodsDetailsAllDiscountCell *discountCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsAllDiscountCellID forIndexPath:indexPath];
        if (_detailModel.mixTips.length > 0 && indexPath.row == 0) {
            discountCell.showType = 0;
        }else{
            if (_detailModel.couponTips.length > 0 && _detailModel.fullMinusTips.length == 0 ) {
                discountCell.showType = 11;
            }else if (_detailModel.couponTips.length == 0 && _detailModel.fullMinusTips.length != 0 ) {
                discountCell.showType = 12;
            }else if(_detailModel.couponTips.length != 0 && _detailModel.fullMinusTips.length != 0 ){
                discountCell.showType = indexPath.row;
            }
        }
        if (_detailModel) {
            discountCell.detailType = self.detailType;
            discountCell.detailModel = self.detailModel;
        }
        discountCell.GLPGoodsDetailsAllDiscountCell_block = ^(NSString * _Nonnull title) {
            if ([title isEqualToString:@"更多"]) {
                GLPDetailActBeanController *vc = [GLPDetailActBeanController new];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                vc.detailModel = self.detailModel;
                [weakSelf addChildViewController:vc];
                [weakSelf.view addSubview:vc.view];
            }else if([title isEqualToString:@"立即领取"]){
                [weakSelf dc_pushDetailTicketController:2];
            }else if([title isEqualToString:@"查看"]){
                // 商品规格
                [weakSelf requestGetNewSpecList:^{
                    weakSelf.specType = 0;
                    if (!weakSelf.specView.isShow) {
                        [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
                    }
                }];
            }
        };
        cell = discountCell;
    }else if(indexPath.section == 3){
        //商品详情等信息
        GLPNewGoodsDetailsTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:GLPNewGoodsDetailsTitleCellID forIndexPath:indexPath];
        if (_detailModel) {
            titleCell.detailType = self.detailType;
            titleCell.detailModel = self.detailModel;
        }
        cell = titleCell;
    }else if(indexPath.section == 4){
        //规格 运费得
        GLPGoodsDetailsSpecificationsCell *specCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsSpecificationsCellID forIndexPath:indexPath];
        if (self.specModelSelect) {
            if (self.specModelSelect.liaoIdx > 0) {
                GLPMarketingMixListModel *marketModel = weakSelf.specModelSelect.marketingMixList[weakSelf.specModelSelect.liaoIdx-1];
                specCell.specificationsStr = [NSString stringWithFormat:@"%@（%@）",self.specModelSelect.attr,marketModel.mixTip];
            }else
                specCell.specificationsStr = self.specModelSelect.attr;
        }
        if (self.addressModel) {
            specCell.addressModel = self.addressModel;
        }
        if (_detailModel) {
            specCell.detailModel = self.detailModel;
        }
        WEAKSELF;
        specCell.GLPGoodsDetailsSpecificationsCell_block = ^{
            // 商品规格
            [weakSelf requestGetNewSpecList:^{
                weakSelf.specType = 0;
                if (!weakSelf.specView.isShow) {
                    [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
                }
            }];
        };
        cell = specCell;
    }else if(indexPath.section == 5){
        //平台介绍
        GLPGoodsDetailsExpressCell *expressCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsExpressCellID forIndexPath:indexPath];
        if (self.detailModel) {
            expressCell.detailModel = self.detailModel;
        }
        expressCell.GLPGoodsDetailsExpressCell_block = ^{
            [weakSelf dc_pushDetailEnsureController];
        };
        cell = expressCell;
    }else if(indexPath.section == 6){
        // 店铺优惠卷
        GLPGoodsDetailsTicketCell *discountCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsTicketCellID forIndexPath:indexPath];
        if (_detailModel) {
            discountCell.detailModel = self.detailModel;
        }
        discountCell.GLPGoodsDetailsTicketCell_block = ^(NSInteger tag) {
            [weakSelf dc_pushDetailTicketController:tag];
        };
        cell = discountCell;
    } else if (indexPath.section == 7) {
        //浏览过商品的用户还购买
        GLPGoodsDetailsSimilarCell *similarCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsSimilarCellID forIndexPath:indexPath];
        if (self.similarArray.count > 0) {
            similarCell.similarArray = self.similarArray;
        }
        similarCell.similarCellBlock = ^(GLPGoodsSimilarModel *model) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:model.goodsId firmId:@"" batchId:model.batchId];
        };
        cell = similarCell;
    }else if (indexPath.section == 8) {//http://wzgk4us5du.52http.net/b2c/goods/prescript mall_LgQj55+ELHIpfjbth1o2yIRUUfY1oqtuzUnvWShc4cPv9lf6Kexogg== 3099 20210602170022008 d6964a7bcc6ced056a48a2c048f97c24
        //处方搭配
        GLPGoodsDetailsMatchCell *matchCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsMatchCellID forIndexPath:indexPath];
        if (self.matchModel.goodsList.count > 0) {
            matchCell.matchModel = self.matchModel;
        }
        matchCell.matchCellBlock = ^(GLPGoodsMatchGoodsModel *goodsModel) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:goodsModel.iD firmId:goodsModel.sellerFirmId batchId:goodsModel.batchId];
        };
        cell = matchCell;
    }else if (indexPath.section == 9) {
        //评价体系
        GLPGoodsDetailsEvaluateCell *evaluateCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsEvaluateCellID forIndexPath:indexPath];
        if (self.evaluateModel && self.evaluateModel.evalList.count > 0) {
            evaluateCell.listModel = self.evaluateModel.evalList[indexPath.row];
        }
        cell = evaluateCell;
    } else if (indexPath.section == 10) {
        //问答专区
        GLPGoodsDetailsQuestionCell *questionCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsQuestionCellID forIndexPath:indexPath];
        questionCell.questionArray = self.questionArray;
        questionCell.questionCellBlock = ^{
            if (weakSelf.detailModel) {
                NSString *params = [NSString stringWithFormat:@"id=%@",weakSelf.detailModel.goodsId];
                [weakSelf dc_pushPersonWebController:@"/geren/quest_answer.html" params:params];
            }
        };
        cell = questionCell;
    }else if (indexPath.section == 11) {
        //店铺
        GLPGoodsDetailsStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsStoreCellID forIndexPath:indexPath];
        if (self.detailModel) {
            storeCell.detailModel = self.detailModel;
        }
        storeCell.GLPGoodsDetailsStoreCell_block = ^(NSInteger tag) {
            [weakSelf dc_storeCellBtnClick:tag indexPath:indexPath];
        };
        cell = storeCell;
    } else if (indexPath.section == 12) {
        //猜你喜欢 为你推荐 店铺热销
        GLPGoodsDetailsRecommendCell *recommendCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsRecommendCellID forIndexPath:indexPath];
        if (self.lickModel) {
            recommendCell.lickModel = self.lickModel;
        }
        recommendCell.recommendCellBlock = ^(GLPGoodsLickGoodsModel *goodsModel) {
            [weakSelf dc_pushGoodsDetailsControllerWithGoodsId:goodsModel.iD firmId:goodsModel.sellerFirmId batchId:goodsModel.batchId];
        };
        cell = recommendCell;
        
    } else if (indexPath.section == 13) {
        //商品详情
        GLPGoodsDetailsInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:GLPGoodsDetailsInfoCellID forIndexPath:indexPath];
        infoCell.infoblock = ^(NSInteger tag) {
            weakSelf.selctIndexTag = tag;
            NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
            [idxSet addIndex:9];
            [idxSet addIndex:10];
            [weakSelf.tableView reloadData];
        };
        infoCell.selctButton = [NSString stringWithFormat:@"%ld",self.selctIndexTag];
        infoCell.detailModel = self.detailModel;
        cell = infoCell;
    } else if (indexPath.section == 14) {
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
    if (section<4) {
        return 0.01f;
    }
    if (section == 6){
        if (self.detailModel.storeCoupons.couponsId.length != 0 || self.detailModel.bossCoupons.couponsId.length != 0 || self.detailModel.goodsCoupons.couponsId.length != 0) {
            return 5.01f;
        }else
            return 0.01f; 
    }else if (section == 7) {
        if (self.similarArray.count > 0) {
            return 5.01f;
        }else
            return 0.01f;
    }else if (section == 8){
        if (self.matchModel.goodsList.count > 0) {
            return 5.01f;
        }else
            return 0.01f;
    }else if (section == 9) {
        //评价体系
            return 44.01f;

    }else if (section == 10) {
        if (self.questionArray.count > 0) {
            return 5.01f;
        }else
            return 5.01f;

    }else if (section == 12) {
        if (self.lickModel && self.lickModel.goodsList && self.lickModel.goodsList.count > 0) {
            return 5.0f;
        } else
            return 0.01f;
    }
    return 5.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 8){
        return 5.0f;
    }else if (section == 9) {
        //评价体系
        return 0.01f;//return 75.0f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 9) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
    }
    WEAKSELF;
    GLPGoodsDetailsEvaluetaHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GLPGoodsDetailsEvaluetaHeaderViewID];
    if (self.evaluateModel) {
        header.evaluateModel = self.evaluateModel;
    }
    header.allEvaluateBlock = ^{
        [weakSelf dc_pushAllEvaluateVC];
    };
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section != 9) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
//    }
//    WEAKSELF;
//    GLPGoodsDetailsEvaluetaFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GLPGoodsDetailsEvaluetaFooterViewID];
//    footer.allEvaluateBlock = ^{
//        [weakSelf dc_pushAllEvaluateVC];
//    };
//    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 11) {
        [self dc_storeCellBtnClick:501 indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [_tableView sendSubviewToBack:_headView];
    }
}

#pragma mark - 页面跳转
//平台商品退换货保障 政策说明
- (void)dc_pushDetailEnsureController
{
    if (!self.detailModel) {
        return;
    }
    GLPDetailEnsureController *vc = [GLPDetailEnsureController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.detailModel = self.detailModel;
    
    [self addChildViewController:vc];
    [self.tableView.superview addSubview:vc.view];
}

//规则说明
- (void)dc_pushDetailRuleeController
{
    GLPDetailRuleController *vc = [GLPDetailRuleController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.titile_str = @"规则详情";
    vc.content_str = @"拼团规则";
    [self addChildViewController:vc];
    [self.tableView.superview addSubview:vc.view];
    
//    EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
//    view.titile_str = @"规则详情";
//    view.content_str = @"拼团规则";
//    view.frame = DC_KEYWINDOW.bounds;
//    [DC_KEYWINDOW addSubview:view];
}

//评价体系
- (void)dc_pushAllEvaluateVC
{
    if (!self.detailModel) {
        return;
    }
    NSString *params = [NSString stringWithFormat:@"id=%@&sellerFirmId=%ld",self.detailModel.goodsId,(long)self.detailModel.sellerFirmId];
    [self dc_pushPersonWebController:@"/geren/all_evaluate.html" params:params];
}

//优惠券
- (void)dc_pushDetailTicketController:(NSInteger)tag{
    GLPDetailTicketController * vc = [GLPDetailTicketController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.detailModel = self.detailModel;
    vc.ticketType = tag == 1 ? GLPTicketTypeWithGoods : GLPTicketTypeWithStore;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    GLPTicketSgnController *vc = [GLPTicketSgnController new];
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    vc.storeId = [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId];
//    vc.goodsId = self.detailModel.goodsId;
//    vc.dissmissBlock = ^{
//        //weakSelf.isNoReload = YES;
//    };
//
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
}

//商品详情
- (void)dc_pushGoodsDetailsControllerWithGoodsId:(NSString *)goodsId firmId:(NSString *)firmId batchId:(NSString *)batchId{
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = goodsId;
    vc.firmId = firmId;
    vc.batchId = batchId;
    [self.navigationController pushViewController:vc animated:YES];
}

//店铺信息
- (void)dc_storeCellBtnClick:(NSInteger)tag indexPath:(NSIndexPath *)indexPath{
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


#pragma mark - 请求 商品信息
- (void)requestGoodsInfo:(BOOL)needRequest
{
    if (!_goodsId) return;
    
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
            dispatch_group_enter(self->group);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadHTMLString:htmls baseURL:nil];
            });
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        if (weakSelf.detailModel) {
            // 默认收货地址与运费
            [weakSelf requestGoodsDetailAddress:1 block:^(BOOL isSuccess) {
                [weakSelf.tableView reloadData];
            }];
            
            // 问答、评价、浏览此商品的用户还购买了
            [weakSelf requestGoodsDetail_Question_Evaluate_Similar:^{
                [weakSelf.tableView reloadData];
            }];
        }
        
    });
}

#pragma mark - 请求 商品详情
- (void)requestNewGoodsDetail:(dispatch_block_t)block
{
    NSString *goodsId = _goodsId ? _goodsId : @"";
    NSString *batchId = _batchId ? _batchId : @"";
    WEAKSELF;//有促销11200513113926363094 有团购11200629172233489015
    [[DCAPIManager shareManager] person_requestNewGoodsDetailsWithGoodsId:goodsId batchId:batchId success:^(id  _Nullable response) {
        if (response && [response isKindOfClass:[GLPGoodsDetailModel class]]) {
            weakSelf.detailModel = response;
        }
        
        if (weakSelf.detailModel) {
            weakSelf.detailType =  GLPGoodsDetailTypeNormal;//重置
            [weakSelf.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
                BOOL isYES = NO;
                if ([weakSelf.detailModel.isMedical integerValue] == 2) {
                    //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
                    if ([weakSelf.detailModel.attr.batchId isEqualToString:actModel.batchId]) {
                        isYES = YES;
                    }
                }else{
                    isYES = YES;
                }
                if (isYES) {
                    if([actModel.actType isEqualToString:@"group"]) {
                        weakSelf.detailType =  GLPGoodsDetailTypeGroup; // 团购
                    }else if([actModel.actType isEqualToString:@"seckill"]) {
                        weakSelf.detailType = GLPGoodsDetailTypeSeckill;//秒杀
                    }else if([actModel.actType isEqualToString:@"collage"]) {
                        weakSelf.detailType = GLPGoodsDetailTypeCollage;//拼团
                    }
                }
                if([actModel.actType isEqualToString:@"coupon"]) {
                    weakSelf.detailType =  GLPGoodsDetailTypeCoupon; // 单品优惠券
                }else if([actModel.actType isEqualToString:@"freePostage"]) {
                    //weakSelf.detailType =  GLPGoodsDetailTypeFreePostage; // 包邮活动 这个单独遍历查询
                }else if([actModel.actType isEqualToString:@"fullMinus"]) {
                    weakSelf.detailType =  GLPGoodsDetailTypFullMinus; // 满减
                }
            }];

            if (weakSelf.detailModel.attr != nil && weakSelf.detailModel.attr.goodsId.length != 0  && weakSelf.batchId.length > 0) {
                
                if ([weakSelf.detailModel.isMedical integerValue] == 2) {
                    //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
                    [weakSelf.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([weakSelf.batchId isEqualToString:actModel.batchId]) {
                            if([actModel.actType isEqualToString:@"group"]) {
                                weakSelf.detailModel.attr.group = actModel; // 团购
                            }else if([actModel.actType isEqualToString:@"seckill"]) {
                                weakSelf.detailModel.attr.seckillAct = actModel;//秒杀
                            }else if([actModel.actType isEqualToString:@"collage"]) {
                                weakSelf.detailModel.attr.collageAct = actModel;//拼团
                            }
                        }
                    }];
                    
                    NSMutableArray *newActivities = [weakSelf.detailModel.activities mutableCopy];
                    [weakSelf.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
                        if([actModel.actType isEqualToString:@"seckill"]) {
                            [newActivities removeObject:actModel];//秒杀
                        }else if([actModel.actType isEqualToString:@"collage"]) {
                            [newActivities removeObject:actModel];//拼团
                        }else if([actModel.actType isEqualToString:@"coupon"]) {
                            [newActivities removeObject:actModel]; // 单品优惠券
                        }
                    }];
                    
                    if (weakSelf.detailModel.attr.seckillAct.actId.length > 0) {
                        [newActivities addObject:weakSelf.detailModel.attr.seckillAct];
                    }
                    if (weakSelf.detailModel.attr.collageAct.actId.length > 0) {
                        [newActivities addObject:weakSelf.detailModel.attr.collageAct];
                    }
                    if (weakSelf.detailModel.attr.group.actId.length > 0) {
                        [newActivities addObject:weakSelf.detailModel.attr.group];
                    }
                    
                    weakSelf.detailModel.activities = newActivities;
                }
            
                weakSelf.specModelSelect = weakSelf.detailModel.attr;
            }else{
                if (weakSelf.specModelSelect.goodsId.length > 0) {
                    if (weakSelf.specModelSelect.liaoIdx > 0) {
                        GLPMarketingMixListModel *marketModel = weakSelf.specModelSelect.marketingMixList[weakSelf.specModelSelect.liaoIdx-1];
                        CGFloat sellPrice = weakSelf.specModelSelect.sellPrice;
                        CGFloat goodOldPrice = weakSelf.specModelSelect.marketPrice;
                        CGFloat sellOldPrice = sellPrice *  [marketModel.mixNum floatValue];
                        sellPrice = [marketModel.price floatValue] * [marketModel.mixNum floatValue];//goodOldPrice
                        goodOldPrice = sellOldPrice-sellPrice;
                        if (goodOldPrice > 0) {
                            weakSelf.detailModel.liaoOldPrice = [NSString stringWithFormat:@"%0.2f",goodOldPrice];
                        }
                        weakSelf.detailModel.liaoPrice = [NSString stringWithFormat:@"%.2f",sellPrice];
                        
                    }else{
                        weakSelf.detailModel.liaoPrice = @"";
                    }
                }else{
                    GLPGoodsDetailsSpecModel *specModel = [[GLPGoodsDetailsSpecModel alloc] init];
                    specModel.goodsId = weakSelf.detailModel.goodsId;
//                    specModel.batchId = weakSelf.batchId;

                    //非医药商品，isMedical=2；；；packingSpec规格可能没有, 可以不区分
                    specModel.attr = (weakSelf.detailModel.packingSpec.length != 0 && ![weakSelf.detailModel.packingSpec isEqualToString:@"请选择规格"]) ? weakSelf.detailModel.packingSpec : weakSelf.detailModel.goodsTitle;
                    weakSelf.specModelSelect = specModel;
                }
            }
            
            weakSelf.headView.detailModel = weakSelf.detailModel;
            [weakSelf upToDateBottomView];
            
            if (weakSelf.detailModel.totalStock == 0) {
                [weakSelf requestNoStockRecommend:^{
                }];
            }

        }
        block();
    } failture:^(NSError *error) {
        block();
    }];
}

#pragma mark - 请求 商品无库存情况下，查询推荐产品
- (void)requestNoStockRecommend:(dispatch_block_t)block{
    WEAKSELF;
    [[DCAPIManager shareManager] personRequest_b2c_goodsInfo_detail_noStockRecommendWithGoodsId:self.detailModel.goodsId goodsName:self.detailModel.goodsName success:^(id  _Nullable response) {
        NSArray *list = [GLPGoodsLickGoodsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        weakSelf.noStockList = list;
        if (list.count == 0) {
            //请求商品无库存情况下，查询推荐产品
            weakSelf.noStockView.hidden = YES;
        }else
            weakSelf.noStockView.hidden = NO;
    } failture:^(NSError * _Nullable error) {
        
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

#pragma mark - 请求费计算接口
- (void)requestTradeInfoFreightBlock:(void(^)(BOOL isSuccess))block{
    NSString *areaId = self.addressModel.areaId ? self.addressModel.areaId : @"";
    NSString *goodsId = self.detailModel.goodsId ? self.detailModel.goodsId : @"";
    NSInteger logisticsTplId = self.detailModel.logisticsTplId > 0 ? self.detailModel.logisticsTplId : 0;
    NSString *goodsWeight = self.detailModel.goodsWeight ? self.detailModel.goodsWeight : @"";
    NSInteger quantity = self.buyCount>0 ? self.buyCount : 1;
    NSInteger sellerFirmId = self.detailModel.sellerFirmId>0 ? self.detailModel.sellerFirmId : 0;
    NSString *goodsSubtotal = [NSString stringWithFormat:@"%.2f",self.detailModel.sellPrice];//（商品小计，明细页面传入单价、订单确认页面传入后台给的goodsSubtotal）
    __block NSString *freeShippingId = @"";//freeShippingId（包邮活动的Id，若存在）
    [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
        if([actModel.actType isEqualToString:@"freePostage"]) {
            //self.detailType =  GLPGoodsDetailTypeFreePostage; // 包邮活动 这个单独遍历查询
            freeShippingId = actModel.actId;
        }
    }];
    
    NSArray *listArr = @[@{@"goodsId":goodsId,@"logisticsTplId":@(logisticsTplId),@"goodsWeight":goodsWeight,@"quantity":@(quantity),@"sellerFirmId":@(sellerFirmId),@"freeShippingId":freeShippingId,@"goodsSubtotal":goodsSubtotal}];
    WEAKSELF;//因为详情页只有一种商品所以
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_freightWithAreaId:areaId goodsList:listArr success:^(id  _Nullable response) {
        NSArray *listArr = [GLPGoodsAddressExpressModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        weakSelf.addressModel.expressList = listArr;
        block(YES);
    } failture:^(NSError * _Nullable error) {
        block(NO);
    }];
}

#pragma mark - 请求 商品默认收货地址
- (void)requestGoodsDetailAddress:(NSInteger)quantity block:(void(^)(BOOL isSuccess))block
{
    NSInteger logisticsTplId = 0;
    if (self.detailModel.logisticsTplId > 0) {
        logisticsTplId = self.detailModel.logisticsTplId;
    }
    WEAKSELF;
    [[DCAPIManager shareManager] person_GetDefautAddresssuccess:^(id response) {
        GLPGoodsAddressModel *addressModel = [GLPGoodsAddressModel mj_objectWithKeyValues:response[@"data"]];
        weakSelf.addressModel = addressModel;
        [weakSelf requestTradeInfoFreightBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                block(YES);
            }else{
                block(NO);
            }
        }];
    } failture:^(NSError *_Nullable error) {
        block(NO);
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
    NSString *goodsTagNameList  = self.detailModel ? [NSString stringWithFormat:@"%@",self.detailModel.goodsTagNameList] :  @"";;//商品标签

    WEAKSELF;
    [[DCAPIManager shareManager] person_request_goodsInfo_detail_otherInfoWithGoodsId:goodsId certifiNum:certifiNum packingSpec:packingSpec sellerFirmId:sellerFirmId goodsCode:goodsCode goodsTagNameList:goodsTagNameList success:^(id  _Nullable response) {
        NSArray *questionArr = response[@"question"];
        for (NSString *str in questionArr) {
            GLPGoodsQusetionModel *model = [[GLPGoodsQusetionModel alloc] init];
            model.questionContent = str;
            [weakSelf.questionArray addObject:model];
        }
        weakSelf.evaluateModel = [GLPGoodsEvaluateModel mj_objectWithKeyValues:response[@"eval"]];
        [weakSelf.similarArray addObjectsFromArray:[GLPGoodsSimilarModel mj_objectArrayWithKeyValuesArray:response[@"orderGoods"]]];
        weakSelf.matchModel = [GLPGoodsMatchModel mj_objectWithKeyValues:response[@"prescript"]];
        
        NSArray *shopHotGoods = [GLPGoodsLickGoodsModel mj_objectArrayWithKeyValuesArray:response[@"shopHotGoods"]];
        weakSelf.lickModel.goodsList = shopHotGoods;
        weakSelf.detailModel.shopHotGoods = shopHotGoods;
        weakSelf.lickModel.hotGoodsTitle = response[@"hotGoodsTitle"];
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
        if (response && response[@"data"]) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            weakSelf.detailModel.isCollection = [response[@"data"] integerValue];
            [weakSelf.tableView reloadData];
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
        if (response && response[@"data"]) {
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            weakSelf.detailModel.shopInfo.isCollection = [response[@"data"] integerValue];
            weakSelf.storeCollectID = [NSString stringWithFormat:@"%@",response[@"data"]];
            [weakSelf.tableView reloadData];//标注一下
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
            [weakSelf.tableView reloadData];//标注一下
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - 请求 查询商品规格 新接口
- (void)requestGetNewSpecList:(dispatch_block_t)block
{
    if (self.specList.count != 0) {
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
            NSArray *specList = [GLPGoodsDetailsSpecModel mj_objectArrayWithKeyValuesArray:response];
            for (GLPGoodsDetailsSpecModel *attrModel in specList) {
                NSArray *list = [GLPMarketingMixListModel mj_objectArrayWithKeyValuesArray:attrModel.marketingMixList];
                attrModel.marketingMixList = list;
                attrModel.collageAct = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attrModel.collageAct];
                attrModel.seckillAct = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attrModel.seckillAct];
                attrModel.group = [GLPGoodsActivitiesModel mj_objectWithKeyValues:attrModel.group];
            }
            weakSelf.specList = [specList mutableCopy];
            if ([weakSelf.detailModel.isMedical integerValue] == 2) {//非医药商品 改了
                if (weakSelf.batchId.length != 0) {
                    [weakSelf.specList enumerateObjectsUsingBlock:^(GLPGoodsDetailsSpecModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                        if ([weakSelf.batchId isEqualToString:obj.batchId]) {
                            weakSelf.specModelSelect = obj;
                        }
                    }];
                }else{
                    weakSelf.specModelSelect = [weakSelf.specList firstObject];
                }
                
                if (weakSelf.specModelSelect.img.length == 0) {//因为非医药商品的img goodsName 没有所以用详情里面的
                    NSMutableArray *imgurlArray = [NSMutableArray array];
                    if (weakSelf.detailModel.goodsImgs) {
                        if ([weakSelf.detailModel.goodsImgs containsString:@","]) {
                            [imgurlArray addObjectsFromArray:[weakSelf.detailModel.goodsImgs componentsSeparatedByString:@","]];
                        } else {
                            [imgurlArray addObject:weakSelf.detailModel.goodsImgs];
                        }
                    }
                    for (GLPGoodsDetailsSpecModel *model in weakSelf.specList) {
                        model.img = [imgurlArray firstObject];
                        model.goodsTitle = weakSelf.detailModel.goodsName;
                        //model.deliveryTime = weakSelf.detailModel.deliveryTime;
                    }
                }
            }else{//医药商品根据goodsid 判断对应哪个规格
                [weakSelf.specList enumerateObjectsUsingBlock:^(GLPGoodsDetailsSpecModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj.goodsId isEqualToString:weakSelf.detailModel.goodsId]) {
                        //obj.deliveryTime = weakSelf.detailModel.deliveryTime;
                        weakSelf.specModelSelect = obj;
                        return;
                    }
                }];
            }
            //weakSelf.specModelSelect = weakSelf.specList;//
        }
        weakSelf.specView.sendTimeLabel.text = weakSelf.detailModel.deliveryTime;
        weakSelf.specView.specList = weakSelf.specList;//放在前面来标记作用
        weakSelf.specView.specModel = weakSelf.specModelSelect;
        block();
    } failture:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        block();
    }];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
        CGFloat orgY5 = [self.tableView rectForSection:9].origin.y;
        CGFloat orgY9 = [self.tableView rectForSection:12].origin.y;
        CGFloat orgY10 = [self.tableView rectForSection:13].origin.y;
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

#pragma mark - action
- (void)dc_navBarBtnClick:(NSInteger)tag{
    if (tag == 700) {
        if (self.presentingViewController) {
            GLPTabBarController *vc = [[GLPTabBarController alloc] init];
            vc.selectedIndex = 0;
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
        CGFloat orgY5 = [self.tableView rectForSection:9].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY5) animated:NO];
    }
    if (tag == 704) { // 推荐
        CGFloat orgY9 = [self.tableView rectForSection:12].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY9) animated:NO];
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:8] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if (tag == 705) { // 详情
        CGFloat orgY10 = [self.tableView rectForSection:13].origin.y;
        [self.tableView setContentOffset:CGPointMake(0, orgY10) animated:NO];
    }
}

//底部Tool按钮点击事件
- (void)dc_bottomViewBtnClick:(NSInteger)tag
{
    if (!self.detailModel) return;
    
    if (tag == 800) { // 客服
        [self contactCustomerServiceType:1];
    }
    if (tag == 801) { // 药师
        [self contactCustomerServiceType:2];
    }
    if (tag == 802) {
        GLPShoppingCarController *vc = [[GLPShoppingCarController alloc] init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 803) {
        // 加入购物车 -> 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 803;
            [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
        }];
    }
    if (tag == 8033) {
        // 立即购买 -> 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 8033;
            [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
        }];
    }
    if (tag == 804) {
        // 立即购买 -> 商品规格
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 804;
            [weakSelf.specView showType:weakSelf.specType buyCount:weakSelf.buyCount];
        }];
    }
    if (tag == 8044) {
        //立即开团
        WEAKSELF;
        [self requestGetNewSpecList:^{
            weakSelf.specType = 8044;
            [weakSelf specViewBlock:weakSelf.specType];
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

//联系客服
- (void)contactCustomerServiceType:(NSInteger)type{
    
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
        
        WEAKSELF;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
            if ([lgM loginKefuSDK]) {
                NSString *queue = nil;//HDQueueIdentityInfo *queueInfo; //指定技能组 DC_Message_preSale_Key DC_Message_afterSale_Key
                NSString *agent = @"1103975666@qq.com";//HDAgentIdentityInfo *agent; //指定客服 @"1103975666@qq.com" @"ys@123ypw.com"
                if (type == 2) {
                    agent = @"ys@123ypw.com";
                }
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
                    chat.title = title;
                    if (type == 2) {
                        chat.frimId = [NSString stringWithFormat:@"%ld",weakSelf.detailModel.sellerFirmId];
                    }
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

#pragma mark - Lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - 56 - height - kNavBarHeight);
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        
        //        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsActivityCellID) forCellReuseIdentifier:GLPGoodsDetailsActivityCellID];
        //        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsActivityGroupCellID) forCellReuseIdentifier:GLPGoodsDetailsActivityGroupCellID];
        //        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsActivityPreSaleCellID) forCellReuseIdentifier:GLPGoodsDetailsActivityPreSaleCellID];
        
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsTopCellID) forCellReuseIdentifier:GLPGoodsDetailsTopCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsAllActivityCellID) forCellReuseIdentifier:GLPGoodsDetailsAllActivityCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsAllDiscountCellID) forCellReuseIdentifier:GLPGoodsDetailsAllDiscountCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsSpecificationsCellID) forCellReuseIdentifier:GLPGoodsDetailsSpecificationsCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsExpressCellID) forCellReuseIdentifier:GLPGoodsDetailsExpressCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsEvaluateCellID) forCellReuseIdentifier:GLPGoodsDetailsEvaluateCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsQuestionCellID) forCellReuseIdentifier:GLPGoodsDetailsQuestionCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsSimilarCellID) forCellReuseIdentifier:GLPGoodsDetailsSimilarCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsMatchCellID) forCellReuseIdentifier:GLPGoodsDetailsMatchCellID];
    
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsStoreCellID) forCellReuseIdentifier:GLPGoodsDetailsStoreCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsRecommendCellID) forCellReuseIdentifier:GLPGoodsDetailsRecommendCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsInfoCellID) forCellReuseIdentifier:GLPGoodsDetailsInfoCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsWebCellID) forCellReuseIdentifier:GLPGoodsDetailsWebCellID];
        
        
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsEvaluetaHeaderViewID) forHeaderFooterViewReuseIdentifier:GLPGoodsDetailsEvaluetaHeaderViewID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsEvaluetaFooterViewID) forHeaderFooterViewReuseIdentifier:GLPGoodsDetailsEvaluetaFooterViewID];

        
        
        
        [_tableView registerClass:NSClassFromString(GLPNewGoodsDetailsTitleCellID) forCellReuseIdentifier:GLPNewGoodsDetailsTitleCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsDiscountCellID) forCellReuseIdentifier:GLPGoodsDetailsDiscountCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsTicketCellID) forCellReuseIdentifier:GLPGoodsDetailsTicketCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsManualCellID) forCellReuseIdentifier:GLPGoodsDetailsManualCellID];
        [_tableView registerClass:NSClassFromString(GLPGoodsDetailsFreightCellID) forCellReuseIdentifier:GLPGoodsDetailsFreightCellID];
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (GLPGoodsDetailsHeadView *)headView{
    if (!_headView) {
        _headView = [[GLPGoodsDetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW-kNavBarHeight)];
    }
    return _headView;
}

- (GLPGoodsDetailsBottomView *)bottomView{
    if (!_bottomView) {
        
        CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
        _bottomView = [[GLPGoodsDetailsBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - GoodsDetailsBottomView_HEIGHT - height, kScreenW, GoodsDetailsBottomView_HEIGHT + height)];
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

- (GLPGoodsDetailsSpecificationsView *)specView{
    if (!_specView) {
        _specView = [[GLPGoodsDetailsSpecificationsView alloc] init];
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
            [weakSelf specViewBlock:weakSelf.specType];
        };
        _specView.GLPGoodsDetailsSpecificationsView_block = ^{
            //到货通知
            [weakSelf redirectToArrivalNotice];
        };
        
//        AppDelegate *delegate =(id)[UIApplication sharedApplication].delegate;
//        UIViewController *vc = [[UIViewController alloc] init];//实例化一个vc
//        vc.view = self;//self.typeView这个是添加在window上面的view
//        [delegate.window addSubview:vc.view];//添加
    }
    return _specView;
}

/* 改变展示的商品详情*/
- (void)changeShowGoodsView:(BOOL)needChange
{
    if ([self.detailModel.isMedical integerValue] == 2) {
        //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
        //self.detailModel.goodsTitle = self.specModelSelect.goodsTitle;//不需要传回来了
        self.detailModel.marketPrice = self.specModelSelect.marketPrice;
        self.detailModel.sellPrice = self.specModelSelect.sellPrice;
        self.detailModel.totalStock = self.specModelSelect.stock;
        NSMutableArray *newActivities = [self.detailModel.activities mutableCopy];
        
        self.batchId = self.specModelSelect.batchId;

        [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if([actModel.actType isEqualToString:@"seckill"]) {
                [newActivities removeObject:actModel];//秒杀
            }else if([actModel.actType isEqualToString:@"collage"]) {
                [newActivities removeObject:actModel];//拼团
            }else if([actModel.actType isEqualToString:@"coupon"]) {
                [newActivities removeObject:actModel]; // 单品优惠券
            }
        }];
        if (self.specModelSelect.seckillAct.actId.length > 0) {
            [newActivities addObject:self.specModelSelect.seckillAct];
        }
        if (self.specModelSelect.collageAct.actId.length > 0) {
            [newActivities addObject:self.specModelSelect.collageAct];
        }
        if (self.specModelSelect.group.actId.length > 0) {
            [newActivities addObject:self.specModelSelect.group];
        }
        
        self.detailModel.attr = self.specModelSelect;
        self.detailModel.activities = newActivities;
        
        [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
                if([actModel.actType isEqualToString:@"group"]) {
                    self.detailType =  GLPGoodsDetailTypeGroup; // 团购
                }else if([actModel.actType isEqualToString:@"seckill"]) {
                    self.detailType = GLPGoodsDetailTypeSeckill;//秒杀
                }else if([actModel.actType isEqualToString:@"collage"]) {
                    self.detailType = GLPGoodsDetailTypeCollage;//拼团
                }else if([actModel.actType isEqualToString:@"freePostage"]) {
                    //self.detailType =  GLPGoodsDetailTypeFreePostage; // 包邮活动 这个单独遍历查询
                }else if([actModel.actType isEqualToString:@"coupon"]) {
                    self.detailType =  GLPGoodsDetailTypeCoupon; // 单品优惠券
                }else if([actModel.actType isEqualToString:@"fullMinus"]) {
                    self.detailType =  GLPGoodsDetailTypFullMinus; // 满减
                }
        }];

        CGFloat spreadAmount = self.detailModel.sellPrice * self.detailModel.spreadRate;
        self.detailModel.spreadAmount = [NSString stringWithFormat:@"%.2f",spreadAmount];
        self.headView.imageArray = [self getGoodsImages:self.detailModel.goodsImgs replace:self.specModelSelect.img];
        [self upToDateBottomView];//到货通知刷新
        [self.tableView reloadData];
    }else{
        self.goodsId = self.specModelSelect.goodsId;
        if (needChange) {
            [SVProgressHUD show];
            [self requestGoodsInfo:NO];
        }else{
            if (self.specModelSelect.liaoIdx > 0) {
                GLPMarketingMixListModel *marketModel = self.specModelSelect.marketingMixList[self.specModelSelect.liaoIdx-1];
                CGFloat sellPrice = self.specModelSelect.sellPrice;
                CGFloat sellOldPrice = sellPrice *  [marketModel.mixNum floatValue];
                
                sellPrice = [marketModel.price floatValue] * [marketModel.mixNum floatValue];//totalPrice
                
                CGFloat goodOldPrice = sellOldPrice-sellPrice;
                if (goodOldPrice > 0) {
                    self.detailModel.liaoOldPrice = [NSString stringWithFormat:@"%0.2f",goodOldPrice];
                }
                self.detailModel.liaoPrice = [NSString stringWithFormat:@"%.2f",sellPrice];
            }else{
                self.detailModel.liaoPrice = @"";
            }
            [self upToDateBottomView];
            [self.tableView reloadData];
        }
    }
}

//更新底部状态
- (void)upToDateBottomView{
    self.bottomView.detailType = self.detailType;
    self.bottomView.detailModel = self.detailModel;
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

#pragma mark - 数据提交 购买
- (void)specViewBlock:(NSInteger)tag{
    
    NSString *goodsId = self.specModelSelect.goodsId ? self.specModelSelect.goodsId : @"";//-*-
    NSString *batchId = self.specModelSelect.batchId ? self.specModelSelect.batchId : @"";//-*-
    NSString *quantity = [NSString stringWithFormat:@"%ld",(long)self.buyCount];//-*-
    NSString *sellerFirmId = self.detailModel.sellerFirmId>0 ? [NSString stringWithFormat:@"%ld",(long)self.detailModel.sellerFirmId] : @"0";//-*-
    NSString *tradeType = @"1";//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
    NSArray *cart = @[];
    
    __block NSString *actType = @"";//1-秒杀；2-拼团；
    __block NSString *actId = @"";//秒杀或者拼团的Id
    NSString *joinId = @"";//参与时存发起拼团ID（拼团购买使用）
    NSString *mixId = @"";//组合装Id
    
    if (tag == 0) {
        //单独选规格
        //        [UIView performWithoutAnimation:^{
        //             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //        }];
    }else if(tag == 803){
        //加入购物车
        if (self.specModelSelect.liaoIdx > 0) {//优先级最高互斥
            GLPMarketingMixListModel *marketModel = self.specModelSelect.marketingMixList[self.specModelSelect.liaoIdx-1];
            mixId = marketModel.mixId ?  marketModel.mixId : @"";
            quantity = [NSString stringWithFormat:@"%ld",self.buyCount * [marketModel.mixNum integerValue]];
        }

        NSDictionary *paramDic = @{@"goodsId":goodsId,
                              @"batchId":batchId,
                              @"quantity":quantity,
                              @"sellerFirmId":sellerFirmId,
                              @"tradeType":tradeType,
                              @"cart":cart,
                              @"actType":actType,
                              @"actId":actId,
                              @"joinId":joinId,
                              @"mixId":mixId};
        WEAKSELF;
        [[DCAPIManager shareManager] glpRequest_b2c_new_tradeInfoWithDic:paramDic success:^(id  _Nullable response) {
            if (response) {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
                [weakSelf.bottomView reshnum];
            }
        } failture:^(NSError *_Nullable error) {
        }];
    }else if(tag == 8033){
        //原价购买
        tradeType = @"4";;//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
        if (self.specModelSelect.liaoIdx > 0) {//优先级最高互斥
            GLPMarketingMixListModel *marketModel = self.specModelSelect.marketingMixList[self.specModelSelect.liaoIdx-1];
            mixId = marketModel.mixId ?  marketModel.mixId : @"";
            quantity = [NSString stringWithFormat:@"%ld",self.buyCount * [marketModel.mixNum integerValue]];
        }

        NSDictionary *paramDic = @{@"goodsId":goodsId,
                              @"batchId":batchId,
                              @"quantity":quantity,
                              @"sellerFirmId":sellerFirmId,
                              @"tradeType":tradeType,
                              @"cart":cart,
                              @"actType":actType,
                              @"actId":actId,
                              @"joinId":joinId,
                              @"mixId":mixId};
        [self requestBuyGoods:paramDic forType:1];
    }else if(tag == 804){
        //立即购买
        tradeType = @"4";;//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
        WEAKSELF;
        [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([self.detailModel.isMedical integerValue] == 2) {
                //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
                if ([weakSelf.detailModel.attr.batchId isEqualToString:actModel.batchId]) {
                    if([actModel.actType isEqualToString:@"seckill"]) {
                        actId = actModel.actId;
                        actType = @"1";
                    }else if([actModel.actType isEqualToString:@"collage"]) {
                        actId = actModel.actId;
                        actType = @"2";
                    }
                }
            }else{
                if([actModel.actType isEqualToString:@"seckill"]) {
                    actId = actModel.actId;
                    actType = @"1";
                }else if([actModel.actType isEqualToString:@"collage"]) {
                    actId = actModel.actId;
                    actType = @"2";
                }
            }
        }];
        if (self.specModelSelect.liaoIdx > 0) {//优先级最高互斥
            actType = @"";
            actId = @"";
            joinId = @"";
            GLPMarketingMixListModel *marketModel = self.specModelSelect.marketingMixList[self.specModelSelect.liaoIdx-1];
            mixId = marketModel.mixId ?  marketModel.mixId : @"";
            quantity = [NSString stringWithFormat:@"%ld",self.buyCount * [marketModel.mixNum integerValue]];
        }

        NSDictionary *paramDic = @{@"goodsId":goodsId,
                              @"batchId":batchId,
                              @"quantity":quantity,
                              @"sellerFirmId":sellerFirmId,
                              @"tradeType":tradeType,
                              @"cart":cart,
                              @"actType":actType,
                              @"actId":actId,
                              @"joinId":joinId,
                              @"mixId":mixId};
        [self requestBuyGoods:paramDic forType:1];
    }else if(tag == 8044){
        //立即开团
        WEAKSELF;
        tradeType = @"4";;//1：加入到购物车；2-从购物车到订单确认页面；3-:立即购买验证；4:立即购买到订单确认页面;5-订单提交
        [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([self.detailModel.isMedical integerValue] == 2) {
                //非医药上改变gooIInfo里的主图 市场价 商城价 活动得比较batchId
                if ([weakSelf.specModelSelect.batchId isEqualToString:actModel.batchId]) {
                    if([actModel.actType isEqualToString:@"seckill"]) {
                        actId = actModel.actId;
                        actType = @"1";
                    }else if([actModel.actType isEqualToString:@"collage"]) {
                        actId = actModel.actId;
                        actType = @"2";
                    }
                }
            }else{
                if([actModel.actType isEqualToString:@"seckill"]) {
                    actId = actModel.actId;
                    actType = @"1";
                }else if([actModel.actType isEqualToString:@"collage"]) {
                    actId = actModel.actId;
                    actType = @"2";
                }
            }
        }];
        if (self.specModelSelect.liaoIdx > 0) {//优先级最高互斥
            actType = @"";
            actId = @"";
            joinId = @"";
            GLPMarketingMixListModel *marketModel = self.specModelSelect.marketingMixList[self.specModelSelect.liaoIdx-1];
            mixId = marketModel.mixId ?  marketModel.mixId : @"";
            quantity = [NSString stringWithFormat:@"%ld",self.buyCount * [marketModel.mixNum integerValue]];
        }

        NSDictionary *paramDic = @{@"goodsId":goodsId,
                              @"batchId":batchId,
                              @"quantity":quantity,
                              @"sellerFirmId":sellerFirmId,
                              @"tradeType":tradeType,
                              @"cart":cart,
                              @"actType":actType,
                              @"actId":actId,
                              @"joinId":joinId,
                              @"mixId":mixId};
        [self requestBuyGoods:paramDic forType:1];
    }

}

- (void)requestBuyGoods:(NSDictionary *)paramDic forType:(NSInteger)type{
    WEAKSELF;
    [[DCAPIManager shareManager] glpRequest_b2c_tradeInfo_confirmOrder_newWith:paramDic success:^(id  _Nullable response) {
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
        vc.actDic = paramDic;
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

- (NSArray *)specList{
    if (!_specList) {
        _specList = @[];
    }
    return _specList;
}

- (GLPGoodsLickModel *)lickModel{
    if (!_lickModel) {
        _lickModel = [[GLPGoodsLickModel alloc] init];
    }
    return _lickModel;
}

- (UIView *)noStockView{
    if (!_noStockView) {
        _noStockView = [[UIView alloc] init];
        _noStockView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        [self.view addSubview:_noStockView];
        CGFloat height = kStatusBarHeight > 20 ? 27 : 0;
        _noStockView.frame = CGRectMake(0, kScreenH - GoodsDetailsBottomView_HEIGHT - height-50, kScreenW, 50);
        [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_noStockView byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(20, 20)];
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"暂时无货，先看看其他商品";
        title.font = [UIFont fontWithName:PFR size:15];
        title.textColor = [UIColor dc_colorWithHexString:@"#666666"];
        [_noStockView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_noStockView.mas_centerY);
            make.left.equalTo(_noStockView.mas_left).offset(20);
        }];
        
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn addTarget:self action:@selector(showMoreSearchType:) forControlEvents:UIControlEventTouchUpInside];
        [arrowBtn setImage:[UIImage imageNamed:@"dc_arrow_up_hei"] forState:UIControlStateNormal];
        [_noStockView addSubview:arrowBtn];
        [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_noStockView.mas_centerY);
            make.right.equalTo(_noStockView.mas_right).offset(-8);
            make.size.equalTo(CGSizeMake(60, 40));
        }];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipLabelClick:)];
        [_noStockView addGestureRecognizer:tap];
        
    }
    return _noStockView;
}

- (void)skipLabelClick:(id)sender{
    [self showMoreSearchType:nil];
}

- (void)showMoreSearchType:(UIButton *)butten{
//    UIImageView *img = butten.subviews[0];
//    CGAffineTransform transform = img.transform;
//    if (transform.d < 0) {
//        img.transform = CGAffineTransformMakeScale(1,1);
//    }
//    else
//        img.transform = CGAffineTransformMakeScale(1,-1);
//    butten.tag = butten.tag == 0 ? 1 : 0;
    
    DCNoStockRecommendVC *vc = [DCNoStockRecommendVC new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.dataArray = self.noStockList;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
//    [self.noStockView addSubview:vc.view];
//    self.noStockView.clipsToBounds = NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [self.noStockView hitTest:point withEvent:event];
   
    if (view == nil) {
          //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
        
    }
    return view;
}



- (void)dealloc {
    [_webView stopLoading];
    _webView.navigationDelegate = nil;
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}



/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//标注一下
/*[self requestGoodsDetailAddress:count block:^(BOOL isSuccess) {
 [UIView performWithoutAnimation:^{
 [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
 }];
 }];*/
//而我们实际的项目中几乎不会刷新某个列表超过100次，两者性能差不多，但reloadSection不能用于row，section动态变化的情况下，所以还是更加推荐使用reloadData方法。当复用逻辑复杂的时候。不要使用reloadSection，因为当第一次调用reloadSection的时候，重新创建的cell上的某些控件的frame和原来的展示的cell的控件的frame很可能不一样,所以就可能会导致UI混乱，鄙人深受其害，今天看了一位大神的博客才知道的，故自己mark一下

@end
