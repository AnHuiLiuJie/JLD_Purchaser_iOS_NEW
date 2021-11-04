//
//  GLBStoreRangView.m
//  DCProject
//
//  Created by bigbing on 2019/8/16.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreRangView.h"

@interface GLBStoreRangView ()

@end

@implementation GLBStoreRangView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



- (void)setRangArray:(NSArray *)rangArray
{
    _rangArray = rangArray;
    
    for (id class in self.subviews) {
        [class removeFromSuperview];
    }
    
    CGFloat x = 0;
    
    for (NSInteger i=0; i<_rangArray.count; i++) {
        NSDictionary *dict = _rangArray[i];
        NSString *title = dict[@"value"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        label.font = PFRFont(11);
        label.textAlignment = NSTextAlignmentCenter;
        [label dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#00B7AB"] radius:2];
        [self addSubview:label];
        
        
        CGSize size = [label sizeThatFits:CGSizeMake(200, 18)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(x);
            make.centerY.equalTo(self.centerY);
            make.size.equalTo(CGSizeMake(size.width + 20, 18));
        }];
        
        x = x + size.width+20 + 10;
    }
}

@end
