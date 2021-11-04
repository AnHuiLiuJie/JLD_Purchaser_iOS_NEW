//
//  GLPPaymentManageListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/13.
//

#import "GLPPaymentManageListCell.h"

@interface GLPPaymentManageListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *line;

@end


@implementation GLPPaymentManageListCell

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
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_iconImg];
    [_iconImg dc_cornerRadius:2];
    //[_iconImg setImage:[UIImage imageNamed:@"dd_wxzf"]];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont fontWithName:PFR size:14];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    [_bgView addSubview:_titleLab];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_selectedBtn];
    [_selectedBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:UIControlStateNormal];
    _selectedBtn.selected = NO;
    [_selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectedBtn.enabled = NO;
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_line];
}

#pragma mark - private method
- (void)selectedAction:(UIButton *)button{
    !_GLPPaymentManageListCell_block ? : _GLPPaymentManageListCell_block(1);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(60).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.left.equalTo(self.bgView.left).offset(0);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImg.centerY);
        make.left.equalTo(self.iconImg.right).offset(10);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.centerY);
        make.right.equalTo(self.bgView.right).offset(-5);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.height.equalTo(1);
    }];
}

#pragma mark - set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    
    _titleLab.text = _titleStr;
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
