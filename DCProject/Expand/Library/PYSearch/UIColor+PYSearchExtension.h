//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIColor (PYSearchExtension)

/**
 Returns the corresponding color according to the hexadecimal string.

 @param hexString   hexadecimal string(eg:@"#ccff88")
 @return new instance of `UIColor` class
 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString;

/**
  Returns the corresponding color according to the hexadecimal string and alpha.

 @param hexString   hexadecimal string(eg:@"#ccff88")
 @param alpha       alpha
 @return new instance of `UIColor` class
 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
NS_ASSUME_NONNULL_END
