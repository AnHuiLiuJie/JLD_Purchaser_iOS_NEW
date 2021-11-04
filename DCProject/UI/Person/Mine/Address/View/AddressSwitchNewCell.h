//
//  AddressSwitchNewCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "GLPGoodsAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddressSwitchNewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UISwitch *addswitch;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,strong) GLPGoodsAddressModel *model;


@end

NS_ASSUME_NONNULL_END
