//
//  GLPDetailNormalGoodsView.m
//  DCProject
//
//  Created by bigbing on 2019/9/17.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPDetailNormalGoodsView.h"

@interface GLPDetailNormalGoodsView ()

@property (nonatomic, strong) UILabel *moneyTitleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *markPriceLabel;
@property (nonatomic, strong) UILabel *rebateLab;
@property(nonatomic,strong)UIImageView*bgImageV;
@property(nonatomic,strong) UILabel *teamLab;
@property(nonatomic,strong) UILabel *teamPriceLab;
@property(nonatomic,strong) UILabel *marketPriceLab;
@property(nonatomic,strong) UILabel *platPriceLab;
@property(nonatomic,strong) UILabel *jionLab;
@property(nonatomic,strong) UILabel *mLab;
@property(nonatomic,strong) UILabel *spacLab1;
@property(nonatomic,strong) UILabel *hLab;
@property(nonatomic,strong) UILabel *spacLab2;
@property(nonatomic,strong) UILabel *dLab;
@property(nonatomic,strong) UILabel *spacLab3;

@property (nonatomic, copy) NSString  *extendType;//是否加入创业者

@end

@implementation GLPDetailNormalGoodsView

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
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _moneyLabel.font = [UIFont fontWithName:PFR size:26];
    _moneyLabel.text = @"0.00";
    [self addSubview:_moneyLabel];
    
    _moneyTitleLabel = [[UILabel alloc] init];
    _moneyTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _moneyTitleLabel.font = [UIFont fontWithName:PFR size:17];
    _moneyTitleLabel.text = @"¥";
    [self addSubview:_moneyTitleLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _tipLabel.font = [UIFont fontWithName:PFR size:11];
    _tipLabel.text = @"商城价";
    _tipLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FF5330" alpha:0.1];
    [_tipLabel dc_cornerRadius:10];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel];
    
    _rebateLab = [[UILabel alloc] init];
    _rebateLab.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _rebateLab.font = PFRFont(11);
    _rebateLab.textAlignment = NSTextAlignmentCenter;
    _rebateLab.text = @" 赚*.** ";
    [self addSubview:_rebateLab];
    _extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;


    _markPriceLabel = [[UILabel alloc] init];
    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    _markPriceLabel.font = PFRFont(14);
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"市场价¥0.00"];
    [self addSubview:_markPriceLabel];
    
    _bgImageV = [[UIImageView alloc] init];
    _bgImageV.image = [UIImage imageNamed:@"goodsdetail_bg"];
    [self addSubview:_bgImageV];
    
    _teamLab = [[UILabel alloc] init];
    _teamLab.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _teamLab.font = [UIFont fontWithName:PFR size:11];
    _teamLab.text = @"团购价";
    _teamLab.backgroundColor = [UIColor whiteColor];
    [_teamLab dc_cornerRadius:10];
    _teamLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_teamLab];
    
    _teamPriceLab = [[UILabel alloc] init];
    _teamPriceLab.textColor = [UIColor whiteColor];
    _teamPriceLab.font = [UIFont fontWithName:PFR size:16];
    _teamPriceLab.text = @"0.00";
    [self addSubview:_teamPriceLab];
    
    _platPriceLab = [[UILabel alloc] init];
    _platPriceLab.textColor = [UIColor whiteColor];
    _platPriceLab.font = PFRFont(14);
    _platPriceLab.attributedText = [NSString dc_strikethroughWithString:@"商城价¥0.00"];
    [self addSubview:_platPriceLab];
    
    _marketPriceLab = [[UILabel alloc] init];
    _marketPriceLab.textColor = [UIColor whiteColor];
    _marketPriceLab.font = PFRFont(14);
    _marketPriceLab.alpha=0.6;
    _marketPriceLab.attributedText = [NSString dc_strikethroughWithString:@"市场价¥0.00"];
    [self addSubview:_marketPriceLab];
    
    _jionLab = [[UILabel alloc] init];
    _jionLab.textColor = RGB_COLOR(254, 115, 0);
    _jionLab.font = [UIFont fontWithName:PFR size:16];
    _jionLab.text = @"已有0人参加";
    [self addSubview:_jionLab];
    
    _mLab = [[UILabel alloc] init];
    _mLab.textColor = [UIColor whiteColor];
    _mLab.font = [UIFont fontWithName:PFR size:9];
    _mLab.text = @"00";
    _mLab.backgroundColor = RGB_COLOR(255, 74, 0);
    [_mLab dc_cornerRadius:2];
    _mLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_mLab];
    
    _spacLab1 = [[UILabel alloc] init];
    _spacLab1.textColor = RGB_COLOR(254, 115, 0);
    _spacLab1.font = [UIFont fontWithName:PFR size:10];
    _spacLab1.text = @":";
    [self addSubview:_spacLab1];
    _hLab = [[UILabel alloc] init];
    _hLab.textColor = [UIColor whiteColor];
    _hLab.font = [UIFont fontWithName:PFR size:9];
    _hLab.text = @"00";
    _hLab.backgroundColor = RGB_COLOR(255, 74, 0);
    [_hLab dc_cornerRadius:2];
    _hLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hLab];
    
    _spacLab2 = [[UILabel alloc] init];
    _spacLab2.textColor = RGB_COLOR(254, 115, 0);
    _spacLab2.font = [UIFont fontWithName:PFR size:10];
    _spacLab2.text = @"天";
    [self addSubview:_spacLab2];
    
    _dLab = [[UILabel alloc] init];
    _dLab.textColor = [UIColor whiteColor];
    _dLab.font = [UIFont fontWithName:PFR size:9];
    _dLab.text = @"00";
    _dLab.backgroundColor = RGB_COLOR(255, 74, 0);
    [_dLab dc_cornerRadius:2];
    _dLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dLab];
    
    _spacLab3 = [[UILabel alloc] init];
    _spacLab3.textColor = RGB_COLOR(254, 115, 0);
    _spacLab3.font = [UIFont fontWithName:PFR size:10];
    _spacLab3.text = @"距结束";
    [self addSubview:_spacLab3];
    self.bgImageV.hidden = YES;
    self.teamLab.hidden = YES;
    self.teamPriceLab.hidden = YES;
     self.platPriceLab.hidden = YES;
    self.marketPriceLab.hidden = YES;
    self.jionLab.hidden = YES;
    self.mLab.hidden = YES;
    self.hLab.hidden = YES;
    self.dLab.hidden = YES;
    self.spacLab1.hidden = YES;
    self.spacLab2.hidden = YES;
    self.spacLab3.hidden = YES;
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(30);
        make.top.equalTo(self.top).offset(6);
    }];

    [_moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel.left).offset(-5);
        make.bottom.equalTo(self.moneyLabel.bottom).offset(-3);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.right).offset(10);
        make.top.equalTo(self.moneyLabel.top).offset(5);
        make.size.equalTo(CGSizeMake(52, 20));
    }];
    
    [_rebateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyTitleLabel.left);
        make.top.equalTo(self.moneyLabel.bottom).offset(2);
    }];
    
    [_markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rebateLab.right).offset(5);
        make.top.equalTo(self.moneyLabel.bottom).offset(0);
    }];
    
    [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    [_teamLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.top).offset(14);
        make.size.equalTo(CGSizeMake(52, 20));
    }];
    
    [_teamPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teamLab.mas_right).offset(3);
        make.top.equalTo(self.top).offset(14);
        make.height.offset(20);
    }];
    
    [_platPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.top.equalTo(self.teamLab.mas_bottom).offset(9);
    }];
    
    [_marketPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.platPriceLab.mas_right).offset(5);
        make.top.equalTo(self.teamLab.mas_bottom).offset(9);
    }];
    
    [_jionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-15);
    }];
    
    GLPGoodsDetailGroupModel *groupModel = _detailModel.groupInfo;
    if ([groupModel.joinNum integerValue] == 0) {
        [_mLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-12);
            make.width.height.equalTo(18);
            make.centerY.equalTo(self.centerY);
        }];
        
        [_spacLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mLab.mas_left).offset(-3);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(18);
        }];
        
        [_hLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.spacLab1.mas_left).offset(-3);
            make.centerY.equalTo(self.centerY);
            make.width.height.equalTo(18);
        }];
        
        [_spacLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.hLab.mas_left).offset(-3);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(18);
        }];
        
        [_dLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.spacLab2.mas_left).offset(-3);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(18);
            make.width.greaterThanOrEqualTo(18);
        }];
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dLab.mas_left).offset(-3);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(18);
        }];
    }else{
        [_mLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-12);
            make.bottom.equalTo(self.bottom).offset(-10);
            make.width.height.equalTo(18);
        }];
        
        [_spacLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mLab.mas_left).offset(-3);
            make.centerY.equalTo(self.mLab.centerY);
            make.height.equalTo(18);
        }];
        
        [_hLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.spacLab1.mas_left).offset(-3);
            make.centerY.equalTo(self.mLab.centerY);
            make.width.height.equalTo(18);
        }];
        
        [_spacLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.hLab.mas_left).offset(-3);
            make.centerY.equalTo(self.mLab.centerY);
            make.height.equalTo(18);
        }];
        
        [_dLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.spacLab2.mas_left).offset(-3);
            make.centerY.equalTo(self.mLab.centerY);
            make.height.equalTo(18);
            make.width.greaterThanOrEqualTo(18);
        }];
        
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dLab.mas_left).offset(-3);
            make.centerY.equalTo(self.mLab.centerY);
            make.height.equalTo(18);
        }];
    }



    [DCSpeedy dc_changeControlCircularWith:_rebateLab AndSetCornerRadius:_rebateLab.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];

}

