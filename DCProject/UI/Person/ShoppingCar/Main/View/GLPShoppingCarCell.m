//
//  GLPShoppingCarCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/14.
//

#import "GLPShoppingCarCell.h"

#import "GLPShoppingCarGoodsCell.h"
#import "GLPShoppingCarGoodsSectionView.h"

static NSString *const GLPShoppingCarGoodsCellID = @"GLPShoppingCarGoodsCell";
static NSString *const GLPShoppingCarGoodsSectionViewID = @"GLPShoppingCarGoodsSectionView";

#define kRowHeight 186
#define KSectionHeight 53

@interface GLPShoppingCarCell ()<UITableViewDelegate,UITableViewDataSource,GLPEditCountViewDelegate>

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIButton *shopNameButton;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLPShoppingCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"weixuanz"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:15];
    [self.contentView addSubview:_iconImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _shopNameLabel.text = @"";
    [self.contentView addSubview:_shopNameLabel];
    
    _ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ticketBtn setBackgroundImage:[UIImage imageNamed:@"gwc_lingquan"] forState:0];
    _ticketBtn.adjustsImageWhenHighlighted = NO;
    [_ticketBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_ticketBtn];
    
    _moreImage = [[UIImageView alloc] init];
    _moreImage.image = [UIImage imageNamed:@"dc_arrow_right_xh"];
    [self.contentView addSubview:_moreImage];
    
    _shopNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopNameButton addTarget:self action:@selector(shopNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shopNameButton];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
//    _tableView.sectionHeaderHeight = KSectionHeight;
//    _tableView.rowHeight = kRowHeight;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
//    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
//    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(GLPShoppingCarGoodsCellID) forCellReuseIdentifier:GLPShoppingCarGoodsCellID];
    [_tableView registerClass:NSClassFromString(GLPShoppingCarGoodsSectionViewID) forHeaderFooterViewReuseIdentifier:GLPShoppingCarGoodsSectionViewID];
    [self.contentView addSubview:_tableView];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.attributedText = [self attributeWithMoney:@"0.00"];
    [self.contentView addSubview:_totalLabel];
    
    [self layoutIfNeeded];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = KSectionHeight;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

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
    GLPShoppingCarGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPShoppingCarGoodsCellID forIndexPath:indexPath];
    WEAKSELF;
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            
            ActInfoListModel *carActivityModel = class;
            cell.actGoodsModel = carActivityModel.actGoodsList[indexPath.row];
            
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            cell.noActGoodsModel = array[indexPath.row];
        }
    }
    cell.goodsCellBlock = ^(BOOL isSelcted) {
        [weakSelf dc_cellBtnClick:isSelcted indexPath:indexPath];
    };
    
    // 非法操作
    NSInteger section = 100000+indexPath.section;
    NSInteger row = 100000+indexPath.row;
    NSString *tagStr = [NSString stringWithFormat:@"%ld%ld",(long)section,(long)row];
    cell.countView.tag = [tagStr integerValue];
    cell.countView.delegate = self;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) {
            GLPShoppingCarGoodsSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:GLPShoppingCarGoodsSectionViewID];
            header.acticityModel = array[0];
            return header;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            
            ActInfoListModel *carActivityModel = class;
            GLPNewShopCarGoodsModel *goodsModel = carActivityModel.actGoodsList[indexPath.row];
            
            if (_GLPShoppingCarCell_goodsBlock) {
                _GLPShoppingCarCell_goodsBlock(nil,goodsModel);
            }
            
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            GLPNewShopCarGoodsModel *noActivityModel = array[indexPath.row];
            
            if (_GLPShoppingCarCell_goodsBlock) {
                _GLPShoppingCarCell_goodsBlock(noActivityModel,nil);
            }
        }
    }
}

#pragma mark - <GLPEditCountViewDelegate>
// 加
- (void)dc_personCountAddWithCountView:(GLPEditCountView *)countView {
    // 非法操作
    NSInteger tag = countView.tag;
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)tag];
    NSString *sectionStr = [tagStr substringWithRange:NSMakeRange(0, 6)];
    NSString *rowStr = [tagStr substringWithRange:NSMakeRange(6, tagStr.length - 6)];
    NSInteger section = [sectionStr integerValue] - 100000;
    NSInteger row = [rowStr integerValue] - 100000;
    if (section >= 0 && row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        if (_GLPShoppingCarCell_countViewBlock) {
            _GLPShoppingCarCell_countViewBlock(countView,1,indexPath);
        }
    }
}

// 减
- (void)dc_personCountSubWithCountView:(GLPEditCountView *)countView {
    // 非法操作
    NSInteger tag = countView.tag;
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)tag];
    NSString *sectionStr = [tagStr substringWithRange:NSMakeRange(0, 6)];
    NSString *rowStr = [tagStr substringWithRange:NSMakeRange(6, tagStr.length - 6)];
    NSInteger section = [sectionStr integerValue] - 100000;
    NSInteger row = [rowStr integerValue] - 100000;
    if (section >= 0 && row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        if (_GLPShoppingCarCell_countViewBlock) {
            _GLPShoppingCarCell_countViewBlock(countView,2,indexPath);
        }
    }
}

