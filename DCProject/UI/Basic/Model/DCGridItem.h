//
//  DCGridItem.h
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCGridItem : NSObject

/** 图片  */
@property (nonatomic, copy ,readonly) NSString *iconImage;
/** 文字  */
@property (nonatomic, copy ) NSString *gridTitle;
/** tag  */
@property (nonatomic, copy ) NSString *gridTag;
/** tag颜色  */
@property (nonatomic, copy ,readonly) NSString *gridColor;


@end

NS_ASSUME_NONNULL_END
