//
//  GLPGoodsDetailsWebCell.h
//  DCProject
//
//  Created by bigbing on 2020/3/12.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GLPGoodsDetailModel.h"

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GLPGoodsDetailsWebCell : UITableViewCell


@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *bgView;


- (void)dc_setValueWithModel:(GLPGoodsDetailModel *)detailModel selctButton:(NSString *)selctButton viewHeight:(CGFloat)viewHeight;


// 刷新
@property (nonatomic, copy) dispatch_block_t reloadBlock;





@end

NS_ASSUME_NONNULL_END
