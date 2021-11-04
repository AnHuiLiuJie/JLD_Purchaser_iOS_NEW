//
//  GLPEtpEventInvitationVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/22.
//

#import "GLPEtpEventInvitationVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "EtpInviteTopToolView.h"
#import "ActivitySharingModel.h"

/**友盟分享*/
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface GLPEtpEventInvitationVC ()<UITableViewDataSource,UITableViewDelegate>

/* 内容背景 */
@property (nonatomic, strong) UIView *headerView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic) UITableView *tableView;
/* bottomView */
@property (strong , nonatomic) UIView *bottomView;


/* 顶部Nva */
@property (strong , nonatomic) EtpInviteTopToolView *topToolView;

@end

static NSString *const UITableViewCellID = @"UITableViewCell";
static CGFloat const left_w = 15;
static CGFloat const viewTop_h = 8;
static CGFloat const bottom_h = 10;
static CGFloat const bottomView_h = 80;

// 等比例适配系数
#define kScaleFit_Share (YYISiPhoneX ? ((kScreenW < kScreenH) ? kScreenW / 375.0f : kScreenW / 667.0f) : 1.1f)
#define kScaleFit_Share_X kScreenW / 375.0f
#define kScaleFit_Share_Y kScreenW / 667.0f

@implementation GLPEtpEventInvitationVC

#pragma mark - 请求 服务资讯详情
- (void)requestLoadData{
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_extend_app_newWithSsuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        ActivitySharingModel *model = [ActivitySharingModel mj_objectWithKeyValues:dic];
        [weakSelf updataViewUIWithModel:model];
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self dc_navBarLucency:YES];//解决侧滑显示白色
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";//app分享
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellID];
    
    
    _headerView = [[UIView alloc] init];
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = 10;
    _headerView.backgroundColor = [UIColor clearColor];
    _headerView.frame = CGRectMake(left_w, kNavBarHeight-viewTop_h, _tableView.dc_width-left_w*2, _tableView.dc_height-kNavBarHeight-LJ_TabbarSafeBottomMargin-bottomView_h-bottom_h*3+viewTop_h);
    [self.tableView addSubview:self.headerView];

    _headerBgImageView = [[UIImageView alloc] init];
    //[_headerBgImageView setImage:[UIImage imageNamed:@"etp_invite_bg"]];
    [_headerBgImageView setBackgroundColor:[UIColor clearColor]];
    [_headerBgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_headerBgImageView setClipsToBounds:YES];
    [_headerView addSubview:self.headerBgImageView];
    self.headerBgImageView.frame = self.headerView.bounds;
    
    
    [self.tableView addSubview:self.bottomView];

    
    [self requestLoadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//#pragma mark - 获取文字显示控件
//- (UILabel *)getNewLabelAddShareViewWithTitle:(NSString *)title colorStr:(NSString *)colorStr font:(NSInteger)font point:(CGPoint)point size:(CGSize)size
//{
//    UILabel *addLabel = [[UILabel alloc] init];
//    addLabel.text = title;
//    addLabel.textColor = [UIColor dc_colorWithHexString:colorStr];
//    addLabel.textAlignment = NSTextAlignmentLeft;
//    addLabel.font = [UIFont fontWithName:PFR size:font];
//    addLabel.frame = CGRectMake(point.x, point.y, 100, 20);
//    addLabel.layer.borderWidth = 1;
//    addLabel.layer.borderColor = [UIColor redColor].CGColor;
//    return addLabel;
//}

#pragma mark - 获取图片显示控件
//- (UIImageView *)getNewImageViewWithUrl:(NSString *)url point:(CGPoint)point size:(CGSize)size isMasks:(BOOL)isMasks
//- (void)getTouxiangImageViewWithUrl:(NSString *)url andUserName:(NSString *)nameStr
- (void)updataViewUIWithModel:(ActivitySharingModel *)model
{
    [self.headerBgImageView sd_setImageWithURL:[NSURL URLWithString:model.background] placeholderImage:[UIImage imageNamed:@"dc_app_bg"]];

    UIImageView *addImageView = [[UIImageView alloc] init];
    addImageView.backgroundColor = [UIColor clearColor];
    [addImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg] placeholderImage:nil];//etp_hd_bg
    CGFloat image_w = 50 *kScaleFit;
    CGFloat offset1 = !isPhone6below ? 35*kScaleFit : 0;
    addImageView.frame = CGRectMake((self.headerView.dc_width-image_w)/2,110*kScaleFit+offset1 ,image_w,image_w);
    addImageView.layer.cornerRadius = image_w/2;
    addImageView.layer.masksToBounds = YES;
    [self.headerView addSubview:addImageView];

    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = model.loginName;
    addLabel.textColor = [UIColor dc_colorWithHexString:@"#FCFCFC"];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont fontWithName:PFR size:12];
    addLabel.frame = CGRectMake(0, CGRectGetMaxY(addImageView.frame), self.headerView.dc_width, 20);
    [self.headerView addSubview:addLabel];
    
    
    UIView *qrBgView = [[UIView alloc] init];
    CGFloat offset2 = YYISiPhoneX ? 5*kScaleFit : 0;
    qrBgView.backgroundColor = [UIColor whiteColor];
    CGFloat image_w2 = 115 *kScaleFit+offset2;
    qrBgView.frame = CGRectMake((self.headerView.dc_width-image_w2)/2,self.headerView.dc_height-image_w2-25*kScaleFit ,image_w2,image_w2+10);
    qrBgView.layer.cornerRadius = 8;
    qrBgView.layer.masksToBounds = YES;
    [self.headerView addSubview:qrBgView];
    
    UIImageView *qrImage = [[UIImageView alloc] init];
    qrImage.backgroundColor = [UIColor clearColor];
    [qrImage sd_setImageWithURL:[NSURL URLWithString:model.qrimg] placeholderImage:nil];//etp_hd_bg
    qrImage.frame = CGRectMake(3,3,qrBgView.dc_width-6,qrBgView.dc_width-6);
    [qrBgView addSubview:qrImage];
    
    UILabel *qrLabel = [[UILabel alloc] init];
    qrLabel.text = @"长按扫码注册";
    qrLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    qrLabel.textAlignment = NSTextAlignmentCenter;
    qrLabel.font = [UIFont fontWithName:PFRMedium size:10];
    qrLabel.frame = CGRectMake(0, CGRectGetMaxY(qrImage.frame)-8, qrBgView.dc_width, 20);
    [qrBgView addSubview:qrLabel];
}

