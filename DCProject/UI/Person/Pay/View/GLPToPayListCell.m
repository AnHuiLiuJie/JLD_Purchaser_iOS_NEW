//
//  GLPToPayListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import "GLPToPayListCell.h"


@interface GLPToPayListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;

@end


@implementation GLPToPayListCell

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
    [self.contentView addSubview:_bgView];
    
    _iconImg = [[UIImageView alloc] init];
    _iconImg.contentMode = UIViewContentModeScaleAspectFit;
    [_bgView addSubview:_iconImg];
    [_iconImg dc_cornerRadius:2];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont fontWithName:PFR size:14];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [_bgView addSubview:_titleLab];
    _titleLab.text = @"微信支付";
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_selectedBtn];
    [_selectedBtn setImage:[UIImage imageNamed:@"dc_select_no"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"dc_select_yes"] forState:UIControlStateSelected];
    _selectedBtn.selected = NO;
    [_selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(50).priorityHigh();
    }];
    
    if([_model.titleName isEqualToString:@"绑定银行卡"]){
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView.centerY);
            make.left.equalTo(self.bgView.left).offset(12);
            make.size.equalTo(CGSizeMake(31, 31));
        }];
    }else{
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView.centerY);
            make.left.equalTo(self.bgView.left).offset(10);
            make.size.equalTo(CGSizeMake(35, 35));
        }];
    }

    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImg.centerY);
        make.left.equalTo(self.iconImg.right).offset(10);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.right.equalTo(self.bgView.right).offset(-5);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
}

#pragma mark - action
- (void)selectedAction:(UIButton *)btn{
    !_GLPToPayListCell_block ? : _GLPToPayListCell_block(self.model);
}

#pragma mark - set
- (void)setShowType:(NSInteger)showType{
    _showType = showType;
}

- (void)setModel:(GLPBankCardListModel *)model{
    _model = model;
    
    _iconImg.backgroundColor = [UIColor whiteColor];
    if ([_model.titleName isEqualToString:@"支付宝支付"]) {
        [_iconImg setImage:[UIImage imageNamed:@"dc_pay_zhifubao"]];
        _titleLab.text = _model.titleName;
        //_selectedBtn.selected = YES;
    }else if([_model.titleName isEqualToString:@"微信支付"]){
        [_iconImg setImage:[UIImage imageNamed:@"dc_pay_wechat"]];
        _titleLab.text = _model.titleName;
    }else if([_model.titleName isEqualToString:@"绑定银行卡"]){
        [_selectedBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:UIControlStateSelected];
        [_iconImg setImage:[UIImage imageNamed:@"icon_pay_bankcard"]];
        _titleLab.text = _model.titleName;
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"dc_select_no"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"dc_select_yes"] forState:UIControlStateSelected];
        [_iconImg setImage:[UIImage imageNamed:@"icon_pay_bankcard_list"]];
        NSString *cardType = @"借记卡";
        if ([_model.accType isEqualToString:@"C"]) {
            cardType = @"信用卡";
        }
        if (_model.accNo.length > 4) {
            _titleLab.text = [NSString stringWithFormat:@"%@ **** %@ （%@）",[_model.accNo substringToIndex:4],[_model.accNo substringFromIndex:_model.accNo.length-4],cardType];
        }
    }
    [self layoutIfNeeded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
