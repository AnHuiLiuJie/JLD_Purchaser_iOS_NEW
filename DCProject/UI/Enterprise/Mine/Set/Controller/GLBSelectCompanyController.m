//
//  GLBSelectCompanyController.m
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSelectCompanyController.h"

@interface GLBSelectCompanyController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray<GLBCompanyTypeModel *> *typeArray;
@property (nonatomic, strong) NSMutableArray<GLBCompanyTypeModel *> *subTypeArray;

@property (nonatomic, assign) NSInteger selectType;
@property (nonatomic, assign) NSInteger selectSubType;

@end

@implementation GLBSelectCompanyController

+ (GLBSelectCompanyController *)shareInstance {
    static GLBSelectCompanyController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = [DCObjectManager dc_readUserDataForKey:DC_CompanyType_Key];//
    if (array && [array count] > 0) {
        
        [self.typeArray removeAllObjects];
        [self.subTypeArray removeAllObjects];
        
        [self.typeArray addObjectsFromArray:[GLBCompanyTypeModel mj_objectArrayWithKeyValuesArray:array]];
        
        if (self.typeArray.count > 0) {
            [self.subTypeArray addObjectsFromArray:[self.typeArray[0] son]];
        }
    }
    
    
    [self setUpUI];
    [self.pickerView reloadAllComponents];
    
    [self dc_getAllCompanyType];
}


- (void)dc_getAllCompanyType
{
    if (self.typeArray.count == 0) {
        [self requestAllAreaData];
    }
}


#pragma mark - <UIPickerViewDataSource && UIPickerViewDelegate>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.typeArray.count;
    }
    if (component == 1) {
        return self.subTypeArray.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW/2, 50)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = PFRFont(14)
    myView.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        myView.text = [self.typeArray[row] catName];
    }
    if (component == 1) {
        myView.text = [self.subTypeArray[row] catName];
    }
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        
        if ([self.typeArray count] >0) {
            [self.subTypeArray removeAllObjects];
            [self.subTypeArray addObjectsFromArray:[self.typeArray[row] son]];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
        
        if (_subTypeArray.count > 0) {
            _selectSubType = 0;
        } else {
            _selectSubType = -1;
        }
        _selectType = row;
    }
    
    if (component == 1) {
        _selectSubType = row;
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
    if (_subTypeArray.count > 0) {
        GLBCompanyTypeModel *type = _typeArray[_selectType];
        GLBCompanyTypeModel *subType = _subTypeArray[_selectSubType];
        
        if (_typeBlock) {
            _typeBlock(type,subType);
        }
    }
    [self bgBtnClick:nil];
}

#pragma mark - 请求
- (void)requestAllAreaData
{
    [self.typeArray removeAllObjects];
    [self.subTypeArray removeAllObjects];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyTypeWithSuccess:^(id response) {
        if (response && [response count] > 0) {
            
            [weakSelf.typeArray addObjectsFromArray:response];
            
            if (weakSelf.typeArray.count > 0) {
                [weakSelf.subTypeArray addObjectsFromArray:[weakSelf.typeArray[0] son]];
            }
            [weakSelf.pickerView reloadAllComponents];
            
            NSMutableArray *newArray = [NSMutableArray array];
            for (NSInteger i=0; i<weakSelf.typeArray.count; i++) {
                [newArray addObject:[weakSelf.typeArray[i] mj_keyValues]];
            }
            [DCObjectManager dc_saveUserData:newArray forKey:DC_CompanyType_Key]; // 储存地区数据
            
        }
    } failture:^(NSError *_Nullable error) {
    }];
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
    _titleLabel.text = @"企业类型选择";
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
- (NSMutableArray<GLBCompanyTypeModel *> *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

- (NSMutableArray<GLBCompanyTypeModel *> *)subTypeArray{
    if (!_subTypeArray) {
        _subTypeArray = [NSMutableArray array];
    }
    return _subTypeArray;
}

@end
