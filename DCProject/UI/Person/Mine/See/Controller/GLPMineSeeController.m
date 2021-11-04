//
//  GLPMineSeeController.m
//  DCProject
//
//  Created by bigbing on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPMineSeeController.h"

#import "TRGoodsCell.h"

#import "GLPGoodsDetailsController.h"
#import "GLPMineSeeModel.h"
#define kRowHeight 160

static NSString *const listCellID = @"TRGoodsCell";
static NSString *const sectionID = @"UITableViewHeaderFooterView";

@interface GLPMineSeeController ()<UITextFieldDelegate>

// 总数据
//@property (nonatomic, strong) NSMutableArray<GLPMineSeeModel *> *bigArray;
// 处理完之后的数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;


@end

@implementation GLPMineSeeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的足迹";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpTableView];
    
    [self addRefresh:NO];
}


#pragma mark - 下拉刷新
- (void)loadNewTableData:(id)sender{
    [self requestSeeGoodsList:YES];
}

#pragma mark - 上拉加载更多
- (void)loadMoreTableData:(id)sender{
    [self requestSeeGoodsList:NO];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GLPMineSeeModel *seeModel = self.dataArray[section];
    if (seeModel && seeModel.accessList) {
        return seeModel.accessList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.seeModel = [self.dataArray[indexPath.section] accessList][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    for (id class in header.contentView.subviews) {
        [class removeFromSuperview];
    }
    
    header.contentView.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor dc_colorWithHexString:@"#747474"];
    titleLabel.font = PFRFont(14);
    [header.contentView addSubview:titleLabel];
    
    GLPMineSeeModel *seeModel = self.dataArray[section];
    titleLabel.text = seeModel.accessDate;
    
//    NSArray *array = self.dataArray[section];
//    if ([array count] > 0) {
//        GLPMineSeeModel *seeModel = array[0];
//        NSString *time = seeModel.accessDate;
//        if ([time containsString:@" "]) {
//            time = [time componentsSeparatedByString:@" "][0];
//        }
//        titleLabel.text = time;
//    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.contentView.centerY);
        make.left.equalTo(header.contentView.left).offset(16);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLPMineSeeGoodsModel *seeModel = [self.dataArray[indexPath.section] accessList][indexPath.row];
    
    if (tableView.isEditing) {
        
        
        
    } else { // 页面跳转
        
        GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
        vc.goodsId = seeModel.goodsId;
        vc.firmId = [NSString stringWithFormat:@"%ld",seeModel.sellerFirmId];
        [self dc_pushNextController:vc];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// ios8 - 11
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        [weakSelf requestAddCollection:indexPath];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {
        [weakSelf requestDeleteBrowse:indexPath];
    }];
    
    
    action1.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    action2.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];
    
    return @[action1, action2];
}

// ios11+
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    WEAKSELF;
    UIContextualAction *colloctAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"收藏" handler:^(UIContextualAction *_Nonnull action, __kindof UIView *_Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf requestAddCollection:indexPath];
    }];
    colloctAction.backgroundColor = [UIColor dc_colorWithHexString:@"#FF9900"];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction *_Nonnull action, __kindof UIView *_Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weakSelf requestDeleteBrowse:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3F3F"];
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,colloctAction]];
    actions.performsFirstActionWithFullSwipe = NO;
    return actions;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}



