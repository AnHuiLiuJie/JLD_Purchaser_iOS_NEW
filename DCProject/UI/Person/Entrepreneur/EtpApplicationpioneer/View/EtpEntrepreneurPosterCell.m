//
//  EtpEntrepreneurPosterCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import "EtpEntrepreneurPosterCell.h"

@interface EtpEntrepreneurPosterCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *applicationBtn;
@property (nonatomic, strong) UIButton *descriptionBtn;


@end


@implementation EtpEntrepreneurPosterCell

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
    [self.contentView addSubview:_bgView];
    
    _bgImage = [[UIImageView alloc] init];
    [_bgImage setImage:[UIImage imageNamed:@"etp_yq_bg"]];
    [_bgView addSubview:_bgImage];
    
    _applicationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_applicationBtn addTarget:self action:@selector(applicationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_applicationBtn setImage:[UIImage imageNamed:@"etp_yq_yq"] forState:UIControlStateNormal];
    _applicationBtn.backgroundColor = [UIColor clearColor];
    _applicationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _applicationBtn.bounds = CGRectMake(0, 0, kScreenW/2, 50);
    [DCSpeedy dc_changeControlCircularWith:_applicationBtn AndSetCornerRadius:_applicationBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    [self.bgView addSubview:_applicationBtn];
    
    _descriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_descriptionBtn addTarget:self action:@selector(descriptionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _descriptionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _descriptionBtn.titleLabel.font = [UIFont fontWithName:PFR size:14];
    [_descriptionBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [_descriptionBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _descriptionBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#7c88fb"];
    [_bgView addSubview:_descriptionBtn];
        
}

#pragma mark - 说明
- (void)descriptionBtnAction:(UIButton *)button
{
    !_etpEntrepreneurPosterCellClick_block ? : _etpEntrepreneurPosterCellClick_block(1);
}

#pragma mark - 申请
- (void)applicationBtnAction:(UIButton *)button
{
    !_etpEntrepreneurPosterCellClick_block ? : _etpEntrepreneurPosterCellClick_block(2);

}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, -1, 0, 0));;
    }];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    [_applicationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.bottom).offset(-30);
        make.centerX.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(kScreenW/2, 45));
    }];
    
    [_descriptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView.right);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_descriptionBtn byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft size:CGSizeMake(_descriptionBtn.dc_height/2, _descriptionBtn.dc_height/2)];

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
