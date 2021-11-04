//
//  GLPConfirmOrderStoreCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPConfirmOrderStoreCell.h"
#import "DCTextField.h"
#import "GLPConfirmGoodsListCell.h"
#import "GLPConfirmOrderHeaderView.h"


@interface GLPConfirmOrderStoreCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *shopImage;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UIButton *shopBtn;
//@property (nonatomic, strong) GLPConfirmOrderStoreCellGoodsView *goodsView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UILabel *payTitleLabel;
@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *payRightImage;
@property (nonatomic, strong) UIView *discountView;
@property (nonatomic, strong) UILabel *discountTitleLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIImageView *discountRightImage;
@property (nonatomic, strong) UIView *yunfeiView;
@property (nonatomic, strong) UILabel *yunfeiTitleLabel;
@property (nonatomic, strong) UILabel *qualityLabel;
@property (nonatomic, strong) UILabel *yunfeiLabel;
@property (nonatomic, strong) UIImageView *yunfeiRightImage;
@property (nonatomic, strong) UIView *remarkView;
@property (nonatomic, strong) UILabel *remarkTitleLabel;
@property (nonatomic, strong) DCTextField *remarkTF;
@property (nonatomic, strong) UIImageView *remarkRightImage;

@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIImageView *line3;
@property (nonatomic, strong) UIImageView *line4;
@property (nonatomic, strong) UIImageView *line5;
@property (nonatomic, strong) UIImageView *line6;

@property (nonatomic, assign) CGFloat KSectionHeight;


@end

static NSString *const GLPConfirmGoodsListCellID = @"GLPConfirmGoodsListCell";
static NSString *const GLPConfirmOrderHeaderViewID = @"GLPConfirmOrderHeaderView";
static CGFloat Item_H = 84;
static CGFloat KSection_H = 53;

@implementation GLPConfirmOrderStoreCell

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
    
    _shopImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_shopImage];
    
    _shopLabel = [[UILabel alloc] init];
    _shopLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopLabel.font = [UIFont fontWithName:PFRMedium size:15];
    [self.contentView addSubview:_shopLabel];
    
    _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopBtn addTarget:self action:@selector(shopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shopBtn];
    
    
    [self.contentView addSubview:self.tableView];
