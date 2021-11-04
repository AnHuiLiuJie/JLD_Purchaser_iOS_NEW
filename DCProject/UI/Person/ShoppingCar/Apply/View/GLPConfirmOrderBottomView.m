//
//  GLPConfirmOrderBottomView.m
//  DCProject
//
//  Created by LiuMac on 2021/7/13.
//

#import "GLPConfirmOrderBottomView.h"
@interface GLPConfirmOrderBottomView ()

@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation GLPConfirmOrderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commintBtn setTitle:@"提交订单" forState:0];
    [_commintBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _commintBtn.titleLabel.font = PFRFont(16);
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FD4F00"];
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _commintBtn.frame = CGRectMake(kScreenW-165, 0, 165, 56);
    [self addSubview:_commintBtn];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#787878"];
    _moneyLabel.font = PFRFont(14);
    _moneyLabel.attributedText = [self dc_attStr:@"0.00"];
    _moneyLabel.frame = CGRectMake(15, 0, kScreenW-180, 56);
    [self addSubview:_moneyLabel];
    
}


#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    !_GLPConfirmOrderBottomView_block ? : _GLPConfirmOrderBottomView_block();
}


#pragma mark -
- (NSMutableAttributedString *)dc_attStr:(NSString *)price
{
    NSString *text = [NSString stringWithFormat:@"需付：¥%@",price];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:17],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 3)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(3, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:20],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(4, attrStr.length - 4)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:15],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    return attrStr;
}

- (void)setModel:(GLPNewShoppingCarModel *)model{
    _model = model;
    
    __block CGFloat allYunfei = 0;
    CGFloat allDiscount = [_model.orderCouponsDiscount floatValue];
    CGFloat allPrice = [_model.orderTotalPrice floatValue];
    //CGFloat orderPrice = [_model.orderPrice floatValue];
    [_model.firmList enumerateObjectsUsingBlock:^(GLPFirmListModel *  _Nonnull firmModel, NSUInteger idx, BOOL * _Nonnull stop) {
        allYunfei += firmModel.yufei;
    }];
    
    _moneyLabel.attributedText = [self dc_attStr:[NSString stringWithFormat:@"%.2f",allPrice-allDiscount+allYunfei]];
}


@end
