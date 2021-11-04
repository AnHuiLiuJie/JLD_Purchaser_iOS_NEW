//
//  DCSpeedy.h
//  XbdStation
//
//  Created by 赤道 on 2019/8/7.
//  Copyright © 2019 赤道. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCSpeedy : NSObject

//把字符串 包含汉字的转换成字符数
+ (NSInteger)is_Chinese_Conversion_To_CharNumber:(NSString *)str;

/*截取时间
@param  numDays 截取多少天 date当前时间
@return 推延的时间
*/
+ (NSDate *)offsetDay:(int)numDays date:(NSDate *)date;
/*计算两个日期字符串的差值*/
+ (NSString *)getTotalTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)getNowTimeTimesForm:(NSString *)str;
+ (int)getTotalTimeForIntWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
/**
 设置按钮的圆角
 
 @param anyControl 控件
 @param radius 圆角度
 @param width 边宽度
 @param borderColor 边线颜色
 @param can 是否裁剪
 @return 控件
 */
+(id)dc_changeControlCircularWith:(id)anyControl AndSetCornerRadius:(NSInteger)radius SetBorderWidth:(NSInteger)width SetBorderColor:(UIColor *)borderColor canMasksToBounds:(BOOL)can;


/**
 选取部分数据变色（label）
 
 @param label label
 @param arrray 变色数组
 @param color 变色颜色
 @return label
 */
+(id)dc_setSomeOneChangeColor:(UILabel *)label SetSelectArray:(NSArray *)arrray SetChangeColor:(UIColor *)color;


#pragma mark -  根据传入字体大小计算字体宽高
+ (CGSize)dc_calculateTextSizeWithText : (NSString *)text WithTextFont: (NSInteger)textFont WithMaxW : (CGFloat)maxW ;
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

/**
 下划线
 
 @param view 下划线
 */
+ (void)dc_setUpAcrossPartingLineWith:(UIView *)view WithColor:(UIColor *)color;

/**
 竖线线
 
 @param view 竖线线
 */
+ (void)dc_setUpLongLineWith:(UIView *)view WithColor:(UIColor *)color WithHightRatio:(CGFloat)ratio;


/**
 利用贝塞尔曲线设置圆角

 @param control 按钮
 @param size 圆角尺寸
 */
+ (void)dc_setUpBezierPathCircularLayerWithControl:(UIButton *)control size:(CGSize)size;

+ (void)dc_setUpBezierPathCircularLayerWithControl:(UIView *)control byRoundingCorners:(UIRectCorner)corners size:(CGSize)size;


/**
 label首行缩进

 @param label label
 @param emptylen 缩进比
 */
+ (void)dc_setUpLabel:(UILabel *)label Content:(NSString *)content IndentationFortheFirstLineWith:(CGFloat)emptylen;


/**
 字符串加星处理

 @param content NSString字符串
 @param findex 第几位开始加星
 @return 返回加星后的字符串
 */
+ (NSString *)dc_encryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex;



/**
 取随机数

 @param StarNum 开始值
 @param endNum 结束值
 @return 从开始值到结束值之间的随机数
 */
+ (NSInteger)dc_GetRandomNumber:(NSInteger)StarNum to:(NSInteger)endNum;


#pragma mark - 图片转base64编码
+ (NSString *)UIImageToBase64Str:(UIImage *) image;

#pragma mark - base64图片转编码
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

+ (void)dc_SetUpAlterWithView:(UIViewController *)vc Message:(NSString *)message Sure:(dispatch_block_t)sureBlock Cancel:(dispatch_block_t)cancelBlock;



/**
 触动
 */
+ (void)dc_callFeedback;


#pragma mark - 获取当前的时间
+ (NSString *)getCurrentTimes;


/**
 获取当前控制器
 */
+ (UIViewController *)dc_getCurrentVC;



#pragma mark - 文本框限制数
/**
 输入框字数限制,输入达不到限制就不能输入了,拼音
 @param  textField 输入框 length限制字数
 */
+ (void)editChange:(UITextField*)textField length:(int)kMaxLength;

+ (void)editTextViewChange:(UITextView*)textView length:(NSInteger)kMaxLength;


#pragma mark - 判断字符非空
+  (BOOL)isBlankString:(NSString *)string;

//iOS 13之前获取KeyWindow直接使用[UIApplication sharedApplication].keyWindow。iOS 13这个属性被废弃了。
+ (UIWindow *)getKeyWindow;

@end
