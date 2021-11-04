//
//  GLBAddInfoController.m
//  DCProject
//
//  Created by bigbing on 2019/7/26.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddInfoController.h"

#import "GLBAddInfoTFCell.h"
#import "GLBAddInfoTVCell.h"
#import "GLBAddInfoAuthorizationCell.h"
#import "GLBAddInfoUploadCell.h"

#import "GLBQualificateModel.h"

#import "GLBSelectCompanyController.h"
#import "GLBSelectAreaController.h"
#import "TZImagePickerController.h"
#import "DCNavigationController.h"
#import "GLBGuideController.h"

static NSString *const tfCellID = @"GLBAddInfoTFCell";
static NSString *const tvCellID = @"GLBAddInfoTVCell";
static NSString *const updateCellID = @"GLBAddInfoUploadCell";
static NSString *const authCellID = @"GLBAddInfoAuthorizationCell";

@interface GLBAddInfoController ()<UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *commintBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;

// 需要上传的资质列表
@property (nonatomic, strong) NSMutableArray<GLBQualificateListModel *> *requireArray;

// 资质模型
@property (nonatomic, strong) GLBQualificateModel *qualificateModel;
// 企业类型
@property (nonatomic, strong) GLBCompanyTypeModel *typeModel;
// 企业子类型
@property (nonatomic, strong) GLBCompanyTypeModel *subTypeModel;
// 地区id
@property (nonatomic, assign) NSInteger areaId;

@end

@implementation GLBAddInfoController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_popBackDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_popBackDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"资质提交";
    if (_hiddedSkipBtn == NO) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dc_itemWithTitle:@"跳过" color:[UIColor dc_colorWithHexString:@"#00B7AB"] font:[UIFont fontWithName:PFR size:14] target:self action:@selector(skipAction:)];
    }
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dc_leftItemWithImage:[UIImage imageNamed:@"dc_fanhui_hei"] target:self action:@selector(backItemAction:)];
    
    [self.view addSubview:self.commintBtn];
    [self.view addSubview:self.tableView];
    
    self.index = arc4random() % 2;
    
    [self.dataArray addObjectsFromArray:@[@[@"",@"",@"",@""],@[@"",@""],@[@""]]];
    [self.tableView reloadData];
    
    [self requestQualicateModel];
}


#pragma mark - <UITableViewDataSource && UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + self.requireArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 1;
    } else {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0)) {
        
        GLBAddInfoTFCell *tfCell = [tableView dequeueReusableCellWithIdentifier:tfCellID forIndexPath:indexPath];
        [tfCell setAddInfoValueWithContents:self.dataArray index:self.index indexPath:indexPath];
        tfCell.tfClickBlock = ^{
            if (indexPath.section == 0 && indexPath.row == 3
                ) { // 选择企业类型
                [weakSelf dc_presentSelectCompanyTypeController];
            } else if (indexPath.section == 1 && indexPath.row == 0) {
                [weakSelf dc_presentSelectAreaController];
            }
        };
        tfCell.textFieldBlock = ^(NSString *text) {
            NSMutableArray *array = [weakSelf.dataArray[indexPath.section] mutableCopy];
            [array replaceObjectAtIndex:indexPath.row withObject:text];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:array];
        };
        cell = tfCell;
        
    } else if (indexPath.section == 1){
        
        GLBAddInfoTVCell *tvCell = [tableView dequeueReusableCellWithIdentifier:tvCellID forIndexPath:indexPath];
        tvCell.textView.content = self.dataArray[indexPath.section][indexPath.row];
        tvCell.textViewBlock = ^(NSString *text) {
            NSMutableArray *array = [weakSelf.dataArray[indexPath.section] mutableCopy];
            [array replaceObjectAtIndex:indexPath.row withObject:text];
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:array];
        };
        cell = tvCell;
 
    } else {
        
        GLBAddInfoUploadCell *uploadCell = [tableView dequeueReusableCellWithIdentifier:updateCellID forIndexPath:indexPath];
        if (self.requireArray.count > 0) {
            uploadCell.listModel = self.requireArray[indexPath.section - 3];
        }
        uploadCell.uploadBlock = ^{
            [weakSelf dc_openImagePickerController:indexPath];
        };
        uploadCell.deleteBlock = ^(NSMutableArray *newArray) {
            GLBQualificateListModel *listModel = weakSelf.requireArray[indexPath.section - 3];
            listModel.imgUrlArray = newArray;
            [weakSelf.requireArray replaceObjectAtIndex:indexPath.section - 3 withObject:listModel];
            [weakSelf.tableView reloadData];
        };
        cell = uploadCell;
            
//        } else {
//
//            GLBAddInfoAuthorizationCell *authCell = [tableView dequeueReusableCellWithIdentifier:authCellID forIndexPath:indexPath];
//            cell = authCell;
//
//        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 3 ? 0.01f : 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    NSString *company = self.dataArray[0][1];
    NSString *name = self.dataArray[0][2];
    NSString *area = self.dataArray[1][0];
    NSString *address = self.dataArray[1][1];
    
    if (company.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入企业名称"];
        return;
    }
    if (name.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人"];
        return;
    }
    if (area.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择所在地区"];
        return;
    }
    if (address.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    
    NSMutableArray *qcArray = [NSMutableArray array];
    for (NSInteger i=0; i<self.requireArray.count; i++) {
        GLBQualificateListModel *listModel = self.requireArray[i];
        if ([listModel.isRequired isEqualToString:@"1"]) {
            if ([listModel.imgUrlArray count] == 0) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请上传%@",listModel.qcName]];
                return;
            }
            
            NSString *qcPic = @"";
            if ([listModel.imgUrlArray count] > 0) {
                for (int i=0; i<[listModel.imgUrlArray count]; i++) {
                    NSString *imageUrl = listModel.imgUrlArray[i];
                    if (i == 0) {
                        qcPic = imageUrl;
                    } else {
                        qcPic = [NSString stringWithFormat:@"%@,%@",qcPic,imageUrl];
                    }
                }
            }
            
            NSDictionary *dict = @{@"isRequired":listModel.isRequired,
                                    @"qcCode":listModel.qcCode,
                                    @"qcName":listModel.qcName,
                                    @"qcPic":qcPic
                                    };
            [qcArray addObject:dict];
        }
    }
    
    [self requestCommintQualicateWith:address firmArea:area firmContact:name firmName:company qcList:qcArray];
}

