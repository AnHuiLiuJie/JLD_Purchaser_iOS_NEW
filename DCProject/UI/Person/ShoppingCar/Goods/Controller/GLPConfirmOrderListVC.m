//
//  GLPConfirmOrderListVC.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPConfirmOrderListVC.h"
#import "GLPConfirmOrderHeaderView.h"
#import "GLPGoodsDetailsController.h"

static NSString *const GLPConfirmOrderLisCellID = @"GLPConfirmOrderLisCell";
static NSString *const GLPConfirmOrderHeaderViewID = @"GLPConfirmOrderHeaderView";

#define kRowHeight 186
#define KSectionHeight 53

@interface GLPConfirmOrderListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPConfirmOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setUpUI];
    
    [self.dataArray removeAllObjects];
    
    //WEAKSELF;
    [_firmModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *actModel, NSUInteger idx21, BOOL * _Nonnull stop21) {
        [self.dataArray addObject:@[actModel]];
    }];
    
    [_dataArray addObject:_firmModel.cartGoodsList];

    
    [self.tableView reloadData];
}


- (void)setUpUI
{
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    CGFloat itemH = kScreenH/5 * 4;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - itemH, kScreenW, itemH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _titleLabel.text = _firmModel.sellerFirmName;
    [_bgView addSubview:_titleLabel];
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //_iconImage.image = [UIImage imageNamed:@"logo"];
    [_bgView addSubview:_iconImage];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerClass:NSClassFromString(GLPConfirmOrderLisCellID) forCellReuseIdentifier:GLPConfirmOrderLisCellID];
    [_tableView registerClass:NSClassFromString(GLPConfirmOrderHeaderViewID) forHeaderFooterViewReuseIdentifier:GLPConfirmOrderHeaderViewID];
    [_bgView addSubview:_tableView];
    
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kScreenH - itemH, 0, 0, 0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.bgView.top).offset(15);
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
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.left.equalTo(self.bgView.left).offset(0);
        make.right.equalTo(self.bgView.right).offset(0);
        make.bottom.equalTo(self.bgView.bottom).offset(LJ_TabbarSafeBottomMargin);
    }];
}

#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) {
            ActInfoListModel *carActivityModel = class;
            return [carActivityModel.actGoodsList count];
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            return [array count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPConfirmOrderLisCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPConfirmOrderLisCellID forIndexPath:indexPath];
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            ActInfoListModel *actModel = class;
            cell.actGoodsModel = actModel.actGoodsList[indexPath.row];
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            cell.noActGoodsModel = array[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) {
            return KSectionHeight;
        }
    }
    return 0.01;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if (![class isKindOfClass:[ActInfoListModel class]]) {
            return [UITableViewHeaderFooterView new];
        }
    } else {
        return [UITableViewHeaderFooterView new];
    }
    
    GLPConfirmOrderHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GLPConfirmOrderHeaderViewID];
    header.acticityModel = array[0];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *goodsId = @"";
    
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            
            ActInfoListModel *carActivityModel = class;
            GLPNewShopCarGoodsModel *goodsModel = carActivityModel.actGoodsList[indexPath.row];
            
            goodsId = goodsModel.goodsId;
            
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            GLPNewShopCarGoodsModel *noActivityModel = array[indexPath.row];
            
            goodsId = noActivityModel.goodsId;
        }
    }
    
    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = goodsId;
    vc.firmId = [NSString stringWithFormat:@"%@",self.firmModel.sellerFirmId];
    vc.detailType = GLPGoodsDetailTypeNormal;
    [self dc_pushNextController:vc];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
