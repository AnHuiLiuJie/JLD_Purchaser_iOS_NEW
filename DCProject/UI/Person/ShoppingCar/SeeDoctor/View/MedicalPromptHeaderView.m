//
//  MedicalPromptHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "MedicalPromptHeaderView.h"

@interface MedicalPromptHeaderView ()

@property (nonatomic, strong) UILabel *promptLab;

@end

@implementation MedicalPromptHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _promptLab = [[UILabel alloc] init];
    _promptLab.text = @"温馨提示。";
    _promptLab.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _promptLab.font = [UIFont fontWithName:PFR size:14];
    _promptLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_promptLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.right.equalTo(self.contentView.right).offset(0);
        make.top.equalTo(self.contentView.top).offset(5);
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
    }];
}

#pragma set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    
    _promptLab.text = titleStr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
