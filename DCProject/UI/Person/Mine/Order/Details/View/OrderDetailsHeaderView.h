//
//  OrderDetailsHeaderView.h
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgView_Y_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;



@end

NS_ASSUME_NONNULL_END
