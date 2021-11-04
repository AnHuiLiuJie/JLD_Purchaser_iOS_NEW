//
//  RequestCommitVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "RequestCommitVC.h"
#import "PrecriptionGoodsCell.h"
#import "TRRequestAddressCell.h"
#import "TRRequestCommodityCell.h"
#import "TRrequestTFCell.h"
#import "TRRequestPicCell.h"
#import "TRRequestPriceCell.h"
#import "GLPAddressListVC.h"
#import "GLPGoodsAddressModel.h"
#import "TZImagePickerController.h"
@interface RequestCommitVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) GLPGoodsAddressModel *adressmodel;
@property(nonatomic,copy) NSString *imageStr;
@property(nonatomic,copy) NSString *imageStr1;
@property(nonatomic,copy) NSString *imageStr2;
@property(nonatomic,copy) NSString *imageType;//1,2,3按顺序
@property(nonatomic,strong)UITextField*remakeTF;
@end

@implementation RequestCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"需求清单提交";
    
//    self.tableview.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor]
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-LJ_TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"TRRequestAddressCell" bundle:nil] forCellReuseIdentifier:@"TRRequestAddressCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"TRRequestCommodityCell" bundle:nil] forCellReuseIdentifier:@"TRRequestCommodityCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"TRrequestTFCell" bundle:nil] forCellReuseIdentifier:@"TRrequestTFCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"TRRequestPicCell" bundle:nil] forCellReuseIdentifier:@"TRRequestPicCell"];
      [self.tableview registerNib:[UINib nibWithNibName:@"TRRequestPriceCell" bundle:nil] forCellReuseIdentifier:@"TRRequestPriceCell"];
    [self.view addSubview:self.tableview];
    self.tableview.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff" alpha:0];
    self.imageStr=@"";
    self.imageStr1=@"";
    self.imageStr2=@"";
    self.imageType = @"1";
    [self getdefautAddress];
}

