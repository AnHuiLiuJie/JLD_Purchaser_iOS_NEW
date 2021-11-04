//
//  AddPhotoTableViewCell.h
//  MSIApp
//
//  Created by ZhihanCui on 2018/6/20.
//  Copyright © 2018年 ZhihanCui. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DeleBlock)(NSInteger deleId);
typedef void (^AddBlock)(NSInteger deleId);

@interface AddPhotoTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSMutableArray *photoArray;
@property(nonatomic,strong)NSArray *clickPhotoArray;
@property(nonatomic,copy)DeleBlock deleblock;

@property(nonatomic,copy)AddBlock addblock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
