//
//  ReasonEvaluationView.h
//  DCProject
//
//  Created by LiuMac on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "HAppraiseTagsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReasonEvaluationViewDelegate <NSObject>

- (void)dc_evaluationTagSelectWithArray:(NSArray *)tags;

@end

@interface ReasonEvaluationView : UIView
//不满意原因：100-回复不及时，010-服务态度差，001-客服对业务不熟悉（111-表示三个原因都选中）

@property (nonatomic, assign) NSInteger indexType;
@property (nonatomic, weak) id<ReasonEvaluationViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

// 标记 1 选中 第一个。2 选中第二个  3选中第三个。12。13 23 123
@property (nonatomic, assign) NSUInteger mark;

//记录选择的标签
@property (nonatomic, strong) NSMutableArray *selectTagsArray;


@end

NS_ASSUME_NONNULL_END
