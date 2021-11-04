//
//  EtpStatisticsModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/21.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EtpStatisticsModel : DCBaseModel

@end

#pragma mark -服务费统计
@interface EtpStatisticsFeesModel : DCBaseModel


@property (nonatomic, copy) NSString *near7Level1Fee;
@property (nonatomic, copy) NSString *near7Level2Fee;
@property (nonatomic, copy) NSString *near7Level3Fee;
@property (nonatomic, copy) NSString *near30Level1Fee;
@property (nonatomic, copy) NSString *near30Level2Fee;
@property (nonatomic, copy) NSString *near30Level3Fee;
@property (nonatomic, copy) NSString *totalLevel1Fee;
@property (nonatomic, copy) NSString *totalLevel2Fee;
@property (nonatomic, copy) NSString *totalLevel3Fee;
@property (nonatomic, copy) NSString *nosettleLevel1Fee;
@property (nonatomic, copy) NSString *nosettleLevel2Fee;
@property (nonatomic, copy) NSString *nosettleLevel3Fee;
@property (nonatomic, copy) NSString *settleLevel1Fee;
@property (nonatomic, copy) NSString *settleLevel2Fee;
@property (nonatomic, copy) NSString *settleLevel3Fee;
@property (nonatomic, copy) NSString *failLevel1Fee;
@property (nonatomic, copy) NSString *failLevel2Fee;
@property (nonatomic, copy) NSString *failLevel3Fee;

@end

#pragma mark -推广用户数统计
@interface EtpStatisticsUserModel : DCBaseModel

@property (nonatomic, copy) NSString *near7Level1UserCount;
@property (nonatomic, copy) NSString *near7Level2UserCount;
@property (nonatomic, copy) NSString *near7Level3UserCount;
@property (nonatomic, copy) NSString *near30Level1UserCount;
@property (nonatomic, copy) NSString *near30Level2UserCount;
@property (nonatomic, copy) NSString *near30Level3UserCount;
@property (nonatomic, copy) NSString *totalLevel1UserCount;
@property (nonatomic, copy) NSString *totalLevel2UserCount;
@property (nonatomic, copy) NSString *totalLevel3UserCount;
@property (nonatomic, copy) NSString *effectLevel1UserCount;
@property (nonatomic, copy) NSString *effectLevel2UserCount;
@property (nonatomic, copy) NSString *effectLevel3UserCount;
@property (nonatomic, copy) NSString *effectLevel1Ratio;
@property (nonatomic, copy) NSString *effectLevel2Ratio;
@property (nonatomic, copy) NSString *effectLevel3Ratio;
@end

NS_ASSUME_NONNULL_END
