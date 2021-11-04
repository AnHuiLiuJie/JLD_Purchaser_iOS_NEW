//
//  GLPSpikeHomeListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/13.
//

#import <UIKit/UIKit.h>
#import "DCActivityBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPSpikeHomeListCell : UITableViewCell


@property (nonatomic, strong) DCSeckillListModel *model;
@property (nonatomic, assign) NSInteger goodsType;//类型：1-进行中秒杀，2-未开始秒杀


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titileLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalLab;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@property (nonatomic, copy) void(^GLPSpikeHomeListCell_btnBlock)(NSString *btnTitle,DCSeckillListModel *model);

@property (assign, nonatomic) NSInteger radiusType;

@end

NS_ASSUME_NONNULL_END
