//
//  GLPToPayViewController.h
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//

#import "DCBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPToPayViewController : DCBasicViewController

@property (nonatomic, copy) NSString *orderNoStr;
@property (nonatomic, copy) NSString *firmIdStr;

@property (nonatomic, assign) BOOL isNeedBackOrder;

@end

NS_ASSUME_NONNULL_END