//    _goodsView = [[GLPConfirmOrderStoreCellGoodsView alloc] init];
//    _goodsView.backgroundColor = [UIColor dc_colorWithHexString:@"#FCFCFC"];
//    [self.contentView addSubview:_goodsView];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _totalLabel.font = PFRFont(14);
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.attributedText = [self dc_attStrWithCount:@"0" price:@"0"];
    [self.contentView addSubview:_totalLabel];
    
    _payView = [[UIView alloc] init];
    _payView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_payView];
    
    _payTitleLabel = [[UILabel alloc] init];
    _payTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _payTitleLabel.font = PFRFont(17);
    _payTitleLabel.text = @"配送";
    [_payView addSubview:_payTitleLabel];
    
    _payLabel = [[UILabel alloc] init];
    _payLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _payLabel.font = PFRFont(13);
    _payLabel.text = @"24小时发货";
    _payLabel.textAlignment = NSTextAlignmentCenter;
    _payLabel.userInteractionEnabled = YES;
    [_payView addSubview:_payLabel];
    
    _sendLabel = [[UILabel alloc] init];
    _sendLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _sendLabel.font = PFRFont(13);
    _sendLabel.textAlignment = NSTextAlignmentCenter;
    _sendLabel.text = @"";
    _sendLabel.userInteractionEnabled = YES;
    [_payView addSubview:_sendLabel];

    _payRightImage = [[UIImageView alloc] init];
    _payRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_payView addSubview:_payRightImage];
    _payRightImage.hidden = YES;
    _discountView = [[UIView alloc] init];
    _discountView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_discountView];
    
    _discountTitleLabel = [[UILabel alloc] init];
    _discountTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _discountTitleLabel.font = PFRFont(17);
    _discountTitleLabel.text = @"优惠";
    [_discountView addSubview:_discountTitleLabel];
    
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.textColor = [UIColor dc_colorWithHexString:@"#F84D2A"];
    _discountLabel.font = PFRFont(15);
    _discountLabel.text = @"-¥0.00";
    _discountLabel.textAlignment = NSTextAlignmentRight;
    [_discountView addSubview:_discountLabel];
    
    _discountRightImage = [[UIImageView alloc] init];
    _discountRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_discountView addSubview:_discountRightImage];
    
    _yunfeiView = [[UIView alloc] init];
    _yunfeiView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_yunfeiView];
    
    _yunfeiTitleLabel = [[UILabel alloc] init];
    _yunfeiTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _yunfeiTitleLabel.font = PFRFont(17);
    _yunfeiTitleLabel.text = @"运费";
    [_yunfeiView addSubview:_yunfeiTitleLabel];
    
    _yunfeiLabel = [[UILabel alloc] init];
    _yunfeiLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _yunfeiLabel.font = PFRFont(15);
    _yunfeiLabel.text = @"¥0.00";
    _yunfeiLabel.textAlignment = NSTextAlignmentRight;
    [_yunfeiView addSubview:_yunfeiLabel];
    
    _qualityLabel = [[UILabel alloc] init];
    _qualityLabel.textColor = [UIColor dc_colorWithHexString:@"#818181"];
    _qualityLabel.font = PFRFont(14);
    _qualityLabel.text = @"（总重0g）";
    _qualityLabel.textAlignment = NSTextAlignmentRight;
    _qualityLabel.hidden = YES;
    [_yunfeiView addSubview:_qualityLabel];
    
    _yunfeiRightImage = [[UIImageView alloc] init];
    _yunfeiRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    _yunfeiRightImage.hidden = YES;
    [_yunfeiView addSubview:_yunfeiRightImage];
    
    _remarkView = [[UIView alloc] init];
    _remarkView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_remarkView];
    
    _remarkTitleLabel = [[UILabel alloc] init];
    _remarkTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _remarkTitleLabel.font = PFRFont(17);
    _remarkTitleLabel.text = @"订单备注";
    [_remarkView addSubview:_remarkTitleLabel];
    
    _remarkRightImage = [[UIImageView alloc] init];
    _remarkRightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [_remarkView addSubview:_remarkRightImage];
    
    _remarkTF = [[DCTextField alloc] init];
    _remarkTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"如有特殊要求，请在此处填写"];
    _remarkTF.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _remarkTF.font = PFRFont(15);
    _remarkTF.textAlignment = NSTextAlignmentRight;
    [_remarkTF addTarget:self action:@selector(remarkTFValueChange:) forControlEvents:UIControlEventEditingChanged];
    [_remarkView addSubview:_remarkTF];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line2];
    
    _line3 = [[UIImageView alloc] init];
    _line3.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line3];
    
    _line4 = [[UIImageView alloc] init];
    _line4.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line4];
    
    _line5 = [[UIImageView alloc] init];
    _line5.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line5];
    
    _line6 = [[UIImageView alloc] init];
    _line6.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line6];
    
//    _goodsView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [_goodsView addGestureRecognizer:tap];
    
    _discountView.userInteractionEnabled = YES;
    UITapGestureRecognizer *discountTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountTapAction:)];
    [_discountView addGestureRecognizer:discountTap];
    
//    [self layoutIfNeeded];
}

#pragma mark - action
- (void)tapAction:(id)sender{
    !_clickGoodsView_Block ? : _clickGoodsView_Block();
}

- (void)discountTapAction:(id)sender{
    !_clickMoreTicketView_Block ? : _clickMoreTicketView_Block();
}

- (void)shopBtnClick:(id)sender{
    !_clickShopBtnBlock_Block ? : _clickShopBtnBlock_Block();
}

#pragma mark - 值改变
- (void)remarkTFValueChange:(UITextField *)textField
{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        !_GLPConfirmOrderStoreCell_block ? : _GLPConfirmOrderStoreCell_block(textField.text);
    }else { //有高亮文字
        //do nothing
    }
}

#pragma mark - 富文本
- (NSMutableAttributedString *)dc_attStrWithCount:(NSString *)count price:(NSString *)price
{
    NSString *text = [NSString stringWithFormat:@"共计%@件商品 合计：¥%@",count,price];
    NSString *floStr;
    NSString *intStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        intStr = [text substringToIndex:range.location];//前
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];

    NSRange range1 = [text rangeOfString:intStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:range1];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:14],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#E71313"]} range:NSMakeRange(2, count.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(count.length+9, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:16],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(count.length+10, attrStr.length - count.length-10)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}


#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_shopImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(18);
        make.top.equalTo(self.contentView.top).offset(15);
        make.size.equalTo(CGSizeMake(34, 28));
    }];
    
    [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopImage.right).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.shopImage.centerY);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.shopImage.bottom).offset(15);
        make.height.equalTo(1);
    }];
    
    [_shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.line1.top);
    }];

    CGFloat tableViewH = self.goodsArray.count*Item_H+self.KSectionHeight;
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line1.bottom);
        make.height.equalTo(tableViewH);
    }];
    
