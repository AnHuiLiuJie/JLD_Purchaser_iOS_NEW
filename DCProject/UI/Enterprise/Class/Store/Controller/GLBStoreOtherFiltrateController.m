//
//  GLBStoreOtherFiltrateController.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreOtherFiltrateController.h"

#import "GLBOtherFiltrateCell.h"
#import "GLBOtherFiltrateHeadView.h"

static NSString *otherCellID = @"GLBOtherFiltrateCell";
static NSString *sectionID = @"GLBOtherFiltrateHeadView";

@interface GLBStoreOtherFiltrateController ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *restBtn;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) NSMutableArray *discountArray;
@property (nonatomic, strong) NSMutableArray *selectDiscountArray;
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSMutableArray *selectPriceArray;
@property (nonatomic, strong) NSMutableArray *rangArray;
@property (nonatomic, strong) NSMutableArray *selectRangArray;


@end

@implementation GLBStoreOtherFiltrateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0];
    
    [self.discountArray addObjectsFromArray:@[@"有优惠券",@"有促销活动"]];
    [self.priceArray addObjectsFromArray:@[@"0~300",@"300~500",@"500~1000",@"1000以上"]];
    
    [self requestRangList];
    
    [self setUpUI];
}


- (void)setUpUI
{
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.cancelBtn];
    
    [self setUpTableView];
    [self.view addSubview:self.restBtn];
    [self.view addSubview:self.commintBtn];
    [self.view addSubview:self.line];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLBOtherFiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setTypeValueWithTypeArray:self.discountArray selectTypeArray:self.selectDiscountArray];
    } else if (indexPath.section == 1) {
        [cell setTypeValueWithTypeArray:self.priceArray selectTypeArray:self.selectPriceArray];
    } else if (indexPath.section == 2) {
        [cell setRangValueWithRangArray:self.rangArray selectRangArray:self.selectRangArray];
    }
    WEAKSELF;
    cell.otherCellBlock = ^(NSInteger tag) {
        [weakSelf dc_clickTypeItem:tag indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *array = @[];
    if (indexPath.section == 0) {
        array = self.discountArray;
    } else if (indexPath.section == 1) {
        array = self.priceArray;
    } else if (indexPath.section == 2) {
        array = self.rangArray;
    }
    
    NSInteger line = 0;
    if (array.count > 0) {
        line = (array.count - 1)/3 + 1;
    }
    CGFloat height = 0;
    if (line > 0) {
        height = 10 + (40+10)*line;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GLBOtherFiltrateHeadView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.openBtn.hidden = YES;
    if (section == 0) {
        header.titleLabel.text = @"优惠";
    } else if (section == 1) {
        header.titleLabel.text = @"起配金额";
    } else {
        header.titleLabel.text = @"经营范围";
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - 点击类型按钮
- (void)dc_clickTypeItem:(NSInteger)tag indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 优惠
        
        NSString *title = self.discountArray[tag];
        if ([self.selectDiscountArray containsObject:title]) {
            [self.selectDiscountArray removeObject:title];
        } else {
            [self.selectDiscountArray addObject:title];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (indexPath.section == 1) {
        
        NSString *title = self.priceArray[tag];
        if ([self.selectPriceArray containsObject:title]) {
            [self.selectPriceArray removeObject:title];
        } else {
            [self.selectPriceArray removeAllObjects];
            [self.selectPriceArray addObject:title];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (indexPath.section == 2) {
        
        GLBRangModel *model = self.rangArray[tag];
        
        GLBRangModel *selectModel = nil;
        if (self.selectRangArray.count > 0) {
            for (GLBRangModel *rangModel in self.selectRangArray) {
                if ([rangModel.key isEqualToString:model.key]) {
                    selectModel = rangModel;
                }
            }
        }
        
        if (selectModel) {
            [self.selectRangArray removeObject:selectModel];
        } else {
//            [self.selectRangArray removeAllObjects];
            [self.selectRangArray addObject:model];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.view removeFromSuperview];
    
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)commintBtnClick:(UIButton *)button
{
    if (_successBlock) {
        _successBlock(self.selectDiscountArray,self.selectPriceArray,self.selectRangArray);
    }
    
    [self cancelBtnClick:nil];
}

- (void)restBtnClick:(UIButton *)button
{
    [self.selectDiscountArray removeAllObjects];
    [self.selectPriceArray removeAllObjects];
    [self.selectRangArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - 请求 经营范围列表
- (void)requestRangList
{
    [self.rangArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyRangWithSuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.rangArray addObjectsFromArray:response];
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40 - 44);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 36.0f;
    self.tableView.sectionHeaderHeight = 50.0f;
    self.tableView.sectionFooterHeight = 0.01f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:NSClassFromString(otherCellID) forCellReuseIdentifier:otherCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID
     ];
    
}


#pragma mark - lazy load
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 40, kScreenW, kScreenH - kNavBarHeight - 40)];
        _bgView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor alpha:1];
    }
    return _bgView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = [UIScreen mainScreen].bounds;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)restBtn{
    if (!_restBtn) {
        _restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _restBtn.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenW/2, 44);
        _restBtn.backgroundColor = [UIColor whiteColor];
        [_restBtn setTitle:@"重置" forState:0];
        [_restBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
        _restBtn.titleLabel.font = PFRFont(14);
        [_restBtn addTarget:self action:@selector(restBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restBtn;
}

- (UIButton *)commintBtn{
    if (!_commintBtn) {
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commintBtn.frame = CGRectMake(kScreenW/2, CGRectGetMaxY(self.tableView.frame), kScreenW/2, 44);
        _commintBtn.backgroundColor = [UIColor whiteColor];
        [_commintBtn setTitle:@"确定" forState:0];
        [_commintBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:0];
        _commintBtn.titleLabel.font = PFRFont(14);
        [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commintBtn;
}

- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(kScreenW/2, CGRectGetMinY(self.restBtn.frame), 1, CGRectGetHeight(self.restBtn.frame));
        _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    }
    return _line;
}

- (NSMutableArray *)discountArray{
    if (!_discountArray) {
        _discountArray = [NSMutableArray array];
    }
    return _discountArray;
}

- (NSMutableArray *)selectDiscountArray{
    if (!_selectDiscountArray) {
        _selectDiscountArray = [NSMutableArray array];
    }
    return _selectDiscountArray;
}

- (NSMutableArray *)priceArray{
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

- (NSMutableArray *)selectPriceArray{
    if (!_selectPriceArray) {
        _selectPriceArray = [NSMutableArray array];
    }
    return _selectPriceArray;
}

- (NSMutableArray *)rangArray{
    if (!_rangArray) {
        _rangArray = [NSMutableArray array];
    }
    return _rangArray;
}

- (NSMutableArray *)selectRangArray{
    if (!_selectRangArray) {
        _selectRangArray = [NSMutableArray array];
    }
    return _selectRangArray;
}


#pragma mark - setter
- (void)setUserDiscountArray:(NSArray *)userDiscountArray
{
    _userDiscountArray = userDiscountArray;
    
    [self.selectDiscountArray removeAllObjects];
    [self.selectDiscountArray addObjectsFromArray:_userDiscountArray];
}


- (void)setUserPriceArray:(NSArray *)userPriceArray
{
    _userPriceArray = userPriceArray;
    
    [self.selectPriceArray removeAllObjects];
    [self.selectPriceArray addObjectsFromArray:_userPriceArray];
}


- (void)setUserRangArray:(NSArray *)userRangArray
{
    _userRangArray = userRangArray;
    
    [self.selectRangArray removeAllObjects];
    [self.selectRangArray addObjectsFromArray:_userRangArray];
}


@end
