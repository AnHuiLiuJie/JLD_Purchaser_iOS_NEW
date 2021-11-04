//
//  GLPInvalidGoodsListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPInvalidGoodsListCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) dispatch_block_t GLPInvalidGoodsListCell_Block;

@end

NS_ASSUME_NONNULL_END
