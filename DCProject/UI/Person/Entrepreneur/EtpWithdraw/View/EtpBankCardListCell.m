//
//  EtpBankCardListCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/14.
//

#import "EtpBankCardListCell.h"

@interface EtpBankCardListCell ()

@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *bankNaneLab;
@property (nonatomic, strong) UILabel *cardNumLab;

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIImageView *cardImg;
@property (nonatomic, strong) UIButton *editBtn;


@end

@implementation EtpBankCardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    [self.contentView addSubview:_bgView];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectedBtn.backgroundColor = [UIColor clearColor];
    [_selectedBtn setImage:[UIImage imageNamed:@"dc_gx_no"] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"dc_gx_yes"] forState:UIControlStateSelected];
    _selectedBtn.selected = NO;
    [_bgView addSubview:_selectedBtn];
    
    _cardImg = [[UIImageView alloc] init];
    [_cardImg setImage:[UIImage imageNamed:@"etp_center_card"]];
    [_bgView addSubview:_cardImg];
    
    _bankNaneLab = [[UILabel alloc] init];
    _bankNaneLab.text = @"银行名称";
    _bankNaneLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _bankNaneLab.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_bankNaneLab];
    
    _cardNumLab = [[UILabel alloc] init];
    _cardNumLab.text = @"尾号****";
    _cardNumLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _cardNumLab.font = [UIFont fontWithName:PFR size:13];
    [_bgView addSubview:_cardNumLab];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.backgroundColor = [UIColor clearColor];
    [_editBtn setImage:[UIImage imageNamed:@"dc_eidt_hui"] forState:UIControlStateNormal];
    [_bgView addSubview:_editBtn];
}

- (void)selectedBtnAction:(UIButton *)button{
//    button.selected = YES;
//    _model.isSlected = YES;
    !_slectedBtnClick_block ? : _slectedBtnClick_block(button);
}

- (void)editBtnAction:(UIButton *)button{
    !_editBtnClick_block ? : _editBtnClick_block();
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 5, 15));
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(8);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedBtn.right).offset(10);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(42, 27));
    }];
    
    [_bankNaneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardImg.right).offset(10);
        make.centerY.equalTo(self.bgView).offset(-10);
        make.right.equalTo(self.bgView.right).offset(-30);
    }];
    
    [_cardNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNaneLab.left);
        make.top.equalTo(self.bankNaneLab.bottom);
        make.right.equalTo(self.bgView.right).offset(-30);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-12);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(12*2, 13*2));
    }];
}

#pragma mark - set model
- (void)setModel:(EtpBankCardListModel *)model{
    _model = model;
    
    _bankNaneLab.text = _model.bankName;
    
    if (_model.bankAccount.length > 4) {
        _cardNumLab.text = [NSString stringWithFormat:@"%@ **** %@",[_model.bankAccount substringToIndex:4],[_model.bankAccount substringFromIndex:_model.bankAccount.length-4]];
    }
    BOOL isSelected = NO;
    if ([_model.isDefault isEqualToString:@"1"]) {
        isSelected = YES;
    }
    _selectedBtn.selected = isSelected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
