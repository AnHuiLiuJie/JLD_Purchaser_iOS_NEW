//
//  EtpInviteCustomerCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpInviteCustomerCell.h"

@implementation EtpInviteCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];

    
    [DCSpeedy dc_changeControlCircularWith:_inviteBtn AndSetCornerRadius:_inviteBtn.dc_height/2 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    [_inviteBtn addTarget:self action:@selector(inviteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _inviteBtn.backgroundColor = [UIColor colorWithRed:243/255.0 green:0/255.0 blue:65/255.0 alpha:1.0];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,_inviteBtn.dc_width+_inviteBtn.dc_height,_inviteBtn.dc_height);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:243/255.0 green:0/255.0 blue:65/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:100/255.0 blue:33/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.inviteBtn.layer addSublayer:gl];
    
    
    [DCSpeedy dc_changeControlCircularWith:_bgView2 AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];//f30041  fc6421  ffede4  fddee9
    
    
    _titileView.backgroundColor = [UIColor colorWithRed:255/255.0 green:237/255.0 blue:228/255.0 alpha:1.0];
    CAGradientLayer *gl2 = [CAGradientLayer layer];
    gl2.frame = CGRectMake(CGRectGetMidX(_titileView.frame),0,_titileView.dc_width+10,_titileView.dc_height);
    gl2.startPoint = CGPointMake(0, 0);
    gl2.endPoint = CGPointMake(1, 1);
    gl2.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:237/255.0 blue:228/255.0 alpha:0].CGColor,(__bridge id)[UIColor colorWithRed:253/255.0 green:222/255.0 blue:233/255.0 alpha:1.0].CGColor];
    gl2.locations = @[@(0.0),@(1.0)];
    [self.titileView.layer addSublayer:gl2];
    
}

- (void)inviteBtnAction{
    !_etpInviteCustomerCellClick_blcok ? : _etpInviteCustomerCellClick_blcok();
}

#pragma mark - set model
- (void)setModel:(CustomerExplainModel *)model{
    _model = model;
    
    _contentLab.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
