//
//  EtpStatisticsCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import "EtpStatisticsCell.h"

@implementation EtpStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
    
}

#pragma mark - view
- (void)setViewUI{
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];
    [DCSpeedy dc_changeControlCircularWith:_bgView2 AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];

}

#pragma mark - set
- (void)setModel1:(EtpStatisticsFeesModel *)model1{
    _model1 = model1;
    if (_model1==nil) {
        return;
    }
    _near7Level1Fee.text = model1.near7Level1Fee;
    _near7Level2Fee.text = model1.near7Level2Fee;
    _near7Level3Fee.text = model1.near7Level3Fee;
    _near30Level1Fee.text = model1.near30Level1Fee;
    _near30Level2Fee.text = model1.near30Level2Fee;
    _near30Level3Fee.text = model1.near30Level3Fee;
    _totalLevel1Fee.text = model1.totalLevel1Fee;
    _totalLevel2Fee.text = model1.totalLevel2Fee;
    _totalLevel3Fee.text = model1.totalLevel3Fee;
    _nosettleLevel1Fee.text = model1.nosettleLevel1Fee;
    _nosettleLevel2Fee.text = model1.nosettleLevel2Fee;
    _nosettleLevel3Fee.text = model1.nosettleLevel3Fee;
    _settleLevel1Fee.text = model1.settleLevel1Fee;
    _settleLevel2Fee.text = model1.settleLevel2Fee;
    _settleLevel3Fee.text = model1.settleLevel3Fee;
    _failLevel1Fee.text = model1.failLevel1Fee;
    _failLevel2Fee.text = model1.failLevel2Fee;
    _failLevel3Fee.text = model1.failLevel3Fee;

}

- (void)setModel2:(EtpStatisticsUserModel *)model2{
    _model2 = model2;
    if (_model2==nil) {
        return;
    }
    _near7Level1UserCount.text = model2.near7Level1UserCount;
    _near7Level2UserCount.text = model2.near7Level2UserCount;
    _near7Level3UserCount.text = model2.near7Level3UserCount;
    _near30Level1UserCount.text = model2.near30Level1UserCount;
    _near30Level2UserCount.text = model2.near30Level2UserCount;
    _near30Level3UserCount.text = model2.near30Level3UserCount;
    _totalLevel1UserCount.text = model2.totalLevel1UserCount;
    _totalLevel2UserCount.text = model2.totalLevel2UserCount;
    _totalLevel3UserCount.text = model2.totalLevel3UserCount;
    _effectLevel1UserCount.text = model2.effectLevel1UserCount;
    _effectLevel2UserCount.text = model2.effectLevel2UserCount;
    _effectLevel3UserCount.text = model2.effectLevel3UserCount;
    _effectLevel1Ratio.text = [NSString stringWithFormat:@"%@%@",model2.effectLevel1Ratio,@"%"];
    _effectLevel2Ratio.text = [NSString stringWithFormat:@"%@%@",model2.effectLevel2Ratio,@"%"];
    _effectLevel3Ratio.text = [NSString stringWithFormat:@"%@%@",model2.effectLevel3Ratio,@"%"];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
