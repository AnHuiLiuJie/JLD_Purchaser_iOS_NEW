//
//  GLPEtpApplicationVC.m
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import "GLPEtpApplicationVC.h"
#import "EtpApplicationCell.h"
#import "GLBProtocolModel.h"
#import "EtpRuleDescriptionView.h"
#import "GLPEtpApprovalStatusVC.h"
#import "DCAPIManager+PioneerRequest.h"
#import "GLBSelectAreaController.h"
#import "DCCheckRegular.h"

static NSString *const EtpApplicationCellID = @"EtpApplicationCell";

@interface GLPEtpApplicationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *identityStr;
@property (nonatomic, copy) NSString *wxStr;
@property(nonatomic,  copy) NSString *areaIdStr;

@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;


@end

@implementation GLPEtpApplicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpViewUI];

}

#pragma mark - 请求 申请创业者
- (void)requestLoadData{
    
    if (!self.protocolBtn.selected){
        [SVProgressHUD showInfoWithStatus:@"请查仔细阅读协议,并确认"];
        return;
    }
    
    if (self.nameStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入联系人"];
        return;
    }
    
    if (self.phoneStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入联系电话"];
        return;
    }
    
    if (![DCCheckRegular dc_checkTelNumber:self.phoneStr]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.identityStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入身份证号"];
        return;
    }
    
    if (![DCCheckRegular dc_checkUserIdCard:self.identityStr]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号"];
        return;
    }
    
    if (self.wxStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入联系人微信号"];
        return;
    }
    
    if (self.areaIdStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请选择地区"];
        return;
    }
//    [[DCAlterTool shareTool] showDefaultWithTitle:@"是否确定删除改银行卡?" message:@"" defaultTitle:@"确定" handler:^(UIAlertAction *_Nonnull action) {
//
//    }];
    WEAKSELF;
    [[DCAPIManager shareManager] pioneerRequest_b2c_pioneer_applyWithAreaId:_areaIdStr cellphone:_phoneStr idCard:_identityStr userName:_nameStr wechat:_wxStr success:^(id response) {
        if (response) {
            GLPEtpApprovalStatusVC *vc = [[GLPEtpApprovalStatusVC alloc] init];
            vc.statusType = EtpApprovalStatusReviewing;
            [weakSelf dc_pushNextController:vc];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)setUpViewUI
{
    self.title = @"申请";
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    self.tableView.hidden = NO;
    
    if (self.userInfoModel != nil) {
        _nameStr = _userInfoModel.userName;
        _phoneStr = _userInfoModel.cellphone;
        _identityStr = _userInfoModel.idCard;
        _wxStr = _userInfoModel.wechat;
        _areaIdStr = _userInfoModel.areaId;
    }else{
        self.nameStr = @"";
        self.phoneStr = @"";
        self.identityStr = @"";
        self.wxStr = @"";
        self.areaIdStr = @"";
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EtpApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:EtpApplicationCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _userInfoModel;
    WEAKSELF;
    cell.etpApplicationCell_name_tf_block = ^(NSString *_Nonnull text) {
        weakSelf.nameStr = text;
    };
    
    cell.etpApplicationCell_phone_tf_block = ^(NSString *_Nonnull text) {
        weakSelf.phoneStr = text;
    };

    cell.etpApplicationCell_identity_tf_block = ^(NSString *_Nonnull text) {
        weakSelf.identityStr = text;
    };
    
    cell.etpApplicationCell_wx_tf_block = ^(NSString *_Nonnull text) {
        weakSelf.wxStr = text;
    };

    __block EtpApplicationCell *strongCell = cell;
    
    cell.etpApplicationCell_area_tf_block = ^(NSString *_Nonnull text) {
        [weakSelf.view endEditing:YES];
        GLBSelectAreaController *vc = [GLBSelectAreaController new];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.isPerson=@"1";
        vc.areaBlock = ^(NSString *areaFullName, NSInteger areaId) {
            weakSelf.areaIdStr = [NSString stringWithFormat:@"%ld",(long)areaId];
            strongCell.area_tf.text = areaFullName;
        };
        
        [weakSelf addChildViewController:vc];
        [weakSelf.view addSubview:vc.view];
    };



//    WEAKSELF;
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

#pragma mark - 申请
- (void)submitBtnAction:(UIButton *)button
{
    
    [self requestLoadData];
}

#pragma mark - 协议
- (void)protocolBtnClick:(UIButton *)button
{
    _protocolBtn.selected = !_protocolBtn.selected;
}

- (void)protocolAction:(UITapGestureRecognizer *)sender
{
    EtpRuleDescriptionView *view = [[EtpRuleDescriptionView alloc] init];
    view.showType = EtpRuleDescriptionViewTypeAgreement;
    view.titile_str = @"自由创业者用户协议";
    view.frame = DC_KEYWINDOW.bounds;
    [DC_KEYWINDOW addSubview:view];
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
        _tableView.frame = CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin-10-self.submitBtn.dc_height-5-self.protocolBtn.dc_height);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[EtpApplicationCell class] forCellReuseIdentifier:EtpApplicationCellID];
    }
    return _tableView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_AppThemeColor];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _submitBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
        _submitBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-44, kScreenW-30, 44);
        [DCSpeedy dc_changeControlCircularWith:_submitBtn AndSetCornerRadius:_submitBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
        [self.view addSubview:_submitBtn];
        
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setImage:[UIImage imageNamed:@"xuanz"] forState:0];
        [_protocolBtn setImage:[UIImage imageNamed:@"tongyi"] forState:UIControlStateSelected];
        _protocolBtn.adjustsImageWhenHighlighted = NO;
        [_protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _protocolBtn.selected = NO;
        _protocolBtn.frame = CGRectMake(15, kScreenH-LJ_TabbarSafeBottomMargin-10-44-5-30, 30, 30);
        [self.view addSubview:_protocolBtn];
        
        _protocolLabel = [[UILabel alloc] init];
        _protocolLabel.textColor = [UIColor dc_colorWithHexString:@"#7A7A7A"];
        _protocolLabel.font = PFRFont(11);
        _protocolLabel.attributedText = [self dc_attributeStr];
        _protocolLabel.numberOfLines=0;
        _protocolLabel.userInteractionEnabled = YES;
        _protocolLabel.frame = CGRectMake(15+30+5, kScreenH-LJ_TabbarSafeBottomMargin-10-44-5-30, kScreenW-CGRectGetMaxX(_protocolBtn.frame)-15-5, 30);
        [self.view addSubview:_protocolLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
        [_protocolLabel addGestureRecognizer:tap];
    }
    return _submitBtn;
}

- (NSMutableArray<GLBProtocolModel *> *)protocolArray{
    if (!_protocolArray) {
        _protocolArray = [NSMutableArray array];
    }
    return _protocolArray;
}

#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr
{
    NSString *protocolStr = @"《自由创业者用户协议》";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金利达%@",protocolStr]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 3)];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(3, attrStr.length - 3)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.alignment = NSTextAlignmentLeft;
    [attrStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
}



- (void)dealloc{
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/*
#pragma mark - Navigation

// In a storyboard-based submit, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

