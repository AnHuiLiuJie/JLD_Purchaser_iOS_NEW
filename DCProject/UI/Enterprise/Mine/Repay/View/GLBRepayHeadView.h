//
//  GLBRepayHeadView.h
//  DCProject
//
//  Created by bigbing on 2019/8/5.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^ClickBlock)(void);
typedef void (^LookBlock)(void);
typedef void (^ResetBlock)(void);
typedef void (^BeaginBlock)(void);
typedef void (^EndBlock)(void);
@interface GLBRepayHeadView : UIView
@property(nonatomic,copy)ClickBlock clickblock;
@property(nonatomic,copy)LookBlock lookblock;
@property(nonatomic,copy)ResetBlock resetblock;
@property(nonatomic,copy)BeaginBlock begainblock;
@property(nonatomic,copy)EndBlock endblock;
@property (nonatomic, strong) DCTextField *searchTF;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) DCTextField *beginTF;
@property (nonatomic, strong) DCTextField *endTF;
@property (nonatomic, strong) UILabel *andLabel;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@end

NS_ASSUME_NONNULL_END
