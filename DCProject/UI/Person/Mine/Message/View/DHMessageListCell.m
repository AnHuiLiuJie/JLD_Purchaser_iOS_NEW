//
//  DHMessageListCell.m
//  DCProject
//
//  Created by Apple on 2019/9/26.
//  Copyright © 2019年 bigbing. All rights reserved.
//

#import "DHMessageListCell.h"


@implementation DHMessageListCell

+(DHMessageListCell *)cellShareInstnce:(UITableView *)tableView with:(NSIndexPath *)indexPath{
    id obj = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    if(obj == nil){
        obj = [[[self class] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    NSLog(@"====obj:%@",NSStringFromClass([self class]));
    return obj;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.msgLB.clipsToBounds = YES;
    self.msgLB.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;
    
    if ([_model.title length] > 0) {
        self.titleLB.text = _model.title;
    }
    else{
        self.titleLB.text = _model.conversation.conversationId;
    }
    
    if ([_model.avatarURLPath length] > 0){
        [self.messageIcon sd_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholderImage:_model.avatarImage];
    } else {
        if (_model.avatarImage) {
            self.messageIcon.image = _model.avatarImage;
        }
    }
    
//    if (_model.conversation.unreadMessagesCount == 0) {
//        _messageIcon.showBadge = NO;
//    }
//    else{
//        messageIcon.showBadge = YES;
//        messageIcon.badge = _model.conversation.unreadMessagesCount;
//    }
    
    self.msgLB.hidden = _model.conversation.unreadMessagesCount <= 0;
    if (_model.conversation.unreadMessagesCount < 10) {
        self.msgLB.text = [NSString stringWithFormat:@"%ld",(long)_model.conversation.unreadMessagesCount];
    }else if (_model.conversation.unreadMessagesCount < 100) {
        self.msgLB.text = [NSString stringWithFormat:@"%ld",(long)_model.conversation.unreadMessagesCount];
    }else{
        self.msgLB.text = @"99+";
    }
    if (_model.conversation.unreadMessagesCount < 10) {
        self.msgWidthLB.constant = 16;
    }else if (_model.conversation.unreadMessagesCount < 100) {
        self.msgWidthLB.constant = 24;
    }else{
        self.msgWidthLB.constant = 32;
    }
}

@end
