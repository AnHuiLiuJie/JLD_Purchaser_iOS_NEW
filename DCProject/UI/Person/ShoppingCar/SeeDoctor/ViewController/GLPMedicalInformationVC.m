//
//  GLPMedicalInformationVC.m
//  DCProject
//
//  Created by LiuMac on 2021/6/7.
//

#import "GLPMedicalInformationVC.h"
#import "MedicalPromptHeaderView.h"
#import "AddOrSelectPatientCell.h"
#import "MedicalTreatmentMethodCell.h"
#import "GLPAddPatientViewController.h"

#import "PrescriptionConfirmCell.h"
#import "PrescriptionPromptCell.h"
#import "DrugSideEffectCell.h"
#import "DescribeSymptomsCell.h"
#import "AdditionalInformationCell.h"

@interface GLPMedicalInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) MedicalInfomationModel *mainModel;
@property (nonatomic, strong) MedicalPersListModel *userModel;

@property (nonatomic, assign) BOOL isFirstLoad;
@end


static NSString *const MedicalPromptHeaderViewID = @"MedicalPromptHeaderView";
static NSString *const AddOrSelectPatientCellID = @"AddOrSelectPatientCell";
static NSString *const MedicalTreatmentMethodCellID = @"MedicalTreatmentMethodCell";

static NSString *const PrescriptionConfirmCellID = @"PrescriptionConfirmCell";
static NSString *const PrescriptionPromptCellID = @"PrescriptionPromptCell";
static NSString *const DrugSideEffectCellID = @"DrugSideEffectCell";
static NSString *const DescribeSymptomsCellID = @"DescribeSymptomsCell";
static NSString *const AdditionalInformationCellID = @"AdditionalInformationCell";

static CGFloat kBottomView_H = 100;

@implementation GLPMedicalInformationVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isFirstLoad) {
        [self requestMainDataIsShowHUD:YES];
        _isFirstLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"就诊信息";
    //    if (self.infoModel != nil && self.infoModel.drugId.length != 0) {
    //        NSArray *arr = [self.infoModel.drugImg componentsSeparatedByString:@","];
    //        self.infoModel.drugImgList = [arr mutableCopy];
    //    }
    
    
    self.bottomView.backgroundColor = self.tableView.backgroundColor;
    
    [self changeDefineBtnState];
    
}