- (void)getdefautAddress
{
    [[DCAPIManager shareManager]person_GetDefautAddresssuccess:^(id response) {
        NSDictionary *dic = response[@"data"];
        self.adressmodel = [GLPGoodsAddressModel mj_objectWithKeyValues:dic];
        [self.tableview reloadData];
    } failture:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4+self.goodsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        TRRequestAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRRequestAddressCell"];
        if (cell== nil)
        {
            cell = [[TRRequestAddressCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *dic = [self.adressmodel mj_keyValues];
        if ([dic dc_isNull]||[dic isEqualToDictionary:@{}])
        {
            cell.addLab.hidden = NO;
            cell.nameLab.hidden = YES;
            cell.addressLab.hidden = YES;
        }
        else{
            cell.addLab.hidden = YES;
            cell.nameLab.hidden = NO;
            cell.addressLab.hidden = NO;
            cell.nameLab.text = [NSString stringWithFormat:@"%@  %@",self.adressmodel.recevier,self.adressmodel.cellphone];
            cell.addressLab.text = [NSString stringWithFormat:@"%@ %@",self.adressmodel.areaName,self.adressmodel.streetInfo];
        }
        return cell;
    }
   else if (indexPath.section==self.goodsArray.count+1) {
        TRrequestTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRrequestTFCell"];
        if (cell== nil)
        {
            cell = [[TRrequestTFCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
       self.remakeTF=cell.rightTF;
        return cell;
    }
   else if (indexPath.section==self.goodsArray.count+2) {
       TRRequestPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRRequestPicCell"];
       if (cell== nil)
       {
           cell = [[TRRequestPicCell alloc] init];
       }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.backgroundColor = [UIColor whiteColor];
       [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"human_my_photo_add"]];
       cell.imageV.userInteractionEnabled = YES;
       UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addpicClick)];
       [cell.imageV addGestureRecognizer:tap];
       
       [cell.imageV1 sd_setImageWithURL:[NSURL URLWithString:self.imageStr1] placeholderImage:[UIImage imageNamed:@"human_my_photo_add"]];
       cell.imageV1.userInteractionEnabled = YES;
       UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addpicClick1)];
       [cell.imageV1 addGestureRecognizer:tap1];
       
       [cell.imageV2 sd_setImageWithURL:[NSURL URLWithString:self.imageStr2] placeholderImage:[UIImage imageNamed:@"human_my_photo_add"]];
       cell.imageV2.userInteractionEnabled = YES;
       UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addpicClick2)];
       [cell.imageV2 addGestureRecognizer:tap2];
       return cell;
   }
   else if (indexPath.section==self.goodsArray.count+3) {
       TRRequestPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRRequestPriceCell"];
       if (cell== nil)
       {
           cell = [[TRRequestPriceCell alloc] init];
       }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.backgroundColor = [UIColor whiteColor];
       NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需付：¥%@",self.allPrice]];
       NSRange range1 = [[str string] rangeOfString:@"需付：¥"];
       [str addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(120, 120, 120) range:range1];
       NSRange range2 = [[str string] rangeOfString:@"需付：¥"];
       [str addAttribute:NSFontAttributeName value:[UIFont  systemFontOfSize:14 weight:UIFontWeightRegular] range:range2];
       cell.priceLab.attributedText = str;
       
       cell.callbtn.hidden = YES;
       [cell.callbtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
       [cell.commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
       return cell;
   }
    else{
        TRRequestCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRRequestCommodityCell"];
        if (cell== nil)
        {
            cell = [[TRRequestCommodityCell alloc] init];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *dic = self.goodsArray[indexPath.section-1];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"goodsImg"]] placeholderImage:[UIImage imageNamed:@"logo"]];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",dic[@"goodsTitle"]];
        cell.sepacLab.text = [NSString stringWithFormat:@"%@",dic[@"packingSpec"]];
        cell.numLab.text = [NSString stringWithFormat:@"X%@",dic[@"quantity"]];
        cell.marketLab.text = [NSString stringWithFormat:@"市场价：¥%@",dic[@"marketPrice"]];
        cell.marketLab = [UILabel setupAttributeLabel:cell.marketLab textColor:cell.marketLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        cell.sellLab.text = [NSString stringWithFormat:@"¥%@",dic[@"sellPrice"]];
        cell.totalLab.text = [NSString stringWithFormat:@"单品小计：¥%.2f",[dic[@"sellPrice"] floatValue]*[dic[@"quantity"] intValue]];
        cell.totalLab = [UILabel setupAttributeLabel:cell.totalLab textColor:cell.totalLab.textColor minFont:nil maxFont:nil forReplace:@"¥"];

        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        return 89;
    }
    else if (indexPath.section==self.goodsArray.count+1) {
       return 54;
     }
    else if (indexPath.section==self.goodsArray.count+2) {
        return 174;
    }
    else if (indexPath.section==self.goodsArray.count+3) {
        return 59;
    }
    else{
        return 186;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        GLPAddressListVC *vc = [[GLPAddressListVC alloc] init];
        vc.isChose = @"1";
        vc.addressblock = ^(GLPGoodsAddressModel *_Nonnull model) {
            self.adressmodel = model;
            [self.tableview reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
//选择照片1
- (void)addpicClick
{
    self.imageType = @"1";
     [self pushPhotoSelectController];
}
//选择照片2
- (void)addpicClick1
{
    self.imageType = @"2";
    [self pushPhotoSelectController];
}
//选择照片3
- (void)addpicClick2
{
    self.imageType = @"3";
    [self pushPhotoSelectController];
}
#pragma mark - 选择照片
- (void)pushPhotoSelectController
{
   
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#3B95FF"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [[DCHttpClient shareClient] personRequestUploadWithPath:@"/common/upload" images:photos params:@{} progress:^(NSProgress *_Nonnull uploadProgress) {
            
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
                        if ([self.imageType isEqualToString:@"1"])
                        {
                             self.imageStr=imageUrl;
                        }
                        else if ([self.imageType isEqualToString:@"2"])
                        {
                            self.imageStr1=imageUrl;
                        }
                        else{
                             self.imageStr2=imageUrl;
                        }
                       
                        [self.tableview reloadData];
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
//打电话
- (void)callClick
{
    
}
//提交
- (void)commitClick
{
    
    if (self.adressmodel== nil||[self.adressmodel isEqual:[NSNull null]])
    {
        [SVProgressHUD showInfoWithStatus:@"请选择收货地址"];
        return;
    }
    if (self.imageStr.length==0&&self.imageStr1.length==0&&self.imageStr2.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请上传处方图片"];
        return;
    }
    
    NSString *cartIdStr=@"";
    for (int i=0; i<self.goodsArray.count; i++)
    {
        NSDictionary *dic = self.goodsArray[i];
        if (i==0)
        {
            cartIdStr = [NSString stringWithFormat:@"%@",dic[@"cartId"]];
        }
        else{
            cartIdStr = [NSString stringWithFormat:@"%@,%@",cartIdStr,dic[@"cartId"]];
        }
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (self.imageStr.length!=0)
    {
        [arr addObject:self.imageStr];
    }
    if (self.imageStr1.length!=0)
    {
        [arr addObject:self.imageStr1];
    }
    if (self.imageStr2.length!=0)
    {
        [arr addObject:self.imageStr2];
    }
    NSString *imageString = @"";
    for (int i=0; i<arr.count; i++)
    {
        if (i==0)
        {
            imageString=arr[0];
        }
        else{
            imageString = [NSString stringWithFormat:@"%@,%@",imageString,arr[i]];
        }
    }
    if ([self.goodsId dc_isNull]||self.goodsId.length==0)
    {
        [[DCAPIManager shareManager]person_comfirRequestwithentrance:@"2" addrId:[NSString stringWithFormat:@"%@",self.adressmodel.addrId] cartIds:cartIdStr leaveMsg:self.remakeTF.text prescriptionImg:imageString success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        [[DCAPIManager shareManager]person_detailComfireRequestwithgoodsId:self.goodsId quantity:self.quanlity addrId:self.adressmodel.addrId leaveMsg:self.remakeTF.text prescriptionImg:imageString success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
        } failture:^(NSError *error) {
            
        }];
    }
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
