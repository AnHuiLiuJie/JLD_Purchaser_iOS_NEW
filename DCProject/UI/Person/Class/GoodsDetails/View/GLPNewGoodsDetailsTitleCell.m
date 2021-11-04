//
//  GLPNewGoodsDetailsTitleCell.m
//  DCProject
//
//  Created by LiuMac on 2021/7/20.
//

#import "GLPNewGoodsDetailsTitleCell.h"


static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat view_spacing_x = 8;

@interface GLPNewGoodsDetailsTitleCell ()

/*背景View*/
@property (nonatomic, strong) UIView *bgView;
///*现价*/
//@property (nonatomic, strong) UILabel *moneyLabel;
///*创业者赚*/
//@property (nonatomic, copy) NSString  *extendType;//是否加入创业者
//@property (nonatomic, strong) UILabel *rebateLab;
///*市场价格*/
//@property (nonatomic, strong) UILabel *markPriceLabel;
///*收藏按钮*/
//@property (nonatomic, strong) UIButton *collectBtn;
/*推荐标语*/
@property (nonatomic, strong) UILabel *recommendLab;
/*包邮类型*/
@property (nonatomic, strong) UILabel *supplyLab;
/*药品类型*/
@property (nonatomic, strong) UIButton *classTypeLab;
/*商品标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/*推荐标语*/
@property (nonatomic, strong) UILabel *summaryLab;

@end


@implementation GLPNewGoodsDetailsTitleCell

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
    [_bgView dc_cornerRadius:cell_spacing_x];
    
//    _moneyLabel = [[UILabel alloc] init];
//    _moneyLabel.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
//    _moneyLabel.font = [UIFont fontWithName:PFR size:26];
//    _moneyLabel.text = @"¥0.00";
//    [_bgView addSubview:_moneyLabel];
//
//    _rebateLab = [[UILabel alloc] init];
//    _rebateLab.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
//    _rebateLab.font = PFRFont(11);
//    _rebateLab.textAlignment = NSTextAlignmentCenter;
//    _rebateLab.text = @" 赚*.** ";
//    [_bgView addSubview:_rebateLab];
//    _extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
//    [DCSpeedy dc_changeControlCircularWith:_rebateLab AndSetCornerRadius:9 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
//
//    _markPriceLabel = [[UILabel alloc] init];
//    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
//    _markPriceLabel.font = PFRFont(14);
//    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"市场价¥0.00"];
//    [_bgView addSubview:_markPriceLabel];
    
    _supplyLab = [[UILabel alloc] init];
    _supplyLab.textColor = [UIColor whiteColor];
    _supplyLab.font = PFRFont(11);
    _supplyLab.text = @"";//包邮
    _supplyLab.backgroundColor = [UIColor dc_colorWithHexString:@"#6C53EF"];
    [_bgView addSubview:_supplyLab];
    [_supplyLab dc_cornerRadius:5];
    
    _recommendLab = [[UILabel alloc] init];
    _recommendLab.textColor = [UIColor whiteColor];
    _recommendLab.font = PFRFont(11);
    _recommendLab.text = @"";//优选
    _recommendLab.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    [_bgView addSubview:_recommendLab];
    [_recommendLab dc_cornerRadius:5];
    
    
    _classTypeLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_classTypeLab];
    _classTypeLab.titleLabel.font = PFRFont(11);
    _classTypeLab.bounds = CGRectMake(0, 0, 55, 20);
    [_classTypeLab dc_cornerRadius:10];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = @"       ";
    [_bgView addSubview:_titleLabel];
    UILongPressGestureRecognizer *longPressGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPressGesture2.minimumPressDuration = 0.8f;//设置长按 时间
    _titleLabel.userInteractionEnabled = YES;
    [_titleLabel addGestureRecognizer:longPressGesture2];
    

