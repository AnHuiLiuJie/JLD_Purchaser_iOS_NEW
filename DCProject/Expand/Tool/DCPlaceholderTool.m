//
//  DCPlaceholderTool.m
//  DCProject
//
//  Created by bigbing on 2019/9/3.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCPlaceholderTool.h"
#import "SDWebImageDownloader.h"

@implementation DCPlaceholderTool

+ (DCPlaceholderTool *) shareTool {
    static DCPlaceholderTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}


- (void)dc_updatePlaceholderImage
{
    [[DCAPIManager shareManager] dc_requestDefaultImageWithSuccess:^(id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            if (response && response[@"data"]) {
                NSString *imageUrl = response[@"data"];
                if (imageUrl) {
                    [DCObjectManager dc_saveUserData:imageUrl forKey:DC_Placeholder_Key];
                }
            }
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


- (UIImage *)dc_placeholderImage
{
    UIImage *image = nil;
    NSString *imageUrl = [DCObjectManager dc_readUserDataForKey:DC_Placeholder_Key];
    if (imageUrl) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage dc_initImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(kScreenW, kScreenH)];
    }
    return image;
}

@end
