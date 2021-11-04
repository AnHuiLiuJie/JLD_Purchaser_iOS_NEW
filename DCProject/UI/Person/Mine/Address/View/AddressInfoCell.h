//
//  AddressInfoCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t AddressInfoCell_Block;

@property (copy, nonatomic) void(^AddressInfoCell_block)(NSString *text,NSInteger type);

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *addressTf;
@property (weak, nonatomic) IBOutlet UIView *addressBgView;
@property (weak, nonatomic) IBOutlet UITextField *detailedTf;

@property(nonatomic,strong) GLPGoodsAddressModel *model;


@end

NS_ASSUME_NONNULL_END
