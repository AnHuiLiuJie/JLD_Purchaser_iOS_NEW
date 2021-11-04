//
//  AddGoodsVC.m
//  DCProject
//
//  Created by 刘德山 on 2020/11/5.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "AddGoodsVC.h"
#import <TZImagePickerController.h>
@interface AddGoodsVC ()
@property (nonatomic,strong) UIView *imgeBG ;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,strong) NSMutableArray *imageArrSet;
@property (nonatomic,strong) UITextField *filedp;
@property (nonatomic,strong) UITextField *filedp1;
@property (nonatomic,strong) UITextField *filedp2;
@property (nonatomic,strong) UITextField *filedp3;
@property (nonatomic,strong) UIView *sucesV;
@property (nonatomic,strong) UIScrollView *scrl;
@property (nonatomic,strong) UIButton *btconf;

@end

@implementation AddGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品登记";
    [self dc_navBarHidden:NO];
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"f5f5f5"];
   _scrl = [[UIScrollView alloc] init];
    [self.view addSubview:_scrl];
    [_scrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kTabBarHeight);
        make.bottom.offset((kStatusBarHeight>20?-46:0)-80);
    }];
    UIView *bg = [[UIView alloc] init];
    [_scrl addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
        make.width.offset(kScreenW);
    }];
    bg.backgroundColor = [UIColor whiteColor];
    UILabel *la = [[UILabel alloc] init];
    la.text = @"请填写您想要的商品信息，并留下您的联系方式，方便我们到货后及时通知您！";
    la.numberOfLines = 0;
    la.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    la.textColor = [UIColor dc_colorWithHexString:@"#FF5503"];
    [bg addSubview:la];
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.right.offset(-15);
    }];
    for (int i = 0; i<3; i++) {
        UITextField *la2 = [[UITextField alloc] init];
        la2.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
        la2.textColor = [UIColor dc_colorWithHexString:@"#8E8E8E"];
        [bg addSubview:la2];
        [la2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.height.offset(54);
            make.top.mas_equalTo(la.mas_bottom).offset(15+54*i);
            make.width.offset(300);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
        [bg addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(0);
            make.height.offset(0.5);
            make.bottom.mas_equalTo(la2.mas_bottom);
        }];
        switch (i) {
            case 0:
                la2.placeholder = @"品名";
                _filedp = la2;
                break;
            case 1:
                la2.placeholder = @"规格";
                _filedp1= la2;
                break;
            case 2:
                la2.placeholder = @"生产厂家";
                _filedp2 = la2;
                break;
                
            default:
                break;
        }
    }
    UILabel *la3 = [[UILabel alloc] init];
    la3.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
    la3.text = @"图片";
    [bg addSubview:la3];
    [la3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(la.mas_bottom).offset(15+54*3+30);
    }];
    UILabel *la4 = [[UILabel alloc] init];
    la4.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    la4.text = @"（您可以直接上传包装盒图片）";
    la4.textColor = [UIColor dc_colorWithHexString:@"#8D8D8D"];
    [bg addSubview:la4];
    [la4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(la3.mas_right).offset(0);
        make.centerY.mas_equalTo(la3);
    }];
  _imgeBG = [[UIView alloc] init];
    [bg addSubview:_imgeBG];
    [_imgeBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(la4.mas_bottom).offset(0);
//        make.height.offset(120);
    }];
    [self upimge];
    
    UIView *lin2 = [[UIView alloc] init];
    lin2.backgroundColor = [UIColor dc_colorWithHexString:@"f5f5f5"];
    [bg addSubview:lin2];
    [lin2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(_imgeBG.mas_bottom).offset(0);
        make.height.offset(10);
    }];
    UILabel *la5 = [[UILabel alloc] init];
    la5.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightRegular)];
