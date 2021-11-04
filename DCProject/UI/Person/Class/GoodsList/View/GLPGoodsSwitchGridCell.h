//
//  GLPGoodsSwitchGridCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import "TRStoreGoodsModel.h"
#import "GLPMineCollectModel.h"
#import "GLPMineSeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGoodsSwitchGridCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *classNameLab;
@property (weak, nonatomic) IBOutlet UIView *classView;
@property (weak, nonatomic) IBOutlet UILabel *rebateLab;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *alreadyLab;

@property (strong , nonatomic) TRStoreGoodsModel *model;
@end

NS_ASSUME_NONNULL_END
