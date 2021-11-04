//
//  DCProtocolCell.m
//  DCProject
//
//  Created by bigbing on 2020/4/27.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "DCProtocolCell.h"

@implementation DCProtocolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (void)setUpUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    
}

@end
