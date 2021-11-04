//
//  GLPEtpCenterFunctionalCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DCGridItem;
@interface GLPEtpCenterFunctionalCell : UITableViewCell

/* 将didSelectItemAtIndexPath 点击事件传过来 */
@property (nonatomic, copy) void(^stateItemItemClickBlock)(NSString *title);

/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *serviceItemArray;

@property (strong, nonatomic) UILabel *title_label;
@property (nonatomic, copy) NSString *InforCount;
@property (nonatomic, assign) NSInteger indexRow;

@end

NS_ASSUME_NONNULL_END
