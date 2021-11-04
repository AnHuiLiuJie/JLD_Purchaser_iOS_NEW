//
//  CustomerSourceListCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "CustomerSourceListCell.h"

@interface CustomerSourceListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *accountLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *feeLab;


@end

@implementation CustomerSourceListCell

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
    _bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgView];
    
    _accountLab = [[UILabel alloc] init];
    _accountLab.text = @"138****5678";
    _accountLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _accountLab.font = [UIFont fontWithName:PFRMedium size:12];
    _accountLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_accountLab];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"2021-04-04";
    _timeLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _timeLab.font = [UIFont fontWithName:PFRMedium size:12];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_timeLab];
    
    _feeLab = [[UILabel alloc] init];
    _feeLab.text = @"***.**";
    _feeLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _feeLab.font = [UIFont fontWithName:PFRMedium size:12];
    _feeLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_feeLab];

}

#pragma mark - set
- (void)setModel:(CustomerSourceListModel *)model{
    _model = model;
    
    _accountLab.text = _model.loginName;
    
    _timeLab.text = _model.createTime;
    
    _feeLab.text = [NSString stringWithFormat:@"%@",_model.totalServiceFee];
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat view_w = self.dc_width/3;
    CGFloat view_h = self.dc_height;

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(0);
        make.size.equalTo(CGSizeMake(view_w, view_h));
    }];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountLab.right);
        make.centerY.equalTo(self.accountLab);
        make.size.equalTo(self.accountLab);
    }];

    [self.feeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab.right);
        make.centerY.equalTo(self.accountLab);
        make.size.equalTo(self.accountLab);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
