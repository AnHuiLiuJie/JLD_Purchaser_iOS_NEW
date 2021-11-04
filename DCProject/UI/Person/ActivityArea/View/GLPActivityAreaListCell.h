//
//  GLPActivityAreaListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/10.
//

#import <UIKit/UIKit.h>
#import "ActivityAreaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPActivityAreaListCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *fireImage;

@property (weak, nonatomic) IBOutlet UIView *bugView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn1;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn2;

@property (nonatomic, copy) void(^GLPActivityAreaListCell_block)(NSString *goodsId);

@property (nonatomic, strong) ActivityAreaGoodsVOModel *model;


@end

NS_ASSUME_NONNULL_END
