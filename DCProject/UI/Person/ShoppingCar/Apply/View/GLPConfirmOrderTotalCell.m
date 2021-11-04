//
//  GLPConfirmOrderTotalCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPConfirmOrderTotalCell.h"

@interface GLPConfirmOrderTotalCell ()

@property (nonatomic, strong) UIView *goodsView;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *goodsTotalLabel;
@property (nonatomic, strong) UIView *yunfeiView;
@property (nonatomic, strong) UILabel *yunfeiTitleLabel;
@property (nonatomic, strong) UILabel *qualityLabel;
@property (nonatomic, strong) UILabel *yunfeiLabel;
@property (nonatomic, strong) UIView *discountView;
@property (nonatomic, strong) UILabel *discountTitleLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) UILabel *totalTitleLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIImageView *line2;
@property (nonatomic, strong) UIImageView *line3;

@end

@implementation GLPConfirmOrderTotalCell

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
    
    _goodsView = [[UIView alloc] init];
    _goodsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_goodsView];
    
    _goodsTitleLabel = [[UILabel alloc] init];
    _goodsTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _goodsTitleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _goodsTitleLabel.text = @"商品总金额";
    [_goodsView addSubview:_goodsTitleLabel];
    
    _goodsTotalLabel = [[UILabel alloc] init];
    _goodsTotalLabel.textColor = [UIColor dc_colorWithHexString:@"#F84D2A"];
    _goodsTotalLabel.font = PFRFont(15);
    _goodsTotalLabel.text = @"¥0.00";
    _goodsTotalLabel.textAlignment = NSTextAlignmentRight;
    [_goodsView addSubview:_goodsTotalLabel];
    

    _yunfeiView = [[UIView alloc] init];
    _yunfeiView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_yunfeiView];
    
    _yunfeiTitleLabel = [[UILabel alloc] init];
    _yunfeiTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _yunfeiTitleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _yunfeiTitleLabel.text = @"总运费";
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
    _qualityLabel.hidden = YES;
    [_yunfeiView addSubview:_qualityLabel];
    
    _discountView = [[UIView alloc] init];
    _discountView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_discountView];
    
    _discountTitleLabel = [[UILabel alloc] init];
    _discountTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _discountTitleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _discountTitleLabel.text = @"总优惠";
    [_discountView addSubview:_discountTitleLabel];
    
    _discountLabel = [[UILabel alloc] init];
    _discountLabel.textColor = [UIColor dc_colorWithHexString:@"#F84D2A"];
    _discountLabel.font = PFRFont(17);
    _discountLabel.text = @"-¥0.00";
    _discountLabel.textAlignment = NSTextAlignmentRight;
    [_discountView addSubview:_discountLabel];
    
    _totalView = [[UIView alloc] init];
    _totalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_totalView];
    
    _totalTitleLabel = [[UILabel alloc] init];
    _totalTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _totalTitleLabel.font = [UIFont fontWithName:PFRMedium size:17];
    _totalTitleLabel.text = @"总合计";
    [_totalView addSubview:_totalTitleLabel];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.textColor = [UIColor dc_colorWithHexString:@"#F84D2A"];
    _totalLabel.font = PFRFont(15);
    _totalLabel.text = @"¥0.00";
    _totalLabel.textAlignment = NSTextAlignmentRight;
    [_totalView addSubview:_totalLabel];
    
    _line1 = [[UIImageView alloc] init];
    _line1.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line1];
    
    _line2 = [[UIImageView alloc] init];
    _line2.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line2];
    
    _line3 = [[UIImageView alloc] init];
    _line3.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line3];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(56);
    }];
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsView.left).offset(15);
        make.centerY.equalTo(self.goodsView.centerY);
    }];
    
    [_goodsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goodsView.right).offset(-15);
        make.centerY.equalTo(self.goodsView.centerY);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.goodsView.bottom).offset(0);
        make.height.equalTo(1);
    }];
    
    [_yunfeiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line1.bottom);
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
    
    [_yunfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.yunfeiView.right).offset(-15);
        make.centerY.equalTo(self.yunfeiView.centerY);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.yunfeiView.bottom).offset(0);
        make.height.equalTo(1);
    }];
    
    [_discountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line2.bottom);
        make.height.equalTo(56);
    }];
    
    [_discountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountView.left).offset(15);
        make.centerY.equalTo(self.discountView.centerY);
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountView.centerY);
        make.right.equalTo(self.discountView.right).offset(-15);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.discountView.bottom).offset(0);
        make.height.equalTo(1);
    }];
    
    [_totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line3.bottom);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(56);
    }];
    
    [_totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalView.left).offset(15);
        make.centerY.equalTo(self.totalView.centerY);
    }];
    
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalView.centerY);
        make.right.equalTo(self.totalView.right).offset(-15);
    }];
}


#pragma mark - set
-(void)setModel:(GLPNewShoppingCarModel *)model{
    _model = model;
    
    __block CGFloat allYunfei = 0;
    CGFloat allDiscount = [_model.orderCouponsDiscount floatValue];
    CGFloat allPrice = [_model.orderTotalPrice floatValue];
    [_model.firmList enumerateObjectsUsingBlock:^(GLPFirmListModel *  _Nonnull firmModel, NSUInteger idx, BOOL * _Nonnull stop) {
        allYunfei += firmModel.yufei;
    }];
    
    _goodsTotalLabel.text = [NSString stringWithFormat:@"¥%@",_model.orderTotalPrice];
    _goodsTotalLabel = [UILabel setupAttributeLabel:_goodsTotalLabel textColor:_goodsTotalLabel.textColor minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    
    _yunfeiLabel.text = [NSString stringWithFormat:@"¥%.2f",allYunfei];
    _yunfeiLabel = [UILabel setupAttributeLabel:_yunfeiLabel textColor:_yunfeiLabel.textColor minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    
    _discountLabel.text = [NSString stringWithFormat:@"-¥%.2f",[_model.orderCouponsDiscount floatValue]];
    _discountLabel = [UILabel setupAttributeLabel:_discountLabel textColor:_discountLabel.textColor minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
    
    _totalLabel.text = [NSString stringWithFormat:@"¥%.2f",allPrice-allDiscount+allYunfei];
    _totalLabel = [UILabel setupAttributeLabel:_totalLabel textColor:_totalLabel.textColor minFont:[UIFont fontWithName:PFR size:14] maxFont:[UIFont fontWithName:PFRMedium size:17] forReplace:@"¥"];
}


@end
