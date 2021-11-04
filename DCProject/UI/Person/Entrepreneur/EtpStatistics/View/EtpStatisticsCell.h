//
//  EtpStatisticsCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/16.
//

#import <UIKit/UIKit.h>
#import "EtpStatisticsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView2;


@property (weak, nonatomic) IBOutlet UILabel *near7Level1UserCount;
@property (weak, nonatomic) IBOutlet UILabel *near7Level2UserCount;
@property (weak, nonatomic) IBOutlet UILabel *near7Level3UserCount;
@property (weak, nonatomic) IBOutlet UILabel *near30Level1UserCount;
@property (weak, nonatomic) IBOutlet UILabel *near30Level2UserCount;
@property (weak, nonatomic) IBOutlet UILabel *near30Level3UserCount;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel1UserCount;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel2UserCount;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel3UserCount;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel1UserCount;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel2UserCount;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel3UserCount;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel1Ratio;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel2Ratio;
@property (weak, nonatomic) IBOutlet UILabel *effectLevel3Ratio;


@property (weak, nonatomic) IBOutlet UILabel *near7Level1Fee;
@property (weak, nonatomic) IBOutlet UILabel *near7Level2Fee;
@property (weak, nonatomic) IBOutlet UILabel *near7Level3Fee;
@property (weak, nonatomic) IBOutlet UILabel *near30Level1Fee;
@property (weak, nonatomic) IBOutlet UILabel *near30Level2Fee;
@property (weak, nonatomic) IBOutlet UILabel *near30Level3Fee;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel1Fee;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel2Fee;
@property (weak, nonatomic) IBOutlet UILabel *totalLevel3Fee;
@property (weak, nonatomic) IBOutlet UILabel *nosettleLevel1Fee;
@property (weak, nonatomic) IBOutlet UILabel *nosettleLevel2Fee;
@property (weak, nonatomic) IBOutlet UILabel *nosettleLevel3Fee;
@property (weak, nonatomic) IBOutlet UILabel *settleLevel1Fee;
@property (weak, nonatomic) IBOutlet UILabel *settleLevel2Fee;
@property (weak, nonatomic) IBOutlet UILabel *settleLevel3Fee;
@property (weak, nonatomic) IBOutlet UILabel *failLevel1Fee;
@property (weak, nonatomic) IBOutlet UILabel *failLevel2Fee;
@property (weak, nonatomic) IBOutlet UILabel *failLevel3Fee;

@property (nonatomic, strong) EtpStatisticsFeesModel *model1;
@property (nonatomic, strong) EtpStatisticsUserModel *model2;

@end

NS_ASSUME_NONNULL_END