- (void)requestMainDataIsShowHUD:(BOOL)isHUD
{
    !isHUD ?  : [SVProgressHUD show];
    WEAKSELF;
    [[DCAPIManager shareManager] person_b2c_trade_userSymptomsWithGoodsId:self.goodsIds success:^(id  _Nullable response) {
        MedicalInfomationModel *model = [MedicalInfomationModel mj_objectWithKeyValues:response];
        NSArray *persList = [MedicalPersListModel mj_objectArrayWithKeyValuesArray:model.persList];
        NSArray *symptomList = [MedicalSymptomListModel mj_objectArrayWithKeyValuesArray:model.symptomList];
        model.persList = persList;
        [persList enumerateObjectsUsingBlock:^(MedicalPersListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.isDefault isEqualToString:@"1"]) {
                weakSelf.infoModel.drugId = model.drugId;
                weakSelf.userModel = model;
            }
        }];
        
        [symptomList enumerateObjectsUsingBlock:^(MedicalSymptomListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.infoModel.goodsOtcArray enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([goodsModel.goodsId isEqualToString:model.goodsId]) {
                    model.goodsTitle = goodsModel.goodsTitle;
                    NSArray *symptom = [goodsModel.symptom componentsSeparatedByString:@","];
                    model.symptom = symptom;
                }
            }];
        }];
        model.symptomList = symptomList;
        weakSelf.mainModel = model;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf changeDefineBtnState];
    } failture:^(NSError * _Nullable error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf changeDefineBtnState];
    }];
    
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2+5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger cont = self.mainModel.symptomList.count == 0 ? 1 : self.mainModel.symptomList.count;
    return section == 4 ? cont : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0) {
        AddOrSelectPatientCell *titleCell = [tableView dequeueReusableCellWithIdentifier:AddOrSelectPatientCellID forIndexPath:indexPath];
        if (self.mainModel.persList.count > 0) {
            titleCell.persList = self.mainModel.persList;
        }
        if (self.infoModel.drugId.length > 0) {
            titleCell.drugId = self.infoModel.drugId;
        }
        titleCell.AddOrSelectPatientCell_editBlock = ^(MedicalPersListModel * _Nonnull model) {
            GLPAddPatientViewController *vc = [[GLPAddPatientViewController alloc] init];
            vc.drugId = model.drugId;
            vc.model = model;
            vc.GLPAddPatientViewController_block = ^{
                weakSelf.isFirstLoad = NO;
            };
            [weakSelf dc_pushNextController:vc];
        };
        titleCell.AddOrSelectPatientCell_AddBlock = ^{
            GLPAddPatientViewController *vc = [[GLPAddPatientViewController alloc] init];
            vc.GLPAddPatientViewController_block = ^{
                weakSelf.isFirstLoad = NO;
            };
            [weakSelf dc_pushNextController:vc];
        };
        titleCell.AddOrSelectPatientCell_selectedBlock = ^(MedicalPersListModel * _Nonnull model) {
            weakSelf.userModel = model;
            weakSelf.infoModel.drugId = model.drugId;
            [weakSelf changeDefineBtnState];
        };
        cell = titleCell;
    }else if (indexPath.section == 1) {
        MedicalTreatmentMethodCell *specCell = [tableView dequeueReusableCellWithIdentifier:MedicalTreatmentMethodCellID forIndexPath:indexPath];
        specCell.onlineStatus = self.infoModel.onlineStatus;
        specCell.MedicalTreatmentMethodCell_block = ^(NSString * _Nonnull onlineStatus) {
            weakSelf.infoModel.onlineStatus = onlineStatus;
            [weakSelf changeDefineBtnState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        };
        cell = specCell;
    }else if(indexPath.section == 2) {
        PrescriptionConfirmCell *titleCell = [tableView dequeueReusableCellWithIdentifier:PrescriptionConfirmCellID forIndexPath:indexPath];
        if (![self.infoModel.isConfirm isEqualToString:@"0"]) {
            titleCell.isSelected = YES;
        }
        titleCell.PrescriptionConfirmCell_block = ^{
            weakSelf.infoModel.isConfirm = @"1";
            [weakSelf.tableView reloadData];
            [weakSelf changeDefineBtnState];
        };
        cell = titleCell;
    }else if (indexPath.section == 3) {
        PrescriptionPromptCell *specCell = [tableView dequeueReusableCellWithIdentifier:PrescriptionPromptCellID forIndexPath:indexPath];
        cell = specCell;
    }else if (indexPath.section == 4) {
        DrugSideEffectCell *specCell = [tableView dequeueReusableCellWithIdentifier:DrugSideEffectCellID forIndexPath:indexPath];
        MedicalSymptomListModel *model = self.mainModel.symptomList[indexPath.row];
        specCell.model = model;
        NSString *symptoms = [weakSelf.infoModel.drugInfo objectForKey:model.goodsId];
        if (symptoms.length > 0) {
            NSArray *listArr = [symptoms componentsSeparatedByString:@","];
            specCell.selctedSymptom = [listArr mutableCopy];
        }
        specCell.DrugSideEffectCell_block = ^{
            [weakSelf delWriteTelNum:indexPath.row];
        };
        specCell.DrugSideEffectCell_backBlock = ^(NSString * _Nonnull symptoms) {
            [weakSelf.infoModel.drugInfo setObject:symptoms forKey:model.goodsId];
            [weakSelf changeDefineBtnState];
        };
        cell = specCell;
    }else if (indexPath.section == 5) {
        DescribeSymptomsCell *specCell = [tableView dequeueReusableCellWithIdentifier:DescribeSymptomsCellID forIndexPath:indexPath];
        if (self.infoModel.billDesc.length > 0) {
            specCell.leaveMsg = self.infoModel.billDesc;
        }
        specCell.DescribeSymptomsCell_block = ^(NSString * _Nonnull leaveMsg) {
            weakSelf.infoModel.billDesc = leaveMsg;
        };
        cell = specCell;
    }else if (indexPath.section == 6) {
        AdditionalInformationCell *specCell = [tableView dequeueReusableCellWithIdentifier:AdditionalInformationCellID forIndexPath:indexPath];
        if ([self.infoModel.onlineStatus isEqualToString:@"1"]) {
            specCell.showType = PrescriptionTypeOffline;
        }else{
            specCell.showType = PrescriptionTypeOnline;
        }
        if (self.infoModel.drugImgList.count != 0) {
            specCell.imgsList = self.infoModel.drugImgList;
        }
        specCell.AdditionalInformationCell_block = ^(NSArray * _Nonnull urlArr) {
            weakSelf.infoModel.drugImgList = [urlArr mutableCopy];
            __block NSString *drugImg = @"";
            [urlArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    drugImg = str;
                }else{
                    drugImg = [NSString stringWithFormat:@"%@,%@",drugImg,str];
                }
            }];
            self.infoModel.drugImg = drugImg;
            [weakSelf changeDefineBtnState];
            
        };
        cell = specCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0f;
    }else if(section == 1){
        return  10.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 5.0f;
    }else if(section == 1){
        return  2.0f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [UIView new];;
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    MedicalPromptHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MedicalPromptHeaderViewID];
    header.titleStr = @"以下信息仅用于互联网医院为您提供问诊开方服务。";
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 手动输入
- (void)delWriteTelNum:(NSInteger)indexRow{
    MedicalSymptomListModel *model = self.mainModel.symptomList[indexRow];
    
    //提示框添加文本输入框
    NSString *title  = @"请输入症状";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor dc_colorWithHexString:@"333333"] range:NSMakeRange(0, title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PFRSemibold size:17] range:NSMakeRange(0, title.length)];
    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for(UITextField *text in alert.textFields){
            
            NSMutableArray *newArray = [[NSMutableArray alloc] init];
            newArray = [model.symptom mutableCopy];
            __block BOOL isNeed = NO;
            [newArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([str isEqualToString: text.text]) {
                    isNeed = YES;
                    [DC_KEYWINDOW makeToast:@"已添加" duration:2 position:CSToastPositionBottom];
                }
            }];
            if (!isNeed && text.text.length != 0) {
                [newArray addObject:text.text];
                model.symptom = newArray;
                [strongSelf.tableView reloadData];
            }
        }
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [textField setFont:[UIFont systemFontOfSize:17]];
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.placeholder = @"输入症状";
        [textField addTarget:strongSelf action:@selector(writeTelNum:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)writeTelNum:(id)sender
{
    NSString *text = ((UITextField *)sender).text;
    if ([DCCheckRegular dc_checkContainsEmoji:text]) {
        return;
    }
    if (text.length > 30) {
        [self showTextOnKeyboard:@"输入限制30个字符以内"];
        ((UITextField *)sender).text = [((UITextField *)sender).text substringToIndex:30];
    }
}


#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
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
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        [_tableView registerClass:NSClassFromString(MedicalPromptHeaderViewID) forHeaderFooterViewReuseIdentifier:MedicalPromptHeaderViewID];
        [_tableView registerClass:NSClassFromString(AddOrSelectPatientCellID) forCellReuseIdentifier:AddOrSelectPatientCellID];
        [_tableView registerClass:NSClassFromString(MedicalTreatmentMethodCellID) forCellReuseIdentifier:MedicalTreatmentMethodCellID];
        
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:NSClassFromString(PrescriptionConfirmCellID) forCellReuseIdentifier:PrescriptionConfirmCellID];
        [_tableView registerClass:NSClassFromString(PrescriptionPromptCellID) forCellReuseIdentifier:PrescriptionPromptCellID];
        [_tableView registerClass:NSClassFromString(DrugSideEffectCellID) forCellReuseIdentifier:DrugSideEffectCellID];
        [_tableView registerClass:NSClassFromString(DescribeSymptomsCellID) forCellReuseIdentifier:DescribeSymptomsCellID];
        [_tableView registerClass:NSClassFromString(AdditionalInformationCellID) forCellReuseIdentifier:AdditionalInformationCellID];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)loadNewData{
    [self requestMainDataIsShowHUD:NO];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), kScreenW, kBottomView_H);
        [self.view addSubview:_bottomView];
        
        UILabel *promptLab = [[UILabel alloc] init];
        promptLab.backgroundColor = [UIColor clearColor];
        promptLab.text = @"风险提示：请如实填写就诊信息，不实填写需负全部责任！";
        promptLab.textColor = [UIColor dc_colorWithHexString:@"#FF4141"];
        promptLab.font = [UIFont fontWithName:PFR size:12];
        promptLab.textAlignment = NSTextAlignmentCenter;
        promptLab.frame = CGRectMake(0, 0, _bottomView.dc_width, kBottomView_H*0.25);
        [_bottomView addSubview:promptLab];
        
        _confirmBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_confirmBtn];
        [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:10];
        _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [_confirmBtn setTitle:@"保存并同意问诊" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(promptLab.frame), _bottomView.dc_width-30, kBottomView_H*0.5);
    }
    return _bottomView;
}

