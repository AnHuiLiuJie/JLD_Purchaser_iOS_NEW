//
//  EtpPioneerWebHeaderView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpPioneerWebHeaderView.h"
@interface EtpPioneerWebHeaderView ()

@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UILabel *authorLab;
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation EtpPioneerWebHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"首届百强医院优秀健康科普作品展播总结大 会暨百强医院宣传工作高峰论坛在京召开， 为进一步落实全国卫生与健康大会。";
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.numberOfLines = 0;
    _titleLab.font = [UIFont fontWithName:PFRMedium size:14];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLab];
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topBtn setTitle:@"置顶" forState:UIControlStateNormal];
    [_topBtn setTitleColor:[UIColor dc_colorWithHexString:DC_AppThemeColor] forState:UIControlStateNormal];
    _topBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _topBtn.titleLabel.font = [UIFont fontWithName:PFR size:11];
    [_bgView addSubview:_topBtn];
    
    _authorLab = [[UILabel alloc] init];
    _authorLab.text = @"作者名";
    _authorLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _authorLab.font = [UIFont fontWithName:PFR size:11];
    _authorLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_authorLab];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"2021-04-01";
    _timeLab.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _timeLab.font = [UIFont fontWithName:PFR size:11];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_timeLab];
}

#pragma mark - 置顶
- (void)submitBtnAction:(UIButton *)button{
}

#pragma mark - set
- (void)setModel:(PioneerCollegeListModel *)model{
    _model = model;
    
    _titleLab.text = _model.newsTitle;

    CGFloat author_w = 0;
    if (_model.author.length  == 0) {
        _authorLab.text = @"";
    }else{
        _authorLab.text = _model.author;
        author_w = 80;
    }

    CGFloat topBtn_w = 0;
    if ([_model.isTop isEqual:@"1"]) {
        _topBtn.hidden = NO;
        topBtn_w = 40;
    }else{
        _topBtn.hidden = YES;
    }

    [_topBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(topBtn_w, 20));
    }];
    
    [_authorLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(author_w, 20));
    }];

    _timeLab.text = _model.createTime;
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(8);
        make.right.equalTo(self.bgView.right).offset(-8);
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.topBtn.top).offset(-5);
    }];
    
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-5);
        make.size.equalTo(CGSizeMake(40, 20));
    }];
    
    [_authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBtn.right);
        make.centerY.equalTo(self.topBtn);
        make.size.equalTo(CGSizeMake(80, 20));
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLab.right).offset(0);
        make.centerY.equalTo(self.authorLab);
    }];
}


@end
