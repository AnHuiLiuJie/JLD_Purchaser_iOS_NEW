//
//  CommonPageControl.m
//  DCProject
//
//  Created by LiuMac on 2021/9/30.
//

#import "CommonPageControl.h"

@implementation CommonPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        
    }
    
    return self;
    
}

-(void)updateDots{
    
    for(int i=0;i<[self.subviews count];i++){
        
        if([(UIView *)[self.subviews objectAtIndex:i] isKindOfClass:[UIView class]]){//目前pageControl控件小点是一个view
            
            UIView *dot=[self.subviews objectAtIndex:i];
            
            if(i==self.currentPage){
                
                dot.backgroundColor=[UIColor redColor];
                
            }
            
            else{
                
                dot.backgroundColor = [UIColor greenColor];
                
            }
            
        }
        
    }
    
}

//重写基类方法
-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    
    [self updateDots];
    
}

@end

