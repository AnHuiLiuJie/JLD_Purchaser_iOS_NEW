//
//  GLBSelectAreaController.m
//  DCProject
//
//  Created by bigbing on 2019/8/6.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSelectAreaController.h"
#import "GLBProvinceModel.h"

@interface GLBSelectAreaController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray<GLBProvinceModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<GLBProvinceModel *> *provinceArray;
@property (nonatomic, strong) NSMutableArray<GLBCityModel *> *cityArray;
@property (nonatomic, strong) NSMutableArray<GLBAreaModel *> *areaArray;

@property (nonatomic, assign) NSInteger selectArea;
@property (nonatomic, assign) NSInteger selectCity;

@end

@implementation GLBSelectAreaController

+ (GLBSelectAreaController *)shareInstance {
    static GLBSelectAreaController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array;
    if ([self.isPerson isEqualToString:@"1"])
    {
        array = [DCObjectManager dc_readUserDataForKey:P_AreaData_Key];//个人版
    }
    else{
        array = [DCObjectManager dc_readUserDataForKey:DC_AreaData_Key];//采购版
    }
    
    if (array && [array count] > 0) {
        
        [self.dataArray removeAllObjects];
        [self.provinceArray removeAllObjects];
        [self.cityArray removeAllObjects];
        [self.areaArray removeAllObjects];
        
        [self.dataArray addObjectsFromArray:[GLBProvinceModel mj_objectArrayWithKeyValuesArray:array]];
        [self.provinceArray addObjectsFromArray:self.dataArray];
        
        if (self.provinceArray.count > 0) {
            [self.cityArray addObjectsFromArray:[self.provinceArray[0] son]];
        }
        if (self.cityArray.count > 0) {
            NSArray *array = [self.cityArray[0] son];
            if (array && [array count] > 0) {
                [self.areaArray addObjectsFromArray:array];
            }
        }
    }
    
    
    [self setUpUI];
    [self.pickerView reloadAllComponents];
    
    [self dc_getAllAreaData];
}


- (void)dc_getAllAreaData
{
    if (self.dataArray.count == 0) {
        [self requestAllAreaData];
    }
}


#pragma mark - <UIPickerViewDataSource && UIPickerViewDelegate>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    }
    if (component == 1) {
        return self.cityArray.count;
    }
    if (component == 2) {
        return self.areaArray.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == 0) {
//        return [self.provinceArray[row] areaName];
//    }
//    if (component == 1) {
//        return [self.cityArray[row] areaName];
//    }
//    if (component == 2) {
//        return [self.areaArray[row] areaName];
//    }
//    return @"";
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW/3, 50)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = PFRFont(14)
    myView.backgroundColor = [UIColor whiteColor];
    myView.textColor = [UIColor blackColor];
    
    if (component == 0) {
        myView.text = [self.provinceArray[row] areaName];
    }
    if (component == 1) {
        myView.text = [self.cityArray[row] areaName];
    }
    if (component == 2) {
        myView.text = [self.areaArray[row] areaName];
    }
    return myView;
}




- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        
        [self.cityArray removeAllObjects];
        [self.cityArray addObjectsFromArray:[self.dataArray[row] son]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        
        [self.areaArray removeAllObjects];
        [self.areaArray addObjectsFromArray:[self.cityArray[0] son]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        if (_cityArray.count > 0) {
            _selectCity = 0;
        } else {
            _selectCity = -1;
        }
        
        if (self.areaArray.count > 0) {
            _selectArea = 0;
        } else {
            _selectArea = -1;
        }
        
    }
    if (component == 1) {
        
        [self.areaArray removeAllObjects];
        [self.areaArray addObjectsFromArray:[self.cityArray[row] son]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        
        _selectCity = row;
        if (self.areaArray.count > 0) {
            _selectArea = 0;
        } else {
            _selectArea = -1;
        }
    }
    
    if (component == 2) {
        _selectArea = row;
    }
    
    [pickerView reloadAllComponents];
}



#pragma mark - action
- (void)bgBtnClick:(UIButton *)button
{
    [self cancelBtnClick:nil];
}

- (void)cancelBtnClick:(UIButton *)button
{
    //    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
}

- (void)doneBtnClick:(UIButton *)button
{
    NSString *areaName = @"";
    NSInteger areaId = 0;
    if (_selectArea > -1 && self.areaArray.count > 0) {
        
        areaName = [self.areaArray[_selectArea] areaFullName];
        areaId = [self.areaArray[_selectArea] areaId];
        
    } else {
        
        if (_selectCity > -1 && self.cityArray.count > 0) {
            
            areaName = [self.cityArray[_selectCity] areaFullName];
            areaId = [self.cityArray[_selectCity] areaId];
        }
    }
    
    if (_areaBlock) {
        _areaBlock(areaName,areaId);
    }
    
    [self bgBtnClick:nil];
}

#pragma mark - 请求
- (void)requestAllAreaData
{
    [self.dataArray removeAllObjects];
    [self.provinceArray removeAllObjects];
    [self.cityArray removeAllObjects];
    [self.areaArray removeAllObjects];
    
    WEAKSELF;
    if ([self.isPerson isEqualToString:@"1"])
    {
        [[DCAPIManager shareManager]person_requestAllAreaWithSuccess:^(id response) {
            if (response && [response count] > 0) {
                
                [weakSelf.dataArray addObjectsFromArray:response];
                [weakSelf.provinceArray addObjectsFromArray:weakSelf.dataArray];
                
                if (weakSelf.provinceArray.count > 0) {
                    [weakSelf.cityArray addObjectsFromArray:[weakSelf.provinceArray[0] son]];
                }
                if (weakSelf.cityArray.count > 0) {
                    NSArray *array = [weakSelf.cityArray[0] son];
                    if (array && [array count] > 0) {
                        [weakSelf.areaArray addObjectsFromArray:array];
                    }
                }
                
                [weakSelf.pickerView reloadAllComponents];
                
                NSMutableArray *newArray = [NSMutableArray array];
                for (NSInteger i=0; i<weakSelf.dataArray.count; i++) {
                    [newArray addObject:[weakSelf.dataArray[i] mj_keyValues]];
                }
                [DCObjectManager dc_saveUserData:newArray forKey:P_AreaData_Key]; // 储存地区数据
                
            }
        } failture:^(NSError *error) {
            
        }];
    }
    else{
        [[DCAPIManager shareManager] dc_requestAllAreaWithSuccess:^(id response) {
            if (response && [response count] > 0) {
                
                [weakSelf.dataArray addObjectsFromArray:response];
                [weakSelf.provinceArray addObjectsFromArray:weakSelf.dataArray];
                
                if (weakSelf.provinceArray.count > 0) {
                    [weakSelf.cityArray addObjectsFromArray:[weakSelf.provinceArray[0] son]];
                }
                if (weakSelf.cityArray.count > 0) {
                    NSArray *array = [weakSelf.cityArray[0] son];
                    if (array && [array count] > 0) {
                        [weakSelf.areaArray addObjectsFromArray:array];
                    }
                }
                
                [weakSelf.pickerView reloadAllComponents];
                
                NSMutableArray *newArray = [NSMutableArray array];
                for (NSInteger i=0; i<weakSelf.dataArray.count; i++) {
                    [newArray addObject:[weakSelf.dataArray[i] mj_keyValues]];
                }
                [DCObjectManager dc_saveUserData:newArray forKey:DC_AreaData_Key]; // 储存地区数据
                
            }
        } failture:^(NSError *_Nullable error) {
        }];
    }
    
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [_bgView addSubview:_line];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor dc_colorWithHexString:@"#999999"] forState:0];
    _cancelBtn.titleLabel.font = PFRFont(14);
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bgView addSubview:_cancelBtn];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneBtn setTitle:@"确定" forState:0];
    [_doneBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
    _doneBtn.titleLabel.font = PFRFont(14);
    [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_bgView addSubview:_doneBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"地区选择";
    [_bgView addSubview:_titleLabel];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_bgView addSubview:_pickerView];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
        make.height.equalTo(245);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top);
        make.height.equalTo(40);
        make.centerX.equalTo(self.bgView.centerX);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.titleLabel.bottom);
        make.height.equalTo(5);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.top);
        make.bottom.equalTo(self.titleLabel.bottom);
        make.left.equalTo(self.bgView.left).offset(15);
        make.width.equalTo(80);
    }];
    
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.top);
        make.bottom.equalTo(self.titleLabel.bottom);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.width.equalTo(80);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
    }];
}


#pragma mark - lazy load
- (NSMutableArray<GLBProvinceModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<GLBCityModel *> *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

- (NSMutableArray<GLBProvinceModel *> *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (NSMutableArray<GLBAreaModel *> *)areaArray{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}


@end
