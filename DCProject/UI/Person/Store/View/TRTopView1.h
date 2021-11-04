//
//  TRReusableView2.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^TRStoreActivityBlock)(NSString *clickId);
@interface TRTopView1 : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)TRStoreActivityBlock activitykblock;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *showArray;

- (id)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
