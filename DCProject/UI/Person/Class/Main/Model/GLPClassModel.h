//
//  GLPClassModel.h
//  DCProject
//
//  Created by bigbing on 2019/9/18.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLPClassModel : NSObject

@property (nonatomic, assign) NSInteger catId; // 分类ID
@property (nonatomic, copy) NSString *catName; // 分类名称
@property (nonatomic, copy) NSString *catPic; // 分类icon图片路径
@property (nonatomic, assign) NSInteger pcatId;
@property (nonatomic, copy) NSString *searchCatId; // 跳转分类ID
@property (nonatomic, strong) NSArray *son; // 下级分类

@end

NS_ASSUME_NONNULL_END
