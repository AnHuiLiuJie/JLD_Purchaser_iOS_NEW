//
//  GLPToPayHeadView.h
//  DCProject
//
//  Created by LiuMac on 2021/8/12.
//HeaderView.xib

#import <UIKit/UIKit.h>
#import "GLPOrderForPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPToPayHeadView : UIView

@property (nonatomic, strong) GLPOrderForPayModel *model;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;

@end

NS_ASSUME_NONNULL_END
