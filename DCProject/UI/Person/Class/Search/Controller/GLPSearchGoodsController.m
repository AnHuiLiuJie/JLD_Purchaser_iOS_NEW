//
//  GLPSearchGoodsController.m
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPSearchGoodsController.h"

#import "GLPSearcgNavBar.h"
#import "GLPSearchHotGoodsItemCell.h"
#import "GLPSearchTitleItemCell.h"
#import "TRClassGoodsVC.h"
#import "WSLWaterFlowLayout.h"
#import "GLPSearchGoodsPromptCell.h"
#import "GLPSearchKeyModel.h"

static NSString *const goodsCellID = @"GLPSearchHotGoodsItemCell";
static NSString *const titleCellID = @"GLPSearchTitleItemCell";
static NSString *const sectionID = @"UICollectionReusableView";
static NSString *const searchCellID = @"UITableViewCell";
static NSString *const PromptCellID = @"GLPSearchGoodsPromptCell";

@interface GLPSearchGoodsController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,WSLWaterFlowLayoutDelegate,UITextFieldDelegate>

@property (nonatomic, strong) GLPSearcgNavBar *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WSLWaterFlowLayout *flowLayout;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *hotGoodsArray;
@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation GLPSearchGoodsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dc_navBarHidden:YES];
    
    NSArray *array = [DCObjectManager dc_readUserDataForKey:DC_Person_GoodsSearchRecord_Key];
    if (array && [array count] > 0) {
        [self.recordArray removeAllObjects];
        [self.recordArray addObjectsFromArray:array];
        [self.collectionView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self dc_navBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.view.top);
        make.height.equalTo(kNavBarHeight);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.top.equalTo(self.navBar.bottom);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    [self requestSearchHotGoods];
    
    // 监听键盘高度
    [self addNoticeForKeyboard];
    
    if (_searchKeyWorld && _searchKeyWorld.length > 0) {
        self.navBar.searchTF.attributedPlaceholder = [NSString dc_placeholderWithString:_searchKeyWorld];
    }
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotGoodsArray.count;
    }
    return self.recordArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    WEAKSELF;
    if (indexPath.section == 0) {
        
        GLPSearchHotGoodsItemCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellID forIndexPath:indexPath];
        goodsCell.goodsModel = self.hotGoodsArray[indexPath.item];
        cell = goodsCell;
        
    } else {
        
        GLPSearchTitleItemCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCellID forIndexPath:indexPath];
        titleCell.title = self.recordArray[indexPath.item];
        titleCell.deleteBlock = ^{
            [weakSelf.recordArray removeObjectAtIndex:indexPath.item];
            [weakSelf.collectionView reloadData];
            [DCObjectManager dc_saveUserData:weakSelf.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
        };
        cell = titleCell;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID forIndexPath:indexPath];
    for (id class in header.subviews) {
        [class removeFromSuperview];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    titleLabel.text = indexPath.section == 0 ? @"热门搜索" : @"搜索历史";
    [header addSubview:titleLabel];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:0];
    deleteBtn.adjustsImageWhenHighlighted = NO;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = indexPath.section == 0 ? YES : NO;
    [header addSubview:deleteBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.left).offset(16);
        make.centerY.equalTo(header.centerY);
    }];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.centerY);
        make.right.equalTo(header.right).offset(-10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    return header;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        // TODO 待完善 页面跳转
        GLPSearchHotGoodsModel *goodsModel = self.hotGoodsArray[indexPath.item];
        if (![self.recordArray containsObject:goodsModel.keyword]) {
            
            [self.recordArray insertObject:goodsModel.keyword atIndex:0];
            [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
            TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
            vc.searchStr=goodsModel.keyword;
            vc.classId = @"";
            vc.goodsTagNameList = @"";
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            NSInteger index = [self.recordArray indexOfObject:goodsModel.keyword];
            [self.recordArray removeObjectAtIndex:index];
            [self.recordArray insertObject:goodsModel.keyword atIndex:0];
            [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
            TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
            vc.searchStr=goodsModel.keyword;
            vc.classId = @"";
            vc.goodsTagNameList = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        // TODO 待完善 页面跳转
        
        if (indexPath.item >= 0) { // 搜索排序
            NSString *title = self.recordArray[indexPath.item];
            [self.recordArray removeObjectAtIndex:indexPath.item];
            [self.recordArray insertObject:title atIndex:0];
            [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
            TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
            vc.searchStr=title;
            vc.classId = @"";
            vc.goodsTagNameList = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - <WSLWaterFlowLayoutDelegate>
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GLPSearchHotGoodsModel *goodsModel = self.hotGoodsArray[indexPath.item];
        CGFloat width = [goodsModel.keyword boundingRectWithSize:CGSizeMake(kScreenW - 40, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14]} context:nil].size.width + 30;
        return CGSizeMake(width, 30);
    }
    
    NSString *title = self.recordArray[indexPath.item];
    CGFloat width = [title boundingRectWithSize:CGSizeMake(kScreenW - 40, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14]} context:nil].size.width + 30;
    return CGSizeMake(width, 45);
}


/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 40);
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellID forIndexPath:indexPath];
//    cell.textLabel.font = PFRFont(14);
//    cell.textLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    if (self.searchArray.count > 0) {
//        cell.textLabel.attributedText = [self dc_attributeString:self.searchArray[indexPath.row]];
//    }
//    return cell;
    
    GLPSearchGoodsPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:PromptCellID forIndexPath:indexPath];
    cell.titleStr = self.navBar.searchTF.text;
    cell.model = self.searchArray[indexPath.row];
    WEAKSELF;
    cell.block = ^(NSString *_Nonnull searchStr) {
        [weakSelf searchMethod:searchStr];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GLPSearchKeyModel *keyModel = self.searchArray[indexPath.row];
    NSString *searchText = keyModel.key;
    [self searchMethod:searchText];
    
}

