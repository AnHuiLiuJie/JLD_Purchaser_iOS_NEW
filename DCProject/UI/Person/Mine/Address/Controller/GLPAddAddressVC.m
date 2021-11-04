//
//  GLPAddAddressVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPAddAddressVC.h"
#import "AddressInfoCell.h"
#import "AddressSwitchNewCell.h"
#import "CGXPickerView.h"
#import "GLBSelectAreaController.h"
@interface GLPAddAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end


static NSString *const AddressInfoCellID = @"AddressInfoCell";
static NSString *const AddressSwitchNewCellID = @"AddressSwitchNewCell";

static CGFloat kBottomView_H = 60;

@implementation GLPAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    if (self.addressModel.recevier.length==0)
    {
        self.navigationItem.title = @"新增收货地址";
    }
    else{
        self.navigationItem.title = @"编辑收货地址";
        
        UIButton*rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [rightBtn setTitleColor:RGB_COLOR(0, 190, 179) forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        UIBarButtonItem*rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    
    self.bottomView.hidden = NO;
    
}

- (GLPGoodsAddressModel *)addressModel{
    if (!_addressModel) {
        _addressModel = [[GLPGoodsAddressModel alloc] init];
        _addressModel.isDefault = @"0";
        _addressModel.areaName = @"";
        _addressModel.addrId = @"";
        _addressModel.areaName = @"";
        _addressModel.cellphone = @"";
        _addressModel.streetInfo = @"";
        _addressModel.recevier = @"";
    }
    return _addressModel;
}

- (void)rightClick
{
    WEAKSELF;
    NSString *addrId = self.addressModel.addrId.length == 0 ? @"" : self.addressModel.addrId;
    [[DCAPIManager shareManager]person_deleAddressWithaddrId:addrId success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"删除收货地址成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !weakSelf.GLPAddAddressVC_block ? : weakSelf.GLPAddAddressVC_block();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failture:^(NSError *error) {
        
    }];
}

- (void)btnClick:(UIButton*)btn
{
    NSString *recevier = self.addressModel.recevier.length == 0 ? @"" : self.addressModel.recevier;;
    if (recevier.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人"];
        return;
    }
    NSString *cellphone = self.addressModel.cellphone.length == 0 ? @"" : self.addressModel.cellphone;;
    if (cellphone.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
        return;
    }
    NSString *areaId = self.addressModel.areaId.length == 0 ? @"" : self.addressModel.areaId;
    if (areaId.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择地址"];
        return;
    }
    NSString *streetInfo = self.addressModel.streetInfo.length == 0 ? @"" : self.addressModel.streetInfo;;
    if (streetInfo.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    NSString *isDefault = self.addressModel.isDefault.length == 0 ? @"0" : self.addressModel.isDefault;;
    
    if ([btn.titleLabel.text isEqualToString:@"保存"])
    {

        WEAKSELF;
        [[DCAPIManager shareManager]person_addAddressWithareaId:areaId cellphone:cellphone isDefault:isDefault recevier:recevier streetInfo:streetInfo success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"新增收货地址成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !weakSelf.GLPAddAddressVC_block ? : weakSelf.GLPAddAddressVC_block();
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        NSString *addrId = [NSString stringWithFormat:@"%@",self.addressModel.addrId];
        WEAKSELF;
        [[DCAPIManager shareManager]person_editAddressWithaddrId:addrId areaId:areaId cellphone:cellphone isDefault:isDefault recevier:recevier streetInfo:streetInfo success:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"编辑收货地址成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !weakSelf.GLPAddAddressVC_block ? : weakSelf.GLPAddAddressVC_block();
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } failture:^(NSError *error) {
            
        }];
    }
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        AddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressInfoCellID];
        if (cell==nil)
        {
            cell = [[AddressInfoCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.addressModel;
        WEAKSELF
        cell.AddressInfoCell_Block = ^{
            [weakSelf.view endEditing:YES];
            GLBSelectAreaController *vc = [GLBSelectAreaController new];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.isPerson = @"1";
            vc.areaBlock = ^(NSString *areaFullName, NSInteger areaId) {
                weakSelf.addressModel.areaId = [NSString stringWithFormat:@"%ld",(long)areaId];
                weakSelf.addressModel.areaName = areaFullName;
                [weakSelf.tableView reloadData];
            };
            
            [weakSelf addChildViewController:vc];
            [weakSelf.view addSubview:vc.view];
            
            //        [self presentViewController:vc animated:NO completion:nil];
        };
        
        cell.AddressInfoCell_block = ^(NSString * _Nonnull text, NSInteger type) {
            if (type == 1) {
                weakSelf.addressModel.recevier = text;
            }else if(type == 2){
                weakSelf.addressModel.cellphone = text;
            }else if(type == 3){
                weakSelf.addressModel.streetInfo = text;
            }
        };
        return cell;
    }
    else{
        AddressSwitchNewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressSwitchNewCellID];
        if (cell==nil){
            cell = [[AddressSwitchNewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addLab.text = @"设为默认地址";
        if ([self.addressModel.isDefault isEqualToString:@"0"])
        {
            [cell.addswitch setOn:NO];
        }
        else{
            [cell.addswitch setOn:YES];
        }
        [cell.addswitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)switchClick:(UISwitch*)addswitch
{
    if (addswitch.on==YES)
    {
        self.addressModel.isDefault = @"1";
    }
    else{
        self.addressModel.isDefault = @"0";
    }
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kBottomView_H-LJ_TabbarSafeBottomMargin-10) style:UITableViewStyleGrouped];
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
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        [self.tableView registerNib:[UINib nibWithNibName:@"AddressInfoCell" bundle:nil] forCellReuseIdentifier:AddressInfoCellID];
        [self.tableView registerNib:[UINib nibWithNibName:@"AddressSwitchNewCell" bundle:nil] forCellReuseIdentifier:AddressSwitchNewCellID];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenW, kBottomView_H);
        [self.view addSubview:_bottomView];
        
        UILabel *promptLab = [[UILabel alloc] init];
        promptLab.backgroundColor = [UIColor clearColor];
        promptLab.text = @"";
        promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
        promptLab.font = [UIFont fontWithName:PFR size:12];
        promptLab.textAlignment = NSTextAlignmentLeft;
        promptLab.frame = CGRectMake(15, 0, _bottomView.dc_width, 0);
        [_bottomView addSubview:promptLab];
        
        _confirmBtn = [[UIButton alloc] init];
        [_bottomView addSubview:_confirmBtn];
        [_confirmBtn dc_layerBorderWith:0 color:[UIColor whiteColor] radius:10];
        _confirmBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.frame = CGRectMake(15, CGRectGetMaxY(promptLab.frame), _bottomView.dc_width-30, kBottomView_H*0.8);
        
        if (self.addressModel.recevier.length == 0){
            [_confirmBtn setTitle:@"保存" forState:UIControlStateNormal];
        }else{
            [_confirmBtn setTitle:@"保存收货地址" forState:UIControlStateNormal];
        }

    }
    return _bottomView;
}
@end