#pragma mark - 初始化 -
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(left_w, CGRectGetMaxY(self.headerView.frame)+bottom_h, self.headerView.dc_width, bottomView_h);
        // 阴影
        _bottomView.layer.shadowOffset = CGSizeMake(0, 2);  //阴影偏移量
        _bottomView.layer.shadowRadius = 1;
        _bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bottomView.layer.shadowOpacity = 0.8; //阴影透明度
        _bottomView.layer.cornerRadius = 10.0;
        _bottomView.layer.masksToBounds = NO;
        
        CGFloat image_w = (bottomView_h*3)/5;
        CGFloat top_h = bottomView_h*1/5-10;

        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.frame = CGRectMake(0, 0, _bottomView.dc_width/2, _bottomView.dc_height);
        [_bottomView addSubview:leftView];
        UIImageView *leftImg = [[UIImageView alloc] init];
        leftImg.backgroundColor = [UIColor clearColor];
        [leftImg setImage:[UIImage imageNamed:@"umsocial_wechat.png"]];
        leftImg.frame = CGRectMake((leftView.dc_width-image_w)/2, top_h, image_w, image_w);
        [leftView addSubview:leftImg];
        UILabel *leftLab = [[UILabel alloc] init];
        leftLab.text = @"微信好友";
        leftLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        leftLab.textAlignment = NSTextAlignmentCenter;
        leftLab.font = [UIFont fontWithName:PFR size:14];
        leftLab.frame = CGRectMake(0, CGRectGetMaxY(leftImg.frame), leftView.dc_width, 20);
        [leftView addSubview:leftLab];
        
        UIView *rightView = [[UIView alloc] init];
        rightView.backgroundColor = [UIColor clearColor];
        rightView.frame = CGRectMake(CGRectGetMaxX(leftView.frame), 0, _bottomView.dc_width/2, _bottomView.dc_height);
        [_bottomView addSubview:rightView];
        UIImageView *rightImg = [[UIImageView alloc] init];
        rightImg.backgroundColor = [UIColor clearColor];
        [rightImg setImage:[UIImage imageNamed:@"umsocial_wechat_timeline.png"]];
        //CGFloat image_w = rightView.dc_height*3/5;
        rightImg.frame = CGRectMake((leftView.dc_width-image_w)/2, top_h, image_w, image_w);
        [rightView addSubview:rightImg];
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.text = @"保存至相册";
        rightLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
        rightLab.textAlignment = NSTextAlignmentCenter;
        rightLab.font = [UIFont fontWithName:PFR size:14];
        rightLab.frame = CGRectMake(0, CGRectGetMaxY(rightImg.frame), rightView.dc_width, 20);
        [rightView addSubview:rightLab];
        
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
        leftView.userInteractionEnabled = YES;
        [leftView addGestureRecognizer:tapGesture1];
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap2:)];
        rightView.userInteractionEnabled = YES;
        [rightView addGestureRecognizer:tapGesture2];
        
