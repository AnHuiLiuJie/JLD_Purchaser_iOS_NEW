//
//  DCPlaceholderTool.h
//  DCProject
//
//  Created by bigbing on 2019/9/3.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCPlaceholderTool : NSObject

+ (DCPlaceholderTool *) shareTool;


- (void)dc_updatePlaceholderImage;


- (UIImage *)dc_placeholderImage;

@end

NS_ASSUME_NONNULL_END
