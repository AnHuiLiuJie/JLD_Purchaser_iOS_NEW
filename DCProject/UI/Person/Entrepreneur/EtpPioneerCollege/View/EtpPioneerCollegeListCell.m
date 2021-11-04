//
//  EtpPioneerCollegeListCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import "EtpPioneerCollegeListCell.h"

@implementation EtpPioneerCollegeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self steViewUI];
}

- (void)steViewUI{
    
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    
    [DCSpeedy dc_changeControlCircularWith:_imgeView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];

    
    self.topBtn.hidden = YES;
}

#pragma mark - set
- (void)setModel:(PioneerCollegeListModel *)model{
    _model = model;
    
    [_imgeView sd_setImageWithURL:[NSURL URLWithString:_model.newsImg] placeholderImage:[UIImage imageNamed:@"logo"]];

    _titleLab.text = _model.newsTitle;
    if (_model.author.length  == 0) {
        _authorLab.text = @"";
        _auttor_X_LayoutConstraint.constant = 0;
    }else{
        _authorLab.text = _model.author;
        _auttor_X_LayoutConstraint.constant = 80;
    }
    
    if ([_model.isTop isEqual:@"1"]) {
        _topBtn.hidden = NO;
        self.topBtn_W_LayoutConstraint.constant = 30;
    }else{
        _topBtn.hidden = YES;
        self.topBtn_W_LayoutConstraint.constant = 0;
    }
    _introduction.text = _model.introduction;
    _timeLab.text = _model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
