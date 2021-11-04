//
//  DCMoreGridCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/13.
//

#import <UIKit/UIKit.h>
#import "DCGridItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCMoreGridCell : UICollectionViewCell


/* 10个属性数据 */
@property (strong , nonatomic)DCGridItem *gridItem;


/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* gridLabel */
@property (strong , nonatomic)UILabel *gridLabel;
/* tagLabel */
@property (strong , nonatomic)UILabel *tagLabel;

@property (assign , nonatomic)BOOL showType;//NO 长方形  YES 圆形

@end

NS_ASSUME_NONNULL_END
