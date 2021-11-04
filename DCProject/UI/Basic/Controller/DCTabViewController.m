//
//  DCTabViewController.m
//  DCProject
//
//  Created by bigbing on 2019/4/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCTabViewController.h"
#import "DCRefreshTool.h"

@interface DCTabViewController ()



@end

@implementation DCTabViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


#pragma mark -  添加刷新
- (void)addRefresh:(BOOL)isBegin
{
    [self addHeaderRefresh:isBegin];
    [self addFooterRefresh];
}


#pragma mark -  添加刷新 下拉
- (void)addHeaderRefresh:(BOOL)isBegin
{
    WEAKSELF;
    self.tableView.mj_header = [[DCRefreshTool shareTool] headerDefaultWithIsFirstRefresh:isBegin block:^{
        [weakSelf loadNewTableData:nil];
    }];
}


#pragma mark -  添加刷新 上拉
- (void)addFooterRefresh
{
    WEAKSELF;
    self.tableView.mj_footer = [[DCRefreshTool shareTool] footerDefaultWithBlock:^{
        [weakSelf loadMoreTableData:nil];
    }];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id _Nullable)sender{
    
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id _Nullable)sender{
    
}

#pragma mark -  移除刷新
- (void)removeRefresh{
    
    [self endRefresh];
    
    [self.tableView.mj_header removeFromSuperview];
    [self.tableView.mj_footer removeFromSuperview];
}

#pragma mark - 结束刷新
- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -  刷新TableView
- (void)reloadTableViewWithDatas:(NSArray *)datas lasts:(NSArray *)lasts{
    
    [self endRefresh];
    
    if (datas && [datas count]>0) {
        
        self.noDataView.hidden = YES;
        
        if (lasts && [lasts count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.tableView.mj_footer.hidden = NO;
        
    }else {
        
        if (![self.view.subviews containsObject:self.noDataView] && !_isHiddenTip) {
            [self.view insertSubview:self.noDataView belowSubview:self.tableView];
            
            if (CGRectEqualToRect(self.noDataView.frame, CGRectZero)) {
                self.noDataView.frame = self.tableView.frame;
                self.noDataImg.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - kNavBarHeight/2);
                self.noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noDataImg.frame) + 10, kScreenW, 20);
            }
        }
        self.noDataView.hidden = NO;
        
        self.tableView.mj_footer.hidden = YES;
    }
    
    [self.tableView reloadData];
}


// 自定义刷新方法  待完善
- (void)reloadTableViewWithDatas:(NSArray *)datas hasNextPage:(BOOL)hasNextPage {
    
    [self endRefresh];
    
    if (datas && [datas count]>0) {
        
        self.noDataView.hidden = YES;
        
        if (hasNextPage == NO) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.tableView.mj_footer.hidden = NO;
        
    }else {
        
        if (![self.view.subviews containsObject:self.noDataView] && !_isHiddenTip) {
            [self.view insertSubview:self.noDataView belowSubview:self.view];
            
            if (CGRectEqualToRect(self.noDataView.frame, CGRectZero)) {
                self.noDataView.frame = self.tableView.frame;
                self.noDataImg.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - self.tableView.frame.size.height/5);
                self.noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noDataImg.frame) + 10, kScreenW, 20);
                self.noDataBtn.frame = CGRectMake((self.tableView.dc_width - 120)/2, CGRectGetMaxY(self.noDataLabel.frame) + 20, 120, 44);
            }
        }
        self.noDataView.hidden = NO;
        
        self.tableView.mj_footer.hidden = YES;
    }
    
    [self.tableView reloadData];
}


/// 按钮点击事件
- (void)noDataBtnClick:(UIButton *)button
{
    
}

#pragma mark - lazy load
- (UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectZero];
        _noDataView.backgroundColor = [UIColor whiteColor];
        
        [_noDataView addSubview:self.noDataImg];
        [_noDataView addSubview:self.noDataLabel];
        [_noDataView addSubview:self.noDataBtn];
    }
    return _noDataView;
}

- (UIImageView *)noDataImg{
    if (!_noDataImg) {
        _noDataImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW *0.36, kScreenW *0.36)];
        _noDataImg.image = [UIImage imageNamed:@"none"];
    }
    return _noDataImg;
}

- (UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.frame = CGRectMake(0, CGRectGetMaxY(self.noDataImg.frame) + 10, kScreenW, 20);
//        _noDataLabel.text = @"暂无数据~";
        _noDataLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
        _noDataLabel.font = PFRFont(14);
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}

- (UIButton *)noDataBtn{
    if (!_noDataBtn) {
        _noDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noDataBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#3B95FF"];
        [_noDataBtn setTitleColor:[UIColor whiteColor] forState:0];
        _noDataBtn.titleLabel.font = PFRFont(14);
        [_noDataBtn addTarget:self action:@selector(noDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataBtn dc_cornerRadius:22];
        _noDataBtn.hidden = YES;
    }
    return _noDataBtn;
}

#pragma mark - 重写setter方法
- (void)setTableStyle:(UITableViewStyle)tableStyle
{
    _tableStyle = tableStyle;
    
    if (!_tableView) {
        _tableView = nil;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_tableStyle];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        [self.view addSubview:_tableView];
    }
}


- (void)setIsHiddenTip:(BOOL)isHiddenTip{
    _isHiddenTip = isHiddenTip;
}


@end
