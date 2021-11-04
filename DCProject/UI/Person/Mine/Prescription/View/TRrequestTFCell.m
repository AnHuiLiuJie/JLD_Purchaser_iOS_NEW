//
//  TRrequestTFCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRrequestTFCell.h"

@implementation TRrequestTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightTF.textColor = [UIColor blackColor];
    self.rightTF.attributedPlaceholder = [NSString dc_placeholderWithString:@"如有特殊要求，可在此处填写"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
