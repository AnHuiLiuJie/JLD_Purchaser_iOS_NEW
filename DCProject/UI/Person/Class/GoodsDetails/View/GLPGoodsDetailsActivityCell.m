//
//  GLPGoodsDetailsActivityCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/23.
//

#import "GLPGoodsDetailsActivityCell.h"

static CGFloat cell_spacing_x = 10;
static CGFloat cell_spacing_y = 5;
static CGFloat cell_spacing_h = 75;

#pragma mark *******************************   限时活动 **************************************。

@interface GLPGoodsDetailsActivityCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) GLPGCountdownTimeView *timeView;
/*现价*/
@property (nonatomic, strong) UILabel *moneyLabel;
/*商城价格*/
@property (nonatomic, strong) UILabel *markPriceLabel;

@end

@implementation GLPGoodsDetailsActivityCell

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
    _bgView.bounds = CGRectMake(0, 0, kScreenW, cell_spacing_h);
    [self.contentView addSubview:_bgView];
    

    _iconImg = [[UIImageView alloc] init];
    [_iconImg setImage:[UIImage imageNamed:@"weixinLogin_color"]];
    _iconImg.clipsToBounds = NO;
    _iconImg.contentMode = UIViewContentModeScaleToFill;
    [_bgView addSubview:_iconImg];

    _timeView = [[GLPGCountdownTimeView alloc] init];
    _timeView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_timeView];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FEFEFE"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:32];
    _moneyLabel.text = @"¥0.00";
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_moneyLabel];
    
    _markPriceLabel = [[UILabel alloc] init];
    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FC3309"];
    _markPriceLabel.font = PFRFont(11);
    _markPriceLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#FBF0F0"];
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"商城价¥0.00"];
    [_bgView addSubview:_markPriceLabel];
    [_markPriceLabel dc_cornerRadius:8];
}

#pragma mark -set
- (void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
    
    _timeView.detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;

    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:nil minFont:[UIFont fontWithName:PFR size:17] maxFont:[UIFont fontWithName:PFRMedium size:32] forReplace:@"¥"];

    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  商城价¥%.2f  ",_detailModel.marketPrice]];
    GLPGoodsDetailGroupModel *groupModel = detailModel.groupInfo;
    self.timeView.model = groupModel;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(0);
        make.bottom.equalTo(self.contentView.bottom).offset(-cell_spacing_y);
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(1);
        make.top.equalTo(self.bgView.top).offset(-10);
        make.bottom.equalTo(self.bgView.bottom).offset(5);
        make.width.equalTo(_iconImg.height);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.top);
        make.bottom.equalTo(self.iconImg.bottom);
        make.centerX.equalTo(self.bgView.centerX);
        make.width.greaterThanOrEqualTo(120);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-cell_spacing_x);
        make.top.equalTo(self.bgView.top).offset(5);
    }];
    
    [_markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.bottom).offset(0);
        make.centerX.equalTo(self.moneyLabel.centerX);
        make.height.equalTo(16);
    }];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,nil];
    CAGradientLayer *gradientLayer = [self.bgView dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @.9] colors:clolor1];
    [self.bgView.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma mark *******************************   拼团活动 **************************************
@interface GLPGoodsDetailsActivityGroupCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) GLPGCountdownTimeView *timeView;
/*现价提示*/
@property (nonatomic, strong) UILabel *promptLabel;
/*现价*/
@property (nonatomic, strong) UILabel *moneyLabel;
/*商城价格*/
@property (nonatomic, strong) UILabel *markPriceLabel;

@end

