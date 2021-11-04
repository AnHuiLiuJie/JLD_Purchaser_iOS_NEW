//
//  LogisticsInformationVC.h
//  DCProject
//
//  Created by LiuMac on 2021/6/22.
//

#import "DCBasicViewController.h"
#import "LogisticsInfoListCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface LogisticsInformationVC : DCBasicViewController

@property (nonatomic, copy) NSArray *allGoodsArr;
@property (nonatomic, copy) NSString *orderNoStr;

@end

NS_ASSUME_NONNULL_END
