//
//  PayAndDistributionVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^payWayBlock)(NSString *payway);
typedef void(^distributionWayBlock)(NSString *distributionway);
@interface PayAndDistributionVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn1;
@property (weak, nonatomic) IBOutlet UIButton *payBtn2;
@property (weak, nonatomic) IBOutlet UIButton *distributionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *distributionBtn2;
- (IBAction)payClick1:(id)sender;
- (IBAction)payClick2:(id)sender;
- (IBAction)distributionClick:(id)sender;
- (IBAction)distributionClick2:(id)sender;
@property(nonatomic,strong)NSArray *goodsArray;
@property(nonatomic,copy) NSString *payWay;
@property(nonatomic,copy) NSString *distributionWay;
@property(nonatomic,copy)payWayBlock paywayBlock;
@property(nonatomic,copy)distributionWayBlock distributionwayBlock;
@end

NS_ASSUME_NONNULL_END
