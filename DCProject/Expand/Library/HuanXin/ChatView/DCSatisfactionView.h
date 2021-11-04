//
//  DCSatisfactionView.h
//  DCProject
//
//  Created by LiuMac on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "HDIMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DCSatisfactionViewDelegate <NSObject>

@optional
- (void)commitSatisfactionWithControlArguments:(ControlArguments *)arguments type:(ControlType *)type reasonArray:(NSMutableArray *)reasonArray evaluationTagsArray:(NSMutableArray *)tags evaluationDegreeId:(NSNumber *)evaluationDegreeId;

@end

@interface DCSatisfactionView : UIView


@property (nonatomic, weak) id<DCSatisfactionViewDelegate> delegate;

@property (nonatomic, strong) id<HDIMessageModel> messageModel;

@property (nonatomic,copy) void(^DCSatisfactionViewBlock)(void);

- (void)showWithAnimation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
