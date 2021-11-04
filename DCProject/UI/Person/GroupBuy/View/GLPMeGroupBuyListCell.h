//
//  GLPMeGroupBuyListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "DCActivityBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPMeGroupBuyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *titileLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalLab;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn1;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn2;

@property (nonatomic, copy) void(^GLPMeGroupBuyListCell_btnBlock)(NSString *title,NSInteger tag);

@property (nonatomic, strong) DCMyCollageListModel *model;

@end

NS_ASSUME_NONNULL_END
