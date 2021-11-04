//
//  GLPEtpStatementsDetailVC.h
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import "DCBasicViewController.h"
#import "StatementsDetailListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpStatementsDetailVC : DCBasicViewController

@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, assign) CGFloat view_H;

@property (nonatomic, strong) NSString *orderNo;


@end

NS_ASSUME_NONNULL_END
