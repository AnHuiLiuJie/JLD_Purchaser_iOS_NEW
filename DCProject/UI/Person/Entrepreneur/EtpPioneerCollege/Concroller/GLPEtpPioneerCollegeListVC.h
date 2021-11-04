//
//  GLPEtpPioneerCollegeListVC.h
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import "DCBasicViewController.h"

//typedef NS_ENUM(NSInteger ,EtpEtpPioneerCollege) {
//    EtpEtpPioneerCollegeNews = 0,       // 资讯
//    EtpEtpPioneerCollegeHot,           //热榜
//    EtpEtpPioneerCollegeRecommend,          //推荐
//    EtpEtpPioneerCollegeHealth,          //健康
//    EtpEtpPioneerCollegeMedical,          //医疗
//
//
//};

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpPioneerCollegeListVC : DCBasicViewController


@property (nonatomic,copy) NSString *catIdStr;
@property (nonatomic, assign) CGFloat view_H;

@end

NS_ASSUME_NONNULL_END
