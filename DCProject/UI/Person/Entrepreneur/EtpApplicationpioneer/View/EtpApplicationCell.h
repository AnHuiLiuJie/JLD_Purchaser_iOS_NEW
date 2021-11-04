//
//  EtpApplicationCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/15.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"
#import "EntrepreneurInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EtpApplicationCell : UITableViewCell

@property (copy, nonatomic) void(^etpApplicationCell_name_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_phone_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_identity_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_wx_tf_block)(NSString *text);
@property (copy, nonatomic) void(^etpApplicationCell_area_tf_block)(NSString *text);


@property (nonatomic, strong) UITextField *name_tf;
@property (nonatomic, strong) DCTextField *phone_tf;
@property (nonatomic, strong) DCTextField *identity_tf;
@property (nonatomic, strong) UITextField *wx_tf;
@property (nonatomic, strong) UITextField *area_tf;


@property (strong , nonatomic) EntrepreneurInfoModel *model;


@end

NS_ASSUME_NONNULL_END
