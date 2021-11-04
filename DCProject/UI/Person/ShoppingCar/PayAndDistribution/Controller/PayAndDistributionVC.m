//
//  PayAndDistributionVC.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/24.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "PayAndDistributionVC.h"
#import "PayAndDistriCCell.h"
@interface PayAndDistributionVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation PayAndDistributionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择支付配送方式";
    self.payBtn1.layer.masksToBounds = YES;
    self.payBtn1.layer.cornerRadius = 18.5;
    self.payBtn1.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
    self.payBtn1.layer.borderWidth = 1;
    self.payBtn1.backgroundColor = [UIColor whiteColor];
    self.payBtn1.selected = NO;
    
    self.payBtn2.layer.masksToBounds = YES;
    self.payBtn2.layer.cornerRadius = 18.5;
    self.payBtn2.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.payBtn2.layer.borderWidth = 1;
    self.payBtn2.backgroundColor = RGB_COLOR(0, 190, 179);
    self.payBtn2.selected = YES;
    
    self.distributionBtn1.layer.masksToBounds = YES;
    self.distributionBtn1.layer.cornerRadius = 18.5;
    self.distributionBtn1.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.distributionBtn1.layer.borderWidth = 1;
    self.distributionBtn1.backgroundColor = RGB_COLOR(0, 190, 179);
    self.distributionBtn1.selected = YES;
    
    self.distributionBtn2.layer.masksToBounds = YES;
    self.distributionBtn2.layer.cornerRadius = 18.5;
    self.distributionBtn2.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
    self.distributionBtn2.layer.borderWidth = 1;
    self.distributionBtn2.backgroundColor = [UIColor whiteColor];
    self.distributionBtn2.selected = NO;
    
    if ([self.payWay isEqualToString:@"1"]) {
        [self payselect1];
    }
    else{
        [self payselect2];
    }
    if ([self.distributionWay isEqualToString:@"1"]) {
           [self distributionselect1];
       }
       else{
           [self distributionselect2];
       }
    self.countLab.text = [NSString stringWithFormat:@"共%lu件",(unsigned long)self.goodsArray.count];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.minimumInteritemSpacing = 0;// 垂直方向的间距
    layout.minimumLineSpacing = 10; // 水平方向的间距
    layout.itemSize = CGSizeMake(54, 70);
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = RGB_COLOR(246, 246, 246);
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PayAndDistriCCell" bundle:nil] forCellWithReuseIdentifier:@"PayAndDistriCCell"];
}
//货到付款点击
- (IBAction)payClick1:(id)sender {
    [self payselect1];
    if (self.paywayBlock) {
           self.paywayBlock(@"1");
       }
}

- (void)payselect1
{
    self.payBtn1.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.payBtn1.backgroundColor = RGB_COLOR(0, 190, 179);
    self.payBtn1.selected = YES;
    self.payBtn2.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
    self.payBtn2.backgroundColor = [UIColor whiteColor];
    self.payBtn2.selected = NO;
}
//在线支付点击
- (IBAction)payClick2:(id)sender {
    [self payselect2];
   
    if (self.paywayBlock) {
              self.paywayBlock(@"2");
          }
}

- (void)payselect2
{
    self.payBtn2.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
       self.payBtn2.backgroundColor = RGB_COLOR(0, 190, 179);
       self.payBtn2.selected = YES;
       self.payBtn1.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
       self.payBtn1.backgroundColor = [UIColor whiteColor];
       self.payBtn1.selected = NO;
}
//快递配送点击
- (IBAction)distributionClick:(id)sender {
    [self distributionselect1];
    if (self.distributionwayBlock) {
        self.distributionwayBlock(@"1");
    }
}

- (void)distributionselect1
{
    self.distributionBtn1.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
       self.distributionBtn1.backgroundColor = RGB_COLOR(0, 190, 179);
       self.distributionBtn1.selected = YES;
       self.distributionBtn2.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
       self.distributionBtn2.backgroundColor = [UIColor whiteColor];
       self.distributionBtn2.selected = NO;
}
//到店自取点击
- (IBAction)distributionClick2:(id)sender {
    [self distributionselect2];
    if (self.distributionwayBlock) {
        self.distributionwayBlock(@"2");
    }
}

- (void)distributionselect2
{
    self.distributionBtn2.layer.borderColor = RGB_COLOR(0, 190, 179).CGColor;
    self.distributionBtn2.backgroundColor = RGB_COLOR(0, 190, 179);
    self.distributionBtn2.selected = YES;
    self.distributionBtn1.layer.borderColor = RGB_COLOR(221, 221, 221).CGColor;
    self.distributionBtn1.backgroundColor = [UIColor whiteColor];
    self.distributionBtn1.selected = NO;
}
#pragma collectionView delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PayAndDistriCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PayAndDistriCCell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:@"logo"];
    return cell;
}

@end