// 改变
- (void)dc_personCountChangeWithCountView:(GLPEditCountView *)countView {
    // 非法操作
    NSInteger tag = countView.tag;
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)tag];
    NSString *sectionStr = [tagStr substringWithRange:NSMakeRange(0, 6)];
    NSString *rowStr = [tagStr substringWithRange:NSMakeRange(6, tagStr.length - 6)];
    NSInteger section = [sectionStr integerValue] - 100000;
    NSInteger row = [rowStr integerValue] - 100000;
    if (section >= 0 && row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        if (_GLPShoppingCarCell_countViewBlock) {
            _GLPShoppingCarCell_countViewBlock(countView,3,indexPath);
        }
    }
}


#pragma mark - 点击cell上的编辑按钮
- (void)dc_cellBtnClick:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath {
    // 获取数据
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
            
            ActInfoListModel *carActivityModel = class;
            NSArray *goodsList = carActivityModel.actGoodsList;
            GLPNewShopCarGoodsModel *actGoodsModel = goodsList[indexPath.row];
            actGoodsModel.isSelected = isSelected;
            
            // 数据源替换
//            NSMutableArray *newGoodsList = [goodsList mutableCopy];
//            [newGoodsList replaceObjectAtIndex:indexPath.row withObject:actGoodsModel];
//            carActivityModel.actGoodsList = newGoodsList;
//
//            NSMutableArray *actInfoList = [_shoppingCarModel.actInfoList mutableCopy];
//            [actInfoList replaceObjectAtIndex:indexPath.section withObject:carActivityModel];
//            _shoppingCarModel.actInfoList = actInfoList;
        
            if (_GLPShoppingCarCell_editBtnBlock) {
                _GLPShoppingCarCell_editBtnBlock(_shoppingCarModel);
            }
            
        } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
            
            GLPNewShopCarGoodsModel *noActModel = array[indexPath.row];
            noActModel.isSelected = isSelected;
            
            // 数据源替换
//            NSMutableArray *newSubArray = [array mutableCopy];
//            [newSubArray replaceObjectAtIndex:indexPath.row withObject:noActModel];
//            _shoppingCarModel.cartGoodsList = newSubArray;
            
            if (_GLPShoppingCarCell_editBtnBlock) {
                _GLPShoppingCarCell_editBtnBlock(_shoppingCarModel);
            }
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    [self dc_isAllSelected];
    [self dc_selectAllPrice];
}


#pragma mark - 判读是否全部选中
- (void)dc_isAllSelected
{
    __block BOOL isAllSelected = YES;
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        
        if (array.count > 0) {
            id class = array[0];
            if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
                ActInfoListModel *carActivityModel = class;
                [carActivityModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (goodsModel.isSelected == NO) {
                        isAllSelected = NO;
                    }
                }];
            } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) { // 无活动
                [array enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (goodsModel.isSelected == NO) {
                        isAllSelected = NO;
                    }
                }];
            }
        }
    }

    _editBtn.selected = isAllSelected;
}


#pragma mark - 全选/全不选
- (void)dc_selectedAll:(BOOL)isSelected
{
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        
        if (array.count > 0) {
            id class = array[0];
            if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
                
                ActInfoListModel *carActivityModel = class;
                //NSMutableArray *newGoodsList = [NSMutableArray array];
                [carActivityModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    goodsModel.isSelected = isSelected;
                    //[newGoodsList addObject:goodsModel];
                }];
                //carActivityModel.actGoodsList = newGoodsList;
                // cell数据源替换
                //[self.dataArray replaceObjectAtIndex:i withObject:@[carActivityModel]];
                [self.tableView reloadData];
                
                // 外层数据源替换
//                NSMutableArray *actInfoList = [_shoppingCarModel.actInfoList mutableCopy];
//                [actInfoList replaceObjectAtIndex:i withObject:carActivityModel];
//                _shoppingCarModel.actInfoList = actInfoList;
                
            } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) { // 无活动
                
//                NSMutableArray *newSubArray = [array mutableCopy];
                [array enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    goodsModel.isSelected = isSelected;
                    //[newSubArray replaceObjectAtIndex:j withObject:noActModel];
                }];

                // cell数据源替换
//                [self.dataArray replaceObjectAtIndex:i withObject:newSubArray];
                [self.tableView reloadData];
                
//                _shoppingCarModel.cartGoodsList = newSubArray;
            }
        }
    }
    
    [self dc_selectAllPrice];
    [self.tableView reloadData];
    
    if (_GLPShoppingCarCell_editBtnBlock) {
        _GLPShoppingCarCell_editBtnBlock(_shoppingCarModel);
    }
}


