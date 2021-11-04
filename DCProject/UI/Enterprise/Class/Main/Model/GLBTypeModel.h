//
//  GLBTypeModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBTypeModel : NSObject

@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, copy) NSString *catPic;
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, strong) NSArray *son;

//"catId": 11,
//"catName": "化学药品",
//"catPic": "",
//"goodsNum": 23128,
//"son": [
//        ]

@end



NS_ASSUME_NONNULL_END
