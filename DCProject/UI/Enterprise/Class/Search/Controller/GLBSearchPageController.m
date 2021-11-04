//
//  GLBSearchPageController.m
//  DCProject
//
//  Created by bigbing on 2019/8/15.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBSearchPageController.h"
#import "DCRefreshTool.h"

#import "GLBSearchPageNaVBar.h"
#import "GLBSearchRecordListController.h"
#import "GLBGoodsListController.h"
#import "GLBStoreListController.h"

#import "GLBSearchGoodsModel.h"
#import "GLBSearchStoreModel.h"
#import "WMScrollView+DCPopGesture.h"


static NSString *const listCellID = @"UITableViewCell";

@interface GLBSearchPageController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) GLBSearchPageNaVBar *navBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation GLBSearchPageController

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.titleFontName = PFR;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.automaticallyCalculatesItemWidths = YES;
        self.menuItemWidth = kScreenW / 2;
        self.progressWidth = 13;
        self.menuView.scrollView.backgroundColor = [UIColor whiteColor];
        self.titleColorSelected = [UIColor dc_colorWithHexString:@"#00B7AB"];
        self.titleColorNormal = [UIColor dc_colorWithHexString:@"#333333"];
        self.progressColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.view addSubview:self.tableView];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight,kScreenW, 32)];
    self.image.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.image belowSubview:self.menuView];

    // 监听键盘高度
    [self addNoticeForKeyboard];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.names.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GLBSearchRecordListController *vc = [GLBSearchRecordListController new];
    vc.searchType = [self.types[index] integerValue];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.names[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    
    return CGRectMake(0, kNavBarHeight + 32, kScreenW, kScreenH - kNavBarHeight - 32);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, kNavBarHeight, kScreenW, 32);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    cell.textLabel.font = PFRFont(12);
    cell.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    cell.contentView.backgroundColor = [UIColor dc_colorWithHexString:@"#ffffff"];
    if (self.selectIndex == 0) {
        GLBSearchGoodsModel *model = self.dataArray[indexPath.row];
        cell.textLabel.attributedText = [self dc_attributeStr:model.goodsName];
    } else {
        GLBSearchStoreModel *model = self.dataArray[indexPath.row];
        cell.textLabel.attributedText = [self dc_attributeStr:model.goodsName];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.hidden = YES;
    self.navBar.textField.text = @"";
    
    if (self.selectIndex == 0) { // 商品
        
        GLBSearchGoodsModel *model = self.dataArray[indexPath.row];
        
        // 添加进历史记录
        NSArray *goodsRecordArray = [DCObjectManager dc_readUserDataForKey:DC_GoodsSearchRecord_Key];
        if (goodsRecordArray) {
            NSMutableArray *dataArray = [goodsRecordArray mutableCopy];
            if (![dataArray containsObject:model.goodsName]) {
                [dataArray addObject:model.goodsName];
                [DCObjectManager dc_saveUserData:[dataArray copy] forKey:DC_GoodsSearchRecord_Key];
            }
            
        } else {
            NSArray *array = @[model.goodsName];
            [DCObjectManager dc_saveUserData:array forKey:DC_GoodsSearchRecord_Key];
        }
        
        GLBGoodsListController *vc = [GLBGoodsListController new];
        vc.goodsName = model.goodsName;
        vc.catIds = @"11,12,16,26,14,15,25,24";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else {  // 店铺
     
        GLBSearchStoreModel *model = self.dataArray[indexPath.row];
        
        // 添加进历史记录
        NSArray *storeRecordArray = [DCObjectManager dc_readUserDataForKey:DC_StoreSearchRecord_Key];
        if (storeRecordArray) {
            NSMutableArray *dataArray = [storeRecordArray mutableCopy];
            if (![dataArray containsObject:model.goodsName]) {
                [dataArray addObject:model.goodsName];
                [DCObjectManager dc_saveUserData:[dataArray copy] forKey:DC_StoreSearchRecord_Key];
            }
            
        } else {
            NSArray *array = @[model.goodsName];
            [DCObjectManager dc_saveUserData:array forKey:DC_StoreSearchRecord_Key];
        }
        
        GLBStoreListController *vc = [GLBStoreListController new];
        vc.firmName = model.goodsName;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}


#pragma mark - action
- (void)textFieldValueChange:(UITextField *)textField
{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        
        if (textField.text.length > 0) {
            self.tableView.hidden = NO;
            if (self.selectIndex == 0) { // 商品
                [self requestSearchGoods:YES];
            } else { // 店铺
                [self requestSearchStore:YES];
            }
        } else {
            self.tableView.hidden = YES;
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            self.tableView.mj_footer.hidden = YES;
        }
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
        return NO;
    }
    
    if (self.selectIndex == 0) { // 商品
        
        NSString *text = textField.text;
        
        // 添加进历史记录
        NSArray *goodsRecordArray = [DCObjectManager dc_readUserDataForKey:DC_GoodsSearchRecord_Key];
        if (goodsRecordArray) {
            NSMutableArray *dataArray = [goodsRecordArray mutableCopy];
            if (![dataArray containsObject:text]) {
                [dataArray addObject:text];
                [DCObjectManager dc_saveUserData:[dataArray copy] forKey:DC_GoodsSearchRecord_Key];
            }
            
        } else {
            NSArray *array = @[text];
            [DCObjectManager dc_saveUserData:array forKey:DC_GoodsSearchRecord_Key];
        }
        
        GLBGoodsListController *vc = [GLBGoodsListController new];
        vc.goodsName = text;
        vc.catIds = @"11,12,16,26,14,15,25,24";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else {  // 店铺
        
        NSString *text = textField.text;
        
        // 添加进历史记录
        NSArray *storeRecordArray = [DCObjectManager dc_readUserDataForKey:DC_StoreSearchRecord_Key];
        if (storeRecordArray) {
            NSMutableArray *dataArray = [storeRecordArray mutableCopy];
            if (![dataArray containsObject:text]) {
                [dataArray addObject:text];
                [DCObjectManager dc_saveUserData:[dataArray copy] forKey:DC_StoreSearchRecord_Key];
            }
            
        } else {
            NSArray *array = @[text];
            [DCObjectManager dc_saveUserData:array forKey:DC_StoreSearchRecord_Key];
        }
        
        GLBStoreListController *vc = [GLBStoreListController new];
        vc.firmName = text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    self.tableView.hidden = YES;
    self.navBar.textField.text = @"";
    
    return YES;
}


#pragma mark - 搜索商品
- (void)requestSearchGoods:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchGoodsKeywordWithKeyword:self.navBar.textField.text isZyc:@"" success:^(id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - 搜索店铺
- (void)requestSearchStore:(BOOL)isReload
{
    _page ++;
    if (isReload) {
        _page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestSearchStoreKeywordWithKeyword:self.navBar.textField.text success:^(id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:response];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

//键盘farme值
- (void)keyboardFrameChange:(NSNotification *)notifi{
    
    NSDictionary *userInfo = notifi.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)(void) = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
        
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
    
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (toFrame.origin.y  == [[UIScreen mainScreen] bounds].size.height){//键盘收起
        
    }else{ //键盘升起
        CGFloat height = toFrame.size.height;
        self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - height);
    }
}


#pragma mark -
- (NSMutableAttributedString *)dc_attributeStr:(NSString *)string
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    if ([string containsString:self.navBar.textField.text]) {
        NSArray *array = [string componentsSeparatedByString:self.navBar.textField.text];
        NSString *string1 = array[0];
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(string1.length, self.navBar.textField.text.length)];
    }
    return attStr;
}


#pragma mark - lazy load
- (GLBSearchPageNaVBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLBSearchPageNaVBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        WEAKSELF;
        _navBar.cancelBtnClick = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navBar.textField.delegate = self;
        [_navBar.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _navBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.hidden = YES;
        
        WEAKSELF;
        _tableView.mj_footer = [[DCRefreshTool shareTool] footerDefaultWithBlock:^{
            if (weakSelf.selectIndex == 0) {
                [weakSelf requestSearchGoods:NO];
            } else {
                [weakSelf requestSearchStore:NO];
            }
        }];
        
        [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    }
    return _tableView;
}

- (NSArray *)names{
    if (!_names) {
        _names = @[@"商品",@"店铺"];
    }
    return _names;
}

- (NSArray *)types{
    if (!_types) {
        _types = @[@(GLBSearchTypeGoods),
                   @(GLBSearchTypeStore)];
    }
    return _types;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

@end
