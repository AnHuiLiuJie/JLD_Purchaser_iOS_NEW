//
//  AddressListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressListCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t AddressListCellDel_block;
@property (nonatomic, copy) dispatch_block_t AddressListCellEid_block;


@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *mrLab;


@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,strong) GLPGoodsAddressModel *model;


@end

NS_ASSUME_NONNULL_END
