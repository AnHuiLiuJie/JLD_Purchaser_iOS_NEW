//
//  AuthenticationVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "AuthenticationVC.h"
#import "TZImagePickerController.h"
@interface AuthenticationVC ()<TZImagePickerControllerDelegate>
@property(nonatomic,copy) NSString *imageType;
@property(nonatomic,copy) NSString *imageStr1;
@property(nonatomic,copy) NSString *imageStr2;
@property(nonatomic,copy) NSString *imageStr3;
@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.comfireBtn.layer.masksToBounds = YES;
    self.comfireBtn.layer.cornerRadius = 25;
    self.imageV1.userInteractionEnabled = YES;
    self.imageV1.tag=1;
    UITapGestureRecognizer*imagetap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    [self.imageV1 addGestureRecognizer:imagetap1];
    self.imageV2.userInteractionEnabled = YES;
    self.imageV2.tag=2;
    UITapGestureRecognizer*imagetap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    [self.imageV2 addGestureRecognizer:imagetap2];
    self.imageV3.userInteractionEnabled = YES;
    self.imageV3.tag=3;
    UITapGestureRecognizer*imagetap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    [self.imageV3 addGestureRecognizer:imagetap3];
    self.imageStr1=@"";
    self.imageStr2=@"";
    self.imageStr3=@"";
    if (![self.statuStr isEqualToString:@"1"])
    {
        [[DCAPIManager shareManager]person_GetAuthenInfosuccess:^(id response) {
            NSDictionary *dic = response[@"data"];
            self.imageStr1 = [NSString stringWithFormat:@"%@",dic[@"idCardFrontPic"]];
            self.imageStr2 = [NSString stringWithFormat:@"%@",dic[@"frontPic"]];
            self.imageStr3 = [NSString stringWithFormat:@"%@",dic[@"idCardFacePic"]];
            self.modifyTimeParam = [NSString stringWithFormat:@"%@",dic[@"modifyTime"]];
            self.nameTF.text = [NSString stringWithFormat:@"%@",dic[@"userName"]];
            self.idCardTF.text = [NSString stringWithFormat:@"%@",dic[@"idCard"]];
            [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:self.imageStr1] placeholderImage:[UIImage imageNamed:@"zm"]];
             [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:self.imageStr2] placeholderImage:[UIImage imageNamed:@"tr_fm"]];
             [self.imageV3 sd_setImageWithURL:[NSURL URLWithString:self.imageStr3] placeholderImage:[UIImage imageNamed:@"sc"]];
        } failture:^(NSError *error) {
            
        }];
        if ([self.statuStr isEqualToString:@"4"]) {
            self.comfireBtn.hidden = NO;
            self.imageV1.userInteractionEnabled = YES;
             self.imageV2.userInteractionEnabled = YES;
             self.imageV3.userInteractionEnabled = YES;
            self.nameTF.userInteractionEnabled = YES;
            self.idCardTF.userInteractionEnabled = YES;
        }
        else{
            self.imageV1.userInteractionEnabled = NO;
            self.imageV2.userInteractionEnabled = NO;
            self.imageV3.userInteractionEnabled = NO;
            self.nameTF.userInteractionEnabled = NO;
            self.idCardTF.userInteractionEnabled = NO;
             self.comfireBtn.hidden = YES;
        }
       
    }
    
}

- (void)imageClick:(UITapGestureRecognizer*)tap
{
    self.imageType = [NSString stringWithFormat:@"%ld",(long)tap.view.tag];
     [self pushPhotoSelectController];
}
#pragma mark - 选择照片
- (void)pushPhotoSelectController
{
    WEAKSELF;
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
                        if ([weakSelf.imageType isEqualToString:@"1"])
                        {
                            self.imageStr1=imageUrl;
                            [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:self.imageStr1] placeholderImage:[UIImage imageNamed:@"zm"]];
                        }
                        else if([weakSelf.imageType isEqualToString:@"2"])
                        {
                            self.imageStr2=imageUrl;
                            [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:self.imageStr2] placeholderImage:[UIImage imageNamed:@"tr_fm"]];
                        }
                        else{
                            self.imageStr3=imageUrl;
                            [self.imageV3 sd_setImageWithURL:[NSURL URLWithString:self.imageStr3] placeholderImage:[UIImage imageNamed:@"sc"]];
                        }
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

- (IBAction)comfireClick:(id)sender {
    if (self.nameTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入真实姓名"];
        return;
    }
    if (self.idCardTF.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入身份证号码"];
        return;
    }
    if (self.imageStr1.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请上传身份证正面"];
        return;
    }
    if (self.imageStr2.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请上传身份证反面"];
        return;
    }
    if (self.imageStr3.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请上传手持身份证"];
        return;
    }
    [[DCAPIManager shareManager]person_AuthenWithuserName:self.nameTF.text idCard:self.idCardTF.text modifyTimeParam:self.modifyTimeParam idCardFrontPic:self.imageStr1 frontPic:self.imageStr2 idCardFacePic:self.imageStr3 success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"实名认证提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failture:^(NSError *error) {
        
    }];
}
@end
