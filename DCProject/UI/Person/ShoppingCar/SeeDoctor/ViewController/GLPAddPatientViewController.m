//
//  GLPAddPatientViewController.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "GLPAddPatientViewController.h"

#import "MedicalPromptHeaderView.h"
#import "PatientRelationshipCell.h"
#import "HealthInformationView.h"
#import "PatientInfoFooterView.h"
@interface GLPAddPatientViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL haveData;

@end


static NSString *const MedicalPromptHeaderViewID = @"MedicalPromptHeaderView";
static NSString *const PatientInfoCellID = @"PatientInfoCell";
static NSString *const PatientInfoFooterViewID = @"PatientInfoFooterView";
static NSString *const PatientRelationshipCellID = @"PatientRelationshipCell";

static CGFloat kBottomView_H = 100;

@implementation GLPAddPatientViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (!_isFirstLoad) {
//        [self requestMainDataIsShowHUD:YES];
//        _isFirstLoad = YES;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增用药人";

    self.bottomView.backgroundColor = self.tableView.backgroundColor;
    
    if (self.drugId.length > 0) {
        self.haveData = YES;
        [_confirmBtn setTitle:@"保存修改" forState:UIControlStateNormal];
        self.title = @"修改用药人";
    }
}

- (void)requestMainDataIsShowHUD:(BOOL)isHUD
{
    if (self.drugId.length == 0) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    !isHUD ?  : [SVProgressHUD show];
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_druguser_detailWithDrugId:self.drugId success:^(id  _Nullable response) {
        MedicalPersListModel *model = [MedicalPersListModel mj_objectWithKeyValues:response];
        weakSelf.model = model;
        weakSelf.haveData = YES;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failture:^(NSError * _Nullable error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0) {
        PatientInfoCell *titleCell = [tableView dequeueReusableCellWithIdentifier:PatientInfoCellID forIndexPath:indexPath];
        titleCell.model = self.model;
        if (_haveData) {
            [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:titleCell.bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(0.01, 1)];
        }
        titleCell.PatientInfoCell_Block = ^(MedicalPersListModel * _Nonnull model) {
            [weakSelf addMoreInfoButtonClick:[weakSelf.model copy]];
        };
        titleCell.PatientInfoCell_block = ^(NSString * _Nonnull text, NSInteger type) {
            if (type == 1) {
                weakSelf.model.patientName = text;
            }else if(type == 2){
                weakSelf.model.idCard = text;
            }else if(type == 3){
                weakSelf.model.weight = text;
            }else if(type == 4){
                weakSelf.model.patientTel = text;
            }
        };
        cell = titleCell;
    }else if (indexPath.section == 1) {
        PatientRelationshipCell *specCell = [tableView dequeueReusableCellWithIdentifier:PatientRelationshipCellID forIndexPath:indexPath];
        specCell.PatientRelationshipCell_block = ^(MedicalPersListModel *model) {
            weakSelf.model = model;
        };
        specCell.model = self.model;
        cell = specCell;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 40.0f : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (_haveData) {
            return UITableViewAutomaticDimension;
        }
    }
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0 ) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
    }
    MedicalPromptHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MedicalPromptHeaderViewID];
    header.titleStr = @"根据国家相关法律规定，网络购买处方药需要实名认证。";
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != 0 || !_haveData) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        return view;
    }
    
    PatientInfoFooterView *footer = [[PatientInfoFooterView alloc] init];
    footer.model = self.model;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma makr - 搜索
- (void)addMoreInfoButtonClick:(MedicalPersListModel *)model
{
    HealthInformationView *view = [[HealthInformationView alloc] init];
    WEAKSELF;
    view.HealthInformationView_Block = ^(MedicalPersListModel * _Nonnull model) {
        weakSelf.model = model;
        weakSelf.haveData = YES;
        [weakSelf.tableView reloadData];
    };
    view.model = [self.model copy];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    

}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 44.0f;
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        [_tableView registerClass:NSClassFromString(MedicalPromptHeaderViewID) forHeaderFooterViewReuseIdentifier:MedicalPromptHeaderViewID];
        //[_tableView registerNib:[UINib nibWithNibName:PatientInfoFooterViewID bundle:nil] forHeaderFooterViewReuseIdentifier:PatientInfoFooterViewID];
        
        [_tableView registerNib:[UINib nibWithNibName:PatientInfoCellID bundle:nil] forCellReuseIdentifier:PatientInfoCellID];
        [_tableView registerNib:[UINib nibWithNibName:PatientRelationshipCellID bundle:nil] forCellReuseIdentifier:PatientRelationshipCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)loadNewData{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self requestMainDataIsShowHUD:NO];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), kScreenW, kBottomView_H);
        [self.view addSubview:_bottomView];
        
        UILabel *promptLab = [[UILabel alloc] init];
        promptLab.backgroundColor = [UIColor clearColor];
        promptLab.text = @"温馨提示：您最多可添加5位用药人信息！";
        promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
        promptLab.font = [UIFont fontWithName:PFR size:12];
        promptLab.textAlignment = NSTextAlignmentLeft;
        promptLab.frame = CGRectMake(15, 0, _bottomView.dc_width, kBottomView_H*0.25);
        [_bottomView addSubview:promptLab];
        
        _confirmBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_confirmBtn];
        [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:10];
        _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [_confirmBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(promptLab.frame), _bottomView.dc_width-30, kBottomView_H*0.5);
    }
    return _bottomView;
}

