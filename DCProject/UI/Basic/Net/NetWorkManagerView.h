//
//  NetWorkManagerView.h
//  Pole
//
//  Created by 赤道 on 2020/1/14.
//  Copyright © 2020 刘伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkManagerView : UIView

@property (nonatomic, copy) void(^clickNewWorkBtnAction_Block)(NSInteger);

@property (nonatomic, assign) NSInteger isFristLoad;//1 首次安装尚未开启权限


@end

NS_ASSUME_NONNULL_END