//    la5.textColor = [UIColor dc_colorWithHexString:@"#8E8E8E"];
    la5.text = @"常用手机";
    [bg addSubview:la5];
    [la5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(54);
        make.top.mas_equalTo(lin2.mas_bottom).offset(0);
    }];
    UITextField *filed = [[UITextField alloc] init];
    filed.placeholder = @"请准确填写您的手机号";
    filed.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    [bg addSubview:filed];
    [filed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(54);
        make.top.mas_equalTo(lin2.mas_bottom).offset(0);
        make.width.offset(240);
    }];
    filed.textAlignment = NSTextAlignmentRight;
    _filedp3 = filed;
    _filedp3.keyboardType = UIKeyboardTypeNumberPad;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor dc_colorWithHexString:@"f5f5f5"];
    [bg addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.mas_equalTo(la5.mas_bottom).offset(0);
        make.height.offset(40);
    }];
    UILabel *la8 = [[UILabel alloc] init];
    la8.text = @"*为了保护您的隐私，我们绝不会将您的反馈信息泄露给其他人，请您放心填写";
    la8.numberOfLines = 0;
    la8.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
    la8.textColor = [UIColor dc_colorWithHexString:@"#FF5503"];
    [v addSubview:la8];
    [la8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(v.mas_bottom).offset(0);
    }];
 _btconf = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_btconf setTitle:@"提交" forState:0];
    _btconf.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    _btconf.backgroundColor = [UIColor dc_colorWithHexString:@"#02A299"];
    _btconf.layer.cornerRadius = 3;
    [self.view addSubview:_btconf];
    [_btconf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.mas_equalTo(_scrl.mas_bottom).offset(10);
        make.height.offset(50);
    }];
    _imageArrSet = [NSMutableArray array];
    _imageArr = [NSMutableArray array];
    [_btconf addTarget:self action:@selector(ti) forControlEvents:(UIControlEventTouchUpInside)];
    _sucesV = [[UIView alloc] init];
    _sucesV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sucesV];
    [_sucesV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kTabBarHeight);
        make.height.offset(400);
    }];
    UIView *lin3 = [[UIView alloc] init];
    lin3.backgroundColor = [UIColor dc_colorWithHexString:@"eeeeee"];
    [self.view addSubview:lin3];
    [lin3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kTabBarHeight+1);
        make.height.offset(0.5);
    }];
    UIImageView *ico = [[UIImageView alloc] init];
    ico.image = [UIImage imageNamed:@"jic"];
    [_sucesV addSubview:ico];
    [ico mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.offset(0);
    }];
    UILabel *la10 = [[UILabel alloc] init];
    la10.text = @"提交完成";
    la10.numberOfLines = 0;
    la10.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightMedium)];
   
    [_sucesV addSubview:la10];
    [la10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ico.mas_bottom).offset(12);
        make.centerX.offset(0);
    }];
    
    UILabel *la11 = [[UILabel alloc] init];
    la11.text = @"您的需求已提交，我们将尽快补充您所需的商品。感谢您的关注，您现在可以";
    la11.numberOfLines = 0;
    la11.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
    la11.textColor = [UIColor dc_colorWithHexString:@"#8E8C8C"];
    [_sucesV addSubview:la11];
    la11.textAlignment = NSTextAlignmentCenter;
    [la11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(la10.mas_bottom).offset(12);
        make.centerX.offset(0);
        make.width.offset(250);
    }];
    UIButton *bt4 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [bt4 setTitle:@"回到首页" forState:0];
    [bt4 setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
    bt4.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    bt4.layer.cornerRadius = 21;
    bt4.layer.borderWidth = 0.5;
    bt4.layer.borderColor = [UIColor dc_colorWithHexString:DC_BtnColor].CGColor;
    [_sucesV addSubview:bt4];
    [bt4 mas_makeConstraints:^(MASConstraintMaker *make) {
   make.centerX.offset(0);
        make.height.offset(42);
        make.width.offset(160);
        make.top.mas_equalTo(la11.mas_bottom).offset(46);
    }];
    [bt4 addTarget:self action:@selector(djgd) forControlEvents:(UIControlEventTouchUpInside)];
    _sucesV.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DC_KeyWindow endEditing:YES];//关闭键盘
}

- (void)djgd{
  //  [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)ti{
    if (_filedp.text.length == 0 && _imageArr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"品名或图片至少上传一样！"];
        return;
    }
//    if (_filedp1.text.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"请输入规格"];
//        return;
//    }
//    if (_filedp2.text.length == 0) {
//        [SVProgressHUD showInfoWithStatus:@"请输入生产厂家"];
//        return;
//    }
    if (_filedp3.text.length >0) {
        if (_filedp3.text.length != 11) {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
            return;
        }
    }
   
    if (_imageArr.count == 0) {
        WEAKSELF
        NSDictionary *params = @{@"goodsImgs":@"",@"goodsName":_filedp.text,@"manufactory":_filedp2.text,@"packingSpec":_filedp1.text,@"phone":_filedp3.text,@"source":@"2"};
        [SVProgressHUD show];
        [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product/goodsInfoApply" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dict = [responseObject mj_JSONObject];
            if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
                if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    weakSelf.scrl.hidden = YES;
                    weakSelf.sucesV.hidden = NO;
                    weakSelf.btconf.hidden = YES;
                }
            } else {
                [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            }
        } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
            [SVProgressHUD dismiss];
           
        }];
        
        return;
    }
    NSMutableArray *url = [NSMutableArray array];
    WEAKSELF
    [SVProgressHUD show];
    for (int i=0; i<_imageArr.count; i++)
    {
        NSArray *arr = [NSArray arrayWithObject:_imageArr[i]];
        [[DCHttpClient shareClient] personRequestUploadWithPath:@"/common/upload" images:arr params:nil progress:^(NSProgress *_Nonnull uploadProgress) {
                         
                     } sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
                         
//                         [SVProgressHUD dismiss];
                         if (responseObject) {
                             NSDictionary *dict = [responseObject mj_JSONObject];
                             if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) { // 请求成功
                                 if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                                     NSDictionary *dictionary = dict[@"data"];
                                     NSString *imageUrl = dictionary[@"uri"];
                                     if (!imageUrl || [imageUrl dc_isNull]) {
                                         imageUrl = @"";
                                     }
                                     [url addObject:imageUrl];
                                     if (url.count == weakSelf.imageArr.count) {
                                         NSString *p = @"";
                                         for (NSString *st in url) {
                                             if (p.length <2) {
                                                 p = st;
                                             }else{
                                                 p = [NSString stringWithFormat:@"%@,%@",p,st];
                                             }
                                         }
                                         [weakSelf uplad:p];
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
    }
}

- (void)uplad:(NSString *)ph{
    NSDictionary *params = @{@"goodsImgs":ph,@"goodsName":_filedp.text,@"manufactory":_filedp2.text,@"packingSpec":_filedp1.text,@"phone":_filedp3.text,@"source":@"2"};
//    [SVProgressHUD show];
    WEAKSELF
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/product/goodsInfoApply" params:params httpMethod:DCHttpRequestJsonPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                weakSelf.scrl.hidden = YES;
                weakSelf.sucesV.hidden = NO;
                weakSelf.btconf.hidden = YES;
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [SVProgressHUD dismiss];
       
    }];
}

