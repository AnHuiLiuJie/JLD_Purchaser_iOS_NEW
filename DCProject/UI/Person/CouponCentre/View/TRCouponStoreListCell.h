//
//  TRCouponStoreListCell.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TRCouponStoreListCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *requestLab;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIImageView *haveImageV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;
@end

NS_ASSUME_NONNULL_END