- (void)confirmBtnAction
{
    if (_model.patientName.length == 0) {
        [self.view makeToast:@"请输入用药人真实姓名" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    
    if (_model.idCard.length == 0){
        [self.view makeToast:@"请输入身份证号" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    if (![DCCheckRegular dc_checkUserIdCard:_model.idCard]) {
        [self.view makeToast:@"请输入正确的身份证号" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    
    if (_model.patientTel.length == 0) {
        [self.view makeToast:@"请输入用药人手机号" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    if (![DCCheckRegular dc_checkTelNumber:_model.patientTel]) {
        [self.view makeToast:@"请输入正确的手机号" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    
    if (!_haveData) {
        [self.view makeToast:@"请填写健康信息" duration:Toast_During position:CSToastPositionBottom];
        return;
    }
    
    NSString *patientName = _model.patientName;
    NSString *idCard = _model.idCard;
    NSString *weight = _model.weight.length != 0 ? _model.weight : @"";
    NSString *patientTel = _model.patientTel;
    
    NSString *isNowIllness = _model.isNowIllness;
    NSString *nowIllness = _model.nowIllness;
    NSString *isHistoryAllergic = _model.isHistoryAllergic;
    NSString *historyAllergic = _model.historyAllergic;
    NSString *isHistoryIllness = _model.isHistoryIllness;
    NSString *historyIllness = _model.historyIllness;
    NSString *liverUnusual = _model.liverUnusual;
    NSString *renalUnusual = _model.renalUnusual;
    NSString *lactationFlag = _model.lactationFlag;

    NSString *relation = _model.relation.length != 0 ? _model.relation : @"1";
    NSString *isDefault = _model.isDefault.length != 0 ? _model.isDefault : @"1";

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:patientName forKey:@"patientName"];
    [paramDic setObject:idCard forKey:@"idCard"];
    [paramDic setObject:weight forKey:@"weight"];
    [paramDic setObject:patientTel forKey:@"patientTel"];

    [paramDic setObject:isNowIllness forKey:@"isNowIllness"];
    [paramDic setObject:nowIllness forKey:@"nowIllness"];
    [paramDic setObject:isHistoryAllergic forKey:@"isHistoryAllergic"];
    [paramDic setObject:historyAllergic forKey:@"historyAllergic"];
    [paramDic setObject:isHistoryIllness forKey:@"isHistoryIllness"];
    [paramDic setObject:historyIllness forKey:@"historyIllness"];
    [paramDic setObject:liverUnusual forKey:@"liverUnusual"];
    [paramDic setObject:renalUnusual forKey:@"renalUnusual"];
    [paramDic setObject:lactationFlag forKey:@"lactationFlag"];
    [paramDic setObject:relation forKey:@"relation"];
    [paramDic setObject:isDefault forKey:@"isDefault"];
    
//    [paramDic setObject:@"" forKey:@"drugId"];
//    [paramDic setObject:@"1990-12" forKey:@"birthTime"];
//    [paramDic setObject:@"" forKey:@"chiefComplaint"];
//    [paramDic setObject:@"24" forKey:@"patientAge"];
//    [paramDic setObject:@"1" forKey:@"patientGender"];
    WEAKSELF;
    if (self.drugId.length == 0) {
        [[DCAPIManager shareManager] person_b2c_druguser_addWithParamDic:paramDic success:^(id  _Nullable response) {
            //[weakSelf.view makeToast:@"添加成功" duration:Toast_During position:CSToastPositionBottom];
            [[DCAlterTool shareTool] showDoneWithTitle:@"添加成功!" message:@"" defaultTitle:@"返回" handler:^(UIAlertAction * _Nonnull action) {
                !weakSelf.GLPAddPatientViewController_block ? : weakSelf.GLPAddPatientViewController_block();
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failture:^(NSError * _Nullable error) {
            
        }];
    }else{
        NSString *drugId = _model.drugId.length != 0 ? _model.drugId : @"";
        [paramDic setObject:drugId forKey:@"drugId"];
        [[DCAPIManager shareManager] person_b2c_druguser_editWithParamDic:paramDic success:^(id  _Nullable response) {
            !weakSelf.GLPAddPatientViewController_block ? : weakSelf.GLPAddPatientViewController_block();
            [[DCAlterTool shareTool] showDoneWithTitle:@"修改成功" message:@"" defaultTitle:@"返回" handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } failture:^(NSError * _Nullable error) {
        
        }];
    }


}
/**
 "birthTime": "",//患者出生时间
 "chiefComplaint": "",//病情描述（主诉)
 "drugId": 0,//患者ID
 "patientAge": "",//患者年龄
 "patientGender": 0,//患者性别：1-男， 2-女
 */

- (void)setViewUIForModel{
    
}

- (MedicalPersListModel *)model{
    if (!_model) {
        _model = [[MedicalPersListModel alloc] init];
        _model.patientName = @"";
        _model.idCard = @"";
        _model.weight = @"";
        _model.patientTel = @"";
        _model.isNowIllness = @"2";
        _model.nowIllness = @"";
        _model.isHistoryAllergic = @"2";
        _model.historyAllergic = @"";
        _model.isHistoryIllness = @"2";
        _model.historyIllness = @"";
        _model.liverUnusual = @"2";
        _model.renalUnusual = @"2";
        _model.lactationFlag = @"2";
        _model.relation = @"1";
        _model.isDefault = @"2";
        self.haveData = NO;
    }
    return _model;
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