@implementation GLPGoodsDetailsActivityGroupCell

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
    _bgView.bounds = CGRectMake(0, 0, kScreenW, cell_spacing_h);
    [self.contentView addSubview:_bgView];
    

    _iconImg = [[UIImageView alloc] init];
    [_iconImg setImage:[UIImage imageNamed:@"weixinLogin_color"]];
    _iconImg.clipsToBounds = NO;
    _iconImg.contentMode = UIViewContentModeScaleToFill;
    [_bgView addSubview:_iconImg];

    _timeView = [[GLPGCountdownTimeView alloc] init];
    _timeView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFE8C7"];
    [_bgView addSubview:_timeView];
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _promptLabel.font = [UIFont fontWithName:PFR size:13];
    _promptLabel.text = @"拼团价：";
    _promptLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_promptLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _moneyLabel.font = [UIFont fontWithName:PFRMedium size:24];
    _moneyLabel.text = @"¥0.00";
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_moneyLabel];
    
    _markPriceLabel = [[UILabel alloc] init];
    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _markPriceLabel.font = PFRFont(13);
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"商城价：¥0.00"];
    [_bgView addSubview:_markPriceLabel];
    [_markPriceLabel dc_cornerRadius:8];

}

#pragma mark -set
- (void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
    
    _timeView.detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;

    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFRMedium size:24] forReplace:@"¥"];

    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" 商城价：¥%.2f ",_detailModel.marketPrice]];
    GLPGoodsDetailGroupModel *groupModel = detailModel.groupInfo;
    self.timeView.model = groupModel;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom).offset(5);
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(cell_spacing_x);
        make.top.equalTo(self.bgView.top).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-5);
        make.width.equalTo(_iconImg.height);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.centerY.equalTo(self.bgView.centerY);
        make.height.equalTo(cell_spacing_h);
        make.width.greaterThanOrEqualTo(150);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.right).offset(8);
        make.centerY.equalTo(self.moneyLabel.centerY).offset(5);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptLabel.right).offset(2);
        make.top.equalTo(self.iconImg.top).offset(5);
    }];
    
    [_markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.bottom).offset(0);
        make.left.equalTo(self.promptLabel.left);
    }];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,nil];
    CAGradientLayer *gradientLayer = [self.bgView dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @.9] colors:clolor1];
    [self.bgView.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序
    
    [_timeView dc_cornerRadius:cell_spacing_h rectCorner:UIRectCornerTopLeft|UIRectCornerBottomLeft];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


#pragma mark *******************************   预售活动 **************************************
@interface GLPGoodsDetailsActivityPreSaleCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) GLPGCountdownTimeView *timeView;
/*提示定金*/
@property (nonatomic, strong) UILabel *promptLabel;
/*定金*/
@property (nonatomic, strong) UILabel *depositLab;
/*提示预售价*/
@property (nonatomic, strong) UILabel *promptLabel2;
/*预售价格*/
@property (nonatomic, strong) UILabel *preSaleLabel;

@end

@implementation GLPGoodsDetailsActivityPreSaleCell

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
    _bgView.bounds = CGRectMake(0, 0, kScreenW, cell_spacing_h);
    [self.contentView addSubview:_bgView];
    

    _iconImg = [[UIImageView alloc] init];
    [_iconImg setImage:[UIImage imageNamed:@"weixinLogin_color"]];
    _iconImg.clipsToBounds = NO;
    _iconImg.contentMode = UIViewContentModeScaleToFill;
    [_bgView addSubview:_iconImg];

    _timeView = [[GLPGCountdownTimeView alloc] init];
    _timeView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_timeView];
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _promptLabel.font = [UIFont fontWithName:PFR size:13];
    _promptLabel.text = @"   定金：";
    _promptLabel.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_promptLabel];
    
    _depositLab = [[UILabel alloc] init];
    _depositLab.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _depositLab.font = [UIFont fontWithName:PFRMedium size:18];
    _depositLab.text = @"¥0.00";
    [_bgView addSubview:_depositLab];
    
    _promptLabel2 = [[UILabel alloc] init];
    _promptLabel2.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _promptLabel2.font = [UIFont fontWithName:PFR size:13];
    _promptLabel2.text = @"预售价：";
    _promptLabel2.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_promptLabel2];
    
    _preSaleLabel = [[UILabel alloc] init];
    _preSaleLabel.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    _preSaleLabel.font = [UIFont fontWithName:PFRMedium size:24];
    _preSaleLabel.text = @"¥0.00";
    [_bgView addSubview:_preSaleLabel];

}

