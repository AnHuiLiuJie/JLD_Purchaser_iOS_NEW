//
//  DCChatGoodsTopView.m
//  DCProject
//
//  Created by bigbing on 2019/12/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "DCChatGoodsTopView.h"

@interface DCChatGoodsTopView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIView  *line_x;
@property (nonatomic, strong) UILabel *manufactory;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation DCChatGoodsTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_layerBorderWith:1 color:[UIColor dc_colorWithHexString:@"#E8E8E8"] radius:3];
    [self addSubview:_bgView];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    [_goodsImage dc_cornerRadius:3];
    _goodsImage.image = [[DCPlaceholderTool shareTool] dc_placeholderImage];
    [_bgView addSubview:_goodsImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(14);
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 2;
    [_bgView addSubview:_titleLabel];
    
    _manufactory = [[UILabel alloc] init];
    _manufactory.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _manufactory.font = PFRFont(12);
    _manufactory.text = @"";
    _manufactory.numberOfLines = 1;
    [_bgView addSubview:_manufactory];
    
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    _priceLabel.attributedText = [self dc_attStrWithPrice:@"0.00"];
    [_bgView addSubview:_priceLabel];
    
    _line_x = [[UIView alloc] init];
    _line_x.backgroundColor = [UIColor dc_colorWithHexString:@"#E8E8E8"];
    [_bgView addSubview:_line_x];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_sendBtn dc_cornerRadius:13];

    _sendBtn.bounds = CGRectMake(0, 0, 78, 28);
    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_sendBtn];
    NSArray *clolor = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#42E5A6"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00B7AB"].CGColor,
                       nil];
    CAGradientLayer *gradientLayer = [_sendBtn dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@0.3, @0.9] colors:clolor];
    [self.sendBtn.layer addSublayer:gradientLayer];
    [_sendBtn setTitle:@"发送链接" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_gwc_quxiao"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];

    [self layoutIfNeeded];
}


#pragma mark - action
- (void)sendBtnClick:(id)sender
{
    if (_sendBtnBlock) {
        _sendBtnBlock();
        [self cancelBtnAction];
    }
}

- (void)cancelBtnAction
{
    if (_cancelBtnBlock) {
        _cancelBtnBlock();
        [self removeFromSuperview];
    }
}

#pragma mark - NSMutableAttributedString
- (NSMutableAttributedString *)dc_attStrWithPrice:(NSString *)price
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",price]];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:11]} range:NSMakeRange(0, 1)];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15]} range:NSMakeRange(1, attStr.length - 1)];
    return attStr;
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.bgView.top).offset(5);
        make.width.height.equalTo(60);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImage.top).offset(5);
        make.left.equalTo(self.goodsImage.right).offset(8);
        make.right.equalTo(self.bgView.right).offset(-6);
    }];
    
    [_manufactory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(0);
        make.left.equalTo(self.goodsImage.right).offset(8);
        make.right.equalTo(self.bgView.right).offset(-6);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self.goodsImage.bottom).offset(5);
    }];
    
    [_line_x mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.left.equalTo(self.bgView.left);
        make.height.equalTo(0.5);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView).offset(5);
        make.top.equalTo(self.line_x.bottom).offset(5);
        make.bottom.equalTo(self.bgView).offset(-5);
        make.size.equalTo(CGSizeMake(72, 26));
    }];
    
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.top.equalTo(self.bgView.top).offset(5);
        make.width.height.equalTo(25);
    }];
}


#pragma mark - setter
- (void)setGoodsModel:(DCChatGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImage] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _goodsModel.goodsName;
    _priceLabel.attributedText = [self dc_attStrWithPrice:_goodsModel.price];
    _manufactory.text = _goodsModel.manufactory;
}

@end