#pragma mark - lazy load
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if ([_extendType integerValue] == 1) {
        _rebateLab.hidden = NO;
        if (![DCSpeedy isBlankString:_detailModel.spreadAmount]) {
            _rebateLab.text = [NSString stringWithFormat:@" 赚%@  ",_detailModel.spreadAmount];
        }
    }else{
        _rebateLab.hidden = YES;
        _rebateLab.text = @"";
    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",_detailModel.sellPrice];
    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:_moneyLabel.textColor minFont:[UIFont fontWithName:PFR size:17] maxFont:nil forReplace:@"¥"];

    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"市场价¥%.2f",_detailModel.marketPrice]];
    GLPGoodsDetailGroupModel *groupModel = detailModel.groupInfo;
    NSDictionary *dic = [detailModel.groupInfo mj_keyValues];
    if ([dic dc_isNull]||dic==nil||[dic isEqual:@{}])
    {
        self.bgImageV.hidden = YES;
        self.teamLab.hidden = YES;
        self.teamPriceLab.hidden = YES;
         self.platPriceLab.hidden = YES;
        self.marketPriceLab.hidden = YES;
        self.jionLab.hidden = YES;
        self.mLab.hidden = YES;
        self.hLab.hidden = YES;
        self.dLab.hidden = YES;
        self.spacLab1.hidden = YES;
        self.spacLab2.hidden = YES;
        self.spacLab3.hidden = YES;
    }
    else{
        self.bgImageV.hidden = NO;
        self.teamLab.hidden = NO;
        self.teamPriceLab.hidden = NO;
        self.platPriceLab.hidden = NO;
        self.marketPriceLab.hidden = NO;
        self.jionLab.hidden = NO;
        self.mLab.hidden = NO;
        self.hLab.hidden = NO;
        self.dLab.hidden = NO;
        self.spacLab1.hidden = NO;
        self.spacLab2.hidden = NO;
        self.spacLab3.hidden = NO;
        _marketPriceLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"市场价¥%.2f",_detailModel.marketPrice]];
        _platPriceLab.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"商城价¥%.2f",_detailModel.sellPrice]];
        _teamPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[groupModel.actPrice floatValue]];
        _teamPriceLab = [UILabel setupAttributeLabel:_teamPriceLab textColor:nil minFont:nil maxFont:nil forReplace:@"¥"];
        if ([groupModel.joinNum integerValue] == 0) {
            _jionLab.hidden = YES;
        }else
            _jionLab.text = [NSString stringWithFormat:@"已有%@人参加",groupModel.joinNum];

        NSString *endtime = [NSString stringWithFormat:@"%@ 00:00:00",groupModel.actEtime];
        NSDate *date = [[NSDate alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curTime = [formatter stringFromDate:date];
        NSDate *endDate = [NSDate dateFromString:endtime];
        NSDate *currentDate = [NSDate dateFromString:curTime];
        NSTimeInterval vale = [endDate timeIntervalSinceDate:currentDate];
        int timenum = vale;
        if (vale>0)
        {
            int day=timenum/(3600*24);
            int a=timenum%(3600*24);
            int hou=a/3600;
            int b=a%3600;
            int m=b/60;
            if (day<10)
            {
                 self.dLab.text = [NSString stringWithFormat:@"0%d",day];
            }
            else{
                self.dLab.text = [NSString stringWithFormat:@"%d",day];
            }
            if (hou<10)
            {
                 self.hLab.text = [NSString stringWithFormat:@"0%d",hou];
            }
            else{
                self.hLab.text = [NSString stringWithFormat:@"%d",hou];
            }
            if (m<10)
            {
                self.mLab.text = [NSString stringWithFormat:@"0%d",m];
            }
            else{
                self.mLab.text = [NSString stringWithFormat:@"%d",m];
            }
            
        }
        else{
            self.dLab.text = @"00";
            self.hLab.text = @"00";
            self.mLab.text = @"00";
        }
    }
    [self layoutSubviews];
}

@end
