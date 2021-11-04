//
//  GLPDetailEnsureController.m
//  DCProject
//
//  Created by bigbing on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPDetailEnsureController.h"
#import "GLPDetailEnsureCell.h"

static NSString *const listCellID = @"GLPDetailEnsureCell";

@interface GLPDetailEnsureController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPDetailEnsureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPDetailEnsureCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        cell.titleLabel.text = self.dataArray[indexPath.row];
        if (self.dataArray.count > 2) { //
            if (indexPath.row
                 == 0) { // 支持
                cell.iconImage.image = [UIImage imageNamed:@"zhichi"];
            } else { // 不支持
                cell.iconImage.image = [UIImage imageNamed:@"buzhic"];
            }
        } else {
            cell.iconImage.image = [UIImage imageNamed:@"zhichi"];
        }
    }
    return cell;
}



#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - kScreenH/2, kScreenW, kScreenH/2)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.text = @"金利达无忧购物";
    [_bgView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImage.image = [UIImage imageNamed:@"logo"];
    [_bgView addSubview:_iconImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#8A8989"];
    _subLabel.font = PFRFont(14);
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.text = @"品质优选·便捷物流·全程服务";
    [_bgView addSubview:_subLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [_bgView addSubview:_tableView];
    
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kScreenH/2, 0, 0, 0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(20);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.titleLabel.left).offset(-5);
        make.size.equalTo(CGSizeMake(18, 20));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(12);
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.top.equalTo(self.subLabel.bottom).offset(25);
    }];
    
    [self.dataArray removeAllObjects];
    if ([self.detailModel.isMedical isEqualToString:@"1"])
    {
         [self.dataArray addObject:@"由商家负责发货及售后\n该商品由所售商家负责发货及售后服务，金利达药品交易网负责监督商家的服务以及商品质量。"];
         [self.dataArray addObject:@"不支持7天无理由退换商品\n因药品属于特殊商品，根据规定药品一经售出，无质量问题不退不换。"];
         [self.dataArray addObject:@"暂不支持医保支付\n该商品暂时不支持在线医保支付。"];
    }
    else{
        [self.dataArray addObject:@"由商家负责发货及售后\n该商品由所售商家负责发货及售后服务，金利达药品交易网负责监督商家的服务以及商品质量。"];
        [self.dataArray addObject:@"支持7天无理由退换商品（未拆封）\n该商品在不影响二次销售的前提下，支持7天无理由退换商品。"];
    }
    [self.tableView reloadData];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end





