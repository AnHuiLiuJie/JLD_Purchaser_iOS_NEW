//
//  ChoseModel.h
//  DCProject
//
//  Created by 陶锐 on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChoseModel : NSObject
@property(nonatomic,copy)NSString *choseName;
@property(nonatomic,copy)NSString *choseId;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