- (void)skipAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backItemAction:(id)sender
{
    [self skipAction:nil];
}


#pragma mark - 选择公司类型
- (void)dc_presentSelectCompanyTypeController
{
    WEAKSELF;
    GLBSelectCompanyController *vc = [GLBSelectCompanyController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.typeBlock = ^(GLBCompanyTypeModel *type, GLBCompanyTypeModel *subType) {
        weakSelf.typeModel = type;
        weakSelf.subTypeModel = subType;
        
        NSString *typeStr = [NSString stringWithFormat:@"%@-%@",weakSelf.typeModel.catName,weakSelf.subTypeModel.catName];
        if (typeStr && typeStr.length > 0) {
            NSMutableArray *array = [weakSelf.dataArray[0] mutableCopy];
            [array replaceObjectAtIndex:3 withObject:typeStr];
            [weakSelf.dataArray replaceObjectAtIndex:0 withObject:array];
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf requestRequireQualicate:[NSString stringWithFormat:@"%ld",weakSelf.typeModel.catId] firmCat2:[NSString stringWithFormat:@"%ld",weakSelf.subTypeModel.catId]];
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark - 选择地区
- (void)dc_presentSelectAreaController
{
    WEAKSELF;
    GLBSelectAreaController *vc = [GLBSelectAreaController new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.areaBlock = ^(NSString *areaFullName, NSInteger areaId) {
        weakSelf.areaId = areaId;
        
        NSMutableArray *array = [weakSelf.dataArray[1] mutableCopy];
        [array replaceObjectAtIndex:0 withObject:areaFullName];
        [weakSelf.dataArray replaceObjectAtIndex:1 withObject:array];
        [weakSelf.tableView reloadData];
    };
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark - 打开图片选择器
- (void)dc_openImagePickerController:(NSIndexPath *)indexpath
{
    WEAKSELF;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if ([photos count] > 0) {
            [weakSelf requestUploadImage:photos indexPath:indexpath];
        }
        
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 请求 获取需要上传的资质信息
- (void)requestRequireQualicate:(NSString *)firmCat1 firmCat2:(NSString *)firmCat2
{
    [self.requireArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestRequireUploadQualificateWithfirmCat1:firmCat1 firmCat2:firmCat2 success:^(id response) {
        if (response && [response count]>0) {
            [weakSelf.requireArray addObjectsFromArray:response];
        }
        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 获取资质信息
- (void)requestQualicateModel
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyQualificateWithSuccess:^(id response) {
        if (response) {
            weakSelf.qualificateModel = response;
            
            [weakSelf setQualificateValue];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 资质提交
- (void)requestCommintQualicateWith:(NSString *)address firmArea:(NSString *)firmArea firmContact:(NSString *)firmContact firmName:(NSString *)firmName qcList:(NSArray *)qcList
{
    NSString *firmCat1 = [NSString stringWithFormat:@"%ld",self.typeModel.catId];
    NSString *firmCat2List = [NSString stringWithFormat:@"%ld",self.subTypeModel.catId];
    NSInteger firmId = self.qualificateModel.firmId;
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCommintQualificateWithFirmAddress:address firmArea:firmArea firmAreaId:self.areaId firmCat1:firmCat1 firmCat2List:firmCat2List firmContact:firmContact firmId:firmId firmName:firmName qcList:qcList success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
//                DC_KeyWindow.rootViewController = [[DCNavigationController alloc] initWithRootViewController:[GLBGuideController new]];
            });
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 上传图片
- (void)requestUploadImage:(NSArray *)images indexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    WEAKSELF;
    [[DCHttpClient shareClient] requestUploadWithPath:@"/common/upload" images:images params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if (responseObject) {
            NSDictionary *dict = [responseObject mj_JSONObject];
            if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) { // 请求成功
                
                if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dictionary = dict[@"data"];
                    NSString *imageUrl = dictionary[@"uri"];
                    if (!imageUrl || [imageUrl dc_isNull]) {
                        imageUrl = @"";
                    }
                    
                    GLBQualificateListModel *model = weakSelf.requireArray[indexPath.section - 3];
                    NSMutableArray *imgUrlArray = [model.imgUrlArray mutableCopy];
                    [imgUrlArray addObject:imageUrl];
                    model.imgUrlArray = imgUrlArray;
                    [weakSelf.requireArray replaceObjectAtIndex:indexPath.section - 3 withObject:model];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];;
                }
                
            } else {
                
                [SVProgressHUD showInfoWithStatus:dict[DC_ResultMsg_Key]];
            }
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"响应失败 - %@",error);
        [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
    }];
}


#pragma mark - 赋值
- (void)setQualificateValue
{
    if (self.qualificateModel) {
        
        NSString *code = [NSString stringWithFormat:@"%ld",self.qualificateModel.firmId];
        NSString *company = self.qualificateModel.firmName;
        NSString *name = self.qualificateModel.firmContact;
        NSString *area = self.qualificateModel.firmArea;;
        self.areaId = self.qualificateModel.firmAreaId;
        
        if (code && code.length > 0) {
            NSMutableArray *array = [self.dataArray[0] mutableCopy];
            [array replaceObjectAtIndex:0 withObject:code];
            [self.dataArray replaceObjectAtIndex:0 withObject:array];
        }
        
        if (company && company.length > 0) {
            NSMutableArray *array = [self.dataArray[0] mutableCopy];
            [array replaceObjectAtIndex:1 withObject:company];
            [self.dataArray replaceObjectAtIndex:0 withObject:array];
        }
        
        if (name && name.length > 0) {
            NSMutableArray *array = [self.dataArray[0] mutableCopy];
            [array replaceObjectAtIndex:2 withObject:name];
            [self.dataArray replaceObjectAtIndex:0 withObject:array];
        }
        
        if (area && area.length > 0) {
            NSMutableArray *array = [self.dataArray[1] mutableCopy];
            [array replaceObjectAtIndex:0 withObject:area];
            [self.dataArray replaceObjectAtIndex:1 withObject:array];
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - 44 - 20*2) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.sectionHeaderHeight = 5.0f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        
        [_tableView registerClass:NSClassFromString(tfCellID) forCellReuseIdentifier:tfCellID];
        [_tableView registerClass:NSClassFromString(tvCellID) forCellReuseIdentifier:tvCellID];
        [_tableView registerClass:NSClassFromString(authCellID) forCellReuseIdentifier:authCellID];
        [_tableView registerClass:NSClassFromString(updateCellID) forCellReuseIdentifier:updateCellID];
    }
    return _tableView;
}

- (UIButton *)commintBtn{
    if (!_commintBtn) {
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commintBtn.frame = CGRectMake(15, kScreenH - 44 - 20, kScreenW - 15*2, 44);
        _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_commintBtn setTitle:@"提交审核" forState:0];
        [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
        _commintBtn.titleLabel.font = PFRFont(16);
        [_commintBtn dc_cornerRadius:22];
        [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commintBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)requireArray{
    if (!_requireArray) {
        _requireArray = [NSMutableArray array];
    }
    return _requireArray;
}

@end
