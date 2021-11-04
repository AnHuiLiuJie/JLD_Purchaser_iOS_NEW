//
//  GLPUserInfoController.m
//  DCProject
//
//  Created by bigbing on 2019/8/23.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPUserInfoController.h"
#import "GLPUserInfoCell.h"

#import "STPickerSingle.h"
#import "TZImagePickerController.h"

static NSString *const listCellID = @"GLPUserInfoCell";

@interface GLPUserInfoController ()<STPickerSingleDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UIButton *saveBtn;
@property(nonatomic,strong)NSDictionary *personDic;
@property(nonatomic,copy) NSString *timeStr;
@end

@implementation GLPUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    self.titles = @[@"头像",@"昵称",@"性别",@"手机",@"QQ",@"微信"];
    self.placeholders = @[@"请上传头像",@"请填写昵称",@"请选择性别",@"请填写手机",@"请填写QQ",@"请填写微信"];
    self.contents = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = @[@"",@"",@"",@"",@"",@""];
    [self.contents addObjectsFromArray:arr];
    
    [self setUpTableView];
    [self.view addSubview:self.saveBtn];
    [self getPersonData];
}

- (void)getPersonData
{
    
    [[DCAPIManager shareManager]person_requestPersonDataWithisShowHUD:YES Success:^(id response) {
        NSDictionary *dic = response[@"data"];
        if (dic) {
            [self.contents removeAllObjects];
            NSString *userImg = dic[@"userImg"] ?  dic[@"userImg"] : @"";
            NSString *sexStr = dic[@"sex"] ? dic[@"sex"] : @"";
            NSString *sex;
            if ([sexStr isEqualToString:@"1"])
            {
                sex=@"男";
            }
            else if ([sexStr isEqualToString:@"2"])
            {
                sex=@"女";
            }
            else{
                sex=@"";
            }
            NSString *nickName = dic[@"nickName"] ? dic[@"nickName"] : @"";
            NSString *cellphone = dic[@"cellphone"] ? dic[@"cellphone"] : @"";
            NSString *qq = dic[@"qq"] ? dic[@"qq"] : @"";
            NSString *wechat = dic[@"wechat"] ? dic[@"wechat"]  : @"";
            self.timeStr=dic[@"modifyTime"] ? dic[@"modifyTime"] : @"";
            [self.contents addObjectsFromArray:@[userImg,nickName,sex,cellphone,qq,wechat]];
        }
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}
#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    [cell dc_setValueWithTitles:self.titles placeholders:self.placeholders contents:self.contents indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 60 : 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self pushPhotoSelectController];
    }
    
    if (indexPath.row == 2) {
        [self createSTPickerSingleWithTitle:@"性别" datas:@[@"男",@"女"]];
    }
}


#pragma mark - 选择照片
- (void)pushPhotoSelectController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#3B95FF"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    //    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    __block TZImagePickerController *blockSelf = imagePickerVc;
    WEAKSELF;
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if ([photos count] > 0) {
            [blockSelf.navigationBar setBackgroundImage:photos[0] forBarMetrics:UIBarMetricsDefault];
        }
        
        [[DCHttpClient shareClient] personRequestUploadWithPath:@"/common/upload" images:photos params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
            
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
                        [weakSelf.contents replaceObjectAtIndex:0 withObject:imageUrl];
                        [weakSelf.tableView reloadData];
                    }
                    
                } else {
                    
                    [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
                }
            }
            
        } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
            
            [SVProgressHUD dismiss];
            NSLog(@"响应失败 - %@",error);
            [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
        }];
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 创建性别选择器
- (void)createSTPickerSingleWithTitle:(NSString *)title datas:(NSArray *)datas
{
    if ([DC_KeyWindow.subviews.lastObject isKindOfClass:[STPickerSingle class]]) {
        return;
    }
    STPickerSingle *single = [[STPickerSingle alloc] init];
    [single setArrayData:[datas mutableCopy]];
    [single setTitle:title];
    single.font = [UIFont fontWithName:PFR size:14];
    single.titleColor = [UIColor dc_colorWithHexString:@"#3D444D"];
    single.widthPickerComponent = kScreenW;
    single.heightPickerComponent = 35;
    [single setContentMode:STPickerContentModeBottom];
    [single setDelegate:self];
    [single show];
}

#pragma mark - <STPickerSingleDelegate>
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    //    NSString *string = [selectedTitle isEqualToString:@"男"] ? @"1" : @"0";
    [self.contents replaceObjectAtIndex:2 withObject:selectedTitle];
    [self.tableView reloadData];
}


#pragma mark - action
- (void)saveBtnClick:(UIButton *)button
{
    DCTextField *nickTF = [(GLPUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField];
    DCTextField *QQTF = [(GLPUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] textField];
    DCTextField *weichatTF = [(GLPUserInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]] textField];
    NSString *sex = [self.contents[2] isEqualToString:@"男"] ? @"1" : @"2";
    [[DCAPIManager shareManager]person_requestSaveUserInfoWithuserImg:self.contents[0] nickName:nickTF.text sex:sex qq:QQTF.text wechat:weichatTF.text  modifyTimeParam:self.timeStr success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 54.0f;
    self.tableView.sectionHeaderHeight = 5.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    self.tableView.separatorColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
}


#pragma mark - lazy load
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(20, kScreenH - LJ_TabbarSafeBottomMargin - 44 - 20, kScreenW - 40, 44);
        [_saveBtn dc_cornerRadius:5];
        _saveBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        [_saveBtn setTitle:@"保存" forState:0];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
        _saveBtn.titleLabel.font = PFRFont(16);
        [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (NSMutableArray *)contents{
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}
@end
