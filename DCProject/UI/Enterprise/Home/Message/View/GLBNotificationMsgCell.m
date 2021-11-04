//
//  GLBNotificationMsgCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBNotificationMsgCell.h"

@interface GLBNotificationMsgCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLBNotificationMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self dc_cornerRadius:6];

    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFR size:14];
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(29, 23, 29, 23));
    }];
    
}



#pragma mark - setter
- (void)setMessageModel:(GLBMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _titleLabel.text = _messageModel.msgContent;
}

@end
