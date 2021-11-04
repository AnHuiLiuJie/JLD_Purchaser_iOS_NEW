//
//  UIBarButtonItem+Extension.h
//  DCProject
//
//  Created by LiuMac on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Extension)

+ (instancetype) itemWithImage:(NSString *) imageName hightlightedImage:(NSString *) highlightedImageName target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
