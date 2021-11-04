//
//  GLBNewsModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/7.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBNewsModel : NSObject

@property (nonatomic, copy) NSString *iD;
@property (nonatomic, copy) NSString *infoTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsImg;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *catIds;
@property (nonatomic, copy) NSString *catNames;
@property (nonatomic, copy) NSString *accessCount;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, strong) NSArray *catId;


@end


#pragma mark -
@interface GLBNewsCatIdModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *valuessssss;

@end

NS_ASSUME_NONNULL_END
