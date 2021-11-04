//
//  TRClassGoodsVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRClassGoodsVC : DCBasicViewController
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
- (IBAction)backClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mrBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priceImageV;
@property (weak, nonatomic) IBOutlet UIImageView *choseImageV;
@property (weak, nonatomic) IBOutlet UIImageView *mor_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
- (IBAction)mrClick:(id)sender;
- (IBAction)priceClick:(id)sender;
- (IBAction)choseClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *searView;
@property (weak, nonatomic) IBOutlet UITextField *searTF;
- (IBAction)moreClick:(id)sender;
@property(nonatomic,copy) NSString *classId;
@property(nonatomic,copy) NSString *searchStr;
@property(nonatomic,copy) NSString *goodsTagNameList;
@property(nonatomic,copy) NSString *firmId;
@end

NS_ASSUME_NONNULL_END
