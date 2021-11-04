//
//  GLPEtpInviteCustomerVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "GLPEtpInviteCustomerVC.h"
#import "GLPEtpEventInvitationVC.h"

/*headView*/
#import "EtpInviteCustomerHeaderView.h"
/*NavView*/
#import "EtpInviteTopToolView.h"
/*cell*/
#import "EtpInviteCustomerCell.h"
#import "DCAPIManager+PioneerRequest.h"

static CGFloat const CellOne_HEIGHT = 400;

static CGFloat const stagger_H = 70;
#define EtpInvite_IMAGE_HEIGHT 310 *kScaleFit - stagger_H

@interface GLPEtpInviteCustomerVC ()<UITableViewDataSource,UITableViewDelegate>

/* headView */
@property (strong , nonatomic)EtpInviteCustomerHeaderView *headView;

/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 顶部Nva */
@property (strong , nonatomic) EtpInviteTopToolView *topToolView;

@property (strong , nonatomic) CustomerExplainModel *model;

@end

static NSString *const EtpInviteCustomerCellID = @"EtpInviteCustomerCell";
static NSString *const productID_VIP = @"zuxunhuiyuannian";

@implementation GLPEtpInviteCustomerVC

#pragma mark - 请求 
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_rule_moneyWithSsuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        CustomerExplainModel *model = [CustomerExplainModel mj_objectWithKeyValues:dic];
        self.model = model;
        
        [weakSelf.headerBgImageView sd_setImageWithURL:[NSURL URLWithString:model.background] placeholderImage:[UIImage imageNamed:@"etp_invite_bg"]];

        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dc_navBarHidden:YES animated:animated];
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    [self setUpNavTopView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self dc_navBarHidden:NO animated:animated];
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";//邀请客源
    [self setUpHeaderCenterView];
    [self requestLoadData];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView{
    self.topToolView.hidden = NO;
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    self.headerBgImageView.frame = CGRectMake(0, 0, kScreenW, EtpInvite_IMAGE_HEIGHT+stagger_H);//self.headView.bounds
    [self.view addSubview:self.headerBgImageView];
    self.tableView.tableHeaderView = self.headView;
//    [self.headView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpInviteCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpInviteCustomerCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    cell.etpInviteCustomerCellClick_blcok = ^{
        /////////[self saveImageBtnAction];//保存
        GLPEtpEventInvitationVC *vc = [[GLPEtpEventInvitationVC alloc] init];
        [self dc_pushNextController:vc];
    };
    return cell;
}



- (void)saveImageBtnAction{
    UIImageView *testImageView = [[UIImageView alloc] init];
    testImageView.frame = self.view.frame;
    testImageView.image = [self makeImageWithView:self.view withSize:self.view.frame.size];;
    [self loadImageFinished:testImageView.image];
}

#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)loadImageFinished:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        NSLog(@"图片保存成功" );
    }else{
        NSLog(@"图片保存失败" );
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cell_h = kScreenH - self.headView.dc_height - LJ_TabbarSafeBottomMargin;

    if (CellOne_HEIGHT > cell_h) {
        return CellOne_HEIGHT;
    }else
        return cell_h;
}

#pragma mark - 滚动tableview 完毕之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;//根据起始坐标 确定值
    CGFloat topH = kNavBarHeight;

    if (offsetY < 0) {
        if (offsetY > -topH) {
            CGFloat alpha = (offsetY + topH) / topH;
            [self.topToolView wr_setBackgroundAlpha:alpha];
        }else{
            [self.topToolView wr_setBackgroundAlpha:0];
            self.topToolView.backgroundColor = [UIColor clearColor];
        }
    }else if (offsetY == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.topToolView wr_setBackgroundAlpha:1];
            self.topToolView.backgroundColor = [UIColor clearColor];
        }];
    }else{
        [self.topToolView wr_setBackgroundAlpha:1];
        if (offsetY >  EtpInvite_IMAGE_HEIGHT - topH) {
            self.topToolView.backgroundColor = [UIColor clearColor];
        }else{

        }
    }
    
    //图片高度
    CGFloat imageHeight = self.headView.dc_height;
    //图片宽度
    CGFloat imageWidth = kScreenW;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        self.headerBgImageView.frame = CGRectMake(-(imageWidth *f - imageWidth) *0.5, imageOffsetY, imageWidth *f, totalOffset+stagger_H);
        
       // self.headerBgImageView.frame = CGRectMake(0, imageOffsetY, imageWidth, totalOffset+stagger_H);
    }
}

#pragma mark - 初始化 -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
//        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,0, kScreenW, kScreenH-LJ_TabbarSafeBottomMargin-0);
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EtpInviteCustomerCell class]) bundle:nil] forCellReuseIdentifier:EtpInviteCustomerCellID];
    }
    return _tableView;
}

- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
//        [_headerBgImageView setImage:[UIImage imageNamed:@"etp_invite_bg"]];
        [_headerBgImageView setBackgroundColor:[UIColor whiteColor]];
        [_headerBgImageView setContentMode:UIViewContentModeScaleToFill];
        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (EtpInviteCustomerHeaderView *)headView
{
    if (!_headView) {
        _headView = [[EtpInviteCustomerHeaderView alloc] init];
        _headView.backgroundColor = [UIColor clearColor];
        _headView.frame = CGRectMake(0, 0, kScreenW, EtpInvite_IMAGE_HEIGHT);
    }
    return _headView;
}

- (EtpInviteTopToolView *)topToolView{
    if (!_topToolView) {
        _topToolView = [[EtpInviteTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenW+1, kNavBarHeight)];
        WEAKSELF;
        _topToolView.leftItemClickBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:_topToolView];
    }
    return _topToolView;
}


#pragma mark - Dealloc
- (void)dealloc{
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

@end
