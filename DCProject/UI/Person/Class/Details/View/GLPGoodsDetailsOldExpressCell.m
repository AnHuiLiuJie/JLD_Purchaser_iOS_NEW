//
//  GLPGoodsDetailsOldExpressCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsOldExpressCell.h"

@interface GLPGoodsDetailsOldExpressCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *sendImage;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIImageView *tipImage;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *returnImage;
@property (nonatomic, strong) UILabel *returnLabel;
@property (nonatomic, strong) UIImageView *onlineImage;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLPGoodsDetailsOldExpressCell

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
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    
    _sendImage = [[UIImageView alloc] init];
    _sendImage.image = [UIImage imageNamed:@"buzhic"];
    [_bgView addSubview:_sendImage];
    
    _sendLabel = [[UILabel alloc] init];
    _sendLabel.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    _sendLabel.font = PFRFont(10);
    [_bgView addSubview:_sendLabel];
    
    _tipImage = [[UIImageView alloc] init];
    _tipImage.image = [UIImage imageNamed:@"buzhic"];
    [_bgView addSubview:_tipImage];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    _tipLabel.font = PFRFont(10);
    [_bgView addSubview:_tipLabel];
    
    _returnImage = [[UIImageView alloc] init];
    _returnImage.image = [UIImage imageNamed:@"buzhic"];
    [_bgView addSubview:_returnImage];
    
    _returnLabel = [[UILabel alloc] init];
    _returnLabel.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    _returnLabel.font = PFRFont(10);
    [_bgView addSubview:_returnLabel];
    
    _onlineImage = [[UIImageView alloc] init];
    _onlineImage.image = [UIImage imageNamed:@"buzhic"];
    [_bgView addSubview:_onlineImage];
    
    _onlineLabel = [[UILabel alloc] init];
    _onlineLabel.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    _onlineLabel.font = PFRFont(10);
    [_bgView addSubview:_onlineLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"zjankai"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_moreBtn];
    
}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    if (_moreBtnBlock) {
        _moreBtnBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_sendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(8);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    
    [_sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sendImage.centerY);
        make.left.equalTo(self.sendImage.right).offset(3);
        make.width.equalTo(kScreenW/2.5);
    }];
    
    [_tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.sendImage.bottom).offset(12);
        make.size.equalTo(CGSizeMake(12, 12));
        //make.bottom.equalTo(self.contentView.bottom).offset(-8);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipImage.centerY);
        make.left.equalTo(self.tipImage.right).offset(3);
        make.width.equalTo(kScreenW/1.8);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.sendImage.centerY);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_returnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendLabel.right);
        make.centerY.equalTo(self.sendImage.centerY);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    
    [_returnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.returnImage.centerY);
        make.left.equalTo(self.returnImage.right).offset(3);
        make.right.equalTo(self.moreBtn.left);
    }];
    
    [_onlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.returnImage.left);
        make.centerY.equalTo(self.tipImage.centerY);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
    
    [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.onlineImage.centerY);
        make.left.equalTo(self.onlineImage.right).offset(3);
        make.right.equalTo(self.returnLabel.right);
    }];
    
    CGFloat hight = CGRectGetMaxY(self.tipImage.frame);
    if (hight == 0) {
        hight = 40;
    }
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        //make.height.mas_greaterThanOrEqualTo(hight+5).priorityHigh();
        make.height.equalTo(hight+8).priorityHigh();
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if ([_detailModel.isMedical isEqualToString:@"1"]) {
        
        _sendLabel.text = @"暂不支持医保支付";
        _tipLabel.text = @"由商家负责发货及售后";
        _returnLabel.text = @"";
        _onlineLabel.text = @"不支持7天无理由退换商品";
        _returnImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
        _sendImage.image = [UIImage imageNamed:@"buzhic"];
        _tipImage.image = [UIImage imageNamed:@"zhichi"];
        _onlineImage.image = [UIImage imageNamed:@"buzhic"];
//        NSInteger sta = [_detailModel.frontClassState integerValue];
//        if (sta == 1) {
//            _sendLabel.text = @"小编推荐";
//            _sendImage.image = [UIImage imageNamed:@"zhichi"];
//            _returnLabel.text = @"暂不支持医保支付";
//            _returnImage.image = [UIImage imageNamed:@"buzhic"];
//        }
//        if (sta == 2) {C39XM25LKPFT  357203095353735
//            _sendLabel.text = @"快速发货";
//            _sendImage.image = [UIImage imageNamed:@"zhichi"];
//            _returnLabel.text = @"暂不支持医保支付";
//            _returnImage.image = [UIImage imageNamed:@"buzhic"];
//        }
    }
    else{
        _sendLabel.text = @"由商家负责发货及售后";
        _tipLabel.text = @"支持7天无理由退换商品（未拆封）";
        _returnLabel.text = @"";
        _onlineLabel.text = @"";
        _returnImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
        _sendImage.image = [UIImage imageNamed:@"zhichi"];
        _tipImage.image = [UIImage imageNamed:@"zhichi"];
        _onlineImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
//        NSInteger sta = [_detailModel.frontClassState integerValue];
//       
//        if (sta == 1) {
//            _sendLabel.text = @"小编推荐";
//            _sendImage.image = [UIImage imageNamed:@"zhichi"];
//            _tipLabel.text =@"由商家负责发货及售后";
//            _returnLabel.text = @"";
//            _onlineLabel.text = @"不支持7天无理由退换商品";
//            _onlineImage.image = [UIImage imageNamed:@"zhichi"];
//        }
//        if (sta == 2) {
//            _sendLabel.text = @"快速发货";
//            _sendImage.image = [UIImage imageNamed:@"zhichi"];
//            _tipLabel.text = @"由商家负责发货及售后";
//            _returnLabel.text = @"";
//            _onlineLabel.text = @"不支持7天无理由退换商品";
//            _onlineImage.image = [UIImage imageNamed:@"zhichi"];
//        }
    }
    
}

@end
