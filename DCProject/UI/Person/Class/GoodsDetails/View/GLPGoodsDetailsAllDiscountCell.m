//
//  GLPGoodsDetailsAllDiscountCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/18.
//

#import "GLPGoodsDetailsAllDiscountCell.h"

@interface GLPGoodsDetailsAllDiscountCell ()

/*背景View*/
@property (nonatomic, strong) UIView *bgView;
/**/
@property (nonatomic, strong) UILabel *titleLab;
/*功能*/
@property (nonatomic, strong) UIButton *functionBtn;

@end

static CGFloat cell_spacing_x = 5;
static CGFloat cell_spacing_y = 3;
static CGFloat cell_spacing_h = 44;

@implementation GLPGoodsDetailsAllDiscountCell
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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFF4DE"];
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#9E5E0B"];
    _titleLab.font = [UIFont fontWithName:PFR size:12];
    _titleLab.text = @"¥0.00";
    [_bgView addSubview:_titleLab];
    
    _functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_functionBtn setTitle:@" 更多 " forState:0];
    [_functionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _functionBtn.titleLabel.font = PFRFont(11);
    [_functionBtn setBackgroundImage:[UIImage imageNamed:@"dc_moreBtn_bg"] forState:UIControlStateNormal];
    [_functionBtn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_functionBtn];
}

#pragma mark - Setter Getter Methods
- (void)setShowType:(NSInteger)showType{
    _showType = showType;
}

- (void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    
    if (_showType == 0) {
        _titleLab.text = _detailModel.mixTips;
        [_functionBtn setTitle:@"  查看  " forState:0];
    }else if (_showType == 11 || _showType == 1) {
        [_functionBtn setTitle:@" 立即领取 " forState:0];
        _titleLab.text = _detailModel.couponTips;
    }else if (_showType == 12 || _showType == 2) {
        [_functionBtn setTitle:@"  更多  " forState:0];
        _titleLab.text = _detailModel.fullMinusTips;
    }
}


#pragma mark - action
- (void)functionBtnClick:(UIButton *)button{//立即领取。更多。查看
    NSString *str = [_functionBtn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    !_GLPGoodsDetailsAllDiscountCell_block ? : _GLPGoodsDetailsAllDiscountCell_block(str);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.centerY.equalTo(self.bgView.centerY);
    }];
    
    [_functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.bgView.centerY);
        make.height.equalTo(24);
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
