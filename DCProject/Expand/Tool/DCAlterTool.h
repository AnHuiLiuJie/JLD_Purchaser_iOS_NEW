//
//  DCAlterTool.h
//  DCProject
//
//  Created by bigbing on 2019/3/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCAlterTool : NSObject


// 创建单列
+ (DCAlterTool *)shareTool;


/*！ 显示弹框：确定选项+取消选项  */
- (void)showDefaultWithTitle:(NSString *_Nullable)title
                     message:(NSString *_Nullable)message
                defaultTitle:(NSString *)defaultTitle
                     handler:(void (^)(UIAlertAction *action))handler;


/*! 显示弹框：仅取消选项 */
- (void)showCancelWithTitle:(NSString *_Nullable)title
                    message:(NSString *_Nullable)message
                cancelTitle:(NSString *)cancelTitle;


/*! 显示弹框：仅确定选项 */
- (void)showDoneWithTitle:(NSString *_Nullable)title
                  message:(NSString *_Nullable)message
             defaultTitle:(NSString *)defaultTitle
                  handler:(void (^)(UIAlertAction *action))handler;


/*! 显示弹框：自定义选项 + 自定义选项 */
- (void)showCustomWithTitle:(NSString *_Nullable)title
                    message:(NSString *_Nullable)message
               customTitle1:(NSString *)customTitle1
                   handler1:(void (^)(UIAlertAction *action))handler1
               customTitle2:(NSString *)customTitle2
                   handler2:(void (^)(UIAlertAction *action))handler2;

@end

NS_ASSUME_NONNULL_END
