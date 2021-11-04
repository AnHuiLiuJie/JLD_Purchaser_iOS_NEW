//
//  GLPTicketSgnCell.m
//  DCProject
//
//  Created by bigbing on 2019/9/21.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPTicketSgnCell.h"

@interface GLPTicketSgnCell ()

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
//@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *subTipLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GLPTicketSgnCell

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
    
    [self.contentView dc_cornerRadius:6];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.image = [UIImage imageNamed:@"dc_yhq_ky"];
    [self.contentView addSubview:_bgImage];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _moneyLabel.attributedText = [self dc_attrStr:@"0.00"];
    [self.contentView addSubview:_moneyLabel];
    
    _requireLabel = [[UILabel alloc] init];
    _requireLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _requireLabel.font = PFRFont(11);
    _requireLabel.text = @"满0元可用";
    [self.contentView addSubview:_requireLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    _timeLabel.font = PFRFont(11);
    _timeLabel.text = @"有效期至-";
    [self.contentView addSubview:_timeLabel];
    
//    _tipLabel = [[UILabel alloc] init];
//    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#858585"];
//    _tipLabel.font = PFRFont(13);
//    _tipLabel.text = @"仅可购买金利达大药房部分商品";
//    [self.contentView addSubview:_tipLabel];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5800"];
    _statusLabel.font = PFRFont(13);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.text = @"立即领取";
    [self.contentView addSubview:_statusLabel];
    
    _subTipLabel = [[UILabel alloc] init];
    _subTipLabel.textColor = [UIColor dc_colorWithHexString:@"#847A79"];
    _subTipLabel.font = PFRFont(11);
    _subTipLabel.text = @"购物车中以下商品适用该券";
    [self.contentView addSubview:_subTipLabel];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bounces = NO;
    [self.contentView addSubview:_scrollView];
    
    [self layoutIfNeeded];
}


#pragma mark - 返回富文本
- (NSMutableAttributedString *)dc_attrStr:(NSString *)money
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",money]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:14]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:30]} range:NSMakeRange(1,attStr.length -1)];
    return attStr;
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(85);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImage.centerY);
        make.right.equalTo(self.contentView.right);
        make.width.equalTo(kScreenW*0.3);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [_requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.top.equalTo(self.moneyLabel.bottom).offset(-3);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.requireLabel.right).offset(5);
        make.centerY.equalTo(self.requireLabel.centerY);
    }];
    
//    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.moneyLabel.left);
//        make.top.equalTo(self.requireLabel.bottom).offset(3);
//    }];
    
    [_subTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.top.equalTo(self.bgImage.bottom).offset(5);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.left);
        make.right.equalTo(self.contentView.right).offset(-10);
        make.height.equalTo(54);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
        make.top.equalTo(self.subTipLabel.bottom).offset(5);
    }];
}


#pragma mark - setter
- (void)setTicketModel:(GLPTicketSgnTicketModel *)ticketModel
{
    _ticketModel = ticketModel;
    
    _moneyLabel.attributedText = [self dc_attrStr:[NSString stringWithFormat:@"%@",_ticketModel.discountAmount]];
    _requireLabel.text = [NSString stringWithFormat:@"满%@元可用",_ticketModel.requireAmount];
    
    NSString *time = _ticketModel.useEndDate;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    if ([time containsString:@"-"]) {
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"有效期至%@",time];
    
    if (_ticketModel.isReceive && [_ticketModel.isReceive isEqualToString:@"1"]) {
         _statusLabel.text = @"已领取";
    } else {
         _statusLabel.text = @"立即领取";
    }
    
    for (id class in self.scrollView.subviews) {
        [class removeFromSuperview];
    }
    if (_ticketModel.goodsList && [_ticketModel.goodsList count] >0) {
        for (int i=0; i<_ticketModel.goodsList.count; i++) {
            GLPTicketSgnGoodsModel *goodsModel = _ticketModel.goodsList[i];
            
            UIImageView *image = [[UIImageView alloc] init];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [self.scrollView addSubview:image];
            
            CGFloat y = i*(54+10);
            
            if (i == _ticketModel.goodsList.count - 1) {
                self.scrollView.contentSize = CGSizeMake(y, 54);
            }
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView.left).offset(y);
                make.centerY.equalTo(self.scrollView.centerY);
                make.size.equalTo(CGSizeMake(54, 54));
            }];
            
            [image sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg1] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        }
        
    } else {
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [self.scrollView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.left).offset(0);
            make.centerY.equalTo(self.scrollView.centerY);
            make.size.equalTo(CGSizeMake(54, 54));
        }];
        
        [image sd_setImageWithURL:[NSURL URLWithString:_ticketModel.goodsImg1] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        
        self.scrollView.contentSize = CGSizeMake(54, 54);
    }
}



@end
