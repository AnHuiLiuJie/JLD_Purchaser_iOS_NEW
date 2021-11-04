//
//  GLPBankCardManageListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "GLPBankCardManageListCell.h"
 
@interface GLPBankCardManageListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *editBtn;

@end


@implementation GLPBankCardManageListCell

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
    _iconImg.backgroundColor = [UIColor whiteColor];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_iconImg];
    [_iconImg dc_cornerRadius:2];
    [_iconImg setImage:[UIImage imageNamed:@"etp_center_card"]];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont fontWithName:PFR size:14];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [_bgView addSubview:_titleLab];
    _titleLab.text = @"8888 **** 8888 （信用卡）";
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_editBtn];
    [_editBtn setImage:[UIImage imageNamed:@"dc_cell_more"] forState:UIControlStateNormal];
    _editBtn.selected = NO;
    [_editBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - set
- (void)setModel:(GLPBankCardListModel *)model{
    _model = model;
    NSString *cardType = @"借记卡";
    if ([model.accType isEqualToString:@"C"]) {
        cardType = @"信用卡";
    }
    
    if (_model.accNo.length > 4) {
        _titleLab.text = [NSString stringWithFormat:@"%@ **** %@ （%@）",[_model.accNo substringToIndex:4],[_model.accNo substringFromIndex:_model.accNo.length-4],cardType];
    }
    
}

#pragma mark - private method
- (void)selectedAction:(UIButton *)button{
    !_GLPBankCardManageListCell_block ? : _GLPBankCardManageListCell_block();
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        //make.height.equalTo(60).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.left.equalTo(self.bgView.left).offset(15);
        make.size.equalTo(CGSizeMake(45, 35));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImg.centerY);
        make.left.equalTo(self.iconImg.right).offset(10);
    }];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.right.equalTo(self.bgView.right).offset(-10);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
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