- (void)searchMethod:(NSString *)searchText{
    if ([self.recordArray containsObject:searchText]) { // 先删除 再加入
        NSInteger index = [self.recordArray indexOfObject:searchText];
        [self.recordArray removeObjectAtIndex:index];
    }
    
    [self.recordArray insertObject:searchText atIndex:0];
    [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
    TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
    vc.searchStr=searchText;
    vc.classId = @"";
    vc.goodsTagNameList = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.navBar.searchTF resignFirstResponder];
    self.tableView.hidden = YES;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // TODO 待完善 页面跳转
    if (self.navBar.searchTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
        return NO;
    }

    if ([self.recordArray containsObject:self.navBar.searchTF.text]) { // 先删除 再加入
        NSInteger index = [self.recordArray indexOfObject:self.navBar.searchTF.text];
        [self.recordArray removeObjectAtIndex:index];
    }
    
    [self.recordArray insertObject:self.navBar.searchTF.text atIndex:0];
    [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
    
    TRClassGoodsVC *vc = [[TRClassGoodsVC alloc] init];
    vc.searchStr=self.navBar.searchTF.text;
    vc.classId = @"";
    vc.goodsTagNameList = @"";
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.navBar.searchTF resignFirstResponder];
    self.tableView.hidden = YES;
    
    return YES;
}


#pragma mark - textField值改变
- (void)searchTFValueChange:(UITextField *)textField
{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) { // 没有高亮选择的字
        if (textField.text.length > 0) {
            self.tableView.hidden = NO;
           [self reqeustSearchGoods];
        } else {
            self.tableView.hidden = YES;
            [self.searchArray removeAllObjects];
            [self.tableView reloadData];
        }
        
    }else { //有高亮文字
        //do nothing
    }
}


#pragma mark - action
- (void)deleteBtnClick:(UIButton *)button
{
    [self.recordArray removeAllObjects];
    [self.collectionView reloadData];
    
    [DCObjectManager dc_saveUserData:self.recordArray forKey:DC_Person_GoodsSearchRecord_Key];
}


#pragma mark - 返回富文本
- (NSAttributedString *)dc_attributeString:(NSString *)string
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, attStr.length)];
    if (self.navBar.searchTF.text.length > 0 && [string containsString:self.navBar.searchTF.text]) {
        NSString *str = [string componentsSeparatedByString:self.navBar.searchTF.text][0];
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#AAAAAA"]} range:NSMakeRange(str.length, self.navBar.searchTF.text.length)];
    }
    return attStr;
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
        self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    }else{ //键盘升起
        CGFloat height = toFrame.size.height;
        self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight - height);
    }
}


#pragma mark - 请求 获取商品
- (void)requestSearchHotGoods
{
    [self.hotGoodsArray removeAllObjects];
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestSearchHotGoodsWithCurrentPage:1 success:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.hotGoodsArray addObjectsFromArray:response];
        }
        [weakSelf.collectionView reloadData];
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 商品搜索联想
- (void)reqeustSearchGoods
{
    [self.searchArray removeAllObjects];
    WEAKSELF;
//    [[DCAPIManager shareManager] person_requestSearchWordWithSearchName:self.navBar.searchTF.text success:^(id response) {
//        if (response && [response count] > 0) {
//            [weakSelf.searchArray addObjectsFromArray:response];
//        }
//        [weakSelf.tableView reloadData];
//
//    } failture:^(NSError *_Nullable error) {
//    }];
    
    [[DCAPIManager shareManager] person_requestSearchWordKeyWithKey:self.navBar.searchTF.text success:^(id response) {
        if (response && [response count] > 0) {
            weakSelf.searchArray = [GLPSearchKeyModel mj_objectArrayWithKeyValuesArray:response];
//            [weakSelf.searchArray addObjectsFromArray:response];
        }
        [weakSelf.tableView reloadData];
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - lazy load
- (GLPSearcgNavBar *)navBar{
    if (!_navBar) {
        _navBar = [[GLPSearcgNavBar alloc] init];
        WEAKSELF;
        _navBar.cancelBlock = ^{
            [weakSelf.view endEditing:YES];
            weakSelf.tableView.hidden = YES;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [_navBar.searchTF addTarget:self action:@selector(searchTFValueChange:) forControlEvents:UIControlEventEditingChanged];
        _navBar.searchTF.delegate = self;
    }
    return _navBar;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        _flowLayout = [[WSLWaterFlowLayout alloc] init];
        _flowLayout.delegate = self;
        _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:NSClassFromString(goodsCellID) forCellWithReuseIdentifier:goodsCellID];
        [_collectionView registerClass:NSClassFromString(titleCellID) forCellWithReuseIdentifier:titleCellID];
        [_collectionView registerClass:NSClassFromString(sectionID) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionID];
    }
    return _collectionView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.hidden = YES;
        [_tableView registerClass:NSClassFromString(searchCellID) forCellReuseIdentifier:searchCellID];
        [_tableView registerClass:NSClassFromString(PromptCellID) forCellReuseIdentifier:PromptCellID];
        
    }
    return _tableView;
}


- (NSMutableArray *)hotGoodsArray{
    if (!_hotGoodsArray) {
        _hotGoodsArray = [NSMutableArray array];
    }
    return _hotGoodsArray;
}

- (NSMutableArray *)recordArray{
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}



@end
