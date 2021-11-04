//
//  GLPCustomXFView.h
//  DCProject
//
//  Created by 赤道 on 2021/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^XFViewCloseBlock)(void);
typedef void(^XFViewTapBlock)(NSDictionary *linkDic);



@interface GLPCustomXFView : UIView

//- (instancetype)initWithFrame:(CGRect)frame params:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn;

- (void)initSubViewsparams:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn;

@property (nonatomic,copy)XFViewTapBlock tapBlock;

@property (nonatomic,copy)XFViewCloseBlock closeBlock;

@property (nonatomic,strong) UIImageView *showImg;


/** 单利创建 - Method
*/

+ (instancetype)sharedManagerInitWithFrame:(CGRect)frame params:(NSDictionary *)params isCloseBtn:(BOOL)isCloseBtn;

/** 单利销毁 - Method
*/

- (void)removeSharedManager;


@end

NS_ASSUME_NONNULL_END
