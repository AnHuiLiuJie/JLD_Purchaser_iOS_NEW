//
//  GLBShoppingCarCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBShoppingCarCell.h"

static NSString *const listCellID = @"GLBShoppingCarGoodsCell";

#define kRowHeight 162

@interface GLBShoppingCarCell ()<UITableViewDelegate,UITableViewDataSource,GLBEditCountViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) NSMutableArray<GLBShoppingCarGoodsModel *> *dataArray;

@end

@implementation GLBShoppingCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_editBtn];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:12];
    [_bgView addSubview:_iconImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#303D55"];
    _shopNameLabel.font = [UIFont fontWithName:PFR size:14];
    [_bgView addSubview:_shopNameLabel];
    
    _ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ticketBtn setTitle:@"领券" forState:0];
    [_ticketBtn setTitleColor:[UIColor dc_colorWithHexString:@"#05BEB1"] forState:0];
    _ticketBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    _ticketBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_ticketBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_ticketBtn];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FEF7CB"];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#ED7744"];
    _tipLabel.font = [UIFont fontWithName:PFRMedium size:11];
    _tipLabel.numberOfLines = 2;
    [_bgView addSubview:_tipLabel];
    
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openBtn setImage:[UIImage imageNamed:@"dc_arrow_down_hei"] forState:0];
    [_openBtn setImage:[UIImage imageNamed:@"dc_arrow_up_hei"] forState:UIControlStateSelected];
    _openBtn.adjustsImageWhenHighlighted = NO;
    [_openBtn setTitle:@"收起" forState:0];
    [_openBtn setTitle:@"展开" forState:UIControlStateSelected];
    [_openBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _openBtn.titleLabel.font = PFRFont(12);
    _openBtn.bounds = CGRectMake(0, 0, 70, 36);
    [_openBtn dc_buttonIconRightWithSpacing:10];
    [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_openBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [_bgView addSubview:_tableView];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_totalLabel];
 
    [self layoutIfNeeded];

}


#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    GLBShoppingCarGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
    cell.goodsModel = self.dataArray[indexPath.row];
    cell.countView.tag = indexPath.row;
    cell.countView.delegate = self;
    cell.goodsCellBlock = ^(GLBShoppingCarGoodsModel *goodsModel) {
        [weakSelf dc_responseCellBtnClickWithGoodsModel:goodsModel indexPath:indexPath];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_carGoodsBlock) {
        _carGoodsBlock(self.dataArray[indexPath.row]);
    }
}


#pragma mark - <GLBEditCountViewDelegate>
// 加
- (void)dc_countAddWithCountView:(GLBEditCountView *)countView {
    if (_countViewBlock) {
        _countViewBlock(countView,1,countView.tag);
    }
}

// 减
- (void)dc_countSubWithCountView:(GLBEditCountView *)countView {
    if (_countViewBlock) {
        _countViewBlock(countView,2,countView.tag);
    }
}

// 改变
- (void)dc_countChangeWithCountView:(GLBEditCountView *)countView {
    if (_countViewBlock) {
        _countViewBlock(countView,3,countView.tag);
    }
}


#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    _shoppingCarModel.isSelected =! _shoppingCarModel.isSelected;
    
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarGoodsModel *goodsModel = self.dataArray[i];
        goodsModel.isSelected = _shoppingCarModel.isSelected;
        [self.dataArray replaceObjectAtIndex:i withObject:goodsModel];
    }
    _shoppingCarModel.cartGoodsList = [self.dataArray copy];
    
    if (_cellEditBlock) {
        _cellEditBlock(_shoppingCarModel);
    }
    
}

- (void)ticketBtnClick:(UIButton *)button
{
    if (_ticketBtnBlock) {
        _ticketBtnBlock();
    }
}

- (void)openBtnClick:(UIButton *)button
{
    button.selected = ! button.selected;
    
    [self dc_reloadData];
}


#pragma mark - 响应cell上按钮点击事件
- (void)dc_responseCellBtnClickWithGoodsModel:(GLBShoppingCarGoodsModel *)goodsModel indexPath:(NSIndexPath *)indexPath
{
    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:goodsModel];
    _shoppingCarModel.cartGoodsList = [self.dataArray copy];
    
    NSInteger count = 0;
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarGoodsModel *model = self.dataArray[i];
        if (model.isSelected) {
            count ++;
        }
    }
    if (count == self.dataArray.count) {
        _shoppingCarModel.isSelected = YES;
    } else {
        _shoppingCarModel.isSelected = NO;
    }
    
    if (_cellEditBlock) {
        _cellEditBlock(_shoppingCarModel);
    }
}


#pragma mark -
- (void)dc_reloadData
{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    [self layoutSubviews];
    [self.tableView reloadData];
}


#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithMoney:(NSString *)money
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"小计：￥%@",money]];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(0, 4)];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(4, attrStr.length - 4)];
    return attrStr;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.right.equalTo(self.contentView.right).offset(-10);
        make.top.equalTo(self.contentView.top).offset(0);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.bgView.top);
        make.size.equalTo(CGSizeMake(60, 40));
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.centerY.equalTo(self.ticketBtn.centerY);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.right).offset(10);
        make.centerY.equalTo(self.editBtn.centerY);
        make.size.equalTo(CGSizeMake(24, 24));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.right.equalTo(self.ticketBtn.left);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.ticketBtn.bottom);
        make.height.equalTo(36);
    }];
    
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipLabel.centerY);
        make.right.equalTo(self.bgView.right);
        make.size.equalTo(CGSizeMake(70, 36));
        make.left.equalTo(self.tipLabel.right);
    }];
    
    CGFloat height = self.dataArray.count *kRowHeight;
    if (self.openBtn.selected) {
        height = 0.01f;
    }
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.tipLabel.bottom);
        make.height.equalTo(height);
    }];
    
    [_totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.tableView.bottom);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(32);
    }];
}



#pragma mark -
- (NSMutableArray<GLBShoppingCarGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setShoppingCarModel:(GLBShoppingCarModel *)shoppingCarModel
{
    _shoppingCarModel = shoppingCarModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_shoppingCarModel.suppierFirmLogo] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _shopNameLabel.text = _shoppingCarModel.suppierFirmName;
    _editBtn.selected = _shoppingCarModel.isSelected;
    
    if (_shoppingCarModel.haveCash) { // 存在优惠券
        _ticketBtn.hidden = NO;
    } else {
        _ticketBtn.hidden = YES;
    }
    
    if (_shoppingCarModel.freight && [_shoppingCarModel.freight.freight floatValue] > 0) { // 存在运费
        _tipLabel.hidden = NO;
        _tipLabel.text = [NSString stringWithFormat:@"  供应商提醒: 订单满￥%@元免运费,不满收取￥%@元运费",_shoppingCarModel.freight.requireAmount,_shoppingCarModel.freight.freight] ;
    } else {
        _tipLabel.hidden = YES;
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_shoppingCarModel.cartGoodsList];
    [self.tableView reloadData];
    [self layoutSubviews];
    
    
    CGFloat allMoney = 0;
    for (int i=0; i<self.dataArray.count; i++) {
        GLBShoppingCarGoodsModel *goodsModel = self.dataArray[i];
        if (goodsModel.isSelected) {
            // 判断是否用促销价格计算
            CGFloat price = goodsModel.price;
            if (goodsModel.hasCtrl) {
                price = goodsModel.ctrlPrice;
            }
            allMoney += (goodsModel.quantity *price);
        }
    }
    
     _totalLabel.attributedText = [self attributeWithMoney:[NSString stringWithFormat:@"%.2f",allMoney]];
}

@end
