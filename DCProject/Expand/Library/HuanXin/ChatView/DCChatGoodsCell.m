//
//  DCChatGoodsCell.m
//  DCProject
//
//  Created by bigbing on 2019/12/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCChatGoodsCell.h"

@implementation DCChatGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _logoImage = [[UIImageView alloc] init];
    [_logoImage dc_cornerRadius:20];
    _logoImage.contentMode = UIViewContentModeScaleAspectFill;
    _logoImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_logoImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.text = @"客服";
    [self.contentView addSubview:_nameLabel];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bgView];
    
    
//    _bgImage.image = self.model.isSender ?[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_full"]: [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing_full"];
    
//    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
//       [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];

    _bgImage = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"];
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    _bgImage.image = newImage;
    [_bgView addSubview:_bgImage];
    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsAction:)];
    [_bgView addGestureRecognizer:tap];
    
//    @property (nonatomic) UIEdgeInsets rightBubbleMargin
//    isSender?_rightBubbleMargin:_leftBubbleMargin
//    _bubbleView = [[EaseBubbleView alloc] initWithMargin:leftBubbleMargin isSender:YES];
//    _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
//    _bubbleView.backgroundColor = [UIColor clearColor];
//    [_bgView addSubview:_bubbleView];
    
    _subBgView = [[UIView alloc] init];
    _subBgView.backgroundColor = [UIColor dc_colorWithHexString:@"#F9F9F9"];
    [_bgView addSubview:_subBgView];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
//    [_goodsImage dc_cornerRadius:3];
    _goodsImage.image = [[DCPlaceholderTool shareTool] dc_placeholderImage];
    [_subBgView addSubview:_goodsImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"订单号：";
    _titleLabel.numberOfLines = 1;
    [_subBgView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#A5A5A5"];
    _subLabel.text = @"共0件商品 合计 ¥0.00";
    _subLabel.font = PFRFont(13);
    [_subBgView addSubview:_subLabel];
    
    [self updateMasonryWidthType:NO];
}


#pragma mark - action
- (void)goodsAction:(id)sender
{
    if (_cellBlock) {
        _cellBlock(_messageModel);
    }
}


#pragma mark -
- (void)updateMasonryWidthType:(BOOL)isLeft
{
    if (isLeft) {

        [_logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(10);
            make.top.equalTo(self.contentView.top).offset(10);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImage.right).offset(10);
            make.top.equalTo(self.logoImage.top);
            make.right.equalTo(self.contentView.right).offset(-60);
        }];
        
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.nameLabel.right);
            make.top.equalTo(self.nameLabel.bottom).offset(3);
            make.height.equalTo(75);
        }];
        
        [_bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        
        [_subBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left).offset(15);
            make.right.equalTo(self.bgView.right).offset(-10);
            make.top.equalTo(self.bgView.top).offset(10);
            make.bottom.equalTo(self.bgView.bottom).offset(-10);
        }];
        
        [_goodsImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.subBgView);
            make.width.equalTo(self.goodsImage.height);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImage.right).offset(10);
            make.right.equalTo(self.subBgView.right).offset(-10);
            make.top.equalTo(self.subBgView.top).offset(7);
        }];
        
        [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.bottom).offset(1);
        }];
        
    } else {
        
        [_logoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-10);
            make.top.equalTo(self.contentView.top).offset(10);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.logoImage.left).offset(-10);
            make.bottom.equalTo(self.logoImage.top);
            make.left.equalTo(self.contentView.left).offset(60);
        }];
        
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(60);
            make.right.equalTo(self.logoImage.left).offset(-10);
            make.top.equalTo(self.logoImage.top).offset(3);
            make.height.equalTo(75);
        }];
        
        [_bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        
        [_subBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.left).offset(10);
            make.right.equalTo(self.bgView.right).offset(-20);
            make.top.equalTo(self.bgView.top).offset(10);
            make.bottom.equalTo(self.bgView.bottom).offset(-10);
        }];
        
        [_goodsImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.subBgView);
            make.width.equalTo(self.goodsImage.height);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImage.right).offset(10);
            make.right.equalTo(self.subBgView.right).offset(-10);
            make.top.equalTo(self.subBgView.top).offset(7);
        }];
        
        [_subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.bottom).offset(1);
        }];
    }
    
    
}


#pragma mark - public

+ (NSString *)cellIdentifier
{
    return @"DCChatGoodsCell";
}


#pragma mark - NSMutableAttributedString
- (NSMutableAttributedString *)dc_attStrWithPrice:(NSString *)price
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",price]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:11]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15]} range:NSMakeRange(1, attStr.length - 1)];
    return attStr;
}


#pragma mark - setter
- (void)setMessageModel:(HDMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    NSDictionary *userInfo = [[DCUpdateTool shareClient].easeUserDict objectForKey:[NSString stringWithString:_messageModel.message.from]];
    if (userInfo && ![userInfo[@"headImg"] dc_isNull]) {
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:userInfo[@"headImg"]] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    }else{
        self.logoImage.image = [UIImage imageNamed:@"chatListCellHead"];
    }
    if (userInfo && ![userInfo[@"nickname"] dc_isNull]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",userInfo[@"nickname"]];
    }else{
        _nameLabel.text = _messageModel.nickname;
    }
    
    if (_messageModel.message.ext) {
        NSDictionary *dict = _messageModel.message.ext;
        if (dict[DC_Custom_Message_Key] && [dict[DC_Custom_Message_Key] isKindOfClass:[NSString class]]) {
            NSDictionary *params = [dict[DC_Custom_Message_Key] mj_JSONObject];
            
            DCChatGoodsModel *model = [DCChatGoodsModel mj_objectWithKeyValues:params];
            if (model && model.type && [model.type isEqualToString:@"1"]) { // 商品
                
                [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImage] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
                _titleLabel.text = model.goodsName;
                _subLabel.attributedText = [self dc_attStrWithPrice:model.price];
                _subLabel.textColor = [UIColor dc_colorWithHexString:@"#FF1019"];
                
            } else if (model && model.type && [model.type isEqualToString:@"2"]) { // 订单
                
                [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goodsImage] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
                _titleLabel.text = [NSString stringWithFormat:@"订单号:%@", model.orderNo];
                _subLabel.text = [NSString stringWithFormat:@"共%@件商品 合计 ¥%@",model.goodsCount,model.totalPrice];
                _subLabel = [UILabel setupAttributeLabel:_subLabel textColor:nil minFont:[UIFont fontWithName:PFR size:12]  maxFont:nil forReplace:@"¥"];
                _subLabel.textColor = [UIColor dc_colorWithHexString:@"#A5A5A5"];
                _subLabel.font = PFRFont(13);
            }
        }
    }
    
    if (_messageModel && _messageModel.message && _messageModel.message.direction == EMMessageDirectionReceive) {
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        
        UIImage *image = [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:35 topCapHeight:35];
        _bgImage.image = newImage;
        
        [self updateMasonryWidthType:YES];
        
    } else {
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
        UIImage *image = [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:5 topCapHeight:35];
        _bgImage.image = newImage;
        
        [self updateMasonryWidthType:NO];
    }
}

@end
