//
//  GLPToPayListCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import <UIKit/UIKit.h>
#import "GLPBankCardListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPToPayListCell : UITableViewCell

@property (nonatomic, assign) NSInteger showType;//1支付宝 2微信 0添加银行卡 其他事已添加的银行卡

@property (nonatomic, copy) void(^GLPToPayListCell_block)(GLPBankCardListModel *model);

@property (nonatomic, strong) GLPBankCardListModel *model;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, copy) NSString *titleStr;


@end

NS_ASSUME_NONNULL_END