#pragma mark -set
- (void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
    
    _timeView.detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;

    _depositLab.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    _depositLab = [UILabel setupAttributeLabel:_depositLab textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:18] forReplace:@"¥"];

    _preSaleLabel.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    _preSaleLabel = [UILabel setupAttributeLabel:_preSaleLabel textColor:nil minFont:[UIFont fontWithName:PFR size:12] maxFont:[UIFont fontWithName:PFRMedium size:18] forReplace:@"¥"];
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom).offset(5);
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(cell_spacing_x);
        make.top.equalTo(self.bgView.top).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-5);
        make.width.equalTo(_iconImg.height);
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.bottom.equalTo(self.bgView.bottom);
        make.height.equalTo(cell_spacing_h/2);
        make.width.greaterThanOrEqualTo(165);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.right).offset(8);
        make.top.equalTo(self.iconImg.top).offset(10);
        make.height.equalTo(20);
    }];
    
    [_depositLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptLabel.right);
        make.centerY.equalTo(self.promptLabel.centerY);
    }];
    
    [_promptLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptLabel.left);
        make.top.equalTo(self.promptLabel.bottom).offset(10);
    }];

    [_preSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.promptLabel2.right);
        make.centerY.equalTo(self.promptLabel2.centerY);
    }];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#049A91"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#11C3B9"].CGColor,nil];
    CAGradientLayer *gradientLayer = [self.bgView dc_changeColorWithStart:CGPointMake(0.05,0.1)  end:CGPointMake(1,0) locations:@[@0,@0.45, @1] colors:clolor1];
    [self.bgView.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



#pragma mark *******************************   时间倒计时View **************************************

@interface GLPGCountdownTimeView ()

@property(nonatomic,strong) UILabel *mLab;
@property(nonatomic,strong) UILabel *spacLab1;
@property(nonatomic,strong) UILabel *hLab;
@property(nonatomic,strong) UILabel *spacLab2;
@property(nonatomic,strong) UILabel *dLab;
@property(nonatomic,strong) UILabel *spacLab3;

@property (nonatomic, assign) CGFloat itemH;
@end


@implementation GLPGCountdownTimeView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

//- (instancetype)initWithtype:(GLPGoodsDetailType)type{
//    self = [super init];
//    if (self) {
//        [self createUI];
//    }
//    return self;
//}

- (void)createUI{
    CGFloat itemRadius = 4;
    //self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIColor *timeColor = [UIColor dc_colorWithHexString:@"#FF4A00"];
    UIColor *bgColor = [UIColor dc_colorWithHexString:@"#E8CCCC" alpha:0.8] ;
    UIColor *otherColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    NSInteger tiemSize = 16;
    NSInteger otherSize = 12;
    _itemH = 28;
    if (self.detailType == GLPGoodsDetailTypeGroup) {//#FDAF53。#FC3309
        timeColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
        bgColor = [UIColor dc_colorWithHexString:@"#FF4A00"];
        otherColor = [UIColor dc_colorWithHexString:@"#FE7300"];
        _itemH = 22;
        tiemSize = 14;
        otherSize = 12;
    }else if(self.detailType == GLPGoodsDetailTypeCollage){//#62F2AC #11C3B9
        timeColor = [UIColor dc_colorWithHexString:@"#FFB400"];
        bgColor = [UIColor dc_colorWithHexString:@"#FFF1DD"];
        otherColor = [UIColor dc_colorWithHexString:@"#FEFEFE"];
        _itemH = 22;
        tiemSize = 14;
        otherSize = 12;
    }
    
    _mLab = [[UILabel alloc] init];
    _mLab.textColor = timeColor;
    _mLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _mLab.text = @"00";
    _mLab.backgroundColor = bgColor;
    [_mLab dc_cornerRadius:itemRadius];
    _mLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_mLab];
    
    _spacLab1 = [[UILabel alloc] init];
    _spacLab1.textColor = otherColor;
    _spacLab1.font = [UIFont fontWithName:PFR size:otherSize];
    _spacLab1.text = @":";
    [self addSubview:_spacLab1];
    _hLab = [[UILabel alloc] init];
    _hLab.textColor = timeColor;
    _hLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _hLab.text = @"00";
    _hLab.backgroundColor = bgColor;
    [_hLab dc_cornerRadius:itemRadius];
    _hLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hLab];
    
    _spacLab2 = [[UILabel alloc] init];
    _spacLab2.textColor = otherColor;
    _spacLab2.font = [UIFont fontWithName:PFR size:otherSize];
    _spacLab2.text = @"天";
    [self addSubview:_spacLab2];
    
    _dLab = [[UILabel alloc] init];
    _dLab.textColor = timeColor;
    _dLab.font = [UIFont fontWithName:PFR size:tiemSize];
    _dLab.text = @"00";
    _dLab.backgroundColor = bgColor;
    [_dLab dc_cornerRadius:itemRadius];
    _dLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dLab];
    
    _spacLab3 = [[UILabel alloc] init];
    _spacLab3.textColor = otherColor;
    _spacLab3.font = [UIFont fontWithName:PFR size:otherSize];
    _spacLab3.text = @"距结束还剩";
    [self addSubview:_spacLab3];
}

