//
//  DCListGridCell.h
//  DCProject
//
//  Created by 赤道 on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "TRStoreGoodsModel.h"
#import "GLPMineCollectModel.h"
#import "GLPMineSeeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCListGridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calssView_W_LayoutConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *classIconImg;
@property (weak, nonatomic) IBOutlet UILabel *classNameLab;
@property (weak, nonatomic) IBOutlet UIView *classView;
@property (weak, nonatomic) IBOutlet UILabel *rebateLab;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (strong , nonatomic)TRStoreGoodsModel *model;

@property (nonatomic, copy) void(^colonClickBlock)(NSInteger cellTag);

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bqImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *storeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *mjLab;
@property (weak, nonatomic) IBOutlet UILabel *xsLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *gwcBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *line;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *store_H_LayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Mj_H_LayoutContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *type_H_LayoutContraint;

@end

NS_ASSUME_NONNULL_END
