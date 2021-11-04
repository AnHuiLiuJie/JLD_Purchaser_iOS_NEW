//
//  GLPEtpEntrepreneurPosterVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEtpEntrepreneurPosterVC.h"
#import "EtpEntrepreneurPosterCell.h"
#import "GLPEtpApplicationVC.h"
#import "EtpRuleDescriptionView.h"
static NSString *const EtpEntrepreneurPosterCellID = @"EtpEntrepreneurPosterCell";

@interface GLPEtpEntrepreneurPosterVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GLPEtpEntrepreneurPosterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];
}

- (void)setUpViewUI
{
    self.title = @"创业者申请";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpEntrepreneurPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpEntrepreneurPosterCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAKSELF;
    cell.etpEntrepreneurPosterCellClick_block = ^(NSInteger tag) {
        if (tag == 1) {//规则说明
            EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
            view.showType = EtpRuleDescriptionViewTypeActivity;
            view.titile_str = @"活动规则";
            view.frame = DC_KEYWINDOW.bounds;
            [DC_KEYWINDOW addSubview:view];
        }else{//立即申请
            if (weakSelf.userInfoModel == nil || weakSelf.userInfoModel.userId.length == 0) {
                GLPEtpApplicationVC *vc = [[GLPEtpApplicationVC alloc] init];
                [weakSelf dc_pushNextController:vc];
            }else{
                if ([weakSelf.userInfoModel.state integerValue] == 2) {
                    GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                    vc.statusType = EtpApprovalStatusReviewing;
                    [weakSelf dc_pushNextController:vc];
                }else if ([weakSelf.userInfoModel.state integerValue] == 3) {
                    GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
                    vc.statusType = EtpApprovalStatusReviewFailure;
                    [weakSelf dc_pushNextController:vc];
                }else{
                    [SVProgressHUD showInfoWithStatus:@"您已经申请成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                    GLPEtpApplicationVC *vc = [[GLPEtpApplicationVC alloc] init];
//                    [weakSelf dc_pushNextController:vc];
                }
            }
        }
    };
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.dc_height;
}

#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[EtpEntrepreneurPosterCell class] forCellReuseIdentifier:EtpEntrepreneurPosterCellID];
    }
    return _tableView;
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