//    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_collectBtn setTitle:@"" forState:0];//收藏
//    [_collectBtn setTitle:@"" forState:UIControlStateSelected];//已收藏
//    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
//    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FE4800"] forState:UIControlStateSelected];
//    _collectBtn.titleLabel.font = PFRFont(10);
//    [_collectBtn setImage:[UIImage imageNamed:@"weishouc"] forState:0];
//    [_collectBtn setImage:[UIImage imageNamed:@"yishouc"] forState:UIControlStateSelected];
//    _collectBtn.adjustsImageWhenHighlighted = NO;
//    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //_collectBtn.bounds = CGRectMake(0, 0, 30, 30);
//    //[_collectBtn dc_buttonIconTopWithSpacing:7];
//    [_bgView addSubview:_collectBtn];
    
    _summaryLab = [[UILabel alloc] init];
    _summaryLab.textColor = [UIColor dc_colorWithHexString:@"#C1C1C1"];
    _summaryLab.font = PFRFont(12);
    _summaryLab.textAlignment = NSTextAlignmentLeft;
    _summaryLab.numberOfLines = 0;
    _summaryLab.text = @"本品为 OTC药品 ，请在药师的指导下购买和使用，处方药必须凭处方单购买！点击立即购买可在线问诊获取电子 \n根据GSP相关规定，除药品质量原因外，药品一经售出，不得退换。如本品同时存在新旧包装，则会随机发货。\n\n ";
    [_bgView addSubview:_summaryLab];
}

#pragma mark - lazy load
- (void)setDetailType:(GLPGoodsDetailType)detailType {
    _detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    
//    _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
//    _moneyLabel = [UILabel setupAttributeLabel:_moneyLabel textColor:nil minFont:[UIFont fontWithName:PFR size:17] maxFont:[UIFont fontWithName:PFRMedium size:26] forReplace:@"¥"];
//
//    if ([_extendType integerValue] == 1) {
//        _rebateLab.hidden = NO;
//        if (![DCSpeedy isBlankString:_detailModel.spreadAmount]) {
//            _rebateLab.text = [NSString stringWithFormat:@" 赚%@  ",_detailModel.spreadAmount];
//        }
//    }else{
//        _rebateLab.hidden = YES;
//    }
//
//    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@"  ¥%.2f  ",_detailModel.marketPrice]];
//    
//    if (_detailModel.isCollection > 0) { // 被收藏
//        _collectBtn.selected = YES;
//    } else {
//        _collectBtn.selected = NO;
//    }
    
    NSString *goodsTitle = _detailModel.goodsTitle;
    NSInteger blankNum = 0;
    __block NSString *tips = @"";
    [self.detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
        if([actModel.actType isEqualToString:@"freePostage"]) {
            tips = [actModel.tips firstObject];
        }
    }];
    if (tips.length > 0) {
        blankNum = [DCSpeedy is_Chinese_Conversion_To_CharNumber:tips]+2;
    }
    if (_detailModel.frontClassName.length > 0) {
        _recommendLab.hidden = NO;
        NSString *frontClassName = [NSString stringWithFormat:@" %@ ",_detailModel.frontClassName];
        _recommendLab.text = frontClassName;
        blankNum = blankNum + _detailModel.frontClassName.length*2+2;
    }else{
        _recommendLab.hidden = YES;
        _recommendLab.text = @"";
    }

    if ([_detailModel.isMedical isEqualToString:@"1"]) {
        if (_detailModel.isOtc == 2) {
            //处方药
            ////[self changeCoustomView];
            _summaryLab.attributedText = [self attributeWithSummaryLab:@" 处方药 "];;
            //blankNum = blankNum + 3*2+4 ;
        }else{
            //otc
            _summaryLab.attributedText = [self attributeWithSummaryLab:@"OTC药品"];;
        }
    }else{
        //非医药
        _summaryLab.attributedText = [self attributeWithSummaryLab:@"保健食品"];;
    }
    
    for (NSInteger i=0; i< blankNum; i++) {
        goodsTitle = [NSString stringWithFormat:@" %@",goodsTitle];
    }
    
    _titleLabel.text = goodsTitle;
    
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
    }];
    

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(view_spacing_x);
        make.right.equalTo(self.bgView.right).offset(-view_spacing_x);
        make.top.equalTo(self.bgView.top).offset(10);
    }];
    
