//
//  GLBGoodsTicketCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsTicketCell.h"

@interface GLBGoodsTicketCell ()

@property (nonatomic, strong) UIView *exclusiveView;
@property (nonatomic, strong) UILabel *exclusiveLabel;
@property (nonatomic, strong) UIButton *exclusiveBtn;
@property (nonatomic, strong) UIButton *exclusiveMoreBtn;
@property (nonatomic, strong) UIView *shopView;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UIButton *shopBtn;
@property (nonatomic, strong) UIButton *shopMoreBtn;
@property (nonatomic, strong) UIView *platformView;
@property (nonatomic, strong) UILabel *platformLabel;
@property (nonatomic, strong) UIButton *platformBtn;
@property (nonatomic, strong) UIButton *platformMoreBtn;

@property (nonatomic, strong) UIView *subView;

@end

@implementation GLBGoodsTicketCell

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
    
    _subView = [[UIView alloc] init];
    _subView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_subView];
    
    _exclusiveView = [[UIView alloc] init];
    _exclusiveView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_exclusiveView];
    
    _exclusiveLabel = [[UILabel alloc] init];
    _exclusiveLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _exclusiveLabel.text = @"品种专享";
    _exclusiveLabel.font = PFRFont(13);
    [_exclusiveView addSubview:_exclusiveLabel];
    
    _exclusiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exclusiveBtn setBackgroundImage:[UIImage imageNamed:@"ycj_yh"] forState:0];
    [_exclusiveBtn setTitle:@"" forState:0];
    [_exclusiveBtn setTitleColor:[UIColor dc_colorWithHexString:@"#EA504A"] forState:0];
    _exclusiveBtn.titleLabel.font = PFRFont(11);
    _exclusiveBtn.adjustsImageWhenHighlighted = NO;
    _exclusiveBtn.userInteractionEnabled = NO;
    [_exclusiveView addSubview:_exclusiveBtn];
    
    _exclusiveMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exclusiveMoreBtn setImage:[UIImage imageNamed:@"more"] forState:0];
    _exclusiveMoreBtn.adjustsImageWhenHighlighted = NO;
    _exclusiveMoreBtn.tag = 400;
    [_exclusiveMoreBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_exclusiveView addSubview:_exclusiveMoreBtn];
    
    _shopView = [[UIView alloc] init];
    _shopView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_shopView];
    
    _shopLabel = [[UILabel alloc] init];
    _shopLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _shopLabel.text = @"领商家券";
    _shopLabel.font = PFRFont(13);
    [_shopView addSubview:_shopLabel];
    
    _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopBtn setBackgroundImage:[UIImage imageNamed:@"ycj_yh"] forState:0];
    [_shopBtn setTitle:@"" forState:0];
    [_shopBtn setTitleColor:[UIColor dc_colorWithHexString:@"#EA504A"] forState:0];
    _shopBtn.titleLabel.font = PFRFont(11);
    _shopBtn.adjustsImageWhenHighlighted = NO;
    _shopBtn.userInteractionEnabled = NO;
    [_shopView addSubview:_shopBtn];
    
    _shopMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopMoreBtn setImage:[UIImage imageNamed:@"more"] forState:0];
    _shopMoreBtn.adjustsImageWhenHighlighted = NO;
    _shopMoreBtn.tag = 401;
    [_shopMoreBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shopView addSubview:_shopMoreBtn];
    
    _platformView = [[UIView alloc] init];
    _platformView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_platformView];
    
    _platformLabel = [[UILabel alloc] init];
    _platformLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _platformLabel.text = @"平台优惠";
    _platformLabel.font = PFRFont(13);
    [_platformView addSubview:_platformLabel];
    
    _platformBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_platformBtn setBackgroundImage:[UIImage imageNamed:@"ycj_yh"] forState:0];
    [_platformBtn setTitle:@"" forState:0];
    [_platformBtn setTitleColor:[UIColor dc_colorWithHexString:@"#EA504A"] forState:0];
    _platformBtn.titleLabel.font = PFRFont(11);
    _platformBtn.adjustsImageWhenHighlighted = NO;
    _platformBtn.userInteractionEnabled = NO;
    [_platformView addSubview:_platformBtn];
    
    _platformMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_platformMoreBtn setImage:[UIImage imageNamed:@"more"] forState:0];
    _platformMoreBtn.adjustsImageWhenHighlighted = NO;
    _platformMoreBtn.tag = 402;
    [_platformMoreBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_platformView addSubview:_platformMoreBtn];
    
    _exclusiveView.hidden = YES;
    _shopView.hidden = YES;
    _platformView.hidden = YES;
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)ticketBtnClick:(UIButton *)button
{
    if (_ticketCellBlock) {
        _ticketCellBlock(button.tag);
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_exclusiveView.hidden && _shopView.hidden && _platformView.hidden) {
    
        [_exclusiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [_shopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [_platformView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [_subView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.equalTo(1);
        }];
        return;
    }
    
    [_subView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    
    
    CGFloat exclusiveHeight = _exclusiveView.hidden ? 0.01 : 36;
    
    [_exclusiveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(exclusiveHeight);
    }];
    
    [_exclusiveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exclusiveView.left).offset(16);
        make.centerY.equalTo(self.exclusiveView.centerY);
        make.width.equalTo(80);
    }];
    
    CGSize exclusiveSize = [_exclusiveBtn.titleLabel sizeThatFits:CGSizeMake(200, 16)];
    
    [_exclusiveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.exclusiveLabel.centerY);
        make.left.equalTo(self.exclusiveLabel.right);
        make.size.equalTo(CGSizeMake(exclusiveSize.width + 20, 16));
    }];
    
    [_exclusiveMoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.exclusiveView.right).offset(-10);
        make.centerY.equalTo(self.exclusiveLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    CGFloat shopHeight = _shopView.hidden ? 0.01 : 36;
    
    [_shopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.exclusiveView.bottom);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(shopHeight);
    }];
    
    [_shopLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopView.left).offset(16);
        make.centerY.equalTo(self.shopView.centerY);
        make.width.equalTo(80);
    }];
    
    CGSize shopSize = [_shopBtn.titleLabel sizeThatFits:CGSizeMake(200, 16)];
    
    [_shopBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopLabel.centerY);
        make.left.equalTo(self.shopLabel.right);
        make.size.equalTo(CGSizeMake(shopSize.width+20, 16));
    }];
    
    [_shopMoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopView.right).offset(-10);
        make.centerY.equalTo(self.shopLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    CGFloat platformHeight = _platformView.hidden ? 0.01 : 36;
    
    [_platformView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.shopView.bottom);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(platformHeight);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [_platformLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.platformView.left).offset(16);
        make.centerY.equalTo(self.platformView.centerY);
        make.width.equalTo(self.shopLabel.width);
    }];
    
    CGSize platformSize = [_platformBtn.titleLabel sizeThatFits:CGSizeMake(200, 16)];
    
    [_platformBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.platformLabel.centerY);
        make.left.equalTo(self.platformLabel.right);
        make.size.equalTo(CGSizeMake(platformSize.width + 20, 16));
    }];
    
    [_platformMoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.platformView.right).offset(-10);
        make.centerY.equalTo(self.platformLabel.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _exclusiveView.hidden = YES;
    _shopView.hidden = YES;
    _platformView.hidden = YES;
    
    if (_detailModel.goodsTicketArray && _detailModel.goodsTicketArray.count > 0) {
        
        GLBGoodsTicketModel *ticketModel = _detailModel.goodsTicketArray[0];
        
        _exclusiveView.hidden = NO;
        [_exclusiveBtn setTitle:[NSString stringWithFormat:@"满%.0f元减%.0f元",ticketModel.requireAmount,ticketModel.discountAmount] forState:0];
    }
    
    if (_detailModel.storeTicketArray && _detailModel.storeTicketArray.count > 0) {
        
        GLBStoreTicketModel *ticketModel = _detailModel.storeTicketArray[0];
        
//        if (ticketModel) {
//            <#statements#>
//        }
        
        _shopView.hidden = NO;
        [_shopBtn setTitle:[NSString stringWithFormat:@"满%.0f元减%.0f元",ticketModel.requireAmount,ticketModel.discountAmount] forState:0];
    }
    
    // TODO 平台券
    
    [self layoutSubviews];
}
    
@end