#pragma mark - 请求 收藏记录
- (void)requestSeeGoodsList:(BOOL)isReload
{
    _page++;
    if (isReload) {
        _page = 1;
//        [self.bigArray removeAllObjects];
        [self.dataArray removeAllObjects];
    }
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestSeeGoodsListWithCurrentPage:_page success:^(NSArray *array, BOOL hasNextPage,CommonListModel *commonModel) {
        if (array && [array count] > 0) {
            [weakSelf.dataArray addObjectsFromArray:array];
        }
        
//        // 数据处理
//        [weakSelf.dataArray removeAllObjects];
//        for (int i = 0; i<weakSelf.bigArray.count; i++) {
//            GLPMineSeeModel *seeModel = weakSelf.bigArray[i];
//            if (weakSelf.dataArray.count == 0) {
//
//                NSMutableArray *subArray = [NSMutableArray array];
//                [subArray addObject:seeModel];
//                [weakSelf.dataArray addObject:subArray];
//
//            } else {
//
//                NSInteger index = 0;
//                for (int j=1; j<weakSelf.dataArray.count+1; j++) {
//                    NSMutableArray *array = weakSelf.dataArray[j-1];
//                    GLPMineSeeModel *subSeeModel = array[0];
//
//                    NSString *time = seeModel.accessDate;
//                    if ([time containsString:@" "]) {
//                        time = [time componentsSeparatedByString:@" "][0];
//                    }
//                    NSString *subTime = subSeeModel.accessDate;
//                    if ([subTime containsString:@" "]) {
//                        subTime = [subTime componentsSeparatedByString:@" "][0];
//                    }
//
//                    if ([subTime isEqualToString:time]) {
//                        index = j;
//                    }
//                }
//
//                if (index > 0) { // 有该日期
//
//                     NSMutableArray *array = weakSelf.dataArray[index-1];
//                    [array addObject:seeModel];
//                    [weakSelf.dataArray replaceObjectAtIndex:index-1 withObject:array];
//
//                } else { // 无该日期
//
//                    NSMutableArray *array = [NSMutableArray array];
//                    [array addObject:seeModel];
//                    [weakSelf.dataArray addObject:array];
//                }
//
//            }
//        }
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray hasNextPage:hasNextPage];
        
    } failture:^(NSError *error) {
        
        [weakSelf reloadTableViewWithDatas:weakSelf.dataArray lasts:@[]];
    }];
}


#pragma mark - 删除浏览记录
- (void)requestDeleteBrowse:(NSIndexPath *)indexPath
{
    GLPMineSeeGoodsModel *model = [self.dataArray[indexPath.section] accessList][indexPath.row];
    NSString *accessId = [NSString stringWithFormat:@"%ld",model.accessId];
    
    WEAKSELF;
    [[DCAPIManager shareManager] person_requestDeleteSeeRecordWithAccessIds:accessId success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            GLPMineSeeModel *seeModel = weakSelf.dataArray[indexPath.section];
            NSMutableArray *array = [[seeModel accessList] mutableCopy];
            [array removeObjectAtIndex:indexPath.row];
            if (array.count == 0) { // 被删完了
                [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
            } else {
                seeModel.accessList = array;
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:seeModel];
            }
            [weakSelf.tableView reloadData];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 添加收藏
- (void)requestAddCollection:(NSIndexPath *)indexPath
{
    GLPMineSeeGoodsModel *model = [self.dataArray[indexPath.section] accessList][indexPath.row];
    NSString *price = [NSString stringWithFormat:@"%.2f",model.sellPrice];
    
    [[DCAPIManager shareManager] person_addCollectionwithcollectionType:@"1" goodsPrice:price objectId:model.goodsId isPrompt:NO success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}



#pragma mark - UI
- (void)setUpTableView
{
    self.tableStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, kNavBarHeight, kScreenW, kScreenH - kNavBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kRowHeight;
    self.tableView.sectionHeaderHeight = 0.01f;
    self.tableView.sectionFooterHeight = 0.01f;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:listCellID bundle:nil] forCellReuseIdentifier:listCellID];
    [self.tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
    
    self.noDataImg.image = [UIImage imageNamed:@"p_shouc"];
    self.noDataLabel.text = @"暂时还没有哦";
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//- (NSMutableArray<GLPMineSeeModel *> *)bigArray{
//    if (!_bigArray) {
//        _bigArray = [NSMutableArray array];
//    }
//    return _bigArray;
//}
@end
