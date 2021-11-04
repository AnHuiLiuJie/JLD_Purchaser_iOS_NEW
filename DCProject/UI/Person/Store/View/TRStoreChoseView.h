//
//  TRStoreChoseView.h
//  DCProject
//
//  Created by 陶锐 on 2019/9/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChoseBtnBlock)(NSArray *arr);
@interface TRStoreChoseView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,copy)ChoseBtnBlock chosebtnblock;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;
@property(nonatomic,strong) NSMutableArray *seleeArray;
@property(nonatomic,strong) NSMutableArray *defaultSelectArr;

- (id)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
