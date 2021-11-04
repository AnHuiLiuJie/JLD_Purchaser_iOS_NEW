//
//  DCChatGoodsCell.h
//  DCProject
//
//  Created by bigbing on 2019/12/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DCChatGoodsCellBlock)(HDMessageModel *messageModel);


@interface DCChatGoodsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIView *subBgView;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
//@property (nonatomic, strong) UIImageView *arrowImage;


#pragma mark - public

+ (NSString *)cellIdentifier;


@property (nonatomic, strong) HDMessageModel* messageModel;


@property (nonatomic, copy) DCChatGoodsCellBlock cellBlock;

@end

NS_ASSUME_NONNULL_END