#pragma mark - set
-(void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
    
    [self createUI];
}

- (void)setModel:(GLPGoodsDetailGroupModel *)model{
    _model = model;
    
    NSString *endtime = [NSString stringWithFormat:@"%@ 00:00:00",_model.actEtime];
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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.detailType == GLPGoodsDetailTypeSeckill) {
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.centerY.equalTo(self.centerY).offset(-15);
            make.height.equalTo(18);
        }];
        
        [_dLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.spacLab3.mas_left);
            make.centerY.equalTo(self.centerY).offset(12);
            make.height.equalTo(self.itemH);
            make.width.greaterThanOrEqualTo(self.itemH);
        }];
    }else if (self.detailType == GLPGoodsDetailTypeGroup) {
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX).offset(-10);
            make.centerY.equalTo(self.centerY).offset(-15);
            make.height.equalTo(18);
        }];
        
        [_dLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.spacLab3.mas_left);
            make.centerY.equalTo(self.centerY).offset(12);
            make.height.equalTo(self.itemH);
            make.width.greaterThanOrEqualTo(self.itemH);
        }];
    }else if (self.detailType == GLPGoodsDetailTypeCollage) {
        _spacLab3.text = @"距结束：";
        [_spacLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(18);
        }];
        
        [_dLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.spacLab3.mas_right).offset(-2);
            make.centerY.equalTo(self.centerY);
            make.height.equalTo(self.itemH);
            make.width.greaterThanOrEqualTo(self.itemH);
        }];
    }
    
    [_spacLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dLab.mas_right).offset(5);
        make.centerY.equalTo(self.dLab.centerY);
        make.height.equalTo(self.dLab.height);
    }];
    
    [_hLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab2.mas_right).offset(5);
        make.centerY.equalTo(self.dLab.centerY);
        make.width.height.equalTo(self.dLab.height);
    }];
    
    
    [_spacLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hLab.mas_right).offset(5);
        make.centerY.equalTo(self.dLab.centerY);
        make.height.equalTo(self.dLab.height);
    }];
    
    
    [_mLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spacLab1.mas_right).offset(5);
        make.centerY.equalTo(self.dLab.centerY);
        make.width.height.equalTo(self.dLab.height);
    }];

}


@end


#pragma mark *******************************  预支付购买流程View **************************************
@interface GLPPurchaseProcessView ()


@property (nonatomic, strong) UIButton *stateBtn1;
@property (nonatomic, strong) UILabel *point1;
@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIButton *stateBtn2;
@property (nonatomic, strong) UILabel *point2;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIButton *stateBtn3;
@property (nonatomic, strong) UILabel *point3;

@end


@implementation GLPPurchaseProcessView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)createUI{
    
    _stateBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stateBtn1 setTitle:@"支付定金" forState:UIControlStateNormal];
    [self addSubview:_stateBtn1];
    
}


@end
