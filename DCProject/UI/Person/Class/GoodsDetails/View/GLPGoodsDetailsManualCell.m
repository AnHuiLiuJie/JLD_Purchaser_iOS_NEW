//
//  GLPGoodsDetailsManualCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/2.
//

#import "GLPGoodsDetailsManualCell.h"

@interface GLPGoodsDetailsManualCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) DescribeInfoView *leftView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) DescribeInfoView *rightView;


@property (nonatomic, strong) UIButton *moreBtn;

@end

static CGFloat cell_spacing_x = 10;
static CGFloat cell_spacing_y = 5;

@implementation GLPGoodsDetailsManualCell
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
    //_bgView.bounds = CGRectMake(0, 0, kScreenW-cell_spacing_x*2, cell_spacing_h);
    [self.contentView addSubview:_bgView];
    [_bgView dc_cornerRadius:cell_spacing_x];
    
    _lineView = [[UIView alloc] init];
    //_lineView.backgroundColor = [UIColor dc_colorWithHexString:@"#DBFFFD"];
    [_bgView addSubview:_lineView];
    NSArray *clolor2 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#DBFFFD"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    [gradientLayer2 setColors:clolor2];//渐变数组
    gradientLayer2.startPoint = CGPointMake(0,0);
    gradientLayer2.endPoint = CGPointMake(1,1);
    gradientLayer2.locations = @[@(0),@(1.0)];//渐变点
    gradientLayer2.frame = CGRectMake(0,0,5,20);
    [_lineView.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
    [_lineView dc_cornerRadius:1];

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLab.text = @"药品说明";
    [_bgView addSubview:_titleLab];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"dc_cell_more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_moreBtn];
    
    _leftView = [[DescribeInfoView alloc] init];
    [_bgView addSubview:_leftView];
    
    _middleView = [[UIView alloc] init];
    _middleView.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_middleView];
    
    _rightView = [[DescribeInfoView alloc] init];
    [_bgView addSubview:_rightView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(5);
        make.size.equalTo(CGSizeMake(5, 20));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.right).offset(10);
        make.centerY.equalTo(self.lineView.centerY);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-5);
        make.centerY.equalTo(self.lineView);
        make.size.equalTo(CGSizeMake(35, 35));
    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.lineView.bottom).offset(20);
        make.width.equalTo(1);
        make.bottom.equalTo(self.leftView.bottom).offset(-10);
    }];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.middleView.top).offset(-10);
        make.bottom.equalTo(self.bgView);
        make.right.equalTo(self.middleView.left).offset(10);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView.right).offset(10);
        make.right.equalTo(self.bgView.right);
        make.centerY.equalTo(self.leftView.centerY);
        make.height.equalTo(self.leftView);
    }];
}

#pragma mark - action
- (void)moreAction:(UIButton *)button{
    !_GLPGoodsDetailsManualCell_block ? : _GLPGoodsDetailsManualCell_block();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


#pragma ##############################################

@interface DescribeInfoView ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation DescribeInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _iconImg = [[UIImageView alloc] init];
    _iconImg.image = [UIImage imageNamed:@"sz_zhaq"];
    [self addSubview:_iconImg];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFR size:13];
    _titleLabel.text = @"功能主治";
    [self addSubview:_titleLabel];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.textColor = [UIColor dc_colorWithHexString:@"#9E5E0B"];
    _contentLab.font = PFRFont(10);
    _contentLab.text = @"风热感冒,咽炎 ,偏桃体炎,目痛,牙痛及痈肿,牙痛,感冒";
    _contentLab.numberOfLines = 0;
    [self addSubview:_contentLab];
    
    [self layoutIfNeeded];
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(5);
        make.top.equalTo(self.top).offset(5);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.right).offset(5);
        make.centerY.equalTo(self.iconImg.centerY);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.left);
        make.right.equalTo(self.right).offset(-15);
        make.top.equalTo(self.iconImg.bottom).offset(5);
        make.bottom.equalTo(self).offset(-10);
    }];

}


#pragma mark - setter

@end