- (void)openImage{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVc.selectedAssets = _imageArrSet;
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    WEAKSELF;
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [weakSelf.imageArr removeAllObjects];
        [weakSelf.imageArrSet removeAllObjects];
        [weakSelf.imageArr addObjectsFromArray:photos];
        [weakSelf.imageArrSet addObjectsFromArray:assets];
        
        [weakSelf upimge];
     
        
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)upimge{
    CGFloat w = ( kScreenW -60)/3;
    for (UIView *v in _imgeBG.subviews) {
        [v removeFromSuperview];
    }
    if (_imageArr.count == 0) {
       
        UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
       // [b setImage:[UIImage imageNamed:@"addph"] forState:0];
        [b setBackgroundImage:[UIImage imageNamed:@"addph"] forState:0];
        [_imgeBG addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(12);
            make.width.height.offset(w);
            
        }];
        [b addTarget:self action:@selector(openImage) forControlEvents:(UIControlEventTouchUpInside)];
        [_imgeBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(b.mas_bottom).offset(30);
        }];
    }else{
        if (_imageArr.count == 9) {
            NSInteger row = 0;
            NSInteger sec = 0;
            for (int i = 0; i<_imageArr.count; i++) {
                row = i/3;
                sec = i%3;
                UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [b setImage:_imageArr[i] forState:0];
                [_imgeBG addSubview:b];
                b.imageView.contentMode = UIViewContentModeScaleAspectFill;
                b.layer.masksToBounds = YES;
                [b mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((15+w)*sec+15);
                    make.top.offset((12+w)*row+12);
                    make.width.height.offset(w);
                    
                }];
                UIButton *bb = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [bb setImage:[UIImage imageNamed:@"tr_qux"] forState:0];
                [b addSubview:bb];
                [bb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.offset(0);
                    make.width.height.offset(20);
                }];
                bb.tag = i;
                [bb addTarget:self action:@selector(delep:) forControlEvents:(UIControlEventTouchUpInside)];
                if (i == _imageArr.count-1) {
//                    [_imgeBG mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.bottom.mas_equalTo(b.mas_bottom).offset(30);
//                    }];
                    [_imgeBG mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(b.mas_bottom).offset(30);
                    }];
                }
            }
        }else{
            NSInteger row = 0;
            NSInteger sec = 0;
            for (int i = 0; i<_imageArr.count+1; i++) {
                row = i/3;
                sec = i%3;
                if (i == _imageArr.count) {
                    UIButton *b2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
//                    [b2 setImage:[UIImage imageNamed:@"addph"] forState:0];
                    [b2 setBackgroundImage:[UIImage imageNamed:@"addph"] forState:0];
                    b2.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [_imgeBG addSubview:b2];
                    [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset((15+w)*sec+15);
                        make.top.offset((12+w)*row+12);
                        make.width.height.offset(w);
                        
                    }];
                    [b2 addTarget:self action:@selector(openImage) forControlEvents:(UIControlEventTouchUpInside)];
//                    [_imgeBG mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.bottom.mas_equalTo(b2.mas_bottom).offset(30);
//                    }];
                    [_imgeBG mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(b2.mas_bottom).offset(30);
                    }];
                    return;
                }
                UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [b setImage:_imageArr[i] forState:0];
                [_imgeBG addSubview:b];
                b.imageView.contentMode = UIViewContentModeScaleAspectFill;
                b.layer.masksToBounds = YES;
                [b mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset((15+w)*sec+15);
                    make.top.offset((12+w)*row+12);
                    make.width.height.offset(w);
                    
                }];
                UIButton *bb = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [bb setImage:[UIImage imageNamed:@"tr_qux"] forState:0];
                [b addSubview:bb];
                bb.tag = i;
                [bb addTarget:self action:@selector(delep:) forControlEvents:(UIControlEventTouchUpInside)];
                [bb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.offset(0);
                    make.width.height.offset(20);
                }];
            }
        }
    }
}

- (void)delep:(UIButton*)bt{
    [self.imageArr removeObjectAtIndex:bt.tag];
    [self.imageArrSet removeObjectAtIndex:bt.tag];
    [self upimge];
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
