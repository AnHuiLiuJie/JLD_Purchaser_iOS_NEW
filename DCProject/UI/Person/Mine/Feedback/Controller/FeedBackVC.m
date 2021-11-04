//
//  FeedBackVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/3.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "FeedBackVC.h"
#import "FeedBackTimeCell.h"
#import "FeedBackTVCell.h"
#import "AddPhotoTableViewCell.h"
#import "FeedBackTFCell.h"
#import "TZImagePickerController.h"
@interface FeedBackVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong) UILabel *pLab;
@property(nonatomic,strong)UITextView*contentTV;
@property(nonatomic,strong)UITextField*phoneTF;
@property(nonatomic,copy) NSString *timeStr;
@property(nonatomic,copy) NSString *phoneStr;
@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    self.tableView.tableFooterView = footView;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(14, 3, kScreenW-19, 34)];
    lab.numberOfLines=0;
    lab.text = @"*为了保护您的隐私，我们绝不会将您的反馈信息泄露给其他人，请您放心填写";
    lab.textColor = RGB_COLOR(255, 77, 0);
    lab.font = [UIFont systemFontOfSize:12];
    [footView addSubview:lab];
    UIButton*comfireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [comfireBtn setTitle:@"提交" forState:UIControlStateNormal];
    [comfireBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    comfireBtn.backgroundColor = RGB_COLOR(0, 190, 179);
    comfireBtn.layer.masksToBounds = YES;
    comfireBtn.layer.cornerRadius = 4;
    comfireBtn.frame = CGRectMake(38, 60, kScreenW-75, 40);
    [comfireBtn addTarget:self action:@selector(comfireClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:comfireBtn];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedBackTimeCell" bundle:nil] forCellReuseIdentifier:@"FeedBackTimeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedBackTVCell" bundle:nil] forCellReuseIdentifier:@"FeedBackTVCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedBackTFCell" bundle:nil] forCellReuseIdentifier:@"FeedBackTFCell"];
    self.photoArray = [NSMutableArray arrayWithCapacity:0];
    [self getinfo];
    
}
//获取时间，电话
- (void)getinfo
{
    [[DCAPIManager shareManager]person_getFeedBackInfosuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        self.timeStr = [NSString stringWithFormat:@"%@",dic[@"dateTime"]];
         self.phoneStr = [NSString stringWithFormat:@"%@",dic[@"phone"]];
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)comfireClick
{
    if (self.contentTV.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入反馈内容"];
        return;
    }
    if (self.phoneTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入常用手机"];
        return;
    }
    NSString *imageStr=@"";
    for (int i=0; i<self.photoArray.count; i++)
    {
        if (i==0)
       {
           imageStr = [NSString stringWithFormat:@"%@",self.photoArray[0]];
        }
        else{
            imageStr = [NSString stringWithFormat:@"%@,%@",imageStr,self.photoArray[i]];
        }
    }
    [[DCAPIManager shareManager]person_feedbackwithcellPhone:self.phoneTF.text content:self.contentTV.text imgs:imageStr success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"意见反馈成功"];
        [self performSelector:@selector(backClick) withObject:nil afterDelay:1.0];
    } failture:^(NSError *error) {
        
    }];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        FeedBackTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackTimeCell"];
        if (cell==nil)
        {
            cell = [[FeedBackTimeCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.Lab.text = [NSString stringWithFormat:@"工作时间:%@",self.timeStr];
        cell.phoneBtn.layer.masksToBounds = YES;
        cell.phoneBtn.layer.cornerRadius = 4;
        [cell.phoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section==1)
    {
        FeedBackTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackTVCell"];
        if (cell==nil)
        {
            cell = [[FeedBackTVCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        self.pLab=cell.pLab;
        cell.TV.delegate = self;
        self.contentTV=cell.TV;
        return cell;
    }
    else if(indexPath.section==2)
    {
        AddPhotoTableViewCell *cell = [AddPhotoTableViewCell cellWithTableView:tableView];
        cell.clickPhotoArray=self.photoArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleblock = ^(NSInteger deleId) {
            [SVProgressHUD showInfoWithStatus:@"删除成功"];
            [self.photoArray removeObjectAtIndex:deleId];
            [self.tableView reloadData];
        };
        cell.addblock = ^(NSInteger deleId) {
            [self addphoto];
        };
        return cell;
    }
    else{
        FeedBackTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackTFCell"];
        if (cell==nil)
        {
            cell = [[FeedBackTFCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        self.phoneTF=cell.TF;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        return 48;
    }
    else if(indexPath.section==1)
    {
        return 122;
    }
    else if (indexPath.section==2)
    {
        if (self.photoArray.count<3)
        {
            return  (kScreenW-50)/3+20;
        }
        else if(self.photoArray.count>=3&&self.photoArray.count<6)
        {
            return  (kScreenW-50)/3*2+30;
        }
        else
        {
            return  (kScreenW-50)/3*3+40;
        }
    }
    else{
        return 51;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1)
    {
        UIView *sectionview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
        sectionview1.backgroundColor = [UIColor whiteColor];
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 12, kScreenW-28, 22)];
        lab1.text = @"反馈内容";
        lab1.textColor = [UIColor blackColor];
        lab1.font = [UIFont systemFontOfSize:16];
        [sectionview1 addSubview:lab1];
        return sectionview1;
    }
    else if (section==2)
    {
        UIView *sectionview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
        sectionview2.backgroundColor = [UIColor whiteColor];
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 12, 40, 22)];
        lab2.text = @"图片";
        lab2.textColor = [UIColor blackColor];
        lab2.font = [UIFont systemFontOfSize:16];
        [sectionview2 addSubview:lab2];
        UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 12, kScreenW-70, 22)];
        lab3.text = @"（最多上传9张图）";
        lab3.textColor = RGB_COLOR(141, 141, 141);
        lab3.font = [UIFont systemFontOfSize:14];
        [sectionview2 addSubview:lab3];
        return sectionview2;
    }
    else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1||section==2)
    {
        return 46;
    }
    else{
         return 10;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0)
    {
        return 10;
    }
    else{
        return 0.01;
    }
    
}

- (void)addphoto
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.photoArray.count delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#3B95FF"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (int i=0; i<photos.count; i++)
        {
            NSArray *arr = [NSArray arrayWithObject:photos[i]];
            [[DCHttpClient shareClient] personRequestUploadWithPath:@"/common/upload" images:arr params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
                             
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
                                         [self.photoArray addObject:imageUrl];
                                         [self.tableView reloadData];
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
        }
      
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.pLab.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0)
    {
        self.pLab.hidden = YES;
    }
    else{
        self.pLab.hidden = NO;
    }
}
//打电话
- (void)callClick
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneStr];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