//    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.left);
//        make.right.equalTo(self.contentView.right);
//        make.top.equalTo(self.line1.bottom);
//        make.height.equalTo(93);
//    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line2.right);
        make.top.equalTo(self.tableView.bottom);
        make.height.equalTo(self.line1.height);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.line2.bottom);
        make.height.equalTo(44);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line2.right);
        make.height.equalTo(self.line1.height);
        make.top.equalTo(self.totalLabel.bottom);
    }];
    
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line3.bottom);
        make.height.equalTo(56);
    }];
    
    [_payTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payView.centerY);
        make.left.equalTo(self.payView.left).offset(15);
    }];
    
    [_payRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payView.centerY);
        make.right.equalTo(self.payView.right).offset(-15);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payView.centerY);
        make.right.equalTo(self.payRightImage.left).offset(-10);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payView.centerY);
        make.right.equalTo(self.sendLabel.left).offset(15);
    }];
    
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line2.right);
        make.height.equalTo(self.line1.height);
        make.top.equalTo(self.payView.bottom);
    }];
    
    [_discountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line4.bottom);
        make.height.equalTo(56);
    }];
    
    [_discountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountView.left).offset(15);
        make.centerY.equalTo(self.discountView.centerY);
    }];
    
    [_discountRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountView.centerY);
        make.right.equalTo(self.discountView.right).offset(-15);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountView.centerY);
        make.right.equalTo(self.discountRightImage.left).offset(-10);
    }];
    
    [_line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line2.right);
        make.height.equalTo(self.line1.height);
        make.top.equalTo(self.discountView.bottom);
    }];
    
    [_yunfeiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line5.bottom);
        make.height.equalTo(56);
    }];
    
    [_yunfeiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yunfeiView.left).offset(15);
        make.centerY.equalTo(self.yunfeiView.centerY);
    }];
    
    [_qualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yunfeiTitleLabel.right).offset(5);
        make.centerY.equalTo(self.yunfeiView.centerY);
    }];
    
    [_yunfeiRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yunfeiView.right).offset(-15);
        make.centerY.equalTo(self.yunfeiView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_yunfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yunfeiRightImage.right).offset(-0);
        make.centerY.equalTo(self.yunfeiView.centerY);
    }];
    
    [_line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.left);
        make.right.equalTo(self.line2.right);
        make.height.equalTo(self.line1.height);
        make.top.equalTo(self.yunfeiView.bottom);
    }];
    
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line6.bottom);
        make.height.equalTo(56);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_remarkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remarkView.left).offset(15);
        make.centerY.equalTo(self.remarkView.centerY);
        make.width.equalTo(100);
    }];
    
    [_remarkRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.remarkView.right).offset(-15);
        make.centerY.equalTo(self.remarkView.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_remarkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.remarkRightImage.left).offset(-10);
        make.left.equalTo(self.remarkTitleLabel.right);
        make.top.equalTo(self.remarkView.top);
        make.bottom.equalTo(self.remarkView.bottom);
    }];
}


#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Item_H;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLPConfirmGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:GLPConfirmGoodsListCellID forIndexPath:indexPath];
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
            self.KSectionHeight = KSection_H;
            return self.KSectionHeight;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    GLPNewShopCarGoodsModel *model = self.dataArray[indexPath.section];
    //!self.OrderGoodsInfoIndexCell_block ? : self.OrderGoodsInfoIndexCell_block(model);
}