#pragma mark - 计算该店铺下选中商品总价格
- (void)dc_selectAllPrice
{
    CGFloat allPrice = 0; // 总价格
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        
        if (array.count > 0) {
            id class = array[0];
            if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
                
                __block CGFloat beforeDiscountAmount = 0.00; // 每个活动商品金额小记
                CGFloat afterDiscountAmount = 0.00;
                ActInfoListModel *carActivityModel = class;
                [carActivityModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (goodsModel.isSelected) {
                        beforeDiscountAmount += ([goodsModel.sellPrice floatValue] * [goodsModel.quantity floatValue]);
                    }
                }];
                
                NSArray *actList = [GLPCouponListModel mj_objectArrayWithKeyValuesArray:carActivityModel.actPriceList];
                __block GLPCouponListModel *indexModel = nil;
                [actList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(GLPCouponListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (beforeDiscountAmount > [actModel.requireAmount floatValue]) {
                        indexModel = actModel;
                    }
                }];
                
                if (beforeDiscountAmount >= [indexModel.discountAmount floatValue] && beforeDiscountAmount > [indexModel.requireAmount floatValue]) {
                    afterDiscountAmount = beforeDiscountAmount - [indexModel.discountAmount floatValue];
                }else
                    afterDiscountAmount = beforeDiscountAmount;
                
//                 活动满减
//                if (beforeDiscountAmount >= [carActivityModel.requireAmount floatValue]) {
//                    beforeDiscountAmount -= [carActivityModel.discountAmount floatValue];
//                }
                
                allPrice += afterDiscountAmount; // 累加
                
            } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) { // 无活动
                
                __block CGFloat beforeDiscountAmount = 0;// 非活动价格小记
                [array enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *  _Nonnull goodsModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (goodsModel.isSelected) {
                        beforeDiscountAmount += ([goodsModel.sellPrice floatValue] * [goodsModel.quantity floatValue]);
                    }
                }];
                allPrice += beforeDiscountAmount;
            }
        }
    }
    
    _totalLabel.attributedText = [self attributeWithMoney:[NSString stringWithFormat:@"%.2f",allPrice]];
}


#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    button.selected =! button.selected;
    
    [self dc_selectedAll:button.selected];
}

- (void)ticketBtnClick:(UIButton *)button
{
    if (_ticketBtnBlock) {
        _ticketBtnBlock();
    }
}

- (void)shopNameButtonClick:(UIButton *)button
{
    if (_shopNameClickBlock) {
        _shopNameClickBlock();
    }
}

#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithMoney:(NSString *)money
{
    NSString *text = [NSString stringWithFormat:@"商品小计：￥%@",money];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 5)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(5, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:16],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(6, attrStr.length - 6)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
//    [super layoutSubviews];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.contentView.top).offset(10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.right).offset(10);
        make.centerY.equalTo(self.editBtn.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.width.lessThanOrEqualTo(200);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.shopNameLabel.right).offset(10);
        make.size.equalTo(CGSizeMake(6, 8));
    }];
    
    [_ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(55, 30));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.editBtn.bottom).offset(10).priorityHigh();
        make.height.equalTo(1);
    }];
    
    [_shopNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.left);
        make.right.equalTo(self.ticketBtn.left);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.line.top);
    }];
    
    CGFloat height = 0;
    for (int i=0; i<self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        if (array.count > 0) {
            id class = array[0];
            if ([class isKindOfClass:[ActInfoListModel class]]) { // 有活动
                
                height += KSectionHeight;
                ActInfoListModel *carActivityModel = class;
                if (carActivityModel.actGoodsList) {
                    height += (carActivityModel.actGoodsList.count *kRowHeight);
                }
                
            } else if ([class isKindOfClass:[GLPNewShopCarGoodsModel class]]) {
                height += (array.count *kRowHeight);
            }
        }
    }
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line.bottom).offset(0);
        make.height.equalTo(height).priorityHigh();
    }];
    
    [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.tableView.bottom).offset(14);
        make.bottom.equalTo(self.contentView.bottom).offset(-14);
    }];
}



#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setShoppingCarModel:(GLPFirmListModel *)shoppingCarModel
{
    _shoppingCarModel = shoppingCarModel;
    
    _shopNameLabel.text = _shoppingCarModel.mallName;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_shoppingCarModel.mallLogo] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    if ([_shoppingCarModel.existCoupons isEqualToString:@"1"]) { // 有优惠券
        _ticketBtn.hidden = NO;
    } else {
        _ticketBtn.hidden = YES;
    }
    
    [self.dataArray removeAllObjects];
    
//    if (_shoppingCarModel.actInfoList && _shoppingCarModel.actInfoList.count > 0) {
//
//        [_shoppingCarModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self.dataArray addObject:@[_shoppingCarModel.actInfoList[idx]]];
//        }];
//    }
    
    [_shoppingCarModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *  _Nonnull actModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray addObject:@[_shoppingCarModel.actInfoList[idx]]];
    }];
    
//    if (_shoppingCarModel.cartGoodsList && _shoppingCarModel.cartGoodsList.count > 0) {
//        [self.dataArray addObject:_shoppingCarModel.cartGoodsList];
//    }
    
    [self.dataArray addObject:_shoppingCarModel.cartGoodsList];

    
    [self dc_isAllSelected];
    [self dc_selectAllPrice];
    
    [self.tableView reloadData];
    [self layoutSubviews];
}


@end