- (PatientDisplayInformationModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[PatientDisplayInformationModel alloc] init];
        _infoModel.drugId = @"";
        _infoModel.onlineStatus = @"0";
        _infoModel.drugImg = @"";
        _infoModel.billDesc = @"";
        _infoModel.isConfirm = @"0";
        _infoModel.drugImgList = [[NSMutableArray alloc] init];
        _infoModel.drugInfo = [NSMutableDictionary dictionary];
    }
    return _infoModel;
}

- (void)confirmBtnAction
{
    PatientDisplayInformationModel *model = [self.infoModel mutableCopy];
    !_GLPMedicalInformationVC_block ? : _GLPMedicalInformationVC_block(model,self.userModel);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeDefineBtnState{
    BOOL isYES = [self isActiveState:NO];
    if (isYES) {
        self.confirmBtn.userInteractionEnabled = YES;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    }else{
        self.confirmBtn.userInteractionEnabled = NO;
        self.confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#b9b9b9"];
    }
}

- (BOOL)isActiveState:(BOOL)isNeedToast{
    if ([self.infoModel.isConfirm isEqualToString:@"0"]) {
        return NO;
    }
    
    if (self.infoModel.drugId.length == 0) {
        return NO;
    }
    
    if (![self.infoModel.onlineStatus isEqualToString:@"0"]) {
        if (self.infoModel.drugImg.length == 0) {
            return NO;
        }
    }
    
    for (MedicalSymptomListModel *model in self.mainModel.symptomList) {
        NSString *goodsId = model.goodsId;
        NSString *sympatoms = self.infoModel.drugInfo[goodsId];
        if ([sympatoms dc_isNull] || sympatoms.length == 0) {
            return NO;
        }
    }
    return YES;
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
