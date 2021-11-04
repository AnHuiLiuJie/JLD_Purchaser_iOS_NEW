//
//  TRMessageListCell.m
//  DCProject
//
//  Created by 陶锐 on 2019/9/10.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRMessageListCell.h"

@implementation TRMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