//    if (_detailType == GLPGoodsDetailTypeNormal) {
//        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.bgView.left).offset(view_spacing_x);
//            make.top.equalTo(self.bgView.top).offset(10);
//            make.height.equalTo(30);
//        }];
//
//        [_rebateLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.moneyLabel.right).offset(10);
//            make.centerY.equalTo(self.moneyLabel.centerY);
//            make.height.equalTo(18);
//        }];
//
//        [_markPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.rebateLab.mas_right).offset(10);
//            make.centerY.equalTo(self.moneyLabel.centerY);
//        }];
//
//        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.bgView.right).offset(-view_spacing_x);
//            make.centerY.equalTo(self.moneyLabel.centerY);
//            make.size.equalTo(CGSizeMake(40, 40));
//        }];
//
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.bgView.left).offset(view_spacing_x);
//            make.right.equalTo(self.bgView.right).offset(-view_spacing_x);
//            make.top.equalTo(self.moneyLabel.bottom).offset(5);
//        }];
//
//
//    }else{
//
//        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.bgView.right).offset(-view_spacing_x);
//            make.top.equalTo(self.bgView.top).offset(5);
//            make.size.equalTo(CGSizeMake(40, 40));
//        }];
//
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.bgView.left).offset(view_spacing_x);
//            make.right.equalTo(self.collectBtn.left).offset(0);
//            make.top.equalTo(self.bgView.top).offset(10);
//        }];
//
//    }
    
    if (tips.length > 0) {
        _supplyLab.text = [NSString stringWithFormat:@" %@ ",tips];
        [_supplyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left);
            make.top.equalTo(self.titleLabel.top).offset(2);
            make.height.equalTo(20);
        }];
        
        [_recommendLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.supplyLab.right).offset(5);
            make.centerY.equalTo(self.supplyLab.centerY);
            make.height.equalTo(20);
        }];

    }else{
        [_recommendLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.left).offset(1);
            make.top.equalTo(self.titleLabel.top).offset(3);
            make.height.equalTo(20);
        }];
    }
    
    [_classTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recommendLab.right).offset(5);
        make.centerY.equalTo(self.recommendLab.centerY).offset(-0.5);
        make.height.equalTo(20);
    }];
    
    [_summaryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(view_spacing_x);
        make.right.equalTo(self.bgView.right).offset(-view_spacing_x);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.bottom.equalTo(self.bgView.bottom).priorityHigh();
    }];
    
//    if ([_detailModel.isMedical isEqualToString:@"1"]) {
//        if (_detailModel.isOtc == 2) {
//            //处方药
//            [self changeCoustomView];
//        }
//    }

}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)changeCoustomView{//不明白为啥这里Lable 不可可渐变色
    _classTypeLab.hidden = NO;
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,nil];
    CAGradientLayer *gradientLayer = [_classTypeLab dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @.9] colors:clolor1];
    [_classTypeLab.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序
    
    [_classTypeLab setTitle:@"  处方药  " forState:0];
    [_classTypeLab setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _classTypeLab.backgroundColor = [UIColor dc_colorWithHexString:@"#FC3309"];
}

#pragma mark 药品概况
- (NSMutableAttributedString *)attributeWithSummaryLab:(NSString *)keywordStr
{
    NSString *text = @"";
    UIColor *color = [UIColor dc_colorWithHexString:@"#FF4A13"];
    if ([keywordStr isEqualToString:@"保健食品"]) {
        text = @"";
//        text = @"保健食品不是药物，不能代替药物治疗疾病，本品添加了营养素,与同类营养素同时服用不宜超过推荐量。\n";
        color = [UIColor dc_colorWithHexString:@"#58D148"];
    }else if([keywordStr isEqualToString:@" 处方药 "]){
        text = @"本品为 处方药 ，请在药师的指导下购买和使用，处方药必须凭处方单购买！点击立即购买可在线问诊获取电子 \n根据GSP相关规定，除药品质量原因外，药品一经售出，不得退换。如本品同时存在新旧包装，则会随机发货。\n ";
    }else if([keywordStr isEqualToString:@"OTC药品"]){
        text = @"根据GSP相关规定，药品属于特殊商品，一经售出无质量问题不退不换。如本品同时存在新旧包装，则会随机发货。\n";
//        text = @"本品为 OTC药品，请在药师的指导下购买和使用，禁忌或注意事项,详见说明书。\n根据GSP相关规定，药品属于特殊商品，一经售出无质量问题不退不换。如本品同时存在新旧包装，则会随机发货。\n ";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 3; // 调整行间距
    paragraphStyle.firstLineHeadIndent = 0;//首行缩进
    
    NSRange range2 = [text rangeOfString:keywordStr];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:12],NSForegroundColorAttributeName:color} range:range2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];

    return attributedString;
}

#pragma mark - action 收藏
- (void)collectBtnClick:(UIButton *)button
{
    !_GLPNewGoodsDetailsTitleCell_Block ? : _GLPNewGoodsDetailsTitleCell_Block();
}

#pragma mark - 复制
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (_detailModel.goodsTitle.length == 0) {
        return;
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.detailModel.goodsTitle;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
