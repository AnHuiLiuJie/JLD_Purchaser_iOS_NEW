//
//  UITextView+placeholder.m
//  Pole
//
//  Created by 赤道 on 2018/12/14.
//  Copyright © 2018 刘伟. All rights reserved.
//

#import "UITextView+placeholder.h"
#import <objc/runtime.h>
#define LEFT_MARGIN 1
#define TOP_MARGIN  5

@implementation UITextView (placeholder)

- (NSString *)placeholder{
    [self textDidChange:nil];
    return self.label.text;
}

- (void)setPlaceholder:(NSString *)placeholder{
    //赋值修改高度
    self.label.text = placeholder;

    [self changeLabelFrame];
    //监听文本改变,如果没有设置placeholder就不会监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

//文本修改
 - (void)textDidChange:(NSNotification *)notify{
     self.label.hidden = self.text.length;
 }

- (UILabel *)label{
    UILabel *label =  objc_getAssociatedObject(self, @"label");
    if (label == nil) {
        //没有就创建,并设置属性
        label = [[UILabel alloc] init];
        label.font = self.font;
        label.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [self addSubview:label];
        //关联到自身
        objc_setAssociatedObject(self, @"label", label, OBJC_ASSOCIATION_RETAIN);
        
    }
    return label;
    
}

//计算frame
- (void)changeLabelFrame{
    //文字可显示区域
    CGSize size = CGSizeMake(self.bounds.size.width - 2*LEFT_MARGIN, CGFLOAT_MAX);
    //计算文字所占区域
    CGSize labelSize = [self.placeholder boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.label.font} context:nil].size;
    
    self.label.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, labelSize.width, labelSize.height);
    
}

@end