#pragma mark - setter
- (void)setFirmModel:(GLPFirmListModel *)firmModel
{
    _firmModel = firmModel;
    self.KSectionHeight = 0;
    
    if (_firmModel.deliveryTime.length != 0) {
        _payLabel.text = _firmModel.deliveryTime;
    }
    
    [_shopImage sd_setImageWithURL:[NSURL URLWithString:_firmModel.mallLogo] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _shopLabel.text = _firmModel.mallName;
    
//    _goodsView.firmModel = _firmModel;
    
//    __block CGFloat allPrice = 0; // 总价格
    NSMutableArray *goodsArray = [NSMutableArray array];
    [firmModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *actModel, NSUInteger idx21, BOOL * _Nonnull stop21) {

        [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx3, BOOL * _Nonnull stop3) {
            [goodsArray addObject:goodsModel];
            
//            CGFloat price = 0; // 单个活动全部商品价格
//            // 累加 单件商品价格
//            price += [goodsModel.sellPrice floatValue] * [goodsModel.quantity floatValue];
//            // 判断是否满足满减规则  满足就减去优惠价格
//            if (price > 0 && price > [actModel.requireAmount floatValue]) {
//                price -= [actModel.discountAmount floatValue];
//            }
//            // 累加活动价格
//            allPrice += price;
        }];
    }];
    
    [firmModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
        [goodsArray addObject:goodsModel];
        
//        CGFloat price = 0; // 单个活动全部商品价格
//        // 累加 单件商品价格
//        price += [goodsModel.sellPrice floatValue] * [goodsModel.quantity floatValue];
//        // 累加活动价格
//        allPrice += price;
    }];

    _totalLabel.attributedText = [self dc_attStrWithCount:[NSString stringWithFormat:@"%ld",goodsArray.count] price:[NSString stringWithFormat:@"%@",_firmModel.shopTotalPrice]];
    
    _yunfeiLabel.text = [NSString stringWithFormat:@"¥%.2f",_firmModel.yufei];
    _yunfeiLabel = [UILabel setupAttributeLabel:_yunfeiLabel textColor:_yunfeiLabel.textColor minFont:[UIFont fontWithName:PFR size:13] maxFont:[UIFont fontWithName:PFRMedium size:15] forReplace:@"¥"];
    
    
    _discountLabel.text = @"-¥0.00";
    __block CGFloat discountAmount = 0.00;
    [firmModel.defaultCoupon enumerateObjectsUsingBlock:^(GLPCouponListModel *couponModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
        discountAmount += [couponModel.discountAmount floatValue];
    }];
    
    _discountLabel.text = [NSString stringWithFormat:@"-¥%.2f",discountAmount];
    
    _discountLabel = [UILabel setupAttributeLabel:_discountLabel textColor:_discountLabel.textColor minFont:[UIFont fontWithName:PFR size:13] maxFont:[UIFont fontWithName:PFRMedium size:15] forReplace:@"¥"];
    
    self.goodsArray = [goodsArray mutableCopy];
    
    //WEAKSELF;
    [self.dataArray removeAllObjects];
    [_firmModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *actModel, NSUInteger idx21, BOOL * _Nonnull stop21) {
        [self.dataArray addObject:@[actModel]];
    }];
    [self.dataArray addObject:_firmModel.cartGoodsList];
    
    [self.tableView reloadData];
    [self layoutIfNeeded];
}


#pragma mark - LazyLoad -
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionHeaderHeight = 0.01f;
        _tableView.sectionFooterHeight = 0.01f;
        _tableView.userInteractionEnabled = NO;
        _tableView.scrollEnabled = NO;
        _tableView.estimatedRowHeight = Item_H;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
        [_tableView registerNib:[UINib nibWithNibName:@"GLPConfirmGoodsListCell" bundle:nil] forCellReuseIdentifier:GLPConfirmGoodsListCellID];
        [_tableView registerClass:NSClassFromString(GLPConfirmOrderHeaderViewID) forHeaderFooterViewReuseIdentifier:GLPConfirmOrderHeaderViewID];

    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end



#pragma mark - 商品
@interface GLPConfirmOrderStoreCellGoodsView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *rightImage;

@end

@implementation GLPConfirmOrderStoreCellGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _rightImage = [[UIImageView alloc] init];
    _rightImage.image = [UIImage imageNamed:@"dc_arrow_right_cuhei"];
    [self addSubview:_rightImage];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#898989"];
    _countLabel.font = PFRFont(14);
    _countLabel.text = @"共0件";
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_countLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-15);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.rightImage.left).offset(-8);
        make.width.equalTo(90);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(self.countLabel.left);
        make.height.equalTo(54);
    }];
}


#pragma mark - setter
- (void)setFirmModel:(GLPFirmListModel *)firmModel
{
    _firmModel = firmModel;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //WEAKSELF;
    [firmModel.actInfoList enumerateObjectsUsingBlock:^(ActInfoListModel *actModel, NSUInteger idx21, BOOL * _Nonnull stop21) {

        [actModel.actGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx3, BOOL * _Nonnull stop3) {
            [dataArray addObject:goodsModel.goodsImg];
        }];
    }];
    
    [firmModel.cartGoodsList enumerateObjectsUsingBlock:^(GLPNewShopCarGoodsModel *goodsModel, NSUInteger idx22, BOOL * _Nonnull stop22) {
        [dataArray addObject:goodsModel.goodsImg];
    }];

    for (id class in self.scrollView.subviews) {
        [class removeFromSuperview];
    }
    
    for (int i=0; i<dataArray.count; i++) {
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [self.scrollView addSubview:image];
        
        CGFloat x = (54+10)*i;
        
        [image mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView.centerY);
            make.left.equalTo(self.scrollView.left).offset(x);
            make.size.equalTo(CGSizeMake(54, 54));
        }];
        
        [image sd_setImageWithURL:[NSURL URLWithString:dataArray[i]] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"共%ld件",dataArray.count];
}

@end
