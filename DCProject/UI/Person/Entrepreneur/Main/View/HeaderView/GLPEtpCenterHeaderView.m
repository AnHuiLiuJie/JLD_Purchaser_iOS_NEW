//
//  GLPEtpCenterHeaderView.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEtpCenterHeaderView.h"


@interface GLPEtpCenterHeaderView()



@end


@implementation GLPEtpCenterHeaderView


#pragma mark - initialize
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView_Y_LayoutConstraint.constant = kNavBarHeight+10;
    
    //圆角
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_avatarBtn AndSetCornerRadius:_avatarBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_recordBtn AndSetCornerRadius:_recordBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:RGB_COLOR(151, 151, 151) canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_withdrawBtn AndSetCornerRadius:_withdrawBtn.dc_height/2 SetBorderWidth:1 SetBorderColor:RGB_COLOR(151, 151, 151) canMasksToBounds:YES];
    
    [_avatarBtn addTarget:self action:@selector(clickAvatarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_infoBtn addTarget:self action:@selector(clickInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [_recordBtn addTarget:self action:@selector(clickRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_withdrawBtn addTarget:self action:@selector(clickWithdrawButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
    _gradeImg.userInteractionEnabled = YES;
    [_gradeImg addGestureRecognizer:tapGesture1];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    !_headerViewClickBlock ? : _headerViewClickBlock(4);
}

#pragma mark - tag=1 点击头像
- (void)clickAvatarButtonAction:(UIButton *)button{
    !_headerViewClickBlock ? : _headerViewClickBlock(1);
}

#pragma mark - tag=1 点击个人资料
- (void)clickInfoButtonAction:(UIButton *)button{
    !_headerViewClickBlock ? : _headerViewClickBlock(1);
}

#pragma mark - tag=2 点击记录
- (void)clickRecordButtonAction:(UIButton *)button{
    !_headerViewClickBlock ? : _headerViewClickBlock(2);
}

#pragma mark - tag=3 提现记录
- (void)clickWithdrawButtonAction:(UIButton *)button{
    !_headerViewClickBlock ? : _headerViewClickBlock(3);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
