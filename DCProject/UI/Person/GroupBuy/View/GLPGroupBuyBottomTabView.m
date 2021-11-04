//
//  GLPGroupBuyBottomTabView.m
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import "GLPGroupBuyBottomTabView.h"

@interface GLPGroupBuyBottomTabView ()

@end

@implementation GLPGroupBuyBottomTabView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat itemH = 50;
    CGFloat itemW = kScreenW/2-1;
    
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    [_leftBtn setImage:[UIImage imageNamed:@"dc_pintuan_syd"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"dc_pintuan_sys"] forState:UIControlStateSelected];
    [_leftBtn setTitleColor:[UIColor dc_colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    [_leftBtn setTitle:@" 拼团首页" forState:UIControlStateNormal];
    [_leftBtn setTitle:@" 拼团首页" forState:UIControlStateSelected];
    _leftBtn.selected = YES;
    _leftBtn.backgroundColor = [UIColor whiteColor];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _leftBtn.bounds = CGRectMake(0, 0, itemW, itemH);

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rightBtn];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    [_rightBtn setImage:[UIImage imageNamed:@"dc_pintuan_med"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"dc_pintuan_mes"] forState:UIControlStateSelected];
    [_rightBtn setTitleColor:[UIColor dc_colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00B7AB"] forState:UIControlStateSelected];
    [_rightBtn setTitle:@" 我的拼团" forState:UIControlStateNormal];
    [_rightBtn setTitle:@" 我的拼团" forState:UIControlStateSelected];
    _rightBtn.selected = NO;
    _rightBtn.backgroundColor = [UIColor whiteColor];
    _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightBtn.bounds = CGRectMake(0, 0, itemW, itemH);

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(50);
    }];
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.bgView.top);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.top.equalTo(self.bgView.top);
        make.size.equalTo(CGSizeMake(itemW, itemH));
    }];
    
    [_leftBtn dc_cornerRadius:5 rectCorner:UIRectCornerTopRight];
    [_rightBtn dc_cornerRadius:5 rectCorner:UIRectCornerTopLeft];
}


#pragma mark - private method
- (void)leftBtnAction:(UIButton *)button{
    _rightBtn.selected = NO;
    _leftBtn.selected = YES;
    !_GLPGroupBuyBottomTabView_btnBlock ? : _GLPGroupBuyBottomTabView_btnBlock(1);
}

- (void)rightBtnAction:(UIButton *)button{
    _rightBtn.selected = YES;
    _leftBtn.selected = NO;
    !_GLPGroupBuyBottomTabView_btnBlock ? : _GLPGroupBuyBottomTabView_btnBlock(2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
