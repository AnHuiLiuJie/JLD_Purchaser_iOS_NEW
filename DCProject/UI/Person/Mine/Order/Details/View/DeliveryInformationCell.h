//
//  DeliveryInformationCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/24.
//

#import <UIKit/UIKit.h>
#import "DeliveryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryInformationCell : UITableViewCell

@property (nonatomic, strong) DeliveryInfoListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *topLineImg;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineImg;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, assign) BOOL isLastCell;

@end

NS_ASSUME_NONNULL_END
