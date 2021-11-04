//
//  TRStoreChoseVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRStoreChoseVC.h"
#import "TRChoseRandVC.h"
#import "TRChoseVenderVC.h"
#import "TRChoseSymptomsVC.h"
#import "TRChoseDosageFormVC.h"
#import "TRStoreChoseView.h"
@interface TRStoreChoseVC ()
@property(nonatomic,strong) NSMutableArray *bandArray;
@property(nonatomic,strong) NSMutableArray *venderArray;
@property(nonatomic,strong) NSMutableArray *symptomsArray;
@property(nonatomic,strong) NSMutableArray *dosageFormArray;
@property(nonatomic,strong) NSMutableArray *wayArray;
@property(nonatomic,strong) NSMutableArray *peopleArray;
@property(nonatomic,strong)TRStoreChoseView*choseview;
@property(nonatomic,strong)TRStoreChoseView*choseview1;
@end

@implementation TRStoreChoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 3;
    self.comfireBtn.layer.masksToBounds = YES;
    self.comfireBtn.layer.cornerRadius = 3;
    self.bandArray = [NSMutableArray arrayWithCapacity:0];
    self.venderArray = [NSMutableArray arrayWithCapacity:0];
    self.symptomsArray = [NSMutableArray arrayWithCapacity:0];
    self.dosageFormArray = [NSMutableArray arrayWithCapacity:0];
    self.wayArray = [NSMutableArray arrayWithCapacity:0];
    self.peopleArray = [NSMutableArray arrayWithCapacity:0];

    if (self.wayArr.count==0)
    {
        self.wayHeight.constant = 10;
        self.choseview.frame = CGRectMake(0, 0, kScreenW-92, 10);
    }
    else  if (self.wayArr.count<=3)
    {
        self.wayHeight.constant = 54;
        self.choseview.frame = CGRectMake(0, 0, kScreenW-92, 54);
    }
    else{
        self.wayHeight.constant = 100;
        self.choseview.frame = CGRectMake(0, 0, kScreenW-92, 100);
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObjectsFromArray:self.wayArr];
    self.choseview.dataArray = arr;
    WEAKSELF;
    self.choseview.chosebtnblock = ^(NSArray *_Nonnull arr) {
        [weakSelf.wayArray removeAllObjects];
        [weakSelf.wayArray addObjectsFromArray:arr];
    };
    [self.userWayView addSubview:_choseview];
    
    if (self.peopleArr.count==0)
    {
        self.peopleHeight.constant = 10;
        self.choseview1.frame = CGRectMake(0, 0, kScreenW-92, 10);
    }
    else  if (self.peopleArr.count<=3)
    {
        self.peopleHeight.constant = 54;
        self.choseview1.frame = CGRectMake(0, 0, kScreenW-92, 54);
    }
    else{
        self.peopleHeight.constant = 100;
        self.choseview1.frame = CGRectMake(0, 0, kScreenW-92, 100);
    }
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
    [arr1 addObjectsFromArray:self.peopleArr];
    self.choseview1.dataArray = arr1;
    self.choseview1.chosebtnblock = ^(NSArray *_Nonnull arr) {
        [weakSelf.peopleArray removeAllObjects];
        [weakSelf.peopleArray addObjectsFromArray:arr];
    };
    [self.userPeopleView addSubview:_choseview1];
    
     [self.bandArray addObjectsFromArray:self.selectbandArr];
     [self.venderArray addObjectsFromArray:self.selectvenderArr];
     [self.symptomsArray addObjectsFromArray:self.selectsymptomsArr];
     [self.dosageFormArray addObjectsFromArray:self.selectdosageFormArr];
     [self.wayArray addObjectsFromArray:self.selectwayArr];
     [self.peopleArray addObjectsFromArray:self.selectpeopleArr];
     self.choseview.defaultSelectArr = self.wayArray;
     self.choseview1.defaultSelectArr = self.peopleArray;
    
    if (self.height && self.height > 0) {
        self.heightConstraint.constant = self.height;
    } else {
        self.heightConstraint.constant = kScreenH;
    }
    
    self.widthCons.constant =((kScreenW - 95) - 16*2 - 30 )/2;
    
}
-(TRStoreChoseView*)choseview
{
    if (_choseview==nil)
    {
        _choseview = [[TRStoreChoseView alloc]initWithFrame:CGRectMake(0, 0, self.userWayView.frame.size.width, self.userWayView.frame.size.height)];
    }
    return _choseview;
}
-(TRStoreChoseView*)choseview1
{
    if (_choseview1==nil)
    {
        _choseview1 = [[TRStoreChoseView alloc]initWithFrame:CGRectMake(0, 0, self.userPeopleView.frame.size.width, self.userPeopleView.frame.size.height)];
    }
    return _choseview1;
}

- (IBAction)BrandClick:(id)sender {
    TRChoseRandVC *vc = [[TRChoseRandVC alloc] init];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.randblock = ^(NSArray *_Nonnull choseArr) {
        [self.bandArray removeAllObjects];
        [self.bandArray addObjectsFromArray:choseArr];
    };
    vc.choseArray=self.bandArray;
    vc.dataArray=self.bandArr;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)VenderClick:(id)sender {
    TRChoseVenderVC *vc = [[TRChoseVenderVC alloc] init];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.venderblock = ^(NSArray *_Nonnull choseArr) {
        [self.venderArray removeAllObjects];
        [self.venderArray addObjectsFromArray:choseArr];
    };
    vc.choseArray=self.venderArray;
    vc.dataArray=self.venderArr;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)SymptomsClick:(id)sender {
    TRChoseSymptomsVC *vc = [[TRChoseSymptomsVC alloc] init];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.symptomsblock = ^(NSArray *_Nonnull choseArr) {
        [self.symptomsArray removeAllObjects];
        [self.symptomsArray addObjectsFromArray:choseArr];
    };
    vc.choseArray=self.symptomsArray;
    vc.dataArray=self.symptomsArr;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)DosageFormClick:(id)sender {
    TRChoseDosageFormVC *vc = [[TRChoseDosageFormVC alloc] init];
    vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dosageFormblock = ^(NSArray *_Nonnull choseArr) {
        [self.dosageFormArray removeAllObjects];
        [self.dosageFormArray addObjectsFromArray:choseArr];
    };
    vc.choseArray=self.dosageFormArray;
    vc.dataArray=self.dosageFormArr;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)resetClick:(id)sender {
    [self.bandArray removeAllObjects];
    [self.venderArray removeAllObjects];
    [self.symptomsArray removeAllObjects];
    [self.dosageFormArray removeAllObjects];
    [self.wayArray removeAllObjects];
    [self.peopleArray removeAllObjects];
    self.choseview.defaultSelectArr = self.wayArray;
    self.choseview1.defaultSelectArr = self.peopleArray;
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (self.choseblock)
    {
        self.choseblock(self.bandArray, self.venderArray, self.symptomsArray, self.dosageFormArray, self.wayArray,self.peopleArray);
    }
}

- (IBAction)comfireClick:(id)sender {
   
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
    
    if (self.choseblock)
    {
        self.choseblock(self.bandArray, self.venderArray, self.symptomsArray, self.dosageFormArray, self.wayArray,self.peopleArray);
    }

}

- (IBAction)dissClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
}
@end
