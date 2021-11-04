//
//  GLBAddInfoTFCell.h
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTextField.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBCompanyBlock)(NSString *companyName);
typedef void(^GLBTextFieldBlock)(NSString *text);

@interface GLBAddInfoTFCell : UITableViewCell

// 输入框
@property (nonatomic, strong) DCTextField *textField;


// 按钮点击回调
@property (nonatomic, copy) dispatch_block_t tfClickBlock;


// 输入完回调
@property (nonatomic, copy) GLBTextFieldBlock textFieldBlock;


// 输入完企业名称回调
@property (nonatomic, copy) GLBCompanyBlock companyBlock;


// 赋值 注册
- (void)setRegrsterValueWithContents:(NSArray *)contents indexPath:(NSIndexPath *)indexPath;


// 赋值 上传资料
- (void)setAddInfoValueWithContents:(NSArray *)contents index:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
