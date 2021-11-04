//
//  GLPBankCardCell.h
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import <UIKit/UIKit.h>
#import "DCCodeButton.h"
#import "GLPBankCardListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPBankCardCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *cardTf;
@property (weak, nonatomic) IBOutlet UIButton *debitBtn;
@property (weak, nonatomic) IBOutlet UIButton *creditBtn;
@property (weak, nonatomic) IBOutlet UITextField *certificateTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *verificationTf;
@property (weak, nonatomic) IBOutlet DCCodeButton *obtainBtn;


@property (copy, nonatomic) void(^GLPBankCardCell_cardTf_block)(NSString *text);
@property (copy, nonatomic) void(^GLPBankCardCell_certificateTf_block)(NSString *text);
@property (copy, nonatomic) void(^GLPBankCardCell_nameTf_block)(NSString *text);
@property (copy, nonatomic) void(^GLPBankCardCell_phoneTf_block)(NSString *text);
@property (copy, nonatomic) void(^GLPBankCardCell_verificationTf_block)(NSString *text);
@property (copy, nonatomic) void(^GLPBankCardCell_cardType_block)(NSInteger type);
@property (copy, nonatomic) dispatch_block_t GLPBankCardCell_send_block;


@property (nonatomic, strong) GLPBankCardListModel *model;

@end

NS_ASSUME_NONNULL_END
