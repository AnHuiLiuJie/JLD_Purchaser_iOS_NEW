
#import "UIView+DCRolling.h"

@implementation UIView (DCRolling)

- (CGFloat)dc_x
{
    return self.frame.origin.x;
}

- (void)setDc_x:(CGFloat)dc_x
{
    CGRect dcFrame = self.frame;
    dcFrame.origin.x = dc_x;
    self.frame = dcFrame;
}

- (CGFloat)dc_y
{
    return self.frame.origin.y;
}

- (void)setDc_y:(CGFloat)dc_y
{
    CGRect dcFrame = self.frame;
    dcFrame.origin.y = dc_y;
    self.frame = dcFrame;
}

-(CGPoint)dc_origin
{
    return self.frame.origin;
}

- (void)setDc_origin:(CGPoint)dc_origin
{
    CGRect dcFrame = self.frame;
    dcFrame.origin = dc_origin;
    self.frame = dcFrame;
}

- (CGFloat)dc_width
{
    return self.frame.size.width;
}

- (void)setDc_width:(CGFloat)dc_width
{
    CGRect dcFrame = self.frame;
    dcFrame.size.width = dc_width;
    self.frame = dcFrame;
}

- (CGFloat)dc_height
{
    return self.frame.size.height;
}

- (void)setDc_height:(CGFloat)dc_height
{
    CGRect dcFrame = self.frame;
    dcFrame.size.height = dc_height;
    self.frame = dcFrame;
}

-(CGSize)dc_size
{
    return self.frame.size;
}

- (void)setDc_size:(CGSize)dc_size
{
    CGRect dcFrame = self.frame;
    dcFrame.size = dc_size;
    self.frame = dcFrame;
}

- (CGFloat)dc_centerX{
    
    return self.center.x;
}

- (void)setDc_centerX:(CGFloat)dc_centerX{
    
    CGPoint dcFrmae = self.center;
    dcFrmae.x = dc_centerX;
    self.center = dcFrmae;
}

- (CGFloat)dc_centerY{
    
    return self.center.y;
}

- (void)setDc_centerY:(CGFloat)dc_centerY{
    
    CGPoint dcFrame = self.center;
    dcFrame.y = dc_centerY;
    self.center = dcFrame;
}

- (CGFloat)dc_right{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)dc_bottom{
    
    return CGRectGetMaxY(self.frame);
}

- (void)setDc_right:(CGFloat)dc_right{
    
    self.dc_x = dc_right - self.dc_width;
}

- (void)setDc_bottom:(CGFloat)dc_bottom{
    
    self.dc_y = dc_bottom - self.dc_height;
}

- (BOOL)intersectWithView:(UIView *)view{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (BOOL)isShowingOnKeyWindow {
    // ?????????
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // ????????????????????????????????????, ??????self????????????
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // ????????????bounds ??? self???????????? ???????????????
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

+(instancetype)dc_viewFromXib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

-(id)dc_changeControlCircularWith:(id)anyControl AndSetCornerRadius:(NSInteger)radius SetBorderWidth:(NSInteger)width SetBorderColor:(UIColor *)borderColor canMasksToBounds:(BOOL)can
{
    //TODO ??????iOS13????????????
//    CALayer *icon_layer = [anyControl layer];
    CALayer *icon_layer = [(UILabel *)anyControl layer];
    [icon_layer setCornerRadius:radius];
    [icon_layer setBorderWidth:width];
    [icon_layer setBorderColor:[borderColor CGColor]];
    [icon_layer setMasksToBounds:can];
    
    return anyControl;
}

@end
