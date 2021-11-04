//
//  GLPMainTicketCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/14.
//

#import <UIKit/UIKit.h>
#import "GLPNewShoppingCarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPMainTicketCell : UITableViewCell


@property (nonatomic, strong) GLPCouponListModel *couponsModel;


// 赋值 个人版
- (void)setPersonValueWithDataArray:(NSArray *)dataArray seletcedArray:(NSMutableArray *)seletcedArray firmModel:(GLPFirmListModel *)firmModel indexPath:(NSIndexPath *)indexPath;


// 回调
@property (nonatomic, copy) void(^GLPMainTicketCell_block)(NSArray *seletcedArray);

@end

NS_ASSUME_NONNULL_END
