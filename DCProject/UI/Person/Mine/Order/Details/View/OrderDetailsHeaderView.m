//
//  OrderDetailsHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderDetailsHeaderView.h"

@interface OrderDetailsHeaderView()



@end


@implementation OrderDetailsHeaderView


#pragma mark - initialize
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.bgView_Y_LayoutConstraint.constant = kNavBarHeight+10;

//    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
//    _gradeImg.userInteractionEnabled = YES;
//    [_gradeImg addGestureRecognizer:tapGesture1];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