//        leftImg.layer.borderWidth = 1;
//        leftImg.layer.borderColor = [UIColor redColor].CGColor;
//
//        rightImg.layer.borderWidth = 1;
//        rightImg.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _bottomView;
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    //!_mytestBlock ? : _mytestBlock(nil);
    
    //分享微信好友
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession shareImage:nil thumbImage:nil];
}

- (void)didBgViewTap2:(UIGestureRecognizer *)gestureRecognizer{
    //保存到相册
    [self saveImageBtnAction];//保存
    
//    NSString *bbb = [self mmymethodWithString:nil];
//    NSLog(@"%@",bbb);
}

//- (NSString *)mmymethodWithString:(NSString *)uuString{
//
//    return uuString;
//}


#pragma mark - 分享
/** 友盟三方平台 分享  图片
  *  platformType  平台
  *  shareImage  图片内容 （可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象(必须是https)）
  *  thumbImage  缩略图 可以是网络地址url  也可是本地图片对象
 */
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType shareImage:(id)shareImage thumbImage:(id)thumbImage{
    if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine || platformType == UMSocialPlatformType_WechatFavorite) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //设置缩略图
        shareObject.thumbImage = thumbImage;

        UIImageView *testImageView = [[UIImageView alloc] init];
        testImageView.frame = self.headerView.frame;
        testImageView.image = [self makeImageWithView:self.headerView withSize:self.headerView.frame.size];
        
        // ⚠️注意：分享图片方式如下： 1. 分享图片仅适用本地图片加载，如UIImage或NSData数据传输。 2. 如需使用网络图片，确保URL为HTTPS图片链接，以便于U-Share SDK下载并进行分享，否则会分享失败
        [shareObject setShareImage:testImageView.image];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[self presentingVC] completion:^(id data, NSError *error) {
            NSDictionary *dict = @{@"type":@"创业者用户分享",@"shareNumber":@"分享次数"};//UM统计 自定义搜索关键词事件
            [MobClick event:UMEventCollection_2 attributes:dict];
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"************Share Success*********");
            }
        }];
    }
}

- (UIViewController *)presentingVC{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

#pragma 保存到本地
- (void)saveImageBtnAction{
    UIImageView *testImageView = [[UIImageView alloc] init];
    testImageView.frame = self.headerView.frame;
    testImageView.image = [self makeImageWithView:self.headerView withSize:self.headerView.frame.size];;
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
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else
        [SVProgressHUD showErrorWithStatus:@"图片保存失败"];
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

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
