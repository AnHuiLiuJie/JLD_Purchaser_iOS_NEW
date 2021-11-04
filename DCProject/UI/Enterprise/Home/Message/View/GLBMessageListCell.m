//
//  GLBMessageListCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBMessageListCell.h"

@interface GLBMessageListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GLBMessageListCell

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
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"wdxx_xtxx"];
    [_iconImage dc_cornerRadius:22];
    [_bgView addSubview:_iconImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#272636"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"系统消息";
    [_bgView addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#95A1A6"];
    _descLabel.font = [UIFont fontWithName:PFR size:14];
    _descLabel.text = @"";
    [_bgView addSubview:_descLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#D2D7D9"];
    _timeLabel.font = [UIFont fontWithName:PFR size:11];
    _timeLabel.text = @"";
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_timeLabel];
    
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = PFRFont(10);
    _countLabel.text = @"0";
    _countLabel.hidden = YES;
    [_countLabel dc_cornerRadius:8];
    _countLabel.backgroundColor = [UIColor redColor];
    [_bgView addSubview:_countLabel];
    
//    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [_readImage setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(13);
        make.bottom.equalTo(self.bgView.bottom).offset(-13);
        make.left.equalTo(self.bgView.left).offset(18);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(15);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.width.equalTo(40);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
//        make.right.greaterThanOrEqualTo(self.timeLabel.left).offset(-8);
        make.left.equalTo(self.titleLabel.right).offset(8);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.right.equalTo(self.timeLabel.right);
        make.bottom.equalTo(self.iconImage.bottom);
    }];
    
}


#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    _titleLabel.text = _title;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    
    _iconImage.image = [UIImage imageNamed:_image];
}


- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    _descLabel.text = _subTitle;
}


#pragma mark - 赋值
- (void)setCountDictValue:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath
{
    self.countLabel.hidden = YES;
    
    if (indexPath.row == 0) {
        NSArray *hConversations = [[HDClient sharedClient].chatManager loadAllConversations];
        long unreadCount = 0;
        for (HDConversation *conv in hConversations) {
            unreadCount += conv.unreadMessagesCount;
        }
        if (unreadCount > 0) {
            self.countLabel.hidden = NO;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",unreadCount];
        }
    }

    if (indexPath.row == 1 && dict && dict[@"sysMsgCount"]) {
        NSInteger sysMsgCount = [dict[@"sysMsgCount"] integerValue];
        if (sysMsgCount > 0) {
//            if (sysMsgCount > 99) {
//                sysMsgCount = 99;
//            }
            self.countLabel.hidden = NO;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",sysMsgCount];
        }
    }

    if (indexPath.row == 2 && dict && dict[@"orderMsgCount"]) {
        NSInteger orderMsgCount = [dict[@"orderMsgCount"] integerValue];
        if (orderMsgCount > 0) {
            self.countLabel.hidden = NO;
            self.countLabel.text = [NSString stringWithFormat:@"%ld",orderMsgCount];
        }
    }
}

@end
