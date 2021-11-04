//
//  TRStoreChoseVC.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ChoseBlock)(NSArray *randArr,NSArray *vendArr,NSArray *symptomsArr,NSArray *dosageFormArr,NSArray *wayArr,NSArray *peopleArr);
@interface TRStoreChoseVC : DCBasicViewController
@property(nonatomic,copy)ChoseBlock choseblock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
- (IBAction)BrandClick:(id)sender;
- (IBAction)VenderClick:(id)sender;
- (IBAction)SymptomsClick:(id)sender;
- (IBAction)DosageFormClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *userWayView;
@property (weak, nonatomic) IBOutlet UIView *userPeopleView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
- (IBAction)resetClick:(id)sender;
- (IBAction)comfireClick:(id)sender;
- (IBAction)dissClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wayHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleHeight;

@property(nonatomic,strong)NSArray *bandArr;
@property(nonatomic,strong)NSArray *venderArr;
@property(nonatomic,strong)NSArray *symptomsArr;
@property(nonatomic,strong)NSArray *dosageFormArr;
@property(nonatomic,strong)NSArray *wayArr;
@property(nonatomic,strong)NSArray *peopleArr;

@property(nonatomic,strong)NSArray *selectbandArr;
@property(nonatomic,strong)NSArray *selectvenderArr;
@property(nonatomic,strong)NSArray *selectsymptomsArr;
@property(nonatomic,strong)NSArray *selectdosageFormArr;
@property(nonatomic,strong)NSArray *selectwayArr;
@property(nonatomic,strong)NSArray *selectpeopleArr;


@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
