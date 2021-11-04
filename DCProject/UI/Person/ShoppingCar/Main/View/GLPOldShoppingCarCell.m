//
//  GLPOldShoppingCarCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPOldShoppingCarCell.h"

#import "GLPShoppingCarGoodsCell.h"
#import "GLPShoppingCarGoodsSectionView.h"

static NSString *const listCellID = @"GLPShoppingCarGoodsCell";
static NSString *const sectionID = @"GLPShoppingCarGoodsSectionView";

#define kRowHeight 186
#define KSectionHeight 53

@interface GLPOldShoppingCarCell ()<UITableViewDelegate,UITableViewDataSource,GLPEditCountViewDelegate>

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

@implementation GLPOldShoppingCarCell

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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [_tableView registerClass:NSClassFromString(sectionID) forHeaderFooterViewReuseIdentifier:sectionID];
    [self.contentView addSubview:_tableView];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.attributedText = [self attributeWithMoney:@"0.00"];
    [self.contentView addSubview:_totalLabel];
    
    [self layoutIfNeeded];
}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            return [carActivityModel.actCartGoodsList count];
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            return [array count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLPShoppingCarGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    WEAKSELF;
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            cell.actGoodsModel = carActivityModel.actCartGoodsList[indexPath.row];
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            cell.noActgoodsModel = array[indexPath.row];
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
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            return KSectionHeight;
        }
    }
    return 0.01;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    if (array.count > 0) {
        id class = array[0];
        if (![class isKindOfClass:[GLPShoppingCarActivityModel class]]) {
            return [UITableViewHeaderFooterView new];
        }
    } else {
        return [UITableViewHeaderFooterView new];
    }
    
    GLPShoppingCarGoodsSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionID];
    header.acticityModel = array[0];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            GLPShoppingCarActivityGoodsModel *goodsModel = carActivityModel.actCartGoodsList[indexPath.row];
            
            if (_goodsBlock) {
                _goodsBlock(nil,goodsModel);
            }
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            GLPShoppingCarNoActivityModel *noActivityModel = array[indexPath.row];
            
            if (_goodsBlock) {
                _goodsBlock(noActivityModel,nil);
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
        if (_countViewBlock) {
            _countViewBlock(countView,1,indexPath);
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
        if (_countViewBlock) {
            _countViewBlock(countView,2,indexPath);
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
        if (_countViewBlock) {
            _countViewBlock(countView,3,indexPath);
        }
    }
}


#pragma mark - 点击cell上的编辑按钮
- (void)dc_cellBtnClick:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath {
    // 获取数据
    NSArray *array = self.dataArray[indexPath.section];
    if (array.count > 0) {
        id class = array[0];
        if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
            
            GLPShoppingCarActivityModel *carActivityModel = class;
            NSArray *goodsList = carActivityModel.actCartGoodsList;
            GLPShoppingCarActivityGoodsModel *actGoodsModel = goodsList[indexPath.row];
            actGoodsModel.isSelected = isSelected;
            
            // 数据源替换 
            NSMutableArray *newGoodsList = [goodsList mutableCopy];
            [newGoodsList replaceObjectAtIndex:indexPath.row withObject:actGoodsModel];
            carActivityModel.actCartGoodsList = newGoodsList;
            
            NSMutableArray *validActInfoList = [_shoppingCarModel.validActInfoList mutableCopy];
            [validActInfoList replaceObjectAtIndex:indexPath.section withObject:carActivityModel];
            _shoppingCarModel.validActInfoList = validActInfoList;
        
            if (_editBtnBlock) {
                _editBtnBlock(_shoppingCarModel);
            }
            
        } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
            
            GLPShoppingCarNoActivityModel *noActModel = array[indexPath.row];
            noActModel.isSelected = isSelected;
            
            NSMutableArray *newSubArray = [array mutableCopy];
            [newSubArray replaceObjectAtIndex:indexPath.row withObject:noActModel];
            
            _shoppingCarModel.validNoActGoodsList = newSubArray;
            
            if (_editBtnBlock) {
                _editBtnBlock(_shoppingCarModel);
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
    BOOL isAllSelected = YES;
    for (int i = 0; i<self.dataArray.count; i++) {
        NSArray *array = self.dataArray[i];
        
        if (array.count > 0) {
            id class = array[0];
            if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
                
                GLPShoppingCarActivityModel *carActivityModel = class;
                NSArray *goodsList = carActivityModel.actCartGoodsList;
                for (int j = 0; j < goodsList.count; j++) {
                    GLPShoppingCarActivityGoodsModel *actGoodsModel = goodsList[j];
                    if (actGoodsModel.isSelected == NO) {
                        isAllSelected = NO;
                    }
                }
                
            } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) { // 无活动
                
                for (int j=0; j<array.count; j++) {
                    GLPShoppingCarNoActivityModel *noActModel = array[j];
                    if (noActModel.isSelected == NO) {
                        isAllSelected = NO;
                    }
                }
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
            if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
                
                GLPShoppingCarActivityModel *carActivityModel = class;
                NSArray *goodsList = carActivityModel.actCartGoodsList;
                NSMutableArray *newGoodsList = [NSMutableArray array];
                for (int j = 0; j < goodsList.count; j++) {
                    GLPShoppingCarActivityGoodsModel *actGoodsModel = goodsList[j];
                    actGoodsModel.isSelected = isSelected;
                    
                    [newGoodsList addObject:actGoodsModel];
                }
                
                carActivityModel.actCartGoodsList = newGoodsList;
                
                // cell数据源替换
                [self.dataArray replaceObjectAtIndex:i withObject:@[carActivityModel]];
                [self.tableView reloadData];
                
                // 外层数据源替换
                NSMutableArray *validActInfoList = [_shoppingCarModel.validActInfoList mutableCopy];
                [validActInfoList replaceObjectAtIndex:i withObject:carActivityModel];
                _shoppingCarModel.validActInfoList = validActInfoList;
                
            } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) { // 无活动
                
                NSMutableArray *newSubArray = [array mutableCopy];
                for (int j=0; j<array.count; j++) {
                    GLPShoppingCarNoActivityModel *noActModel = array[j];
                    noActModel.isSelected = isSelected;
                    
                    [newSubArray replaceObjectAtIndex:j withObject:noActModel];
                }
                
                [self.dataArray replaceObjectAtIndex:i withObject:newSubArray];
                [self.tableView reloadData];
                
                _shoppingCarModel.validNoActGoodsList = newSubArray;
            }
        }
    }
    
    [self dc_selectAllPrice];
    [self.tableView reloadData];
    
    if (_editBtnBlock) {
        _editBtnBlock(_shoppingCarModel);
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
            if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
                
                CGFloat price = 0;// 单个活动价格小记
                GLPShoppingCarActivityModel *carActivityModel = class;
                NSArray *goodsList = carActivityModel.actCartGoodsList;
                for (int j = 0; j < goodsList.count; j++) {
                    GLPShoppingCarActivityGoodsModel *actGoodsModel = goodsList[j];
                    if (actGoodsModel.isSelected) {
                        price += (actGoodsModel.sellPrice *actGoodsModel.quantity);
                    }
                }
                
                // 活动满减
                if (price >= carActivityModel.requireAmount) {
                    price -= carActivityModel.discountAmount;
                }
                
                allPrice += price; // 累加
                
            } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) { // 无活动
                
                CGFloat price = 0;// 非活动价格小记
                for (int j=0; j<array.count; j++) {
                    GLPShoppingCarNoActivityModel *noActModel = array[j];
                    if (noActModel.isSelected) {
                        price += (noActModel.sellPrice *noActModel.quantity);
                    }
                }
                
                allPrice += price;
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
    [super layoutSubviews];
    
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
        make.top.equalTo(self.editBtn.bottom).offset(10);
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
            if ([class isKindOfClass:[GLPShoppingCarActivityModel class]]) { // 有活动
                
                height += KSectionHeight;
                GLPShoppingCarActivityModel *carActivityModel = class;
                if (carActivityModel.actCartGoodsList) {
                    height += (carActivityModel.actCartGoodsList.count *kRowHeight);
                }
                
            } else if ([class isKindOfClass:[GLPShoppingCarNoActivityModel class]]) {
                height += (array.count *kRowHeight);
            }
        }
    }
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line.bottom).offset(0);
        make.height.equalTo(height);
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
- (void)setShoppingCarModel:(GLPShoppingCarModel *)shoppingCarModel
{
    _shoppingCarModel = shoppingCarModel;
    
    _shopNameLabel.text = _shoppingCarModel.mallname;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_shoppingCarModel.mallLogo] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    if ([_shoppingCarModel.existCoupons isEqualToString:@"1"]) { // 有优惠券
        _ticketBtn.hidden = NO;
    } else {
        _ticketBtn.hidden = YES;
    }
    
    [self.dataArray removeAllObjects];
    if (_shoppingCarModel.validActInfoList && _shoppingCarModel.validActInfoList.count > 0) {
        for (int i=0; i<_shoppingCarModel.validActInfoList.count; i++) {
            [self.dataArray addObject:@[_shoppingCarModel.validActInfoList[i]]];
        }
    }
    if (_shoppingCarModel.validNoActGoodsList && _shoppingCarModel.validNoActGoodsList.count > 0) {
        [self.dataArray addObject:_shoppingCarModel.validNoActGoodsList];
    }
    
    [self dc_isAllSelected];
    [self dc_selectAllPrice];
    
    [self.tableView reloadData];
    
    
//    for (NSInteger i = 0; i<self.dataArray.count; i++) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationNone];
//    }
    [self layoutSubviews];
}


@end
