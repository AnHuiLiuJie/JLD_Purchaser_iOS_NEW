//
//  DCNoDataView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "DCNoDataView.h"


@interface DCNoDataView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation DCNoDataView

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
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:@"#F7F7F7"];
    [self addSubview:_bgView];
    
    _bgImage = [[UIImageView alloc] init];
    [_bgImage setImage:[UIImage imageNamed:@"dc_bg_nadata"]];
    [_bgView addSubview:_bgImage];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.text = @"暂无数据";
    _contentLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _contentLab.font = [UIFont fontWithName:PFRMedium size:15];
    [_bgView addSubview:_contentLab];
    
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.bottom).offset(-20);
        make.centerX.equalTo(self.bgView);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
